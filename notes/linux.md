# Linux

## Commands

Append a new line to a pattern in multiple files

```bash
grep -rnl "<SOME_PATTERN>" "<DIR_PATH>" | xargs sed -i '' 's/\(.*\)\(<SOME_PATTERN>.*$\)/\1\2\n\1<NEW_LINE>/g'
```
