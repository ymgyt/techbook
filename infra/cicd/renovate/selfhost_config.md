# Self host config

* repository用の設定ではなく、renovateを実行する際に、renovateに渡すconfig
  * renovate的にはself-hostとrepository側のconfigは区別されていないっぽい?
	  * されているような


```js
module.exports = {
	dryRun: "full", // null | "full" | "extrace" | "lookup"
	platform: "github",
	autodiscover: false,
	autodiscoverFilter: ["my-org/*"],
	repositories: ["ymgyt/renovate-handson"],
	logLevelRemap: [
		{
			matchMessage: "/^Using file match:/",
			newLogLevel: "trace"
		}
	]
};
```

## 対象repositoryの指定

* `autodiscover`
  * github appの場合、install時に許可したrepositoryすべてをが対象になる
	* https://github.com/renovatebot/renovate/blob/2fe8305a7c62aff5aa4e432a15f2f537ba17ca1f/lib/workers/global/autodiscover.ts#L13

 * `autodiscoverFilter`
  * autodiscover でみつかったrepositoryに対するfilter

## 各種limit

* [`prCommitsPerRunLimit`](https://docs.renovatebot.com/self-hosted-configuration/#prcommitsperrunlimit)
  * 一回のrenovateの実行で、作成するPR(Commit)数の制限
	* [`globalInitialize`](https://github.com/renovatebot/renovate/blob/2fe8305a7c62aff5aa4e432a15f2f537ba17ca1f/lib/workers/global/initialize.ts#L89) で設定
	* repositoryごとの[実行毎に確認](https://github.com/renovatebot/renovate/blob/2fe8305a7c62aff5aa4e432a15f2f537ba17ca1f/lib/workers/global/index.ts#L188)している


## Repositoryのrenovate

* [`renovateRepository()`](https://github.com/renovatebot/renovate/blob/78818f19983138ee0b320c8a85e74a806d2c5810/lib/workers/repository/index.ts#L45) がentry point

  * [`initRepo()`](https://github.com/renovatebot/renovate/blob/78818f19983138ee0b320c8a85e74a806d2c5810/lib/workers/repository/init/index.ts#L48) 
	  * [`isOnboarded()`](https://github.com/renovatebot/renovate/blob/78818f19983138ee0b320c8a85e74a806d2c5810/lib/workers/repository/onboarding/branch/check.ts#L63)

	* [`extract()`](https://github.com/renovatebot/renovate/blob/20d65c84be2134056874fb831d7ccd69019cd480/lib/workers/repository/process/extract-update.ts#L132)

	* [`lookup()`](https://github.com/renovatebot/renovate/blob/72abf15d9ef07cec302fad168e15163662fc1051/lib/workers/repository/process/extract-update.ts#L209)

	* [`updateRepo()`](https://github.com/renovatebot/renovate/blob/72abf15d9ef07cec302fad168e15163662fc1051/lib/workers/repository/process/index.ts#L171)
