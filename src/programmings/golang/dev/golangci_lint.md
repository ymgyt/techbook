# golangci lint

## Install

```shell
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.42.1
```

## lintを適用する

```shell
golangci-lint run --config .golangci.yml
```

## Config file

```yaml
run:
  # lint実行のタイムアウト。
  timeout: 10m
  # lintが失敗した場合の実行コマンドの終了ステータス。
  issues-exit-code: 1

  # lint対象にテストコードを含むかどうか。
  tests: true

  # lint対象にするbuild tag。
  build-tags: []

  # lint対象外とするパス。
  skip-dirs:
    - tool$
    - autogen$"
    - vendor$
    - testdata$
    - examples$

  skip-dirs-use-default: false

  # lint対象外とするファイル。
  skip-files: []

  # golangci-lintが複数同時に実行できることを許可するか。
  allow-parallel-runners: false

# output configuration options
output:
  # colored-line-number|line-number|json|tab|checkstyle|code-climate, default is "colored-line-number"
  format: colored-line-number

  # print lines of code with issue, default is true
  print-issued-lines: true

  # print linter name in the end of issue text, default is true
  print-linter-name: true

  unique-by-line: true

  sort-results: true

# https://golangci-lint.run/usage/linters/
linters-settings:
  # https://github.com/kisielk/errcheck
  errcheck:
    # `a := b.(MyStruct)`のようにerrorをチェックしないtype assertionを禁止する。
    check-type-assertions: true
    # `num, _ := strconv.Atoi(numStr)`;
    # のようにerrをblackで受けることを禁止する。
    check-blank: true
    # 除外対象の関数
    # https://github.com/kisielk/errcheck#excluding-functions
    exclude-functions: []

  # https://github.com/dominikh/go-tools/tree/master/simple
  gosimple:
    # Select the Go version to target. The default is '1.13'.
    go: "1.15"
    # https://staticcheck.io/docs/options#checks
    checks: [ "all" ]

  # https://golang.org/cmd/vet/
  govet:
    # report about shadowed variables
    check-shadowing: true
    # settings per analyzer
    settings:
      printf: # analyzer name, run `go tool vet help` to see all analyzers
        funcs: # run `go tool vet help printf` to see available settings for `printf` analyzer
          - (github.com/golangci/golangci-lint/pkg/logutils.Log).Infof
          - (github.com/golangci/golangci-lint/pkg/logutils.Log).Warnf
          - (github.com/golangci/golangci-lint/pkg/logutils.Log).Errorf
          - (github.com/golangci/golangci-lint/pkg/logutils.Log).Fatalf
    # enable or disable analyzers by name
    # run `go tool vet help` to see all analyzers
    enable-all: true

  staticcheck:
    # Select the Go version to target. The default is '1.13'.
    go: "1.15"
    # https://staticcheck.io/docs/options#checks
    checks: [ "all" ]

  # https://github.com/bkielbasa/cyclop
  cyclop:
    # the maximal code complexity to report
    max-complexity: 10
    # the maximal average package complexity. If it's higher than 0.0 (float) the check is enabled (default 0.0)
    package-average: 0.0
    # should ignore tests (default false)
    skip-tests: false

  # https://github.com/OpenPeeDeeP/depguard
  depguard:
    list-type: blacklist
    include-go-root: false
    # importを許したくない特定のpackageがあれば指定する。
    packages: []

  # https://github.com/mibk/dupl
  dupl:
    threshold: 150

  # https://github.com/polyfloyd/go-errorlint
  errorlint:
    # fmt.Errorf("xxx %w", err)のように%wでwrapできているか。
    errorf: true
    # switch err.(type) {
    # case *MyError:
    # }
    # ではなく
    # var me MyError
    # ok := errors.As(err, &me)でassertしているか。
    asserts: true
    # err == ErrXxx ではなく、errors.Is(err,ErrXxx)で比較しているか。
    comparison: true

  # https://github.com/nishanths/exhaustive
  exhaustive:
    # check switch statements in generated files also
    check-generated: true
    # switchにdefault caseがあれば、exhaustiveと判定するか。
    default-signifies-exhaustive: false

  # https://github.com/ashanbrown/forbidigo
  forbidigo:
    # 使用を禁止したい処理があれば追加する
    forbid: []
    # Exclude godoc examples from forbidigo checks.  Default is true.
    exclude_godoc_examples: true

  # https://github.com/ultraware/funlen
  funlen:
    lines: 200
    statements: 150

  # https://github.com/uudashr/gocognit
  gocognit:
    min-complexity: 20

  # https://github.com/jgautheron/goconst
  goconst:
    # minimal length of string constant, 3 by default
    min-len: 3
    # minimum occurrences of constant string count to trigger issue, 3 by default
    min-occurrences: 2
    # ignore test files, false by default
    ignore-tests: true
    # look for existing constants matching the values, true by default
    match-constant: true
    # search also for duplicated numbers, false by default
    numbers: true
    # minimum value, only works with goconst.numbers, 3 by default
    min: 3
    # maximum value, only works with goconst.numbers, 3 by default
    max: 3
    # ignore when constant is not used as function argument, true by default
    ignore-calls: false

  # https://github.com/go-critic/go-critic
  gocritic:
    # https://go-critic.github.io/overview#checks-overview
    # 無効にしたいcheckを指定できる
    # READMEではsecurity tagの記載があるが指定するとエラーになる。
    enabled-checks:
      - truncateCmp # experimentalをdisableに指定しているので明示的に指定する必要がある
    disabled-checks: []
    enabled-tags:
      - diagnostic
      - performance
    disabled-tags:
      - experimental
      - opinionated
      - style
    # Settings passed to gocritic.
    # The settings key is the name of a supported gocritic checker.
    # The list of supported checkers can be find in https://go-critic.github.io/overview.
    settings:
      hugeParam:
        # size in bytes that makes the warning trigger (default 80)
        sizeThreshold: 80
      rangeExprCopy:
        # size in bytes that makes the warning trigger (default 512)
        sizeThreshold: 512
        # whether to check test functions (default true)
        skipTestFuncs: true
      rangeValCopy:
        # size in bytes that makes the warning trigger (default 128)
        sizeThreshold: 256
        # whether to check test functions (default true)
        skipTestFuncs: true
      truncateCmp:
        # whether to skip int/uint/uintptr types (default true)
        skipArchDependent: true

  # https://github.com/tommy-muehle/go-mnd
  gomnd:
    settings:
      mnd:
        # the list of enabled checks, see https://github.com/tommy-muehle/go-mnd/#checks for description.
        checks: argument,case,condition,operation,return,assign
        # ignored-numbers: 1000
        # ignored-files: magic_.*.go
        # ignored-functions: math.*

  # https://github.com/securego/gosec
  gosec:
    # To specify a set of rules to explicitly exclude.
    # Available rules: https://github.com/securego/gosec#available-rules
    excludes:
      - G204
    # To specify the configuration of rules.
    # The configuration of rules is not fully documented by gosec:
    # https://github.com/securego/gosec#configuration
    # https://github.com/securego/gosec/blob/569328eade2ccbad4ce2d0f21ee158ab5356a5cf/rules/rulelist.go#L60-L102
    config:
      G306: "0600"
      G101:
        pattern: "(?i)example"
        ignore_entropy: false
        entropy_threshold: "80.0"
        per_char_threshold: "3.0"
        truncate: "32"

  # https://github.com/golangci/golangci-lint/blob/master/pkg/golinters/nolintlint/README.md
  nolintlint:
    # Enable to ensure that nolint directives are all used. Default is true.
    allow-unused: false
    # Disable to ensure that nolint directives don't have a leading space. Default is true.
    allow-leading-space: true
    # Exclude following linters from requiring an explanation.  Default is [].
    allow-no-explanation: [ ]
    # Enable to require an explanation of nonzero length after each nolint directive. Default is false.
    require-explanation: false
    # Enable to require nolint directives to mention the specific linter being suppressed. Default is false.
    require-specific: true

  # https://github.com/alexkohler/prealloc
  prealloc:
    # XXX: we don't recommend using this linter before doing performance profiling.
    # For most programs usage of prealloc will be a premature optimization.

    # Report preallocation suggestions only on simple loops that have no returns/breaks/continues/gotos in them.
    # True by default.
    simple: true
    range-loops: true # Report preallocation suggestions on range loops, true by default
    for-loops: false # Report preallocation suggestions on for loops, false by default

  # https://github.com/mgechev/revive
  # defaultのまま
  revive:
    # see https://github.com/mgechev/revive#available-rules for details.
    ignore-generated-header: true
    severity: warning
    rules:
      - name: indent-error-flow
        severity: warning
      - name: add-constant
        severity: warning
        arguments:
          - maxLitCount: "3"
            allowStrs: '""'
            allowInts: "0,1,2"
            allowFloats: "0.0,0.,1.0,1.,2.0,2."

  # https://github.com/ldez/tagliatelle
  tagliatelle:
    # check the struck tag name case
    case:
      # use the struct field name to check the name of the struct tag
      use-field-name: true
      rules:
        # any struct tag type can be used.
        # support string case: `camel`, `pascal`, `kebab`, `snake`, `goCamel`, `goPascal`, `goKebab`, `goSnake`, `upper`, `lower`
        json: camel
        yaml: camel


linters:
  disable-all: true
  fast: false
  enable:
    - deadcode
    - errcheck
    - gosimple
    - govet
    - ineffassign
    - staticcheck
    - structcheck
    - typecheck
    - unused
    - varcheck
    - bodyclose
    - cyclop
    - depguard
    - dupl
    - durationcheck
    - errname
    - errorlint
    - exhaustive
    - exportloopref
    - forbidigo
    - funlen
    - gci
    - gocognit
    - goconst
    - gocritic
    - gomnd
    - gosec
    - noctx
    - nolintlint
    - prealloc
    - revive
    - tagliatelle

issues:
  # List of regexps of issue texts to exclude, empty list by default.
  # But independently from this option we use default exclude patterns,
  # it can be disabled by `exclude-use-default: false`. To list all
  # excluded by default patterns execute `golangci-lint run --help`
  exclude: []

  # Excluding configuration per-path, per-linter, per-text and per-source
  exclude-rules:
    # Exclude some linters from running on tests files.
    - path: _test\.go
      linters:
        - cyclop
        - dupl
        - gosec

  exclude-use-default: false

  # Maximum issues count per one linter. Set to 0 to disable. Default is 50.
  max-issues-per-linter: 30

  # Maximum count of issues with the same text. Set to 0 to disable. Default is 3.
  max-same-issues: 3

  # Show only new issues: if there are unstaged changes or untracked files,
  # only those changes are analyzed, else only changes in HEAD~ are analyzed.
  # It's a super-useful option for integration of golangci-lint into existing
  # large codebase. It's not practical to fix all existing issues at the moment
  # of integration: much better don't allow issues in new code.
  # Default is false.
  new: false


```
