# Pinyin configuration examples

[简体中文](options.md) · [README](../README.en.md)

Put these settings inside opts.sources. The user settings are listed below; see the
[README](../README.en.md#configuration) for every scheme and all default fuzzy rules.

| Option | Default | Purpose |
| --- | --- | --- |
| `scheme` | Unset | Full pinyin and initials, or flypy/pyjj/natural/abc/mspy/st double pinyin |
| `fuzzy` | Off | true enables six default rules; false/nil disables; a table replaces the defaults |
| `matcher` | initial for full pinyin; full_code for double pinyin | full_code, initial or prefix matching |

## Default full pinyin and initials

```lua
opts = { sources = { "pinyin" } }
```

Both `zhongwen` and `zw` match “中文”. Fuzzy spelling is off by default.

## Choose double pinyin

```lua
opts = { sources = { { name = "pinyin", scheme = "flypy" } } }
```

This enables Flypy without fuzzy spelling. Change scheme to select another scheme.
Double pinyin advances to the next character using complete codes by default.

## Enable only the fuzzy rules you need

```lua
opts = {
  sources = {
    {
      name = "pinyin",
      fuzzy = {
        initials = { { "n", "l" } },
      },
    },
  },
}
```

Only n/l is enabled. Default rules such as zh/z are not added, and no final-component
rules are enabled. Set fuzzy=true for the six defaults, or false to disable them.
Fuzzy settings can also be combined with scheme.

## Choose matching behavior

```lua
opts = { sources = { { name = "pinyin", matcher = "full_code" } } }
```

full_code requires a complete code to advance to the next character; initial also
accepts its first letter; prefix accepts any nonempty prefix. For “中文”:

| Input | full_code | initial | prefix |
| --- | --- | --- | --- |
| zhongwen | ✓ | ✓ | ✓ |
| zw | — | ✓ | ✓ |
| zhwen | — | — | ✓ |

## Use full and double pinyin together

```lua
opts = {
  sources = {
    "pinyin",
    { name = "pinyin", scheme = "flypy" },
  },
}
```

Both configurations participate. Each may set its own fuzzy and matcher options.
