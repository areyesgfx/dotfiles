-- ============================================================================
-- Plugin Specifications
-- ============================================================================

return {
  -- ==========================================================================
  -- Colorscheme - GitHub Dark High Contrast (matches Ghostty terminal)
  -- ==========================================================================
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({
        options = {
          transparent = true,        -- Enable transparency
          terminal_colors = true,
          styles = {
            comments = "italic",
            keywords = "bold",
            functions = "NONE",
            variables = "NONE",
          },
        },
      })
      vim.cmd.colorscheme("github_dark_high_contrast")
    end,
  },

  -- ==========================================================================
  -- Treesitter - Advanced syntax highlighting
  -- ==========================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Enable treesitter-based highlighting
      vim.treesitter.language.register("hcl", "terraform")

      -- Install parsers automatically
      local parsers = {
        "lua", "vim", "vimdoc", "query", "javascript", "typescript",
        "python", "rust", "go", "bash", "json", "yaml", "toml",
        "html", "css", "markdown", "markdown_inline", "hcl",
      }

      -- Ensure parsers are installed
      for _, parser in ipairs(parsers) do
        pcall(function()
          vim.treesitter.language.add(parser)
        end)
      end

      -- Auto-enable highlighting for buffers
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },

  -- ==========================================================================
  -- Harpoon 2 - Quick file navigation
  -- ==========================================================================
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      -- REQUIRED
      harpoon:setup()

      -- Keymaps
      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end,
        { desc = "Harpoon: Add file" })
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        { desc = "Harpoon: Toggle menu" })

      -- Quick access to harpooned files
      vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end,
        { desc = "Harpoon: File 1" })
      vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end,
        { desc = "Harpoon: File 2" })
      vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end,
        { desc = "Harpoon: File 3" })
      vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end,
        { desc = "Harpoon: File 4" })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end,
        { desc = "Harpoon: Previous" })
      vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end,
        { desc = "Harpoon: Next" })

      -- Harpoon list rendered as a Telescope picker (instead of the native
      -- quick menu), so it gets fuzzy filtering, preview, etc.
      local function harpoon_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        local conf = require("telescope.config").values
        require("telescope.pickers").new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({ results = file_paths }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        }):find()
      end

      vim.keymap.set("n", "<leader>fm", function() harpoon_telescope(harpoon:list()) end,
        { desc = "Harpoon: Marks (Telescope)" })
    end,
  },

  -- ==========================================================================
  -- Telescope - Fuzzy finder over files, buffers, grep, etc.
  -- ==========================================================================
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
      })

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope: Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope: Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope: Buffers" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Telescope: Recent files" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope: Help tags" })
    end,
  },

  -- ==========================================================================
  -- Plenary - Required dependency for many plugins
  -- ==========================================================================
  { "nvim-lua/plenary.nvim", lazy = true },
}
