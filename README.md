# 1TodoS Skill

让 AI 助手连接你的 1TodoS 待办清单，通过自然语言管理任务。

支持 Claude Code、Cursor、WorkBuddy、OpenClaw 等支持 Skill 的 AI 应用。

## 功能

- 查看所有项目和清单
- 获取清单中的未完成/已完成任务
- 全局关键词搜索任务
- 创建新任务到指定清单或收件箱
- 标记任务完成/取消完成
- 删除任务

## 安装

### 方式一：通过 SkillHub 安装（推荐）

在 [SkillHub](https://skillhub.cloud.tencent.com) 搜索 "1TodoS" 或 "kairusi-1todos"，下载安装即可。

### 方式二：手动安装

1. 克隆本仓库：

```bash
git clone https://github.com/你的用户名/1todos-skill.git
```

2. 将文件夹放到你的 AI 应用的 Skill 目录中（具体路径取决于你使用的 AI 应用）

### 方式三：通过 MCP 连接

如果你的 AI 应用支持 MCP 协议（如 Claude Desktop、WorkBuddy），可以直接使用远程 MCP Server：

1. 访问 https://mcptodo.kairusi.com/authorize 登录获取配置
2. 将配置粘贴到 AI 应用的 MCP 设置中

## 使用方法

### 首次授权

对 AI 说"授权1TodoS"或"连接1TodoS"，按提示完成：

1. 访问 https://mcptodo.kairusi.com/authorize
2. 输入 1TodoS 手机号和密码登录
3. 将获取的 Token 发给 AI

### 日常使用

授权完成后，直接对 AI 说：

- "帮我看看所有清单"
- "收件箱里有什么任务？"
- "在紧急事件清单里加个任务：明天交报告"
- "搜索和项目相关的任务"
- "把'给浙大研究院回复'标记为完成"
- "删除那个测试任务"

## 系统要求

- macOS / Linux / Windows
- 系统自带 `curl` 命令（无需安装 Node.js）

## 文件结构

```
1todos-skill/
├── SKILL.md                    # AI 读取的主说明文件
├── README.md                   # 本文件
├── LICENSE                     # MIT 许可证
├── references/
│   └── api-commands.md         # API 接口参考文档
└── scripts/
    ├── save-token.sh           # 保存 Token
    ├── get-lists.sh            # 获取清单列表
    ├── get-tasks.sh            # 获取任务列表
    ├── search-tasks.sh         # 搜索任务
    ├── create-task.sh          # 创建任务
    ├── complete-task.sh        # 完成任务
    └── delete-task.sh          # 删除任务
```

## 隐私说明

- 本 Skill 仅在用户主动授权后访问其 1TodoS 数据
- Token 存储在用户本地 `~/.config/1todos-skill/token`，不会上传到任何第三方
- 所有 API 调用均通过 HTTPS 加密传输

## 许可证

MIT License

## 关于 1TodoS

[1TodoS](https://www.1todos.com) 是一款标准化的清单管理 App，支持收件箱、标签、文件夹等功能，帮助你高效管理日常待办事项。
