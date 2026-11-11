# 拼音配置示例

[English](options.en.md) · [返回主页](../README.md)

所有配置写在 opts.sources 内。可用项只有本页列出的拼音与匹配设置；
[主页](../README.md#配置)给出了全部双拼名称及完整模糊音分组。

| 选项 | 默认值 | 用途 |
| --- | --- | --- |
| `scheme` | 不设置 | 全拼与首字母；可选择 flypy、pyjj、natural、abc、mspy、st 六种双拼 |
| `fuzzy` | 关闭 | true 使用默认六组，false/nil 关闭，表则整体替换默认分组 |
| `matcher` | 全拼 initial，双拼 full_code | full_code、initial、prefix 三种匹配方式 |

## 默认全拼与首字母

```lua
opts = { sources = { "pinyin" } }
```

输入 `zhongwen` 或 `zw`，都能匹配“中文”。默认不启用模糊音。

## 选择双拼

```lua
opts = { sources = { { name = "pinyin", scheme = "flypy" } } }
```

使用小鹤双拼，不开启模糊音。其他方案只需修改 scheme；双拼默认按完整编码推进下一字。

## 仅启用需要的模糊音

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

这里只启用 n/l，不会补上默认的 zh/z 等分组，也不启用韵母模糊。
将 fuzzy 设为 true 才使用默认六组，设为 false 关闭；也可与 scheme 一起配置。

`initials`、`finals` 作用于全拼声母、韵母，在双拼转换前展开；`codes` 作用于
转换后的完整编码，例如 `fuzzy = { codes = { { "eg", "en" } } }`。双拼方案中
直接指定编码的零声母等特殊音节不受 `initials`、`finals` 影响，应通过 `codes`
设置模糊。三类规则可同时配置，详见 [README 模糊音说明](../README.md#手动设置模糊音)。

## 选择匹配方式

```lua
opts = { sources = { { name = "pinyin", matcher = "full_code" } } }
```

full_code 需要完整编码才能继续匹配下一字；initial 也允许用首字母推进；
prefix 允许任意非空编码前缀推进。例如匹配“中文”：

| 输入 | full_code | initial | prefix |
| --- | --- | --- | --- |
| zhongwen | ✓ | ✓ | ✓ |
| zw | — | ✓ | ✓ |
| zhwen | — | — | ✓ |

## 同时使用全拼与双拼

```lua
opts = {
  sources = {
    "pinyin",
    { name = "pinyin", scheme = "flypy" },
  },
}
```

两种方式都参与匹配，每个配置可分别设置 fuzzy 和 matcher。
