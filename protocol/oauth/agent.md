# Agent

Agent定義: モデル推論時の「決定」をもとに、特定の目標に向けた「行動」を実行する能力を持つAIベースのシステム

Agentはクライアントアプリとして動作する。これまでの認証と認可の基本原則が出発点となる

## 課題

* OAuth Clientが1行動主体という前提が崩れた
  * IDE拡張、MCPClientを実際に呼び出したのはagent

* Agentはuserの代理人という前提が崩れる
  * OAuthはclientはuserの委任をうける or 自分自信のbehalf

* agentは user behalf, self behalf, another agent behalf(A2A)を区別したい

* permission discovery
  * clientは必要な権限を事前に知っている前提

## Memo

OAuthはアプリに権限を渡す前提で、自律的に判断する非人間主体に、限定的で連鎖可能な権限付与をモデル化できていない

* 行動を決めた主体とOAuth clientが一致するという前提Client Initiated Backchannel Authentication

* AgentはOAuth model上でfirst-classでない。

> 今日、ユーザの代理としてエ
ージェントが行ったAPIコールは、ユーザが直接行った動作と区別がつかないようにログに記録さ
れることが多く、説明責任と法的証拠の収集や分析にとってのブラックホールを作り出してい
る。真の権限委譲を実装することで、PEPに提示される認証情報には、本人とエージェントで別々
の識別子が含まれる。これにより、PEPは、あるアクションを誰が許可したかだけではなく、どの
特定のエージェント実体がそれを実行したかも明確に記録する、充実した監査ログを生成するこ
とができる。このような豊富なコンテキスト・データ(適切に処理するためのデータ）を取得する
ことは、デバッグ、コンプライアンス要件への準拠、そして最終的には、すべての行動がその起
源まで追跡できる信頼できる自律システムの構築の基礎となる。

### MCP

現行 OAuth 2.1ベース
Authorization Server Metadata
Dynamic Client Registration

### Client Initiated Backchannel Authentication(CIBA)

---
自律エージェントでは、この二択が足りません。なぜなら agent は、単に人の代理でも、単なるアプリそのものでもなく、業務上の役割を持つ非人間主体として扱いたい場面が出てくるからです。たとえば夜間だけ設定差分を監視する監査 agent や、承認済みテンプレートだけを本番適用する deployment agent は、ある特定ユーザーの完全な代理ではありません。しかし単なる client credentials にしてしまうと、「どの業務ロールを持つ agent なのか」という意味づけが弱くなります。記事の “Agents should be able to act with their own defined set of privileges” は、その不足を指摘しています。

## References

* [Best Current Practice for OAuth 2.0 Security](https://datatracker.ietf.org/doc/rfc9700/)
* [The future of AI agents—and why OAuth must evolve](https://techcommunity.microsoft.com/blog/microsoft-entra-blog/the-future-of-ai-agents%E2%80%94and-why-oauth-must-evolve/3827391)
* [MCP](https://modelcontextprotocol.io/specification/draft/basic/authorization)
* [OAuth 2.0 Rich Authorization Requests](https://datatracker.ietf.org/doc/rfc9396/)
* [Agentic AIのためのアイデンティティ管理](https://www.openid.or.jp/Identity-Management-for-Agentic-AI-jp_)
* [A2A Protocol](https://a2aprotocol.ai/)
* [Let's fix OAuth in MCP](https://aaronparecki.com/2025/04/03/15/oauth-for-model-context-protocol)
* [SPIFFE](https://spiffe.io/docs/latest/spiffe-about/overview/)
* [SCIM](https://scim.cloud/)
* [OpenID Connect for Agents(OIDC-A)](https://arxiv.org/abs/2509.25974)
  * [](https://github.com/subramanya1997/oidc-a/)
* [OAuth 2.0 Extension: On-Behalf-Of User Authorization for AI Agents](https://www.ietf.org/archive/id/draft-oauth-ai-agents-on-behalf-of-user-01.html)
* [Web Bot Auth](https://datatracker.ietf.org/wg/webbotauth/about/)
* [OAuth Identity and Authorization Chaining Across Domains](https://datatracker.ietf.org/doc/draft-ietf-oauth-identity-chaining/)
* [OAuth 2.0 Token Exchange](https://datatracker.ietf.org/doc/html/rfc8693)
* [Identity Assertion JWT Authorization Grant](https://datatracker.ietf.org/doc/draft-ietf-oauth-identity-assertion-authz-grant/)
* [LayerX AWS マルチアカウント環境からの Google Cloud フェデレーション設計 — AI時代に合わせた社内認証基盤づくり](https://tech.layerx.co.jp/entry/2026/01/30/152136)
* [SEP-646 and SEP-990: Enterprise-Managed Authorization](https://github.com/modelcontextprotocol/ext-auth/pull/4)
