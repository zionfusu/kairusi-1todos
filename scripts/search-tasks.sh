#!/bin/bash
# 搜索1TodoS任务
# 参数: --keyword <关键词>
T=$(cat ~/.config/1todos-skill/token 2>/dev/null)
if [ -z "$T" ]; then echo '{"error":"未授权，请先执行授权流程"}'; exit 1; fi

KEYWORD=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --keyword) KEYWORD="$2"; shift 2;;
    *) shift;;
  esac
done

if [ -z "$KEYWORD" ]; then echo '{"error":"缺少参数 --keyword"}'; exit 1; fi

curl -s -X POST "https://todo.kairusi.com/index.php/todo/search" \
  -H "Content-Type: application/json" \
  -H "DEVICEID: skill-client-001" \
  -H "DEVICEIDTYPE: android" \
  -H "DEVICELANGUAGE: CN" \
  -H "PRODUCT: todo_pc" \
  -H "APPVERSION: 2.0.0" \
  -H "SESSIONID: $T" \
  -d "{\"keyword\":\"$KEYWORD\"}"
