{
  flake.modules.nixvim.db = {
    lib,
    config,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMap wKeyObj;
    inherit (lib.nixvim.utils) mkRaw;
    cfg = config.plugins.dbee;
    keymaps = builtins.map mkKeyMap (lib.optionals cfg.enable [
      {
        action = mkRaw ''
          function()
            require("dbee").toggle()
          end
        '';
        key = "<localleader>d";
        options.desc = "Dbee toggle";
      }
    ]);
  in {
    inherit keymaps;
    plugins.dbee = {
      enable = true;
      settings = {
        sources = [
          (mkRaw
            ''require("dbee.sources").FileSource:new(vim.fn.stdpath("state") .. "/dbee/persistence.json")'')
          (mkRaw
            ''require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS")'')
        ];
      };
    };
    utils.wKeyList = lib.optionals cfg.enable [
      (wKeyObj ["<localleader>d" "" "Dbee"])
    ];
  };
}
