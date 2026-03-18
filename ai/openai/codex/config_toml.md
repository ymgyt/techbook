# config.toml

* `~/.codex/config.toml`
* `repo/.codex/config.toml`

```toml
# default model
model = "gpt-x"

approval_policy = "on_request"

sandbox_mode = "workspace-write"

web_search = "cached"

model_reasoning_effort = "high"

[shell_environment_policy]
include_only = ["PATH", "HOME"]
```
