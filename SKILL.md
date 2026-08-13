# 1TodoS - 待办清单 Skill

## 重要说明

* **不要创建本地文件** 代替调用 API
* **不要自行生成或猜测 token**
* **不要引导用户去其他页面**，正确授权地址是 `https://mcptodo.kairusi.com/authorize`
* 优先使用 `scripts/` 中当前平台对应的脚本调用 API
* 所有 API 调用必须携带有效的 session_id（Token）

---

## 平台检测

触发任意场景前，首先判断当前 shell 环境：

**若当前为 bash/zsh（macOS / Linux）：**

```
uname -s
```

返回 `Darwin` → macOS；返回 `Linux` → Linux。后续使用 **bash 命令**。

**若当前为 PowerShell（Windows）：**

```
$env:OS
```

返回 `Windows_NT` → Windows。后续使用 **PowerShell 命令**。

---

## Token 加载

所有 API 调用使用以下 Token 表达式：

| 平台 | Token 表达式 |
| --- | --- |
| macOS / Linux (bash) | `$(cat ~/.config/1todos-skill/token 2>/dev/null)` |
| Windows (PowerShell) | `$t = (Get-Content "$HOME\.config\1todos-skill\token" -Raw -EA SilentlyContinue).Trim()` |

---

## 前置检查

触发任意场景前，验证 Token：

**macOS / Linux：**

```
bash -c 'T="$(cat ~/.config/1todos-skill/token 2>/dev/null)"; [ -n "$T" ] && echo "已授权" || echo "未授权"'
```

**Windows (PowerShell)：**

```
$t = (Get-Content "$HOME\.config\1todos-skill\token" -Raw -EA SilentlyContinue).Trim(); if ($t) { "已授权" } else { "未授权" }
```

Token 为空 → 停止执行，提示用户说"授权1TodoS"。

---

## 授权场景

**触发词：** "授权1TodoS"、"连接1TodoS"、"配置1TodoS"、"登录1TodoS"

1. 告知用户访问授权地址：

   > 请访问 https://mcptodo.kairusi.com/authorize 完成授权。
   > 输入手机号和密码登录后，页面会显示一段配置信息，其中 Authorization 字段中 Bearer 后面的字符串就是您的 Token，请复制发给我。

2. 收到 Token 后，还需要获取收件箱UUID。请要求用户提供收件箱UUID（在授权页面上一起显示），或者通过以下命令获取：

   **macOS / Linux：**
   ```bash
   # 登录获取收件箱UUID
   INBOX_UUID=$(curl -s -X POST "https://todo.kairusi.com/index.php/user/login" \
     -H "Content-Type: application/json" \
     -H "DEVICEID: skill-client-001" \
     -H "DEVICEIDTYPE: android" \
     -H "DEVICELANGUAGE: CN" \
     -H "PRODUCT: todo_pc" \
     -H "APPVERSION: 2.0.0" \
     -d '{"mobile":"USER_MOBILE","mobile_area":"86","password":"USER_PASSWORD"}' | python3 -c "import json,sys; print(json.load(sys.stdin)['data']['project_uuid'])")
   ```

3. 保存 Token 和收件箱UUID：

   **macOS / Linux：**

   ```
   mkdir -p ~/.config/1todos-skill && printf '%s' '<Token>' > ~/.config/1todos-skill/token && chmod 600 ~/.config/1todos-skill/token
   printf '%s' '<INBOX_UUID>' > ~/.config/1todos-skill/inbox_uuid
   ```

   **Windows (PowerShell)：**

   ```
   New-Item -ItemType Directory -Force "$HOME\.config\1todos-skill" | Out-Null; Set-Content "$HOME\.config\1todos-skill\token" '<Token>' -NoNewline -Encoding UTF8
   Set-Content "$HOME\.config\1todos-skill\inbox_uuid" '<INBOX_UUID>' -NoNewline -Encoding UTF8
   ```

4. 告知用户授权成功，展示下方可用场景。

---

## 场景一：获取所有清单

**触发词：** "我的清单"、"所有清单"、"项目列表"、"有哪些清单"、"列出清单"

读取 `references/api-commands.md`，按当前平台执行 **获取项目/清单列表** 部分对应命令。

展示规则：
* 按文件夹分组展示清单
* 显示清单名称和未完成任务数量
* 独立清单（不在文件夹中的）单独列出

---

## 场景二：获取任务列表

