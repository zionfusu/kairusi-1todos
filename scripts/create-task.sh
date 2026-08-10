#!/bin/bash
# 创建1TodoS任务
# 参数: --title <标题> --uuid <清单UUID> [--end_time <截止时间戳>]
T=$(cat ~/.config/1todos-skill/token 2>/dev/null)
if [ -z "$T" ]; then echo '{"error":"未授权，请先执行授权流程"}'; exit 1; fi

TITLE=""
UUID=""
END_TIME="0"

while [[ $# -gt 0 ]]; do
  case $1 in
    --title) TITLE="$2"; shift 2;;
    --uuid) UUID="$2"; shift 2;;
    --end_time) END_TIME="$2"; shift 2;;
    *) shift;;
  esac
done

if [ -z "$TITLE" ]; then echo '{"error":"缺少参数 --title"}'; exit 1; fi
if [ -z "$UUID" ]; then echo '{"error":"缺少参数 --uuid"}'; exit 1; fi

curl -s -X POST "https://todo.kairusi.com/index.php/todo/commit" \
  -H "Content-Type: application/json" \
  -H "DEVICEID: skill-client-001" \
  -H "DEVICEIDTYPE: android" \
  -H "DEVICELANGUAGE: CN" \
  -H "PRODUCT: todo_pc" \
  -H "APPVERSION: 2.0.0" \
  -H "SESSIONID: $T" \
  -d "{\"title\":\"$TITLE\",\"project_uuid\":\"$UUID\",\"end_time\":$END_TIME,\"op_type\":\"add\"}"
