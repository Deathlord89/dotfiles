{ config, inputs, ... }: {
  sops.secrets = {
    "vaultwarden_env.enc" = {
      owner = "vaultwarden";
    };
  };

  services = {
    vaultwarden = {
      enable = true;

      dbBackend = "postgresql";
      configurePostgres = false;

      environmentFile = "${config.sops.secrets."vaultwarden_env.enc".path}";
      config = {
        # Refer to https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
        DOMAIN = "https://vault.${inputs.nix-secrets.domain}";

        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";

        DATABASE_URL = "postgresql:///vaultwarden?host=/run/postgresql&user=vaultwarden";
      };
    };

    postgresql = {
      ensureUsers = [
        {
          name = "vaultwarden";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [ "vaultwarden" ];
    };
  };
}
