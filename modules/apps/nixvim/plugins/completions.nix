{
  programs.nixvim.plugins.cmp = {
    # enable = true;
    # autoEnableSources = true;
    # settings = {
    #   mappings = {
    #     "<C-Space>" = "cmp.mapping.complete()";
    #     "<C-y>" = "cmp.mapping.confirm({ select = true })";
    #     "<C-n>" = "cmp.mapping.select_next_item()";
    #     "<C-p>" = "cmp.mapping.select_prev_item()";
    #   };
    #   sources = [
    #     { name = "nvim_lsp"; }
    #     { name = "path"; }
    #     { name = "buffer"; }
    #     { name = "codeium"; }
    #   ];
    # };
    enable = true;
    settings = {
      autoEnableSources = true;
      performance = {
        debounce = 150;
      };
      sources = [
        { name = "path"; }
        {
          name = "nvim_lsp";
          keywordLength = 1;
        }
        {
          name = "buffer";
          keywordLength = 3;
        }
        { name = "supermaven"; }
        { name = "codeium"; }
      ];

      snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
      formatting = {
        fields = [
          "menu"
          "abbr"
          "kind"
        ];
        format = ''
          function(entry, item)
            local menu_icon = {
              nvim_lsp = '[LSP]',
              luasnip = '[SNIP]',
              buffer = '[BUF]',
              path = '[PATH]',
            }

            item.menu = menu_icon[entry.source.name]
            return item
          end
        '';
      };

      mapping = {
        "<Up>" = "cmp.mapping.select_prev_item()";
        "<Down>" = "cmp.mapping.select_next_item()";

        "<C-p>" = "cmp.mapping.select_prev_item()";
        "<C-n>" = "cmp.mapping.select_next_item()";

        "<C-u>" = "cmp.mapping.scroll_docs(-4)";
        "<C-d>" = "cmp.mapping.scroll_docs(4)";

        "<C-e>" = "cmp.mapping.abort()";
        "<C-y>" = "cmp.mapping.confirm({select = true})";
        "<CR>" = "cmp.mapping.confirm({select = false})";

        "<C-f>" = ''
          cmp.mapping(
            function(fallback)
              if luasnip.jumpable(1) then
                luasnip.jump(1)
              else
                fallback()
              end
            end,
            { "i", "s" }
          )
        '';

        "<C-b>" = ''
          cmp.mapping(
            function(fallback)
              if luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end,
            { "i", "s" }
          )
        '';

        "<Tab>" = ''
          cmp.mapping(
            function(fallback)
              local col = vim.fn.col('.') - 1

              if cmp.visible() then
                cmp.select_next_item(select_opts)
              elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                fallback()
              else
                cmp.complete()
              end
            end,
            { "i", "s" }
          )
        '';

        "<S-Tab>" = ''
          cmp.mapping(
            function(fallback)
              if cmp.visible() then
                cmp.select_prev_item(select_opts)
              else
                fallback()
              end
            end,
            { "i", "s" }
          )
        '';
      };
      window = {
        completion = {
          border = "rounded";
          winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None";
          zindex = 1001;
          scrolloff = 0;
          colOffset = 0;
          sidePadding = 1;
          scrollbar = true;
        };
        documentation = {
          border = "rounded";
          winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None";
          zindex = 1001;
          maxHeight = 20;
        };
      };
    };
  };
}
