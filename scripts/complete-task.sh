#!/bin/bash
# 完成/取消完成1TodoS任务
# 参数: --todo_id <任务ID> [--undo 取消完成]
T=$(cat ~/.config/1todos-skill/token 2>/dev/null)
if [ -z "$T" ]; then echo '{"error":"未授权，请先执行授权流程"}'; exit 1; fi

TODO_ID=""
IS_FINISH="1"

while [[ $# -gt 0 ]]; do
  case $1 in
    --todo_id) TODO_ID="$2"; shift 2;;
    --undo) IS_FINISH="0"; shift;;
    *) shift;;
  esac
done

if [ -z "$TODO_ID" ]; then echo '{"error":"缺少参数 --todo_id"}'; exit 1; fi

curl -s -X POST "https://todo.kairusi.com/index.php/todo/commit_finish" \
  -H "Content-Type: application/json" \
  -H "DEVICEID: skill-client-001" \
  -H "DEVICEIDTYPE: android" \
  -H "DEVICELANGUAGE: CN" \
  -H "PRODUCT: todo_pc" \
  -H "APPVERSION: 2.0.0" \
  -H "SESSIONID: $T" \
  -d "{\"todo_id\":\"$TODO_ID\",\"is_finish\":$IS_FINISH}"
