# flash-any.nvim 拼音

[English](README.en.md)

配合 [flash-any.nvim](https://github.com/dirichy/flash-any.nvim/tree/main)，
用全拼、首字母或双拼搜索中文。

![搜索跳转](https://github.com/dirichy/flash-any-pinyin.nvim/releases/download/demos/table.gif)

[高清 MP4](https://github.com/dirichy/flash-any-pinyin.nvim/releases/download/demos/table.mp4)

## 安装

需要 Neovim 0.11+、make 和 C 编译器。在 lazy.nvim 配置中添加：

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

## 使用

1. 按 `s`，输入要找的字的编码。
2. 按屏幕上显示的标签跳转。
3. 继续输入可以匹配更长的文本，编码与普通 ASCII 可以混输。

输入 `zhong` 找“中”，输入 `zhongwen with flash` 找“中文 with flash”。搜索 ASCII 时直接输入原文。

## 配置

需要配置时，将安装示例中的 `opts` 换成下面的形式：

```lua
opts = {
  sources = {
    { name = "pinyin", scheme = "flypy", fuzzy = true },
  },
}
```

| 选项 | 默认值 | 用途 |
| --- | --- | --- |
| `scheme` | 不设置 | 不设置为全拼与首字母；设置字符串选择下表中的双拼 |
| `fuzzy` | 关闭（不设置或 `false`） | `true` 启用默认分组，表则自定义分组 |
| `matcher` | 全拼 `initial`，双拼 `full_code` | 也可显式设为 `full_code`、`initial`、`prefix` |

### 支持的双拼

| scheme | 方案 |
| --- | --- |
| `flypy` | 小鹤双拼 |
| `pyjj` | 拼音加加 |
| `natural` | 自然码 |
| `abc` | 智能 ABC |
| `mspy` | 微软双拼 |
| `st` | 四通双拼 |

例如 `{ name = "pinyin", scheme = "flypy" }` 只启用小鹤双拼，不开启模糊音。
省略 scheme 使用全拼与首字母，`zw` 可以匹配“中文”。要同时支持全拼和双拼，
可在 sources 中分别加入 `"pinyin"` 和 `{ name = "pinyin", scheme = "flypy" }`。

### 默认模糊音

`fuzzy = true` 等价于下面的配置。全拼和双拼都支持模糊音：

```lua
{
  name = "pinyin",
  fuzzy = {
    initials = { { "zh", "z" }, { "ch", "c" }, { "sh", "s" } },
    finals = { { "ang", "an" }, { "eng", "en" }, { "ing", "in" } },
  },
}
```

### 手动设置模糊音

例如只启用 zh/z、n/l 和 ang/an：

```lua
{
  name = "pinyin",
  fuzzy = {
    initials = { { "zh", "z" }, { "n", "l" } },
    finals = { { "ang", "an" } },
  },
}
```

同一组内互相替代。自定义表**整体替换**默认分组，不会自动合并；未列出的声母或
韵母不模糊，省略 initials 或 finals 即关闭该类模糊。`fuzzy = {}` 也不启用模糊音。
同一项出现在多个组时，使用第一个组，不做传递合并。

设置 `scheme = "flypy"` 可将上例用于双拼；双拼只使用该方案能编码的变体，
零声母等特殊音节按方案自己的编码处理。模糊音组合过多会增加构建和匹配开销，
尤其可能增大双拼码表。

其他选项（scope、fallback、短码补空格、自定义码表与编码组）以及组合限制，
见[完整选项](docs/options.md)。

## 更多

- [flash-any 配置说明](https://github.com/dirichy/flash-any.nvim/blob/main/README.zh-CN.md)
- [更新码表与录制演示](docs/maintenance.md)

## 许可

项目代码采用 [MIT](LICENSE)，数据来源和上游条款见 [THIRD_PARTY.md](THIRD_PARTY.md)。
