local M = {}

local separators = {
  command = '|',
  path = '/',
}

---@param script_directory string|nil
local function is_called_from_script(script_directory)
  return script_directory and string.len(script_directory) ~= 0
    or false
end

---@return string script_directory
local function get_script_directory()
  return vim.fn.expand('<sfile>:p:h')
end

---@return string parent_directory
local function get_parent_directory()
  return vim.fn.expand('%:p:h')
end

local function find_origin()
  local script_directory = get_script_directory()

  return is_called_from_script(script_directory) and script_directory
    or get_parent_directory()
end

---@param origin string
---@param paths string[]
---@return string command
local function assemble_command(origin, paths)
  local prefix = 'source ' .. origin .. separators.path

  return prefix .. table.concat(paths, separators.command .. prefix)
end

---@param paths string[]
function M.source_files(paths)
  local command = assemble_command(
    find_origin(),
    paths
  )

  vim.api.nvim_command(command)
end

return M
