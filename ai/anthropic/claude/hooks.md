# Hooks

## Notification

```json

"hooks": {
	"Notification": [
		{
			"matcher": "",
			"hooks": [
				{
					"type": "command",
					"command": "~/.local/bin/claude-notify"
				}
			]
		}
	]
}
```

`claude-notify` command

```sh
#!/usr/bin/env bash
message="$(jq -r '.message // "Claude needs your attention"')"

notify-send \
	--app-name='Claude Code' \
	--urgency=critical \
	--icon=dialog-warning \
	--category=im.received \
	'Claude Code' \
	"$message"
```
