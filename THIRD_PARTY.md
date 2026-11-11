# Third-party data / 码表来源

Original project code uses the root MIT license. Derived dictionary data retains
its upstream terms. 项目代码使用 MIT；派生码表数据保留上游许可，不按 MIT 重新授权。

## Pinyin data / 拼音码表

[pinyin.tsv](lua/flash-any/tables/pinyin.tsv) and
[parts.lua](lua/flash-any/pinyin/parts.lua) are generated from
[iDvel/rime-ice](https://github.com/iDvel/rime-ice/tree/99662ba01e3affa6a0f009174ca530b887bac3b6), commit `99662ba01e3affa6a0f009174ca530b887bac3b6`:

- `cn_dicts/8105.dict.yaml` (version 2026-08-16)
- `cn_dicts/41448.dict.yaml` (version 2026-07-01)

Both enabled single-character dictionaries are merged without restoring commented
readings. Duplicate pairs are removed, weights are omitted, and project punctuation
codes are added. The same generated syllables produce initial/final components.
The result contains 40,596 Han characters plus 29 punctuation characters.

合并两份已启用的单字读音，不恢复注释掉的特殊读音；去重、省略权重并加入项目标点。
同一批音节生成声母/韵母表。共 40,596 个汉字及 29 个标点。

License: [upstream GPL-3.0](licenses/rime-ice-GPL-3.0.txt). Upstream dictionary headers
also identify Wiktionary, BLCU character frequencies, Unicode Unihan and pinyin-data
as their sources. Their source comments remain available at the pinned upstream links.

- `8105.dict.yaml` SHA256: `1f9a42b91dea6982baee2551981780271aeffd78876662b9c9f324e56b37b120`
- `41448.dict.yaml` SHA256: `39102601365554433396fa64947010f5a15e7a2c27d22f6cce4d80775919e7bc`

The old pinyin-data-derived table is no longer shipped. Its original
[MIT notice](licenses/pinyin-data-MIT.txt) is retained for attribution history.
Double-pinyin mappings in schemes.lua reference https://zh.wikipedia.org/wiki/双拼.
