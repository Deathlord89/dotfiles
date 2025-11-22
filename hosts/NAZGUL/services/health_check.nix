# https://mazzo.li/posts/hetzner-zfs.html
{
  config,
  inputs,
  pkgs,
  ...
}:
let
  # Mail sender / recepient
  emailTo = inputs.nix-secrets.email.user; # where to send the notifications
  emailFrom = inputs.nix-secrets.email.domain; # who should be the sender in the emails

  # Sends an email with some heading and the zpool status
  sendEmailEvent =
    { event }:
    ''
      printf "Subject: NAZGUL ${event} ''$(${pkgs.coreutils}/bin/date --iso-8601=seconds)\n\nzpool status:\n\n''$(${pkgs.zfs}/bin/zpool status)" | ${pkgs.msmtp}/bin/msmtp -a default ${emailTo}
    '';
in
{
  sops.secrets.smtppassword = { };

  # We need email support in ZFS for ZED.
  # Seems to work without ...
  #nixpkgs.config.packageOverrides = pkgs: {
  #  zfsStable = pkgs.zfsStable.override {enableMail = true;};
  #};

  # mstp setup
  programs.msmtp = {
    enable = true;
    setSendmail = true;
    defaults = {
      aliases = builtins.toFile "aliases" ''
        default: ${emailTo}
      '';
    };
    accounts.default = {
      auth = true;
      tls = true;
      tls_starttls = false;
      host = "smtp.strato.de";
      port = "465";
      passwordeval = "cat ${config.sops.secrets."smtppassword".path}";
      user = emailFrom;
      from = emailFrom;
    };
  };

  # ZED setup (ZFS notifications)
  # Check out <https://github.com/openzfs/zfs/blob/master/cmd/zed/zed.d/zed.rc> for options.
  services.zfs.zed = {
    enableMail = true;
    settings = {
      ZED_EMAIL_ADDR = [ emailTo ];
      ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";

      ZED_EMAIL_OPTS = "@ADDRESS@";
      #ZED_EMAIL_OPTS = "-a 'FROM:${emailFrom}' -s '@SUBJECT@' @ADDRESS@";

      ZED_NOTIFY_VERBOSE = true;
      ZED_DEBUG_LOG = "/tmp/zed.debug.log";
    };
  };

  # Smartd email notifications
  services.smartd = {
    enable = true;
    notifications.mail = {
      enable = true;
      sender = emailFrom;
      recipient = emailTo;
    };
  };

  # Email alerts on startup, and Mondays.
  systemd = {
    services = {
      "boot-mail-alert" = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = sendEmailEvent { event = "just booted"; };
      };
      "weekly-mail-alert" = {
        serviceConfig.Type = "oneshot";
        script = sendEmailEvent { event = "is still alive"; };
      };
    };
    timers."weekly-mail-alert" = {
      wantedBy = [ "timers.target" ];
      partOf = [ "weekly-mail-alert.service" ];
      timerConfig.OnCalendar = "weekly";
    };
  };
}
