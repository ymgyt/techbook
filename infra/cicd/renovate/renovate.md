# Renovate

## Repository 処理の概要

1. repositoryをscanして、 "package file" を探す
2. "package file" から "dependency" を見つける
3. "dependency" に対応する "datasource" を検索し、新しいversionがあるか調べる

