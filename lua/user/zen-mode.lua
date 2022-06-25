local zen_mode_status_ok, cmp = pcall(require, "zen-mode")
if not zen_mode_status_ok then
  return
end

require("zen-mode").setup({})