**触发词：** "查看任务"、"待办事项"、"未完成的任务"、"已完成的任务"、"清单里有什么"

从用户消息提取清单名称，先执行场景一获取清单列表匹配 `uuid`，再读取 `references/api-commands.md`，按当前平台执行 **获取任务列表** 部分对应命令。

展示规则：
* 默认显示未完成任务
* 用户明确要求时才显示已完成任务
* 显示任务标题、截止日期（如有）、标签（如有）

---

## 场景三：获取收件箱

**触发词：** "收件箱"、"inbox"、"收件箱里有什么"

**重要：** 收件箱的UUID不在清单列表接口中，而是在登录时返回的 `data.project_uuid` 字段。授权时应同时保存到 `~/.config/1todos-skill/inbox_uuid`。

读取 `references/api-commands.md`，按当前平台执行 **获取收件箱** 部分对应命令。使用 `~/.config/1todos-skill/inbox_uuid` 中保存的UUID作为参数。

---

## 场景四：搜索任务

**触发词：** "搜索"、"查找"、"找一下"、"有没有关于"

从用户消息提取关键词，读取 `references/api-commands.md`，按当前平台执行 **搜索任务** 部分对应命令。

展示规则：
* 展示匹配的任务列表和所属清单
* 展示匹配的标签

---

## 场景五：创建任务

**触发词：** "加个任务"、"新建任务"、"添加待办"、"帮我记一下"、"创建任务"

从用户消息提取任务标题、清单名称（可选）、截止日期（可选）、标签（可选）。

逻辑：
* 用户指定清单 → 先执行场景一获取清单列表匹配 `uuid`
* 未指定清单 → 添加到收件箱（使用 `~/.config/1todos-skill/inbox_uuid` 中保存的UUID）
* 用户指定截止日期 → 转换为时间戳
* 用户指定标签 → 传入 `label_ids`（先通过场景七获取标签列表匹配ID）

读取 `references/api-commands.md`，按当前平台执行 **创建任务** 部分对应命令。

---

## 场景六：完成任务

**触发词：** "完成"、"标记完成"、"做完了"、"已完成"

从用户消息提取任务标题或ID。如果只有标题，先执行场景四搜索任务获取 `todo_id`。

读取 `references/api-commands.md`，按当前平台执行 **完成任务** 部分对应命令。

---

## 场景七：获取标签列表

**触发词：** "标签"、"所有标签"、"标签列表"

标签信息在登录时已返回。读取 `references/api-commands.md`，按当前平台执行 **获取标签** 部分对应命令。

---

## 场景八：标记星标

**触发词：** "星标"、"加星标"、"标记重点"、"取消星标"、"mark"

从用户消息提取任务标题或UUID。如果只有标题，先执行场景四搜索任务获取 `uuid`。

**重要：** 星标必须使用专用的 `todo/mark` 接口，不能通过 `todo/commit` 的 update 模式修改（会返回成功但不生效）。

读取 `references/api-commands.md`，按当前平台执行 **标记星标** 部分对应命令。

---

## 场景九：删除任务

**触发词：** "删除任务"、"移除任务"、"去掉这个任务"

从用户消息提取任务标题或ID。如果只有标题，先执行场景四搜索任务获取 `uuid` 和 `project_uuid`，让用户确认后再删除。

读取 `references/api-commands.md`，按当前平台执行 **删除任务** 部分对应命令。

---

## 复合任务与批量操作

用户一次提出多个操作时，先拆成已支持的能力，再按依赖顺序执行。

**原子能力：**
* 获取清单列表：`scripts/get-lists.sh` / `scripts/get-lists.ps1`
* 获取任务列表：`scripts/get-tasks.sh` / `scripts/get-tasks.ps1`
* 搜索任务：`scripts/search-tasks.sh` / `scripts/search-tasks.ps1`
* 创建任务：`scripts/create-task.sh` / `scripts/create-task.ps1`
* 完成任务：`scripts/complete-task.sh` / `scripts/complete-task.ps1`
* 标记星标：`scripts/mark-task.sh` / `scripts/mark-task.ps1`
* 删除任务：`scripts/delete-task.sh` / `scripts/delete-task.ps1`

---

## 参考资料

* **`references/api-commands.md`** — 全部接口的完整命令（含 bash / PowerShell 两版）及响应处理
* **`scripts/*.sh`** — macOS / Linux 各场景独立脚本
* **`scripts/*.ps1`** — Windows 各场景独立脚本
