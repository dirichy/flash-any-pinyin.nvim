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

## Configuration

To configure the source, replace `opts` in the installation example with:

```lua
opts = {
  sources = {
    { name = "pinyin", scheme = "flypy", fuzzy = true },
  },
}
```

| Option | Default | Purpose |
| --- | --- | --- |
| `scheme` | Unset | Unset means full pinyin and initials; a string selects a scheme below |
| `fuzzy` | Off (unset or `false`) | `true` enables the default groups; a table defines custom groups |
| `matcher` | `initial` for full pinyin, `full_code` for double pinyin | May be overridden with `full_code`, `initial` or `prefix` |

### Supported double-pinyin schemes

| scheme | Name |
| --- | --- |
| `flypy` | Xiaohe / Flypy |
| `pyjj` | Pinyin Jiajia |
| `natural` | Natural Code |
| `abc` | Intelligent ABC |
| `mspy` | Microsoft |
| `st` | Stone |

For example, `{ name = "pinyin", scheme = "flypy" }` enables Flypy without fuzzy
spelling. Omit scheme for full pinyin and initials; `zw` matches “中文”. To enable
both, add `"pinyin"` and `{ name = "pinyin", scheme = "flypy" }` as separate sources.

### Default fuzzy groups

`fuzzy = true` is equivalent to the configuration below. Both full and double
pinyin support fuzzy spellings:

```lua
{
  name = "pinyin",
  fuzzy = {
    initials = { { "zh", "z" }, { "ch", "c" }, { "sh", "s" } },
    finals = { { "ang", "an" }, { "eng", "en" }, { "ing", "in" } },
  },
}
```

### Custom fuzzy groups

For example, enable only zh/z, n/l and ang/an:

```lua
{
  name = "pinyin",
  fuzzy = {
    initials = { { "zh", "z" }, { "n", "l" } },
    finals = { { "ang", "an" } },
  },
}
```

Members of a group substitute for each other. A custom table **replaces** all default
groups; it does not merge with them. Unlisted components stay unchanged. Omit
initials or finals to disable that category; `fuzzy = {}` enables no fuzzy groups.
If a component occurs in several groups, the first wins, without transitive merging.

Add `scheme = "flypy"` to use these rules with double pinyin. Only variants mapped
by the chosen scheme are used; special syllables such as zero-initial syllables use
the scheme's own encodings. Many combinations increase build and matching work and
can especially enlarge double-pinyin dictionaries.

See [configuration examples](docs/options.en.md) for matching modes and using
multiple pinyin configurations together.

## More

- [flash-any configuration](https://github.com/dirichy/flash-any.nvim/blob/main/README.md)
- [Updating the table and recording demos](docs/maintenance.md)

## License

Code: [MIT](LICENSE). Data sources and upstream terms: [THIRD_PARTY.md](THIRD_PARTY.md).
