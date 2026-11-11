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

`initials` and `finals` apply to **full-pinyin initials and finals**, not double-pinyin
keystrokes. Add `scheme = "flypy"` to expand those components first, then convert the
variants to double pinyin, keeping only those supported by the scheme. Special
syllables with directly assigned codes, such as zero-initial exceptions, bypass
component expansion: `initials` and `finals` do not affect them. Use `codes` instead.
Many combinations increase build and matching work and
increase the shared spelling groups. Both full and double pinyin share spellings
per syllable instead of expanding them for every character.

Use `codes` to define fuzzy groups for complete final codes. For example, make
Flypy's `eg` and `en` interchangeable:

```lua
{
  name = "pinyin",
  scheme = "flypy",
  fuzzy = {
    codes = { { "eg", "en" } },
  },
}
```

The order is initial/final fuzzing → double-pinyin conversion (if configured) →
whole-code fuzzing. `codes` applies to **the final codes after conversion**, including
directly assigned special codes. These codes need not correspond to standard pinyin syllables and
also works with full pinyin. It matches complete codes, without substring replacement
or recursive expansion. Combine it with `initials` and `finals` as needed; specifying
only `codes` does not enable the default initial/final groups. Whole-code groups
follow the same first-group-wins rule described above.

See [configuration examples](docs/options.en.md) for matching modes and using
multiple pinyin configurations together.

The table merges Rime Ice’s `8105` and `41448` character dictionaries, covering
40,596 Han characters; 
GPL-3.0 license are documented in [THIRD_PARTY.md](THIRD_PARTY.md).

## More

- [flash-any configuration](https://github.com/dirichy/flash-any.nvim/blob/main/README.md)
- [Updating the table and recording demos](docs/maintenance.md)

## License

Code: [MIT](LICENSE). Data sources and upstream terms: [THIRD_PARTY.md](THIRD_PARTY.md).
