#!/bin/bash
# 标记/取消标记任务为星标
# 参数: --uuid <任务UUID> --is_mark <1标记|0取消>
T=$(cat ~/.config/1todos-skill/token 2>/dev/null)
if [ -z "$T" ]; then echo '{"error":"未授权，请先执行授权流程"}'; exit 1; fi

UUID=""
IS_MARK="1"

while [[ $# -gt 0 ]]; do
  case $1 in
    --uuid) UUID="$2"; shift 2;;
    --is_mark) IS_MARK="$2"; shift 2;;
    *) shift;;
  esac
done

if [ -z "$UUID" ]; then echo '{"error":"缺少参数 --uuid"}'; exit 1; fi

curl -s -X POST "https://todo.kairusi.com/index.php/todo/mark" \
  -H "Content-Type: application/json" \
  -H "DEVICEID: skill-client-001" \
  -H "DEVICEIDTYPE: android" \
  -H "DEVICELANGUAGE: CN" \
  -H "PRODUCT: todo_pc" \
  -H "APPVERSION: 2.0.0" \
  -H "SESSIONID: $T" \
  -d "{\"uuid\":\"$UUID\",\"is_mark\":\"$IS_MARK\"}"
