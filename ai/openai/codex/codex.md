# Codex

## Install

```sh
# volta管理していると npm -g ... しても反映されない
volta install @openai/codex@latest
```

## Image Input

```sh
codex -i path/to/screenshot.png
codex --image img1.png,img2.png "Summarize these images"
```

## Configuration

### AGENTS.md

* project guidance
  * build,test commands
  * review expectations
  * repo,dir specific conventions

* path
  * `~/.codex/AGENTS.md` global
  * `repo/AGENTS.md` repo scope


### Skills

* path
  * `~/.agents/skills` global
  * `repo/.agents/skills` repo scope
