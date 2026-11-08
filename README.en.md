# Pinyin for flash-any.nvim

[简体中文](README.md)

Search Chinese text using pinyin, initials or double pinyin. Use it with
[flash-any.nvim](https://github.com/dirichy/flash-any.nvim/tree/main).

![Search and jump](https://github.com/dirichy/flash-any-pinyin.nvim/releases/download/demos/table.gif)

[HD MP4](https://github.com/dirichy/flash-any-pinyin.nvim/releases/download/demos/table.mp4)

## Install

Requires Neovim 0.11+, make and a C compiler. Add this to your lazy.nvim configuration:

```lua
{
  "dirichy/flash-any.nvim",
  branch = "main",
  version = false,
  dependencies = { "folke/flash.nvim", "dirichy/flash-any-pinyin.nvim" },
  build = "make",
  opts = { sources = { "pinyin" } },
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash-any").jump() end },
  },
}
```

## Use

1. Press `s` and enter a character's code.
2. Choose a displayed label to jump there.
3. Keep typing to match a longer phrase, mixing codes and ordinary ASCII text.

Type `zhong` to find “中”, or `zhongwen with flash` to find “中文 with flash”. Ordinary ASCII text can also be searched directly.

Initials work too: `zw` matches “中文”. To use double pinyin and fuzzy spellings,
replace `opts` above with:

```lua
opts = { sources = { { name = "pinyin", scheme = "flypy", fuzzy = true } } }
```

Available schemes: flypy, pyjj, natural, abc, mspy and st. Omit scheme for full pinyin
and initials; omit fuzzy to disable fuzzy spellings. Too many fuzzy combinations
can increase build time and dictionary size, especially with double pinyin.

## More

- [flash-any configuration](https://github.com/dirichy/flash-any.nvim/blob/main/README.md)
- [Updating the table and recording demos](docs/maintenance.md)

## License

Code: [MIT](LICENSE). Data sources and upstream terms: [THIRD_PARTY.md](THIRD_PARTY.md).
