
local M = {}

---@param message string
local function log_error(message)
  vim.notify(
    '[relative-source] ' .. message,
    vim.log.levels.WARN
  )
end

---@param origin string
---@param segment string
---@return string
local function assemble_relative_path(origin, segment)
  return origin .. '/' .. segment
end

---@param pattern string
---@return string
local function assemble_no_matches_error_message(pattern)
  return 'No files matches for pattern: "' .. pattern .. '"'
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

---@param str string
---@return boolean
local function is_empty(str)
  return string.len(str) == 0
end

---@param str string
---@return boolean
local function is_null_or_empty(str)
  return str == nil or is_empty(str)
end

---@param string string
---@return boolean
local function starts_with_slash(string)
  return string.find(string, '^[\\%/]') ~= nil
end

---@param pattern string
---@return boolean
local function starts_with_windows_system_drive(pattern)
  return string.find(pattern, '^.:') ~= nil
end

---@param pattern string
---@return boolean
local function starts_with_tilde(pattern)
  return string.find(pattern, '^~') ~= nil
end

---@param pattern string
---@return boolean
local function is_absolute(pattern)
  return starts_with_slash(pattern)
    or starts_with_tilde(pattern)
    or starts_with_windows_system_drive(pattern)
end

---@param pattern string
---@return string[]
local function find_files(pattern)
  return vim.fn.glob(pattern, 0, 1)
end

---@param pattern string
---@return string
local function find_file(pattern)
  return vim.fn.glob(pattern)
end

---@param pattern string
---@return string[] file_paths
local function expand_absolute_pattern(pattern)
  return find_files(pattern)
end

---@param origin string
---@param pattern string
---@return string[] file_paths
local function expand_relative_pattern(origin, pattern)
  return find_files(assemble_relative_path(origin, pattern))
end

---@return string
local function get_script_directory()
  return find_file('<sfile>:p:h')
end

---@return string
local function get_parent_directory()
  return find_file('%:p:h')
end

---@return string
local function find_origin()
  local script_directory = get_script_directory()

  return is_null_or_empty(script_directory)
    and get_parent_directory()
    or script_directory
end

---@param file_path string
---@return boolean success
local function try_source_file(file_path)
  local command = 'source ' .. file_path
  local success, result = pcall(vim.cmd, command)

  if not success then
    log_source_error(file_path, result)
  end

  return success
end

---@param origin string
---@param patterns string[]
local function source_patterns(origin, patterns)
  for _, pattern in pairs(patterns) do
    local file_paths = is_absolute(pattern)
      and expand_absolute_pattern(pattern)
      or expand_relative_pattern(origin, pattern)

    if #file_paths ~= 0 then
      for _, path in pairs(file_paths) do
        try_source_file(path)
      end
    else
      log_error(assemble_no_matches_error_message(pattern))
    end
  end
end

---@param patterns string[]
function M.source(patterns)
  local origin = find_origin()

  source_patterns(origin, patterns)
end

---@param patterns string[]
---@deprecated use `require('relative-source').source(patterns)` instead
function M.source_files(patterns)
  M.source(patterns)
end

return M
