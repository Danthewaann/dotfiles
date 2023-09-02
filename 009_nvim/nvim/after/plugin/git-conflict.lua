-- vim.cmd("highlight GitConflictCurrent")
-- vim.cmd("highlight GitConflictIncoming")
-- vim.cmd("highlight GitConflictAncestor")
-- vim.cmd("highlight GitConflictCurrentLabel")
-- vim.cmd("highlight GitConflictIncomingLabel")
-- vim.cmd("highlight GitConflictAncestorLabel")

require('git-conflict').setup {
    disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
}

