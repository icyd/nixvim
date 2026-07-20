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
    hash = "sha256-i64MIJqWf3BVJPEf5dpzU5nvnTNXjqn4c8SuQ6Pkct4=";
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
    npmDepsHash = "sha256-b75anfXeKDznavV5Xz4B/FepQGvgpI44cnbLBnU6+yU=";
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
