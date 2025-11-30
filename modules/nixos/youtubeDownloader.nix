{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.multimedia.youtubeDownloader;

  channelsFile = pkgs.writeText "channels.txt" (lib.concatStringsSep "\n" cfg.channels);
  playlistsFile = pkgs.writeText "playlists.txt" (lib.concatStringsSep "\n" cfg.playlists);
  uniqueFile = pkgs.writeText "unique.txt" (lib.concatStringsSep "\n" cfg.uniques);

  format = builtins.replaceStrings [ "\n" ] [ "" ] ''
    (
    bestvideo[vcodec^=av01][height>=4320][fps>30]/bestvideo[vcodec^=vp09.02][height>=4320][fps>30]/bestvideo[vcodec^=vp09.00][height>=4320][fps>30]/bestvideo[vcodec^=vp9][height>=4320][fps>30]/bestvideo[vcodec^=avc1][height>=4320][fps>30]/bestvideo[height>=4320][fps>30]/bestvideo[vcodec^=av01][height>=4320]/bestvideo[vcodec^=vp09.02][height>=4320]/bestvideo[vcodec^=vp09.00][height>=4320]/bestvideo[vcodec^=vp9][height>=4320]/bestvideo[vcodec^=avc1][height>=4320]/bestvideo[height>=4320]/
    bestvideo[vcodec^=av01][height>=2880][fps>30]/bestvideo[vcodec^=vp09.02][height>=2880][fps>30]/bestvideo[vcodec^=vp09.00][height>=2880][fps>30]/bestvideo[vcodec^=vp9][height>=2880][fps>30]/bestvideo[vcodec^=avc1][height>=2880][fps>30]/bestvideo[height>=2880][fps>30]/bestvideo[vcodec^=av01][height>=2880]/bestvideo[vcodec^=vp09.02][height>=2880]/bestvideo[vcodec^=vp09.00][height>=2880]/bestvideo[vcodec^=vp9][height>=2880]/bestvideo[vcodec^=avc1][height>=2880]/bestvideo[height>=2880]/
    bestvideo[vcodec^=av01][height>=2160][fps>30]/bestvideo[vcodec^=vp09.02][height>=2160][fps>30]/bestvideo[vcodec^=vp09.00][height>=2160][fps>30]/bestvideo[vcodec^=vp9][height>=2160][fps>30]/bestvideo[vcodec^=avc1][height>=2160][fps>30]/bestvideo[height>=2160][fps>30]/bestvideo[vcodec^=av01][height>=2160]/bestvideo[vcodec^=vp09.02][height>=2160]/bestvideo[vcodec^=vp09.00][height>=2160]/bestvideo[vcodec^=vp9][height>=2160]/bestvideo[vcodec^=avc1][height>=2160]/bestvideo[height>=2160]/
    bestvideo[vcodec^=av01][height>=1440][fps>30]/bestvideo[vcodec^=vp09.02][height>=1440][fps>30]/bestvideo[vcodec^=vp09.00][height>=1440][fps>30]/bestvideo[vcodec^=vp9][height>=1440][fps>30]/bestvideo[vcodec^=avc1][height>=1440][fps>30]/bestvideo[height>=1440][fps>30]/bestvideo[vcodec^=av01][height>=1440]/bestvideo[vcodec^=vp09.02][height>=1440]/bestvideo[vcodec^=vp09.00][height>=1440]/bestvideo[vcodec^=vp9][height>=1440]/bestvideo[vcodec^=avc1][height>=1440]/bestvideo[height>=1440]/
    bestvideo[vcodec^=av01][height>=1080][fps>30]/bestvideo[vcodec^=vp09.02][height>=1080][fps>30]/bestvideo[vcodec^=vp09.00][height>=1080][fps>30]/bestvideo[vcodec^=vp9][height>=1080][fps>30]/bestvideo[vcodec^=avc1][height>=1080][fps>30]/bestvideo[height>=1080][fps>30]/bestvideo[vcodec^=av01][height>=1080]/bestvideo[vcodec^=vp09.02][height>=1080]/bestvideo[vcodec^=vp09.00][height>=1080]/bestvideo[vcodec^=vp9][height>=1080]/bestvideo[vcodec^=avc1][height>=1080]/bestvideo[height>=1080]/
    bestvideo[vcodec^=av01][height>=720][fps>30]/bestvideo[vcodec^=vp09.02][height>=720][fps>30]/bestvideo[vcodec^=vp09.00][height>=720][fps>30]/bestvideo[vcodec^=vp9][height>=720][fps>30]/bestvideo[vcodec^=avc1][height>=720][fps>30]/bestvideo[height>=720][fps>30]/bestvideo[vcodec^=av01][height>=720]/bestvideo[vcodec^=vp09.02][height>=720]/bestvideo[vcodec^=vp09.00][height>=720]/bestvideo[vcodec^=vp9][height>=720]/bestvideo[vcodec^=avc1][height>=720]/bestvideo[height>=720]/
    bestvideo[vcodec^=av01][height>=480][fps>30]/bestvideo[vcodec^=vp09.02][height>=480][fps>30]/bestvideo[vcodec^=vp09.00][height>=480][fps>30]/bestvideo[vcodec^=vp9][height>=480][fps>30]/bestvideo[vcodec^=avc1][height>=480][fps>30]/bestvideo[height>=480][fps>30]/bestvideo[vcodec^=av01][height>=480]/bestvideo[vcodec^=vp09.02][height>=480]/bestvideo[vcodec^=vp09.00][height>=480]/bestvideo[vcodec^=vp9][height>=480]/bestvideo[vcodec^=avc1][height>=480]/bestvideo[height>=480]/
    bestvideo[vcodec^=av01][height>=360][fps>30]/bestvideo[vcodec^=vp09.02][height>=360][fps>30]/bestvideo[vcodec^=vp09.00][height>=360][fps>30]/bestvideo[vcodec^=vp9][height>=360][fps>30]/bestvideo[vcodec^=avc1][height>=360][fps>30]/bestvideo[height>=360][fps>30]/bestvideo[vcodec^=av01][height>=360]/bestvideo[vcodec^=vp09.02][height>=360]/bestvideo[vcodec^=vp09.00][height>=360]/bestvideo[vcodec^=vp9][height>=360]/bestvideo[vcodec^=avc1][height>=360]/bestvideo[height>=360]/
    bestvideo[vcodec^=avc1][height>=240][fps>30]/bestvideo[vcodec^=av01][height>=240][fps>30]/bestvideo[vcodec^=vp09.02][height>=240][fps>30]/bestvideo[vcodec^=vp09.00][height>=240][fps>30]/bestvideo[vcodec^=vp9][height>=240][fps>30]/bestvideo[height>=240][fps>30]/bestvideo[vcodec^=avc1][height>=240]/bestvideo[vcodec^=av01][height>=240]/bestvideo[vcodec^=vp09.02][height>=240]/bestvideo[vcodec^=vp09.00][height>=240]/bestvideo[vcodec^=vp9][height>=240]/bestvideo[height>=240]/
    bestvideo[vcodec^=avc1][height>=144][fps>30]/bestvideo[vcodec^=av01][height>=144][fps>30]/bestvideo[vcodec^=vp09.02][height>=144][fps>30]/bestvideo[vcodec^=vp09.00][height>=144][fps>30]/bestvideo[vcodec^=vp9][height>=144][fps>30]/bestvideo[height>=144][fps>30]/bestvideo[vcodec^=avc1][height>=144]/bestvideo[vcodec^=av01][height>=144]/bestvideo[vcodec^=vp09.02][height>=144]/bestvideo[vcodec^=vp09.00][height>=144]/bestvideo[vcodec^=vp9][height>=144]/bestvideo[height>=144]/bestvideo
    )+(bestaudio[acodec^=opus]/bestaudio)/best
  '';

  downloadChannelScript = pkgs.writeShellApplication {
    name = "script-youtubeChannelDownloader";
    runtimeInputs = with pkgs; [ yt-dlp ];
    text = ''
      # TheFrenchGhosty's Ultimate YouTube-DL Scripts Collection - Version 3.4.0
      # https://github.com/TheFrenchGhosty/TheFrenchGhostys-Ultimate-YouTube-DL-Scripts-Collection

      yt-dlp \
        --format "${format}" \
        --force-ipv4 \
        --sleep-requests 1 \
        --sleep-interval 5 \
        --max-sleep-interval 30 \
        --ignore-errors \
        --no-continue \
        --no-overwrites \
        --download-archive "${cfg.outputDir}/channel_archive.log" \
        --add-metadata \
        --parse-metadata "%(title)s:%(meta_title)s" \
        --parse-metadata "%(uploader)s:%(meta_artist)s" \
        --write-description \
        --write-info-json \
        --write-thumbnail \
        --embed-thumbnail \
        --sponsorblock-mark all \
        --sponsorblock-remove sponsor \
        --write-subs \
        --write-auto-subs \
        --sub-lang "en.*,de,deu" \
        --embed-subs \
        --check-formats \
        --concurrent-fragments 3 \
        --match-filter "!is_live & !live" \
        --output "{cfg.outputDir}/%(uploader)s/%(uploader)s - %(upload_date)s - %(title)s/%(uploader)s - %(upload_date)s - %(title)s [%(id)s].%(ext)s" \
        --merge-output-format "mkv" \
        --throttled-rate 100K \
        --batch-file ${channelsFile} \
        --verbose
    '';
  };

  downloadPlaylistScript = pkgs.writeShellApplication {
    name = "script-youtubePlaylistDownloader";
    runtimeInputs = with pkgs; [ yt-dlp ];
    text = ''
      # TheFrenchGhosty's Ultimate YouTube-DL Scripts Collection - Version 3.4.0
      # https://github.com/TheFrenchGhosty/TheFrenchGhostys-Ultimate-YouTube-DL-Scripts-Collection

      yt-dlp \
        --format "${format}" \
        --force-ipv4 \
        --sleep-requests 1 \
        --sleep-interval 5 \
        --max-sleep-interval 30 \
        --ignore-errors \
        --no-continue \
        --no-overwrites \
        --download-archive "${cfg.outputDir}/playlist_archive.log" \
        --add-metadata \
        --parse-metadata "%(title)s:%(meta_title)s" --parse-metadata "%(uploader)s:%(meta_artist)s" \
        --write-description \
        --write-info-json \
        --write-thumbnail \
        --embed-thumbnail \
        --sponsorblock-mark all \
        --sponsorblock-remove sponsor \
        --write-subs \
        --write-auto-subs \
        --sub-lang "en.*,de,deu" \
        --embed-subs \
        --check-formats \
        --concurrent-fragments 3 \
        --match-filter "!is_live & !live" \
        --output "${cfg.outputDir}/%(playlist)s - (%(uploader)s)/%(upload_date)s - %(title)s/%(upload_date)s - %(title)s [%(id)s].%(ext)s" \
        --merge-output-format "mkv" \
        --throttled-rate 100K \
        --batch-file ${playlistsFile} \
        --verbose
    '';
  };

  downloadUniqueScript = pkgs.writeShellApplication {
    name = "script-youtubeUniqueDownloader";
    runtimeInputs = with pkgs; [ yt-dlp ];
    text = ''
      # TheFrenchGhosty's Ultimate YouTube-DL Scripts Collection - Version 3.4.0
      # https://github.com/TheFrenchGhosty/TheFrenchGhostys-Ultimate-YouTube-DL-Scripts-Collection

      yt-dlp \
        --format "${format}" \
        --force-ipv4 \
        --sleep-requests 1 \
        --sleep-interval 5 \
        --max-sleep-interval 30 \
        --ignore-errors \
        --no-continue \
        --no-overwrites \
        --download-archive "${cfg.outputDir}/unique_archive.log" \
        --add-metadata \
        --parse-metadata "%(title)s:%(meta_title)s" \
        --parse-metadata "%(uploader)s:%(meta_artist)s" \
        --write-description \
        --write-info-json \
        --write-thumbnail \
        --embed-thumbnail \
        --sponsorblock-mark all \
        --sponsorblock-remove sponsor \
        --write-subs \
        --write-auto-subs \
        --sub-lang "en.*,de,deu" \
        --embed-subs \
        --check-formats \
        --concurrent-fragments 3 \
        --match-filter "!is_live & !live" \
        --output "${cfg.outputDir}/%(title)s - %(uploader)s - %(upload_date)s/%(title)s - %(uploader)s - %(upload_date)s [%(id)s].%(ext)s" \
        --merge-output-format "mkv" \
        --throttled-rate 100K \
        --batch-file ${uniqueFile} \
        --verbose
    '';
  };
in
{
  options = {
    multimedia.youtubeDownloader = {
      enable = lib.mkEnableOption "Enable automatice YouTube Downloader";

      channels = lib.mkOption {
        type = with lib.types; listOf types.str;
        default = [ ];
        description = "List of YouTube channel URLs to download.";
      };

      playlists = lib.mkOption {
        type = with lib.types; listOf types.str;
        default = [ ];
        description = "List of YouTube playlist URLs to download.";
      };

      uniques = lib.mkOption {
        type = with lib.types; listOf types.str;
        default = [ ];
        description = "List of YouTube unique URLs to download.";
      };

      outputDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/ytdl";
        description = "Absolute path to directory where downloaded videos will be stored.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "ytdl";
        description = "System user to run the downloader service as.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "ytdl";
        description = "Group ownership for the output directory and service.";
      };

      timerInterval = lib.mkOption {
        type = lib.types.str;
        default = "daily";
        description = ''
          Systemd timer OnCalendar value, e.g. "daily", "hourly", "weekly", "Mon *-*-* 12:00:00"
          Defines how often the download runs automatically.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = {
      # Create the user if it doesn't exist
      # Note: system user, no login shell
      # If you want custom UID/GID, user can override with user/group options
      ${cfg.user} = lib.mkIf (cfg.user == "ytdl") {
        isSystemUser = true;
        description = "User for running YouTube downloader service";
        inherit (cfg) group;
        home = cfg.outputDir;
        createHome = false;
      };
    };
    users.groups.${cfg.group} = lib.mkIf (cfg.group == "ytdl") { };

    systemd.tmpfiles.rules = [
      # Create output dir with proper ownership & perms
      "d ${cfg.outputDir} 0775 ${cfg.user} ${cfg.group} -"
    ];

    systemd = {
      services = {
        youtubeDownloader = {
          description = "YouTube Downloader Service";

          serviceConfig = {
            # Execute a dummy program
            ExecStart = "/run/current-system/sw/bin/true";
          };

          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];
        };

        youtubeChannelDownloader = lib.mkIf (cfg.channels != [ ]) {
          description = "YouTube Downloader Service - Channel";

          serviceConfig = {
            Type = "oneshot";
            UMask = "002";
            ExecStart = "${pkgs.lib.getExe downloadChannelScript}";
            Restart = "on-failure";
            User = cfg.user;
            Group = cfg.group;
            WorkingDirectory = cfg.outputDir;
          };

          wantedBy = [ "youtubeDownloader.service" ];
          partOf = [ "youtubeDownloader.service" ];
          after = [ "youtubeDownloader.service" ];
        };

        youtubePlaylistDownloader = lib.mkIf (cfg.playlists != [ ]) {
          description = "YouTube Downloader Service - Playlist";

          serviceConfig = {
            Type = "oneshot";
            UMask = "002";
            ExecStart = "${pkgs.lib.getExe downloadPlaylistScript}";
            Restart = "on-failure";
            User = cfg.user;
            Group = cfg.group;
            WorkingDirectory = cfg.outputDir;
          };

          wantedBy = [ "youtubeDownloader.service" ];
          partOf = [ "youtubeDownloader.service" ];
          after = [ "youtubeDownloader.service" ];
        };

        youtubeUniqueDownloader = lib.mkIf (cfg.uniques != [ ]) {
          description = "YouTube Downloader Service - Unique";

          serviceConfig = {
            Type = "oneshot";
            UMask = "002";
            ExecStart = "${pkgs.lib.getExe downloadUniqueScript}";
            Restart = "on-failure";
            User = cfg.user;
            Group = cfg.group;
            WorkingDirectory = cfg.outputDir;
          };

          wantedBy = [ "youtubeDownloader.service" ];
          partOf = [ "youtubeDownloader.service" ];
          after = [ "youtubeDownloader.service" ];
        };
      };

      timers.youtubeDownloader = {
        description = "Timer to run YouTube downloader service";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = cfg.timerInterval;
          Persistent = true;
        };
      };
    };
  };
}
