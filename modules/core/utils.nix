{
  flake.modules.nixvim.core = {
    lib,
    config,
    ...
  }: {
    options.utils = {
      wKeyList = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [];
      };
      mkKey = lib.mkOption {
        type = lib.types.attrs;
        default = {};
      };
    };
    config.utils.mkKey = rec {
      mkKey = {
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
      mkKeyMap = keys: map mkKey keys;
      mkKeyMapIf = cond: keys: lib.optionals cond (mkKeyMap keys);
      lazyKey = {
        mode ? "n",
        key,
        action,
        options,
      }:
        (lib.nixvim.utils.listToUnkeyedAttrs [key action])
        // {
          inherit mode;
          desc = lib.mkIf (lib.hasAttr "desc" options) options.desc;
        };
      keymapUnlazy = keys: lib.optionals (!config.plugins.lz-n.enable) keys;
      keymap2Lazy = keys: lib.optionals config.plugins.lz-n.enable (map lazyKey keys);
      wKeyObj = with builtins;
        keys:
          (lib.nixvim.utils.listToUnkeyedAttrs [(elemAt keys 0)])
          // {
            icon = elemAt keys 1;
            group = elemAt keys 2;
          }
          // lib.optionalAttrs (length keys > 3) {
            hidden = elemAt keys 3;
          };
      wKeyObjIf = cond: keys: lib.optionals cond (wKeyObj keys);
    };
  };
}
