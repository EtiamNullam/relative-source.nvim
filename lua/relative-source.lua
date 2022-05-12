local M = {}

function M.source_files(files_to_source)
  local script_directory = vim.fn.expand('<sfile>:p:h')

  local is_called_from_script = script_directory
    and string.len(script_directory) ~= 0

  local origin = is_called_from_script and script_directory
    or vim.fn.expand('%:p:h')

  local source_relative_command_prefix = 'source ' .. origin .. '/'
  local source_files_command = source_relative_command_prefix .. table.concat(files_to_source, '|' .. source_relative_command_prefix)

  vim.api.nvim_command(source_files_command)
end

return M
