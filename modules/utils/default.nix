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
    mkKeyMap = {
      mode ? "n",
      key,
      action,
      options,
    }: {
      inherit mode key action;
      options =
        {
          silent = true;
          noremap = true;
          remap = true;
        }
        // options;
    };
    lazyKeyMap = {
      mode ? "n",
      key,
      action,
      options,
    }: {
      inherit mode;
      __unkeyed-1 = key;
      __unkeyed-2 = action;
      __unkeyed-3 = options;
    };
    keymapUnlazy = list: lib.optionals (!config.plugins.lz-n.enable) list;
    keymap2Lazy = list: lib.optionals config.plugins.lz-n.enable (builtins.map lazyKeyMap list);
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
