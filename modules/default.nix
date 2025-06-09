{lib, ...}: {
  flake.myModules = lib.foldlAttrs (
      acc: name: type:
        acc // (lib.optionalAttrs (type == "directory") {${name} = ./${name};})
    ) {} (builtins.readDir ./.);
}
