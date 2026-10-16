local M = {}

local function process_line(line)
  local s = vim.trim(line)

  -- Strip any leading non-hex characters
  s = s:match('^[^0-9a-fA-F]*(.*)$') or s

  -- Pad the front with 0's so length is a multiple of 8
  local remainder = #s % 8
  if remainder ~= 0 then
    s = string.rep('0', 8 - remainder) .. s
  end

  -- Split from the end into 8-character chunks
  -- Walking backwards naturally gives us right-to-left order
  local chunks = {}
  for i = #s, 1, -8 do
    local chunk = s:sub(math.max(1, i - 7), i)
    table.insert(chunks, chunk)
  end

  -- Build the output: insert a newline after every 8th word
  local lines = {}
  local current = {}
  for i, word in ipairs(chunks) do
    table.insert(current, word)
    if i % 8 == 0 then
      table.insert(lines, table.concat(current, ' '))
      current = {}
    end
  end
  if #current > 0 then
    table.insert(lines, table.concat(current, ' '))
  end

  return lines
end

function M.split_current_line()
  local line = vim.api.nvim_get_current_line()
  local result = process_line(line)
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  vim.api.nvim_buf_set_lines(0, row, row + 1, false, result)
end

function M.setup(opts)
  opts = opts or {}
  local key = opts.key or '<leader>rv'

  vim.keymap.set('n', key, M.split_current_line, {
    desc = '[r]everse [v]alue copied from sim'
  })
end

return M
