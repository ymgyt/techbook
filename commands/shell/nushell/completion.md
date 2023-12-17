# Completion

## 外部command

```nu
# Description...
export extern "git push" [
    remote?: string@"nu-complete git remotes",  # the name of the remote
    refspec?: string@"nu-complete git branches" # the branch / refspec
    ...
]

def "nu-complete git remotes" [] {
  ^git remote | lines | each { |line| $line | str trim }
}

```

* `extern cmd sub`と書くと、`cmd`でtabおした際に`sub`が補完候補にでる
* `git push`でtabおすと、remote arg用で`nu-complete git remotes`が呼ばれる
   * `nu-complete git remotes`は通常の関数として補完の候補を返すだけでよい


