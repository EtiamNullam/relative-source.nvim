local M = {}

local separators = {
  command = '|',
  path = '/',
}

---@param message string
local function log_error(message)
  vim.notify(
    'relative-source: ' .. message,
    vim.log.levels.WARN
  )
end

---@param origin string
---@return string
local function assemble_command_prefix(origin)
  return 'source ' .. origin .. separators.path
end

---@param path string
---@param result any
---@return string
local function assemble_source_error_message(path, result)
  local message = type(result) == 'string' and result
    or vim.inspect(result)

  return 'Failed to source "' .. path .. '"\n' .. message
end

---@param path string
---@param result any
local function log_source_error(path, result)
  local message = assemble_source_error_message(path, result)

  log_error(message)
end

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

---@param command_prefix string
---@param path string
---@return boolean success
local function try_source_file(command_prefix, path)
  local command = command_prefix .. path
  local success, result = pcall(vim.cmd, command)

  if not success then
    log_source_error(path, result)
  end

  return success
end

---@param command_prefix string
---@param paths string[]
local function source_files(command_prefix, paths)
  for _, path in pairs(paths) do
    try_source_file(command_prefix, path)
  end
end

---@param paths string[]
function M.source(paths)
  local command_prefix = assemble_command_prefix(find_origin())

  source_files(command_prefix, paths)
end

---@param paths string[]
---@deprecated use `require('relative-source').source(paths)` instead
function M.source_files(paths)
  M.source(paths)
end

return M
