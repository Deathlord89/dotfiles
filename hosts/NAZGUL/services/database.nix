{
  config,
  lib,
  pkgs,
  ...
}:
{
  services = {
    postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
      settings = {
        listen_addresses = lib.mkForce ""; # only allow access via unix socket

        # ZFS
        full_page_writes = "off";

        # PGTune
        # DB Version: 16
        # OS Type: linux
        # DB Type: mixed
        # Total Memory (RAM): 12 GB
        # CPUs num: 8
        # Connections num: 200
        # Data Storage: ssd
        max_connections = "200";
        shared_buffers = "3GB";
        effective_cache_size = "9GB";
        maintenance_work_mem = "768MB";
        checkpoint_completion_target = "0.9";
        wal_buffers = "16MB";
        default_statistics_target = "100";
        random_page_cost = "1.1";
        effective_io_concurrency = "200";
        work_mem = "7561kB";
        huge_pages = "off";
        min_wal_size = "1GB";
        max_wal_size = "4GB";
        max_worker_processes = "8";
        max_parallel_workers_per_gather = "4";
        max_parallel_workers = "8";
        max_parallel_maintenance_workers = "4";
      };
    };

    redis = {
      vmOverCommit = true;
    };
  };

  /*
    PostgreSQL upgrade script.

    - set `newPostgres` below (only upgrade one major version increment at a time!)
    - deploy it to make the script available
    - stop all dependent services: `sudo systemctl stop phpfpm-nextcloud listmonk mastodon-sidekiq-all mastodon-web mastodon-streaming-1 mastodon-streaming-2 matrix-synapse atticd hedgedoc markov-bot-telegram`
    - run `sudo upgrade-pg-cluster`
    - set new package in PostgreSQL module above
    - re-deploy
      - note that the binary cache will still be down at this point, causing errors
      - either use `--option substitute false`
      - or temporarily turn it off in `home/base.nix`
    - recreate optimiziations using `vacuumdb --all --analyze-in-stages` as the script suggests
    - check health, then delete old folder

    See:
    https://nixos.org/manual/nixos/stable/#module-services-postgres-upgrading
    https://git.eisfunke.com/config/nixos/-/blob/46be2c5cd340d313917a0bd30fc29e6750d1747f/nixos/server/db.nix#L120
  */
  environment.systemPackages =
    let
      # PostgreSQL version to upgrade to, including extensions if any
      newPostgres = null;
      cfg = config.services.postgresql;
    in
    lib.lists.optional (newPostgres != null) (
      pkgs.writeShellScriptBin "upgrade-pg-cluster" ''
        set -eux

        systemctl stop postgresql

        export NEWDATA="/var/lib/postgresql/${newPostgres.psqlSchema}"
        export NEWBIN="${newPostgres}/bin"
        export OLDDATA="${cfg.dataDir}"
        export OLDBIN="${config.services.postgresql.finalPackage}/bin"

        # create and enter new data dir
        install -d -m 0700 -o postgres -g postgres "$NEWDATA"
        cd "$NEWDATA"

        # initialize new db
        sudo -u postgres $NEWBIN/initdb -D "$NEWDATA"

        # import old db data
        sudo -u postgres $NEWBIN/pg_upgrade \
          --old-datadir "$OLDDATA" --new-datadir "$NEWDATA" \
          --old-bindir $OLDBIN --new-bindir $NEWBIN \
          "$@"
      ''
    );
}
