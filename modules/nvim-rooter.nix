{
  flake.modules.nixvim.nvim-rooter = {
    plugins.nvim-rooter = {
      enable = true;
      lazyLoad.settings = {
        event = ["BufReadPost" "BufNewFile"];
      };
    };
  };
}
