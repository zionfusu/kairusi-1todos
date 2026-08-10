#!/bin/bash
# 获取1TodoS项目/清单列表
T=$(cat ~/.config/1todos-skill/token 2>/dev/null)
if [ -z "$T" ]; then echo '{"error":"未授权，请先执行授权流程"}'; exit 1; fi

curl -s -X POST "https://todo.kairusi.com/index.php/project/get_list_pc_multi" \
  -H "Content-Type: application/json" \
  -H "DEVICEID: skill-client-001" \
  -H "DEVICEIDTYPE: android" \
  -H "DEVICELANGUAGE: CN" \
  -H "PRODUCT: todo_pc" \
  -H "APPVERSION: 2.0.0" \
  -H "SESSIONID: $T" \
  -d '{}'
