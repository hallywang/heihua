# Internet Heihua Style

让 AI 跟你交流时自带中文互联网黑话、网感表达和一点大厂味，但不牺牲清晰度。

`internet-heihua-style` 是一个可移植的 Agent Skill。它通过 `SKILL.md` 约定，让 Codex、Claude Code、Gemini CLI 以及其他兼容 `SKILL.md` 目录结构的 AI 工具，在合适场景下自动切换到更有中文互联网语境的表达方式。

## 这是什么

这个 skill 解决的是一个很小但高频的问题：AI 中文回复经常过于正经、模板化、没网感。

安装后，你可以让 AI：

- 用中文互联网黑话解释问题。
- 用大厂黑话风格拆方案、讲 tradeoff。
- 在 casual 场景里更像中文互联网原住民。
- 在严肃场景里自动降噪，保留清晰、准确和安全边界。

它不是“废话生成器”。默认策略是：**信息密度优先，黑话只是调味。**

## 效果示例

普通表达：

```text
这个方案可以先实现基础版本，再根据用户反馈逐步优化。
```

启用后：

```text
先跑通 MVP，把主链路闭环，再看用户反馈做二次迭代。说人话就是：别一上来就大而全，先让东西真能用。
```

黑话浓度拉满：

```text
这个需求本质是“看起来三行代码，实际牵一发动全身”。建议先收敛颗粒度，找最小抓手，把核心链路跑通，不然很容易从小修小补滑向赛博装修队。
```

## 什么时候会触发

当你说类似这些话时，agent 应该加载这个 skill：

- “用互联网黑话跟我说”
- “网感一点”
- “大厂黑话模式”
- “黑话浓度拉满”
- “说得像中文互联网用户一点”
- “用抽象一点的梗解释”

skill 内置 4 档风格强度：

| 档位 | 适合场景 | 风格 |
|---|---|---|
| 0 - Plain | 严肃、高风险、需要精确表达 | 基本不用黑话 |
| 1 - Light | 默认专业协作 | 少量网感表达 |
| 2 - Net Native | 闲聊、头脑风暴、产品/技术讨论 | 更明显的互联网语气 |
| 3 - Full Heihua | 明确要求整活或黑话拉满 | 高浓度黑话，但保留关键信息 |

## 安装

### 一键安装到常见本地目录

```bash
git clone https://github.com/hallywang/heihua.git
cd heihua
scripts/install.sh --all
```

默认会安装到这些目录：

- Codex: `~/.codex/skills/`
- 通用 Agent Skills: `~/.agents/skills/`
- Claude Code: `~/.claude/skills/`
- Gemini CLI 风格目录: `~/.gemini/skills/`

如果目标目录里已经存在同名 skill，安装脚本会先备份为 `.backup.TIMESTAMP.PID`，再安装新版本。

### 只安装到 Codex

```bash
scripts/install.sh --codex --name internet-heihua-style
```

安装后建议重启 Codex 客户端或新开会话，让 skill 索引刷新。

### 只安装到 Claude Code

```bash
scripts/install.sh --claude --name internet-heihua-style
```

### 安装到自定义目录

```bash
scripts/install.sh --target "$HOME/.my-agent/skills" --name internet-heihua-style
```

## 目录结构

```text
.
├── SKILL.md
├── agents/
│   └── openai.yaml
├── references/
│   └── slang-bank.md
└── scripts/
    └── install.sh
```

- `SKILL.md`: skill 主体，包含触发条件、风格档位、使用原则和输出方式。
- `references/slang-bank.md`: 黑话语料库。需要更高浓度表达时再加载，避免默认上下文过重。
- `scripts/install.sh`: 跨工具安装脚本。
- `agents/openai.yaml`: Codex/OpenAI 侧展示元数据。

## 设计原则

这个 skill 的核心不是“把话说玄”，而是给中文交流加一层可控风格：

- **清晰优先**：如果黑话会影响理解，就用“说人话就是...”解释。
- **按场景降噪**：法律、医疗、金融、安全、冲突等高风险场景默认不整活。
- **不过度堆梗**：网感是增强表达，不是把回答变成赛博 PPT。
- **热梗需验证**：最新流行语变化快，涉及“最新热梗”时应先联网确认。
- **安全边界明确**：避免侮辱、歧视、骚扰、开盒、低俗烂梗和规避审核话术。

## 更新

```bash
cd heihua
git pull
scripts/install.sh --all --name internet-heihua-style
```

如果你只想更新 Codex：

```bash
git pull
scripts/install.sh --codex --name internet-heihua-style
```

## 兼容性

这个仓库采用常见的 `SKILL.md` 文件夹约定，理论上适配：

- OpenAI Codex
- Claude Code
- Gemini CLI 风格 skill/extension 目录
- Cursor、OpenCode、Copilot 等支持读取 `SKILL.md` 或 agent skill 目录的工具
- 其他允许用户配置 skills root 的 agent 客户端

不同客户端的刷新机制不一样。安装后如果 UI 里暂时看不到，优先尝试重启客户端或新开会话。

## 贡献

欢迎提交 issue 或 PR，尤其是：

- 更自然的中文互联网表达。
- 已经过时或不安全的黑话清理。
- 新 agent 客户端的安装路径补充。
- 更好的触发描述和安全边界。

贡献黑话语料时请尽量说明来源和语境。不要加入歧视、骚扰、开盒、低俗擦边或明显有害的表达。

### 如何增加黑话

大多数黑话贡献只需要改 [references/slang-bank.md](references/slang-bank.md)，不要直接把大量词条塞进 [SKILL.md](SKILL.md)。`SKILL.md` 负责稳定规则和触发逻辑，语料库负责可迭代的表达素材。

推荐流程：

1. Fork 本仓库并创建分支。
2. 在 `references/slang-bank.md` 里找到合适分类，例如“大厂黑话”“技术与 AI 黑话”“网感表达”。
3. 按现有表格格式新增词条：`词条`、`含义`、`推荐用法`、`备注`。
4. 如果是最近 3-6 个月的热梗，优先放到“易过期热梗”，并补来源或语境说明。
5. 如果词条有冒犯、歧视、骚扰、开盒、低俗擦边、规避审核风险，不要加入。
6. 提交 PR，并说明这些词适合什么场景、为什么不会损害表达清晰度。

词条示例：

```markdown
| 对齐 | 确认目标、理解或口径一致 | "先对齐目标和约束" | 常用，安全 |
```

热梗示例：

```markdown
- 某某梗：来自某平台/某事件，适合轻松吐槽；时效性强，使用前应确认是否仍流行。
```

PR 自检清单：

- 新词能增强表达，不只是堆梗。
- 解释足够清楚，非中文互联网用户也能大概理解。
- 示例句是自然用法，不是硬凑。
- 没有引入攻击性、歧视性或高风险表达。
- 如果是新热梗，标注了来源、语境或时效性。

## 引用与致谢

本项目的黑话语料库引用并完整收录了 [justjavac/ali-words](https://github.com/justjavac/ali-words) 在 `f358597dbafae7dbcbaaf3dddb751fc4d34309d8` 版本 README 中列出的词汇。`ali-words` 使用 [Unlicense](https://unlicense.org/) 发布，等同公共领域授权；本项目保留来源、版本和许可证信息，方便后续追溯。

除 `ali-words` 外，初始语料还参考了公开网页和媒体报道，具体来源见 [references/slang-bank.md](references/slang-bank.md) 的“来源说明”。

## 许可证

MIT License，见 [LICENSE](LICENSE)。
