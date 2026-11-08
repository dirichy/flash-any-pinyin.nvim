# 拼音完整选项

[English](options.en.md) · [返回主页](../README.md)

选项放在 `opts.sources` 中的 `{ name = "pinyin", ... }` 内，不放在 setup 顶层。
[主页](../README.md#配置)列出全部双拼方案、默认模糊音和自定义分组示例。

## 拼音选项

| 选项 | 默认值 | 支持内容 |
| --- | --- | --- |
| `name` | 名称简写为 `"pinyin"` | 配置表写 `name = "pinyin"` |
| `scheme` | 无，全拼与首字母 | flypy、pyjj、natural、abc、mspy、st |
| `fuzzy` | 关闭 | false/nil 关闭，true 为六组默认模糊音，表整体替换默认分组 |

自定义 fuzzy 包含可选 `initials`、`finals`，每项为 ASCII 字符串的分组数组。
未列出的部分保持原样，重叠时第一个分组生效。双拼采用方案支持的声母/韵母映射，
特殊零声母等音节优先使用方案自带编码，不保证所有零声母模糊变体都展开。
标点不做双拼转换；例如 `,` 可匹配“，”，`.` 可匹配“。”。

## 通用匹配选项

| 选项 | 默认值 | 支持内容 |
| --- | --- | --- |
| `matcher` | 全拼 initial，双拼 full_code | full_code：完整码推进下一字；initial：首字母也可推进；prefix：任意非空前缀可推进 |
| `scope` | `"chinese"` | all/ascii/chinese/unicode/private_use，或字符、区间声明表；用于过滤码表 |
| `fallback` | `false` | true 时仅在此前普通 source 未识别该字素时参与 |
| `append_space_below` | 不补空格 | 正整数；短于此长度的实际编码追加一个空格，不改变 matcher 模式 |
| `groups` | 全拼按 fuzzy 生成；双拼无 | 手动提供组名到 ASCII 编码数组的映射，整体替换工厂生成的分组；通常使用 fuzzy 即可 |

仅使用完整全拼、关闭首字母推进：

```lua
{ name = "pinyin", matcher = "full_code" }
```

可在 sources 中加入多个拼音配置，例如同时启用全拼与小鹤双拼：

```lua
sources = { "pinyin", { name = "pinyin", scheme = "flypy" } }
```

## 覆盖码表

| 选项 | 默认值 | 支持内容 |
| --- | --- | --- |
| `file` | 使用内置 pinyin.tsv | 外部词典路径，可配合下面的读取选项 |
| `data` | 无覆盖 | 少量字素到编码字符串/数组的 Lua 表 |
| `lua` | 无覆盖 | 返回码表的 Lua 文件路径 |
| `tsv` | 无 | 只与 lua 一起使用的完整 TSV 伴随表；独立 TSV 请用 file |
| `selection.keys` | 使用 selection 时必填 | 不同的非空 ASCII 字符串，各长 1..127 字节，按候选排名分配；不局限于单字节标点 |
| `selection` | 无选键 | 仅外部 file，可指定 `{ keys = { " ", ";" } }`；要求最终 matcher="full_code"（全拼需修改默认模式），不能配 converter 或 append_space_below |

file、data、lua 是**替换**，不是追加；file 不可同时配 data、lua 或 tsv。
覆盖表的编码视为已完成编码，不再套用内置拼音的 scheme/fuzzy 或继承音节分组。
因此使用覆盖时省略 scheme/fuzzy，并按实际编码选择 matcher；若要转换文件编码，用 converter。
非中文条目应同时调整 scope。data/lua 仍受继承的 matcher、scope 等通用选项约束。
同一编码不能同时使用 groups 引用和选键后缀。

```lua
{
  name = "pinyin",
  file = "/path/to/custom.tsv",
  matcher = "full_code",
  columns = { "text", "code" },
}
```

不支持运行时 Lua matcher、scope 函数或自定义 loader。构建与缓存由核心管理；
修改已安装的数据后重启 Neovim，特殊失效情况见核心参考。

## 外部文件读取选项

以下选项只用于 `file`：

| 选项 | 默认值 | 支持内容 |
| --- | --- | --- |
| `format` | `"auto"` | auto、rime、tsv/tab、csv、space、fcitx、ibus |
| `columns` | 文件声明或格式默认列序 | 列名数组，必须含 text、code；可含 weight、order，其他列忽略 |
| `encoding` | UTF-8 | Neovim 支持的文件编码，例如 gb18030、utf-16le |
| `header` | `false` | CSV 首条记录是否为标题；不用于 TSV |
| `converter` | 无 | 返回编码数组转换函数的 Lua 文件路径；返回 nil/空数组可移除条目 |

无头 TSV 默认文字在前、编码在后；反向列序设置 `columns = { "code", "text" }`。
每行一个编码，多编码重复写行，逗号是编码本身的一部分。Rime 可读取相对路径的导入表。
文件中的多字素条目会被过滤；直接 data/Lua 表要求每个键恰好一个完整字素。
converter 只在构建时运行，不是运行时 matcher。

完整格式规则、scope 声明与编码组语义见[核心参考](https://github.com/dirichy/flash-any.nvim/blob/main/docs/sources.md)。
