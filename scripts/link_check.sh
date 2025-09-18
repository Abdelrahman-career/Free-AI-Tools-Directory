#!/bin/bash

# A simple script to check the status of URLs listed in a file.
# It outputs a CSV report with the URL, HTTP status code, and response time.

# Updated path to look inside the 'scripts' folder
INPUT="scripts/tools_urls.txt"
OUTPUT="links_report.csv"

# Create the CSV header
echo "url,status_code,ok,response_time_ms" > "$OUTPUT"

# Read each URL from the input file and check its status
while IFS= read -r url; do
  # Get the start time in milliseconds
  start_time=$(date +%s%3N)

  # Use curl to get the HTTP status code.
  status_code=$(curl -o /dev/null -s -w "%{http_code}" -L --max-time 15 "$url")

  # Get the end time in milliseconds
  end_time=$(date +%s%3N)

  # Calculate the response time
  response_time=$((end_time - start_time))

  # Check if the status code is a success (2xx or 3xx)
  is_ok="false"
  if [[ "$status_code" -ge 200 && "$status_code" -lt 400 ]]; then
    is_ok="true"
  fi

  # Append the result to the CSV report
  echo "\"$url\",\"$status_code\",\"$is_ok\",\"$response_time\"" >> "$OUTPUT"

done < "$INPUT"

echo "Link check complete. Report saved to $OUTPUT"
