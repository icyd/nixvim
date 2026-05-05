{
  flake.modules.nixvim.nvim-rooter = {pkgs, ...}: {
    extraPlugins = with pkgs; [
      local.nvim-rooter
    ];
    plugins.lz-n.plugins = [
      {
        __unkeyed-1 = "nvim-rooter";
        event = ["BufReadPost" "BufNewFile"];
        after = ''
          function()
            require("nvim-rooter").setup({})
          end
        '';
      }
    ];
  };
}
