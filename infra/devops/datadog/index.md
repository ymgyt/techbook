# Datadog

## Logs

### Recipe

検索関連の使い方。
```text
# pathで検索
# `/`はエスケープしてやる必要がある
`@path:\/api\/v1\/attachments\/images`

# status codeのrange
`@http.status_code:[200 TO 299]` 
```
