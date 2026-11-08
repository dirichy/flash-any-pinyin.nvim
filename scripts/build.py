#!/usr/bin/env python3
"""Generate the complete UTF-8 TSV. Python is a maintainer dependency only."""
import argparse
from pathlib import Path
import re
import unicodedata

PUNCTUATION = {
    '￥': ['$'],
    '·': ['`'],
    '—': ['_'],
    '…': ['^'],
    '〕': [']'],
    '〔': ['['],
    '』': ['}'],
    '『': ['{'],
    '」': [']'],
    '「': ['['],
    '〉': ['>'],
    '〈': ['<'],
    '》': ['>'],
    '《': ['<'],
    '】': [']'],
    '【': ['['],
    '）': [')'],
    '（': ['('],
    '’': ["'"],
    '‘': ["'"],
    '”': ['"'],
    '“': ['"'],
    '！': ['!'],
    '？': ['?'],
    '：': [':'],
    '；': [';'],
    '、': ['/', '\\'],
    '。': ['.'],
    '，': [','],
}


ROW = re.compile(r"^U\+([0-9A-F]+):\s*([^#]+?)\s+#\s*(.)")


def normalize(value):
    value = value.lower().replace("ü", "v").replace("ǖ", "v").replace("ǘ", "v").replace("ǚ", "v").replace("ǜ", "v")
    return "".join(char for char in unicodedata.normalize("NFD", value) if unicodedata.category(char) != "Mn")


def write_table(path, rows):
    with path.open("w", encoding="utf-8") as output:
        for text in sorted(rows, key=lambda value: value.encode("utf-8")):
            for code in sorted(set(rows[text])):
                output.write(f"{text}\t{code}\n")

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    rows = {}
    for line in args.source.read_text(encoding="utf-8").splitlines():
        match = ROW.match(line)
        if match:
            codes = {normalize(code.strip()) for code in match[2].split(",")}
            rows[match[3]] = codes - {""}
    rows.update(PUNCTUATION)
    write_table(args.output, rows)
    print(f"wrote {len(rows)} characters")


if __name__ == "__main__":
    main()
