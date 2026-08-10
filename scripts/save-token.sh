#!/bin/bash
# 保存1TodoS Token
# 参数: --token <Token值>
TOKEN=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --token) TOKEN="$2"; shift 2;;
    *) shift;;
  esac
done

if [ -z "$TOKEN" ]; then echo '{"error":"缺少参数 --token"}'; exit 1; fi

mkdir -p ~/.config/1todos-skill
printf '%s' "$TOKEN" > ~/.config/1todos-skill/token
chmod 600 ~/.config/1todos-skill/token
echo '{"success":true,"message":"Token已保存"}'
