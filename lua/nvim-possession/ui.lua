local utils = require("nvim-possession.utils")

--- extend fzf builtin previewer
local M = {}

--- Create a Telescope buffer previewer for session files
--- @param session_path string The path to the session directory
--- @return table A Telescope previewer object
M.create_buffer_previewer = function(session_path)
	local previewers = require("telescope.previewers")

	return previewers.new_buffer_previewer({
		define_preview = function(self, entry, status)
			if not entry or not entry.value then
				return
			end

			-- Get the session file path
			local session_file = session_path .. entry.value

			-- Get the list of files in the session
			local files = utils.session_files(session_file)

			-- Clear the preview buffer
			vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {})

			-- If there are files, display them
			if files and #files > 0 then
				vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, files)

				-- Add a header line
				local header = string.format("📌 Session: %s (%d files)", entry.value, #files)
				vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 0, false, { header, string.rep("─", #header) })
			else
				vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {
					"📭 No files found in this session",
				})
			end
		end,
		winopts = {
			wrap = false,
			number = false,
		},
	})
end

return M
