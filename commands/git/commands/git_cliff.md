# git-cliff

* gitのcommit historyからCHANGELOGを生成してくれる
* 基本的にはteraのtemplateを書いて、commitからchangelogのentryへの変換を表現する
* gitのtagでversionの履歴を分割する
  * `git.tag_pattern`で正規表現をかける
  * workspace等で他のcrateのtagを無視したりできる 

* `GIT_CLIFF__GIT__TAG_PATTERN="synd-term-v.*"`のように環境変数を定義すると設定fileを上書きできる
  * `GIT_CLIFF__<SECTION>__<FIELD>`という規約

* workspaceで、crate-aのCHANGELOGを作りたい場合は`--include-path crates/foo/**`と書くとcommitをfilterできる

* `git cliff --context`でrender前のteraのcontextを表示できる

* conventional commitを前提してgroupingしている

## cliff.toml

設定file

```toml
# git-cliff ~ default configuration file
# https://git-cliff.org/docs/configuration
#
# Lines starting with "#" are comments.
# Configuration options are organized into tables and keys.
# See documentation for more information on available options.

[changelog]
# changelog header
header = """
# Changelog\n
All notable changes to this project will be documented in this file.\n
"""
# template for the changelog body
# https://keats.github.io/tera/docs/#introduction
body = """
{% if version %}\
    ## [{{ version | trim_start_matches(pat="v") }}] - {{ timestamp | date(format="%Y-%m-%d") }}
{% else %}\
    ## [unreleased]
{% endif %}\
{% for group, commits in commits | group_by(attribute="group") %}
    ### {{ group | striptags | upper_first }}
    {% for commit in commits %}
        - {{ commit.message | upper_first }} by [@{{ commit.author.name}}](https://github.com/{{ commit.author.name }}) ([{{ commit.id | truncate(length=8, end="") }}](https://github.com/ymgyt/syndicationd/commit/{{ commit.id }}))
    {%- endfor %}
{% endfor %}\n
"""
# remove the leading and trailing whitespace from the template
trim = true
# changelog footer
footer = """
<!-- generated by git-cliff -->
"""
# postprocessors
postprocessors = [
  # { pattern = '<REPO>', replace = "https://github.com/orhun/git-cliff" }, # replace repository URL
]
[git]
# parse the commits based on https://www.conventionalcommits.org
conventional_commits = true
# filter out the commits that are not conventional
filter_unconventional = true
# process each line of a commit as an individual commit
split_commits = false
# regex for preprocessing the commit messages
commit_preprocessors = [
  # { pattern = '\((\w+\s)?#([0-9]+)\)', replace = "([#${2}](<REPO>/issues/${2}))"}, # replace issue numbers
]
# regex for parsing and grouping commits
# comment like <!-- 0 --> for force order 
commit_parsers = [
  { message = "^feat", group = "<!-- 0 -->Features" },
  { message = "^fix", group = "<!-- 1 -->Bug Fixes" },
  { message = "^doc", group = "Documentation" },
  { message = "^perf", group = "Performance" },
  { message = "^refactor", group = "Refactor" },
  { message = "^style", group = "Styling" },
  { message = "^test", group = "Testing" },
  { message = "^chore: release", skip = true },
  { message = "^chore: changelog", skip = true },
  { message = "^chore\\(deps\\)", skip = true },
  { message = "^chore|ci", group = "Miscellaneous Tasks" },
  { body = ".*security", group = "Security" },
  { message = "^revert", group = "Revert" },
]
# protect breaking changes from being skipped due to matching a skipping commit_parser
protect_breaking_commits = false
# filter out the commits that are not matched by commit parsers
filter_commits = false
# regex for matching git tags
tag_pattern = "v[0-9].*"

# regex for skipping tags
skip_tags = "v0.1.0-beta.1"
# regex for ignoring tags
ignore_tags = ""
# sort the tags topologically
topo_order = false
# sort the commits inside sections by oldest/newest order
sort_commits = "oldest"
# limit the number of commits included in the changelog.
# limit_commits = 42
```