local use_ntm = false
if vim.env.USE_NTM ~= nil then
    vim.env.USE_NTM = nil
    use_ntm = true
end

return {
    use_ntm = use_ntm,
}
