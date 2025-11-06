{ nixpkgs, ... }:
{
  # Use path relative to the root of the project
  relativeToRoot = nixpkgs.lib.path.append ../.;

  # Scan folder an import all nix files
  scanPaths =
    path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        nixpkgs.lib.attrsets.filterAttrs (
          path: _type:
          (_type == "directory") # include directories
          || (
            (path != "default.nix") # ignore default.nix
            && (nixpkgs.lib.strings.hasSuffix ".nix" path) # include .nix files
          )
        ) (builtins.readDir path)
      )
    );
}
