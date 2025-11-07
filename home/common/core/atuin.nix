{
  programs.atuin = {
    enable = true;
    daemon.enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      enter_accept = true;
      filter_mode_shell_up_key_binding = "host";
      auto_sync = true;
      sync_frequency = "15m";
      secrets_filter = true;
      records = true;
      daemon = {
        enabled = true;
        systemd_socket = true;
      };
    };
  };
}
