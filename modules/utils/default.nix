{
  lib,
  config,
  ...
}: {
  options.my = {
    wKeyList = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
    };
    mkKey = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };
  config.my.mkKey = rec {
    mkKeyMap = mode: key: action: desc: {
      inherit mode key action;
      options = {
        inherit desc;
        silent = true;
        noremap = true;
        remap = true;
      };
    };
    mkKeyMap' = mode: key: action: mkKeyMap mode key action null;
    mkKeyMapWithOpts = mode: key: action: desc: opts: (mkKeyMap mode key action desc) // {options = opts;};
    lazyKeyMap = key: action: desc: {
      inherit desc;
      __unkeyed-1 = key;
      __unkeyed-2 = action;
    };
    keymap2mkKeyMap = list: builtins.map (i: mkKeyMap i.mode i.key i.action i.options.desc) list;
    keymapUnlazy = list: lib.optionals (!config.plugins.lz-n.enable) list;
    keymap2Lazy = list: lib.optionals config.plugins.lz-n.enable (builtins.map (i: lazyKeyMap i.key i.action i.options.desc) list);
    wKeyObj = with builtins;
      list:
        {
          __unkeyed = elemAt list 0;
          icon = elemAt list 1;
          group = elemAt list 2;
        }
        // lib.optionalAttrs (length list > 3) {
          hidden = elemAt list 3;
        };
  };
}
