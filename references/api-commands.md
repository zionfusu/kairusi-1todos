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
# UUID 替换为目标清单的 project_uuid
# TYPE: 0=未完成, 1=已完成
curl -s -X POST "https://todo.kairusi.com/index.php/todo/get_list_by_uuid" \
  -H "Content-Type: application/json" \
  -H "DEVICEID: skill-client-001" \
  -H "DEVICEIDTYPE: android" \
  -H "DEVICELANGUAGE: CN" \
  -H "PRODUCT: todo_pc" \
  -H "APPVERSION: 2.0.0" \
  -H "SESSIONID: $T" \
  -d '{"project_uuid":"UUID","type":"TYPE","page":1}'
```

### PowerShell (Windows)

```powershell
$t = (Get-Content "$HOME\.config\1todos-skill\token" -Raw -EA SilentlyContinue).Trim()
$headers = @{ "Content-Type"="application/json"; "DEVICEID"="skill-client-001"; "DEVICEIDTYPE"="android"; "DEVICELANGUAGE"="CN"; "PRODUCT"="todo_pc"; "APPVERSION"="2.0.0"; "SESSIONID"=$t }
$body = '{"project_uuid":"UUID","type":"TYPE","page":1}'
Invoke-RestMethod -Uri "https://todo.kairusi.com/index.php/todo/get_list_by_uuid" -Method POST -Headers $headers -Body $body
```

### 响应处理

返回 `data.list` 数组，每项包含：
- `todo_id` — 任务ID
- `title` — 任务标题
- `end_time` — 截止时间（时间戳，0表示无截止日期）
- `is_finish` — 是否完成（0/1）
- `labels` — 标签数组

---

## 获取收件箱

收件箱就是用户的默认项目。先调用获取项目/清单列表，找到类型为收件箱的项目（通常是列表中第一个），然后用其 `project_uuid` 调用获取任务列表接口。

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
