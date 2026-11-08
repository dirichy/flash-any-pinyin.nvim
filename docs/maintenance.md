# 维护拼音 source / Maintaining the pinyin source

安装和使用见[主页](../README.md)与[英文版](../README.en.md)。
For installation and usage, see the READMEs linked above.

## 文件分工 / Files

| 路径 / Path | 用途 / Purpose |
| --- | --- |
| lua/flash-any/sources/pinyin.lua | 默认匹配、模糊音与双拼配置 / Matching defaults, fuzzy spellings and double pinyin |
| lua/flash-any/tables/pinyin.tsv | 完整字符读音及标点 / Complete character readings and punctuation |
| lua/flash-any/pinyin/parts.lua | 音节的声母、韵母 / Initial and final components of syllables |
| lua/flash-any/pinyin/schemes.lua | 双拼键位 / Double-pinyin key mappings |
| scripts/build.py | 从 pinyin-data 生成 TSV / Generate the TSV from pinyin-data |

源码只提供构建期数据与转换；运行时由核心 C 匹配。不要另加常用字缓存。
The package provides build-time data and conversion; matching stays in the C core.
There is no separate common-character cache.

## 更新数据 / Updating data

```sh
python scripts/build.py pinyin-data.txt lua/flash-any/tables/pinyin.tsv
```

输入文件来自 [mozillazg/pinyin-data](https://github.com/mozillazg/pinyin-data)。
生成器去除声调、将 ü 规范为 v，并在同一 TSV 中写入标点；每行一个字素与一个编码。
Python 只用于维护，不是用户安装依赖。来源和许可记录在 [THIRD_PARTY.md](../THIRD_PARTY.md)。
若引入新的音节，也要检查 parts.lua 是否覆盖对应声母、韵母；上述命令仅更新 TSV。

The input comes from pinyin-data. The generator removes tones, normalizes ü to v,
and includes punctuation in the same TSV, with one text/code pair per row.
Python is a maintainer dependency only. Keep provenance and upstream terms in
THIRD_PARTY.md. New syllables also need component coverage in parts.lua; this
command updates only the TSV.

## 验证 / Validation

在 flash-any.nvim 核心仓库执行，路径指向各 source 目录的父目录：
Run in the core checkout, pointing at the parent of the source directories:

```sh
FLASH_ANY_SOURCE_PATH=/path/to/source-parent nvim --clean -l tests/run.lua child tests/integration/pinyin.lua
```

该测试对照全拼、模糊音和连续输入的实际 C 匹配。完整可选 source 集成测试可运行
`FLASH_ANY_SOURCE_PATH=/path/to/source-parent nvim --clean -l tests/run.lua`，需要对应 source 已安装。
The focused test compares C matching for pinyin, fuzzy spellings and continuous input.
The complete optional-source suite requires all referenced source packages.

## 演示 / Demo

编辑 [demo.lua](../demo.lua) 中的目标文本和旁白，工作流只通过 `config: demo.lua`
读取配置，编码自动由 TSV 推导。保持 matcher 与工厂默认模式一致。
Edit demo.lua to change target text and narration. The workflow reads this config
without overriding its dictionary or matcher; query codes come from the TSV.
Keep the demo mode consistent with the factory default.

每次推送 main 或手动运行工作流，都会录制两次真实跳转。验证成功后，自动覆盖
`demos` prerelease 的 GIF、MP4、封面与报告，README 引用固定附件地址；不提交生成媒体。
仅发布任务获得 contents:write 权限。旧录制不会覆盖较新 main 的演示；发布后下载核对附件。

Every main push or manual dispatch records two actual jumps. After verification,
the workflow replaces media and reports in the dedicated demos prerelease.
README links use stable release URLs; generated media is never committed.
Only publishing receives contents:write. Outdated recordings skip publication,
and downloads are compared against the verified artifacts.

工作流的 uses 引用和 flash-any-ref 固定到同一已测试核心提交。
本地录制依赖和字体、画面检查见[录制说明](https://github.com/dirichy/flash-any.nvim/blob/main/demos/README.md)。
Pin both core references in the workflow to the same tested commit. See the recording
guide above for local dependencies, font coverage and visual inspection.
