{ hostname, lib, ... }:
{
  # Import host specific coinfigurations
  imports = (
    lib.optional (builtins.pathExists (./. + "/hosts/${hostname}.nix")) ./hosts/${hostname}.nix
  );

}
