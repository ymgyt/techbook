# pandoc

## Examples

```shell
# latexが含まれているmarkdownをPDF化する
pandoc test.md -o test.pdf --pdf-engine=lualatex -V documentclass=ltjsarticle

# markdownのtableをformatする
cat markdown_table.md | pandoc -t gfm
```
