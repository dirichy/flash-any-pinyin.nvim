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

首字母也可匹配：`zw` 找“中文”。若要启用双拼和模糊音，将上面的 `opts` 换成：

```lua
opts = { sources = { { name = "pinyin", scheme = "flypy", fuzzy = true } } }
```

scheme 支持 flypy、pyjj、natural、abc、mspy、st；省略时使用全拼与首字母。
省略 fuzzy 即关闭模糊音。模糊音组合过多可能增加构建时间和码表体积，尤其是双拼。

## 更多

- [flash-any 配置说明](https://github.com/dirichy/flash-any.nvim/blob/main/README.zh-CN.md)
- [更新码表与录制演示](docs/maintenance.md)

## 许可

项目代码采用 [MIT](LICENSE)，数据来源和上游条款见 [THIRD_PARTY.md](THIRD_PARTY.md)。
