#!/bin/bash
# 获取1TodoS任务列表
# 参数: --uuid <清单UUID> [--type <0未完成|1已完成>] [--page <页码>]
T=$(cat ~/.config/1todos-skill/token 2>/dev/null)
if [ -z "$T" ]; then echo '{"error":"未授权，请先执行授权流程"}'; exit 1; fi

UUID=""
TYPE="0"
PAGE="1"

while [[ $# -gt 0 ]]; do
  case $1 in
    --uuid) UUID="$2"; shift 2;;
    --type) TYPE="$2"; shift 2;;
    --page) PAGE="$2"; shift 2;;
    *) shift;;
  esac
done

if [ -z "$UUID" ]; then echo '{"error":"缺少参数 --uuid"}'; exit 1; fi

curl -s -X POST "https://todo.kairusi.com/index.php/todo/get_list_by_uuid" \
  -H "Content-Type: application/json" \
  -H "DEVICEID: skill-client-001" \
  -H "DEVICEIDTYPE: android" \
  -H "DEVICELANGUAGE: CN" \
  -H "PRODUCT: todo_pc" \
  -H "APPVERSION: 2.0.0" \
  -H "SESSIONID: $T" \
  -d "{\"uuid\":\"$UUID\",\"type\":\"$TYPE\",\"page\":$PAGE}"
