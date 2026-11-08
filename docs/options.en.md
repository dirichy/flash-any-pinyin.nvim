# All pinyin options

[简体中文](options.md) · [README](../README.en.md)

Put these fields inside `{ name = "pinyin", ... }` in `opts.sources`, not at setup's
top level. The [README](../README.en.md#configuration) lists every double-pinyin
scheme, all default fuzzy groups and custom-group examples.

## Pinyin settings

| Option | Default | Accepted values |
| --- | --- | --- |
| `name` | Shorthand `"pinyin"` | Use name="pinyin" in an options table |
| `scheme` | Unset: full pinyin and initials | flypy, pyjj, natural, abc, mspy, st |
| `fuzzy` | Off | false/nil disables; true uses six default groups; a table replaces all default groups |

A custom fuzzy table has optional initials/finals fields, each an array of groups
of ASCII strings. Unlisted components stay unchanged; the first group wins when
they overlap. Double pinyin uses the scheme's available mappings. Special syllables,
including explicit zero-initial encodings, take precedence; not every fuzzy
zero-initial variant is expanded. Punctuation bypasses double-pinyin conversion:
`,` matches “，” and `.` matches “。”.

## Common matching settings

| Option | Default | Accepted values |
| --- | --- | --- |
| `matcher` | initial for full pinyin; full_code for double pinyin | full_code advances on a complete code; initial also advances on its first letter; prefix advances on any nonempty prefix |
| `scope` | `"chinese"` | all/ascii/chinese/unicode/private_use, or character/range declarations; filters the dictionary |
| `fallback` | `false` | Participate only when earlier ordinary sources did not recognize the grapheme |
| `append_space_below` | No padding | Positive integer; append one space to actual codes shorter than this length, without changing matcher mode |
| `groups` | Derived from fuzzy for full pinyin; absent for double pinyin | Explicit group-name to ASCII-code arrays, replacing all generated groups; normally use fuzzy instead |

To require complete full-pinyin codes rather than also accepting initials:

```lua
{ name = "pinyin", matcher = "full_code" }
```

Multiple pinyin configurations may coexist:

```lua
sources = { "pinyin", { name = "pinyin", scheme = "flypy" } }
```

## Dictionary overrides

| Option | Default | Accepted values |
| --- | --- | --- |
| `file` | Bundled pinyin.tsv | External dictionary path, with file settings below |
| `data` | No override | Small Lua map from graphemes to code strings/arrays |
| `lua` | No override | Path to a Lua dictionary file |
| `tsv` | None | Complete TSV companion to lua; use file for a standalone TSV |
| `selection.keys` | Required with selection | Distinct nonempty ASCII strings, 1..127 bytes each, assigned by candidate rank; not limited to single punctuation characters |
| `selection` | No selectors | External file only: e.g. { keys = { " ", ";" } }; requires final matcher="full_code" (override the full-pinyin default), and excludes converter/padding |

file/data/lua **replace** the table rather than extending it. file excludes data,
lua and tsv. Overrides contain finished codes: built-in pinyin conversion and fuzzy
groups are not applied or inherited. Omit scheme/fuzzy when overriding and choose a
matcher for your actual codes; use converter to transform file codes. Change scope
for non-Chinese entries. Overrides still inherit matching settings such as mode and
scope. A code cannot combine a group reference with selector suffixes.

```lua
{
  name = "pinyin",
  file = "/path/to/custom.tsv",
  matcher = "full_code",
  columns = { "text", "code" },
}
```

Runtime Lua matchers, scope functions and custom loaders are unsupported. The core
owns builds and caches; restart Neovim after editing installed data. See the core
reference for cache limitations.

## External file options

These settings apply only to `file`:

| Option | Default | Accepted values |
| --- | --- | --- |
| `format` | `"auto"` | auto, rime, tsv/tab, csv, space, fcitx, ibus |
| `columns` | File metadata or format defaults | Column-name array containing text and code; optional weight/order; other columns ignored |
| `encoding` | UTF-8 | Encodings supported by Neovim, such as gb18030 or utf-16le |
| `header` | `false` | Skip the first CSV record as a heading; does not apply to TSV |
| `converter` | None | Path to a Lua code-list conversion function; nil/empty output removes an entry |

Headerless TSV uses text/code order; set `columns = { "code", "text" }` for the
reverse order. Each row has one code; repeat rows for alternatives. Commas are
literal code characters. Rime imports use relative paths. File sources filter
multi-grapheme entries; direct data/Lua tables require one complete grapheme per key.
Converters run at build time, never as runtime matchers.

See the [core reference](https://github.com/dirichy/flash-any.nvim/blob/main/docs/sources.md)
for file formats, scope declarations and spelling-group semantics.
