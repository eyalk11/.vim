local motions = {
  --TtFf = {},
  para = { backward = "{", forward = "}" },
  sentence = { backward = "(", forward = ")" },
  change = { backward = "g,", forward = "g;" },
  class = { backward = "[[", forward = "]]" },
  --methodend = { backward = "[M", forward = "]M" },
  --line = { backward = "k", forward = "j", repeat_if_count = 1, repeat_count = 1 },
  --char = { backward = "h", forward = "l", repeat_if_count = 1, repeat_count = 1 },
  --word = { backward = "b", forward = "w", repeat_if_count = 1, repeat_count = 1 },
  --fullword = { backward = "B", forward = "W", repeat_if_count = 1, repeat_count = 1 },
  --wordend = { backward = "ge", forward = "e", repeat_if_count = 1, repeat_count = 1 },
  --pos = { backward = "<C-i>", forward = "<C-o>" },
  --page = { backward = "<C-u>", forward = "<C-d>" },
  --pagefull = { backward = "<C-b>", forward = "<C-f>" },
  --undo = { backward = "u", forward = "<C-r>", direction = 1 },
  linescroll = { backward = "<C-e>", forward = "<C-y>" },
  charscroll = { backward = "zh", forward = "zl" },
  --vsplit = { backward = "<C-w><", forward = "<C-w>>" },
  --hsplit = { backward = "<C-w>-", forward = "<C-w>+" },
  --arg = { backward = "[a", forward = "]a" },
  --buffer = { backward = "[b", forward = "]b" },
  --location = { backward = "[l", forward = "]l" },
  --quickfix = { backward = "[q", forward = "]q" },
  --tag = { backward = "[t", forward = "]t" },
  --diagnostic = { backward = "[g", forward = "]g" },
}
--local list_of_lists = {}
local function rep(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end
local keys = {{"[]", "]["}, {"]m", "[m"}, {"]M", "[M"},{"l","h"},{"k","j"},  { "w","b" } ,{ "W","B" } ,{ "e","ge" } ,{ "E","gE" }, {"]E","[E"},{"]a","[a"},{"]d","[d"},{"]e","[e"},{"]h","[h"},{"&","z&"}, {rep('<s-F3>'),rep('<s-F4>')}, {"[=", "]="}, {"]+","[+"}, {"]-","[-"},  {"]c", "[c"}, {"%","g%"}}

for i, key in ipairs(keys) do
    motions[tostring(i)] = { backward = key[1], forward = key[2] }
end

return {
  "vds2212/vim-remotions",
  enabled=false,
  event = { "BufRead", "BufWinEnter", "BufNewFile" },

  config = function()
      vim.g.remotions_motions = motions
  end,
}
