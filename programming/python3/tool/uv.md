# uv

## Install

```sh
curl -LsSf https://astral.sh/uv/install.sh | sh
```
* 以下のいずれかに配置される
  * `$XDG_BIN_HOME`
  * `$XDG_DATA_HOME/../bin`
  * `$HOME/.local/bin`


## Usage

```sh
uv init

uv add dep

uv run main.py
```

### pip

```sh
uv pip install dep
uv pip freeze > requirements.lock
uv pip install -r requirements.lock

```
