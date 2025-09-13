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
```eof
5. انزل لأسفل واضغط **"Commit changes"**.

#### **الخطوة 3: تحديث ملف GitHub Action**

أخيرًا، يجب أن نخبر GitHub Action بمكان السكربت الجديد.

1.  اذهب إلى مجلد `.github/workflows/` واضغط على ملف `main.yml` (أو أي اسم أعطيته له).
2.  اضغط على أيقونة القلم ✎ (Edit file).
3.  ابحث عن السطر `run: bash link_check.sh` وقم بتغييره ليصبح `run: bash scripts/link_check.sh`.
4.  لتسهيل الأمر عليك، قم باستبدال المحتوى بالكامل بالكود المحدث التالي.

```yml:Updated GitHub Action Workflow:.github/workflows/main.yml
# This is a GitHub Action that automatically checks the status of all links in the project.
# It runs once a week and saves a report.

name: Weekly Link Check

on:
  # Triggers the workflow on a schedule (every Monday at 03:00 UTC)
  schedule:
    - cron: '0 3 * * 1'
  
  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

jobs:
  link-checker:
    runs-on: ubuntu-latest
    steps:
      # Step 1: Check out the repository's code
      - name: Checkout repository
        uses: actions/checkout@v4

      # Step 2: Run the link check script from its new location in the 'scripts' folder
      - name: Run link check script
        run: bash scripts/link_check.sh

      # Step 3: Upload the generated report as an artifact
      - name: Upload report as artifact
        uses: actions/upload-artifact@v4
        with:
          name: weekly-links-report
          path: links_report.csv
```eof
5. انزل لأسفل واضغط **"Commit changes"**.

بعد هذه الخطوات الثلاث، سيصبح مشروعك منظمًا للغاية واحترافيًا. الواجهة الرئيسية لن تحتوي إلا على الملفات التي تهم المستخدم مباشرة، بينما الملفات التقنية ستكون منظمة في مجلد خاص بها.
