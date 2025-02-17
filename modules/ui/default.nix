{
  plugins = {
    dressing = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
      settings.input.mapping.n = {
        "q" = "Close";
        "k" = "HistoryPrev";
        "j" = "HistoryNext";
      };
    };
    notify = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
    };
  };
  imports = with builtins;
    map (fn: ./${fn})
    (filter
      (fn: (
        fn != "default.nix"
      ))
      (attrNames (readDir ./.)));
}
