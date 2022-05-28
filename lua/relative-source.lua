local M = {}

local separators = {
  command = '|',
  path = '/',
}

---@return string
local function get_script_directory()
  return vim.fn.expand('<sfile>:p:h')
end

---@return string
local function get_parent_directory()
  return vim.fn.expand('%:p:h')
end

---@param string string
---@return boolean
local function is_null_or_empty(string)
  return not string or string == ''
end

---@return string
local function find_origin()
  local script_directory = get_script_directory()

  return is_null_or_empty(script_directory) and get_parent_directory()
    or script_directory
end

---@param origin string
---@param paths string[]
---@return string command
local function assemble_command(origin, paths)
  local prefix = 'source ' .. origin .. separators.path

  return prefix .. table.concat(paths, separators.command .. prefix)
end

---@param paths string[]
function M.source(paths)
  local command = assemble_command(
    find_origin(),
    paths
  )

  vim.api.nvim_command(command)
end

---@param paths string[]
---@deprecated use `require('relative-source').source(paths)` instead
function M.source_files(paths)
  M.source(paths)
end

return M
