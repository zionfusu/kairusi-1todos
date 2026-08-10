#!/bin/bash
# 删除1TodoS任务
# 参数: --todo_id <任务ID> --uuid <清单UUID>
T=$(cat ~/.config/1todos-skill/token 2>/dev/null)
if [ -z "$T" ]; then echo '{"error":"未授权，请先执行授权流程"}'; exit 1; fi

TODO_ID=""
UUID=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --todo_id) TODO_ID="$2"; shift 2;;
    --uuid) UUID="$2"; shift 2;;
    *) shift;;
  esac
done

if [ -z "$TODO_ID" ]; then echo '{"error":"缺少参数 --todo_id"}'; exit 1; fi
if [ -z "$UUID" ]; then echo '{"error":"缺少参数 --uuid"}'; exit 1; fi

curl -s -X POST "https://todo.kairusi.com/index.php/todo/commit" \
  -H "Content-Type: application/json" \
  -H "DEVICEID: skill-client-001" \
  -H "DEVICEIDTYPE: android" \
  -H "DEVICELANGUAGE: CN" \
  -H "PRODUCT: todo_pc" \
  -H "APPVERSION: 2.0.0" \
  -H "SESSIONID: $T" \
  -d "{\"todo_id\":\"$TODO_ID\",\"project_uuid\":\"$UUID\",\"op_type\":\"del\"}"
