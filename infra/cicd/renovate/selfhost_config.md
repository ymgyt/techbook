# Self host config

* repository用の設定ではなく、renovateを実行する際に、renovateに渡すconfig
  * renovate的にはself-hostとrepository側のconfigは区別されていないっぽい


```js
module.exports = {
	dryRun: "full", // null | "full" | "extrace" | "lookup"
	platform: "github",
	autodiscover: false,
	repositories: ["ymgyt/renovate-handson"],
	logLevelRemap: [
		{
			matchMessage: "/^Using file match:/",
			newLogLevel: "trace"
		}
	]
};
```

* `autodiscover`
  * github appの場合、install時に許可したrepositoryすべてをが対象になる
