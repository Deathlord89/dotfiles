{ lib, ... }: {
  services.tailscale = {
    enable = true;
    # After enabling, you can login to your Tailscale account with:
    # tailscale login
    useRoutingFeatures = lib.mkDefault "client";
  };
}
