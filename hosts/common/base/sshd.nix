{
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      X11Forwarding = true;
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };
}
