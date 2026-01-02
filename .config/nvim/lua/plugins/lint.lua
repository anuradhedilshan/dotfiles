return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- Register the markdownlint-cli2 linter
      lint.linters.markdownlint_cli2 = {
        cmd = 'markdownlint-cli2',
        stdin = false,
        args = { '--stdin' },
        stream = 'stdout',
        ignore_exitcode = true,
      }

      -- Associate the linter with markdown filetypes
      lint.linters_by_ft = {
        markdown = { 'markdownlint_cli2' },
      }

      -- Guard against missing binaries
      if vim.fn.executable 'markdownlint-cli2' == 0 then
        vim.notify('markdownlint-cli2 not found, skipping lint setup', vim.log.levels.WARN)
        return
      end

      -- Autocommand group for linting
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
