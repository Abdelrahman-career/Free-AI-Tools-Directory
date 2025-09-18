#!/bin/bash

INPUT="scripts/tools_urls.txt"
OUTPUT="links_report.csv"

echo "url,status_code,ok,response_time_ms" > "$OUTPUT"

while IFS= read -r url; do
  start_time=$(date +%s%3N)
  status_code=$(curl -o /dev/null -s -w "%{http_code}" -L --max-time 15 "$url")
  end_time=$(date +%s%3N)
  response_time=$((end_time - start_time))
  is_ok="false"
  if [[ "$status_code" -ge 200 && "$status_code" -lt 400 ]]; then
    is_ok="true"
  fi
  echo "\"$url\",\"$status_code\",\"$is_ok\",\"$response_time\"" >> "$OUTPUT"
done < "$INPUT"

echo "Link check complete. Report saved to $OUTPUT"
