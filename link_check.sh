#!/bin/bash
INPUT="tools_urls.txt"
OUTPUT="links_report.csv"
echo "url,status_code,ok,response_time_ms" > $OUTPUT
while read -r url; do
  start=$(date +%s%3N)
  http_code=$(curl -o /dev/null -s -w "%{http_code}" -L --max-time 15 "$url")
  end=$(date +%s%3N)
  ms=$((end-start))
  ok="false"
  if [[ "$http_code" -ge 200 && "$http_code" -lt 400 ]]; then
    ok="true"
  fi
  echo "\"$url\",\"$http_code\",\"$ok\",\"$ms\"" >> $OUTPUT
done < "$INPUT"
