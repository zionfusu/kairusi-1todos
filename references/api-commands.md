# 1TodoS API 命令参考

## 公共参数

所有请求必须携带以下 Header：

```
DEVICEID: skill-client-001
DEVICEIDTYPE: android
DEVICELANGUAGE: CN
PRODUCT: todo_pc
APPVERSION: 2.0.0
Content-Type: application/json
```

Token（session_id）通过 Header `SESSIONID` 传递。

**基础地址：** `https://todo.kairusi.com/index.php/`

---

## 获取项目/清单列表

### bash (macOS / Linux)

```bash
T=$(cat ~/.config/1todos-skill/token 2>/dev/null)
curl -s -X POST "https://todo.kairusi.com/index.php/project/get_list_pc_multi" \
  -H "Content-Type: application/json" \
  -H "DEVICEID: skill-client-001" \
  -H "DEVICEIDTYPE: android" \
  -H "DEVICELANGUAGE: CN" \
  -H "PRODUCT: todo_pc" \
  -H "APPVERSION: 2.0.0" \
  -H "SESSIONID: $T" \
  -d '{}'
```

### PowerShell (Windows)

```powershell
$t = (Get-Content "$HOME\.config\1todos-skill\token" -Raw -EA SilentlyContinue).Trim()
$headers = @{ "Content-Type"="application/json"; "DEVICEID"="skill-client-001"; "DEVICEIDTYPE"="android"; "DEVICELANGUAGE"="CN"; "PRODUCT"="todo_pc"; "APPVERSION"="2.0.0"; "SESSIONID"=$t }
Invoke-RestMethod -Uri "https://todo.kairusi.com/index.php/project/get_list_pc_multi" -Method POST -Headers $headers -Body '{}'
```

### 响应处理

返回 `data` 数组，每项包含：
- `project_name` — 清单名称
- `project_uuid` — 清单UUID（后续获取任务时使用）
- `folder_name` — 所属文件夹名称（可能为空）
- `undone_count` — 未完成任务数

---

## 获取任务列表

### bash (macOS / Linux)

```bash
T=$(cat ~/.config/1todos-skill/token 2>/dev/null)
# UUID 替换为目标清单的 uuid（注意：参数名是 uuid，不是 project_uuid）
# TYPE: 0=未完成, 1=已完成
curl -s -X POST "https://todo.kairusi.com/index.php/todo/get_list_by_uuid" \
  -H "Content-Type: application/json" \
  -H "DEVICEID: skill-client-001" \
  -H "DEVICEIDTYPE: android" \
  -H "DEVICELANGUAGE: CN" \
  -H "PRODUCT: todo_pc" \
  -H "APPVERSION: 2.0.0" \
  -H "SESSIONID: $T" \
  -d '{"uuid":"UUID","type":"TYPE","page":1}'
```

### PowerShell (Windows)

```powershell
$t = (Get-Content "$HOME\.config\1todos-skill\token" -Raw -EA SilentlyContinue).Trim()
$headers = @{ "Content-Type"="application/json"; "DEVICEID"="skill-client-001"; "DEVICEIDTYPE"="android"; "DEVICELANGUAGE"="CN"; "PRODUCT"="todo_pc"; "APPVERSION"="2.0.0"; "SESSIONID"=$t }
$body = '{"uuid":"UUID","type":"TYPE","page":1}'
Invoke-RestMethod -Uri "https://todo.kairusi.com/index.php/todo/get_list_by_uuid" -Method POST -Headers $headers -Body $body
```

### 响应处理

返回 `data` 对象，包含两个数组：
- `data.unfinish` — 未完成任务数组
- `data.finished` — 已完成任务数组

每个任务包含：
- `id` — 任务ID（用于完成/删除操作）
- `title` — 任务标题
- `belong_date` — 截止日期（如 "2026-08-15"，空字符串表示无截止日期）
- `is_finish` — 是否完成（0/1）
- `labels` — 标签数组

---

