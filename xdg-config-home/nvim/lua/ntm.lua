local use_ntm = false
if vim.env.USE_NTM then
    vim.print("USE_NTM was set")
    vim.env.USE_NTM = nil
    use_ntm = true
end

return {
    use_ntm = use_ntm,
}
