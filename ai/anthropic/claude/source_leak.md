# Claude Source Leak

2026-03-31 に npm registry @anthropic-ai/claude-code に `cli.js.map` が公開された

* Language: TypeScript
* Runtime: Bun
* Terminal UI: React + Ink (React for CLI)
* Scale: ~1,900 files, 512,000+ lines of code

* [anthropics/anthropic monorepo?がありそう](https://github.com/DonutShinobu/claude-code-fork/blob/a99de1bb3c0c301b83b784abbcdb7a3674b2cd45/src/bridge/trustedDevice.ts#L29)

* `CLAUDE_CODE_UNDERCOVER=1` でpublic/open-source repoにcontributingする際に、内部情報(internal mode, project name) をださないようにする
  * [`getUndercoverInstructions()`](https://github.com/DonutShinobu/claude-code-fork/blob/a99de1bb3c0c301b83b784abbcdb7a3674b2cd45/src/utils/undercover.ts#L45)

* [INTERNAL_MODEL_REPOS](https://github.com/DonutShinobu/claude-code-fork/blob/a99de1bb3c0c301b83b784abbcdb7a3674b2cd45/src/utils/commitAttribution.ts#L30)

* [開発は ant.dev](https://github.com/DonutShinobu/claude-code-fork/blob/a99de1bb3c0c301b83b784abbcdb7a3674b2cd45/src/constants/oauth.ts#L123)
* [CYBER_RISK_INSTRUCTION](https://github.com/DonutShinobu/claude-code-fork/blob/a99de1bb3c0c301b83b784abbcdb7a3674b2cd45/src/constants/cyberRiskInstruction.ts)
  * Safeguards teamがいるみたい

* [社内環境ではcomputer use mcpを無効](https://github.com/DonutShinobu/claude-code-fork/blob/a99de1bb3c0c301b83b784abbcdb7a3674b2cd45/src/utils/computerUse/gates.ts#L45)

## Links

* [Chaofun Shou X Post](https://x.com/Fried_rice/status/2038894956459290963)
  * "Claude code source code has been leaked via a map file in their npm registry!"
* [Uploaded fork](https://github.com/DonutShinobu/claude-code-fork)
* [ccleaks](https://ccleaks.com/)
* [kuber.studio Claude Code's Entire Source Code Got Leaked via a Sourcemap in npm, Let's Talk About it](https://kuber.studio/blog/AI/Claude-Code's-Entire-Source-Code-Got-Leaked-via-a-Sourcemap-in-npm,-Let's-Talk-About-it)