## 获取收件箱

**重要：** 收件箱的 UUID 是在**登录时**返回的 `data.project_uuid` 字段，不在清单列表接口中。

获取收件箱任务的方法：用登录返回的 `project_uuid` 作为 `uuid` 参数调用获取任务列表接口。

如果用户已授权但不知道收件箱UUID，可以通过 MCP Server 的 `/token` 接口登录时获取，或者在 SKILL 授权流程中同时保存收件箱UUID。

### 保存收件箱UUID

授权时，除了保存 token，还应保存收件箱UUID：

**macOS / Linux：**
```bash
printf '%s' 'INBOX_UUID' > ~/.config/1todos-skill/inbox_uuid
```

### 获取收件箱任务

```bash
T=$(cat ~/.config/1todos-skill/token 2>/dev/null)
INBOX=$(cat ~/.config/1todos-skill/inbox_uuid 2>/dev/null)
curl -s -X POST "https://todo.kairusi.com/index.php/todo/get_list_by_uuid" \
  -H "Content-Type: application/json" \
  -H "DEVICEID: skill-client-001" \
  -H "DEVICEIDTYPE: android" \
  -H "DEVICELANGUAGE: CN" \
  -H "PRODUCT: todo_pc" \
  -H "APPVERSION: 2.0.0" \
  -H "SESSIONID: $T" \
  -d "{\"uuid\":\"$INBOX\",\"type\":\"0\",\"page\":1}"
```

---

## 搜索任务

### bash (macOS / Linux)

```bash
T=$(cat ~/.config/1todos-skill/token 2>/dev/null)
# KEYWORD 替换为搜索关键词
curl -s -X POST "https://todo.kairusi.com/index.php/todo/search" \
  -H "Content-Type: application/json" \
  -H "DEVICEID: skill-client-001" \
  -H "DEVICEIDTYPE: android" \
  -H "DEVICELANGUAGE: CN" \
  -H "PRODUCT: todo_pc" \
  -H "APPVERSION: 2.0.0" \
  -H "SESSIONID: $T" \
  -d '{"keyword":"KEYWORD"}'
```

### PowerShell (Windows)

```powershell
$t = (Get-Content "$HOME\.config\1todos-skill\token" -Raw -EA SilentlyContinue).Trim()
$headers = @{ "Content-Type"="application/json"; "DEVICEID"="skill-client-001"; "DEVICEIDTYPE"="android"; "DEVICELANGUAGE"="CN"; "PRODUCT"="todo_pc"; "APPVERSION"="2.0.0"; "SESSIONID"=$t }
$body = '{"keyword":"KEYWORD"}'
Invoke-RestMethod -Uri "https://todo.kairusi.com/index.php/todo/search" -Method POST -Headers $headers -Body $body
```

### 响应处理

返回 `data` 对象，包含：
- `lists` — 匹配的任务列表
- `labels` — 匹配的标签列表

---

## 创建任务

### bash (macOS / Linux)

```bash
T=$(cat ~/.config/1todos-skill/token 2>/dev/null)
# TITLE — 任务标题
# PROJECT_UUID — 目标清单UUID
# END_TIME — 截止时间戳（可选，0表示无截止日期）
curl -s -X POST "https://todo.kairusi.com/index.php/todo/commit" \
  -H "Content-Type: application/json" \
  -H "DEVICEID: skill-client-001" \
  -H "DEVICEIDTYPE: android" \
  -H "DEVICELANGUAGE: CN" \
  -H "PRODUCT: todo_pc" \
  -H "APPVERSION: 2.0.0" \
  -H "SESSIONID: $T" \
  -d '{"title":"TITLE","project_uuid":"PROJECT_UUID","end_time":0,"op_type":"add"}'
```

### PowerShell (Windows)

