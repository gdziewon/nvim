local M = {}

function M.on_attach(client, bufnr)
  -- Define a helper function to set keymaps
  local function map(mode, keys, func, desc)
    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
  end

  -- LSP Key Mappings
  map('n', 'gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  map('n', 'gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  map('n', 'gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  map('n', '<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  map('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  map('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  map('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  map({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  map('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Highlight references under the cursor
  if client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
    local highlight_augroup = vim.api.nvim_create_augroup('lsp-document-highlight', { clear = true })

    auto({ 'CursorHold', 'CursorHoldI' }, {
      group = highlight_augroup,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })

    auto({ 'CursorMoved', 'CursorMovedI' }, {
      group = highlight_augroup,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })

    auto('LspDetach', {
      group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
      buffer = bufnr,
      callback = function(event)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = 'lsp-document-highlight', buffer = event.buf }
      end,
    })
  end

  -- Toggle inlay hints
  if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    map('n', '<leader>th', function()
      vim.lsp.inlay_hint(bufnr, nil) -- Toggle inlay hints
    end, '[T]oggle Inlay [H]ints')
  end
end

return M
