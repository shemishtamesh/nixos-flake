{
  programs.nixvim.plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
      mappings = {
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-y>" = "cmp.mapping.confirm()";
        "<C-n>" = "cmp.mapping.select_next_item()";
        "<C-p>" = "cmp.mapping.select_prev_item()";
      };
      sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "codeium"; }
      ];
    };
  };
}