```powershell
$t = (Get-Content "$HOME\.config\1todos-skill\token" -Raw -EA SilentlyContinue).Trim()
$headers = @{ "Content-Type"="application/json"; "DEVICEID"="skill-client-001"; "DEVICEIDTYPE"="android"; "DEVICELANGUAGE"="CN"; "PRODUCT"="todo_pc"; "APPVERSION"="2.0.0"; "SESSIONID"=$t }
$body = '{"title":"TITLE","project_uuid":"PROJECT_UUID","end_time":0,"op_type":"add"}'
Invoke-RestMethod -Uri "https://todo.kairusi.com/index.php/todo/commit" -Method POST -Headers $headers -Body ([System.Text.Encoding]::UTF8.GetBytes($body))
```

### 响应处理

返回 `code == 1` 表示成功。

---

## 完成任务

### bash (macOS / Linux)

```bash
T=$(cat ~/.config/1todos-skill/token 2>/dev/null)
# TODO_ID — 任务ID
curl -s -X POST "https://todo.kairusi.com/index.php/todo/commit_finish" \
  -H "Content-Type: application/json" \
  -H "DEVICEID: skill-client-001" \
  -H "DEVICEIDTYPE: android" \
  -H "DEVICELANGUAGE: CN" \
  -H "PRODUCT: todo_pc" \
  -H "APPVERSION: 2.0.0" \
  -H "SESSIONID: $T" \
  -d '{"todo_id":"TODO_ID","is_finish":1}'
```

### PowerShell (Windows)

```powershell
$t = (Get-Content "$HOME\.config\1todos-skill\token" -Raw -EA SilentlyContinue).Trim()
$headers = @{ "Content-Type"="application/json"; "DEVICEID"="skill-client-001"; "DEVICEIDTYPE"="android"; "DEVICELANGUAGE"="CN"; "PRODUCT"="todo_pc"; "APPVERSION"="2.0.0"; "SESSIONID"=$t }
$body = '{"todo_id":"TODO_ID","is_finish":1}'
Invoke-RestMethod -Uri "https://todo.kairusi.com/index.php/todo/commit_finish" -Method POST -Headers $headers -Body $body
```

### 响应处理

返回 `code == 1` 表示成功。

---

## 删除任务

### bash (macOS / Linux)

```bash
T=$(cat ~/.config/1todos-skill/token 2>/dev/null)
# TODO_ID — 任务ID
# PROJECT_UUID — 任务所属清单UUID
curl -s -X POST "https://todo.kairusi.com/index.php/todo/commit" \
  -H "Content-Type: application/json" \
  -H "DEVICEID: skill-client-001" \
  -H "DEVICEIDTYPE: android" \
  -H "DEVICELANGUAGE: CN" \
  -H "PRODUCT: todo_pc" \
  -H "APPVERSION: 2.0.0" \
  -H "SESSIONID: $T" \
  -d '{"todo_id":"TODO_ID","project_uuid":"PROJECT_UUID","op_type":"del"}'
```

### PowerShell (Windows)

```powershell
$t = (Get-Content "$HOME\.config\1todos-skill\token" -Raw -EA SilentlyContinue).Trim()
$headers = @{ "Content-Type"="application/json"; "DEVICEID"="skill-client-001"; "DEVICEIDTYPE"="android"; "DEVICELANGUAGE"="CN"; "PRODUCT"="todo_pc"; "APPVERSION"="2.0.0"; "SESSIONID"=$t }
$body = '{"todo_id":"TODO_ID","project_uuid":"PROJECT_UUID","op_type":"del"}'
Invoke-RestMethod -Uri "https://todo.kairusi.com/index.php/todo/commit" -Method POST -Headers $headers -Body $body
```

### 响应处理

返回 `code == 1` 表示成功。

---

## 获取标签

标签信息在登录时已包含在用户信息中。如需单独获取，使用获取项目/清单列表接口，响应中包含用户的标签列表。

---

## 错误处理

* `code == 0` 且 `msg` 包含 "session" → Token 过期，提示用户重新授权
* `code == 0` → 操作失败，展示 `msg` 字段内容
* `code == 1` → 操作成功
