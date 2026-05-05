{
  pkgs,
  vimUtils,
  buildNpmPackage,
  ...
}: let
  pname = "gitlab-ls";
  version = "git";
  src = pkgs.fetchFromGitLab {
    owner = "gitlab-org/editor-extensions";
    repo = "gitlab.vim";
    rev = "main";
    hash = "sha256-rhYz3Z1Dcffvo8E3390gOBcqfFclWJ19wTKwp6L/874=";
  };
  luaPlugin = vimUtils.buildVimPlugin {
    inherit version src;
    pname = "${pname}-luaplugin";
  };
  npmPkg = buildNpmPackage {
    inherit version src;
    pname = "${pname}-npm-pkgs";
    postPatch = ''
      cp ${../misc/gitlab-vim-package-lock.json} package-lock.json
    '';
    npmFlags = ["--ignore-scripts"];
    # makeCacheWritable = true;
    npmDepsHash = "sha256-K1peydqYdCH7MbzGS1JbYqokgGw4FXNGYMB4vL3GRJ0=";
    dontNpmBuild = true;
    dontNpmInstall = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp package.json $out
      cp package-lock.json $out
      cp -r node_modules $out
      runHook postInstall
    '';
    dontFixup = true;
  };
in
  pkgs.buildEnv {
    name = pname;
    paths = [npmPkg luaPlugin];
    ignoreCollisions = true;
  }
