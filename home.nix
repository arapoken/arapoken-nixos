{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "arapoken";
  home.homeDirectory = "/home/arapoken";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    rust-analyzer fortls basedpyright
    (python3.withPackages (ps: with ps; [
       numpy scipy matplotlib  
    ]))
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # kitty
  programs.kitty = {
    enable = true;
    settings = {
      cursor_trail = 500;
      font_family = "RobotoMono Nerd Font";
      background_opacity = "0.8";
    };
  };

  # fish
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "pure";
        src = pkgs.fetchFromGitHub {
          owner = "pure-fish";
          repo = "pure";
          rev = "376227f02f2ef15f0c4353c6d0265ef10bedb6f8";
          sha256 = "sha256-IE2MgxBPmargP6seM9J8ycxyUeI0TQLhYbZb/Ryzues=";
        };
      }
    ];
  };

  # yazi
  programs.yazi = {
    enable = true;
    plugins = {
      mount = pkgs.yaziPlugins.mount;
    };
    keymap = {
      mgr.prepend_keymap = [
        { run = "plugin mount"; on = [ "M" ]; desc = "mount.yazi"; }
      ];
    };
  };

  # neovim
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      nvim-treesitter.withAllGrammars
      telescope-nvim
      nvim-web-devicons
      nvim-cmp
      cmp-nvim-lsp
      luasnip
      nvim-lspconfig
    ];
    extraLuaConfig = ''
      vim.opt.number = true
      vim.opt.relativenumber = false
      vim.opt.termguicolors = true
      vim.opt.laststatus = 3
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.updatetime = 250
      vim.opt.virtualedit = "block"
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 4
      vim.opt.tabstop = 4
      require("catppuccin").setup({ flavour = "mocha" })
      vim.cmd.colorscheme "catppuccin"
      local servers = { "basedpyright", "fortls", "rust_analyzer" }
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      for _, lsp in ipairs(servers) do
          if vim.lsp.config[lsp] then
              vim.lsp.config(lsp, {
                  install = { capabilities = capabilities }
              })
              vim.lsp.enable(lsp)
          end
      end
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local opts = { buffer = args.buf }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
        end,
      })
    local cmp = require'cmp'
      cmp.setup({
        snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({{ name = 'nvim_lsp' }})
      })
    '';
  };

  # btop
  programs.btop = {
    enable = true;
    settings.color_theme = "dusklight";
  };

  # .config/niri/config.kdl
  # prefer-no-csd
  # focus-ring {
  #     active-color "#22cccc"
  # }
  # window-rule {
  #     geometry-corner-radius 6
  #     clip-to-geometry true
  # }
  # binds {
  #     Mod+Return hotkey-overlay-title="Open a Terminal" { spawn "kitty"; }
  #     Mod+Space hotkey-overlay-title="Run an Application" { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
  #     Mod+P hotkey-overlay-title="Open the Power Menu" { spawn "noctalia-shell" "ipc" "call" "sessionMenu" "toggle"; }
  #     Mod+Alt+L hotkey-overlay-title="Lock the Screen" { spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock"; }
  # }
  # spawn-at-startup "fcitx5" "-d"
  # spawn-at-startup "noctalia-shell"
  # // Set the overview wallpaper on the backdrop.
  # layer-rule {
  #     match namespace="^noctalia-overview*"
  #     place-within-backdrop true
  # }

  # .config/noctalia/settings.json
  # {
  #     "appLauncher": {
  #         "terminalCommand": "kitty -e",
  #     },
  #     "colorSchemes": {
  #         "useWallpaperColors": true
  #     },
  #     "general": {
  #         "avatarImage": "/home/arapoken/Downloads/Screenshot_2026-01-29_at_23-48-18.png",
  #     "wallpaper": {
  #         "directory": "/home/arapoken/Downloads",
  #         "overviewEnabled": true,
  #     }
  # } 

}
