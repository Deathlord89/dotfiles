{
  libx,
  outputs,
  ...
}:
{
  imports = libx.scanPaths ./. ++ (builtins.attrValues outputs.nixosModules);
}
