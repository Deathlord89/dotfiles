{
  config,
  sopsFolder,
  ...
}:
#let
#  sopsFolder = builtins.toString inputs.nix-secrets + "/sops";
#in
{
  sops = {
    defaultSopsFile = "${sopsFolder}/${config.networking.hostName}.yaml";
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;

    age = {
      # Automatically import host SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      # this will use an age key that is expected to already be in the filesystem
      keyFile = "/var/lib/sops-nix/key.txt";
      # generate a new key if the key specified above does not exist
      generateKey = true;
    };
  };
}
