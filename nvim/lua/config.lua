local ok, lspconfig = pcall(require, 'lspconfig')

if ok then
  local ts = lspconfig.ts_ls or lspconfig.tsserver

  if ts then
    ts.setup {}
  end
end
