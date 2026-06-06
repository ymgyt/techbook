# venv

## Install

```shell
python3 -m venv .venv --prompt xxx
```

* `.venv`がvenvで管理するdirectory
  * gitignoreされるものという理解
  * requirements.txtだけgit管理する

## Usage

* activateという概念がある。

```shell
# Activate
source .venv/bin/activate

# Install dependencies
pip3 install xxx
pip3 freeze > requirements.txt
pip3 install -r requiements.txt

# Deactivate
deactivate
```
