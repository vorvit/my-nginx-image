#!/bin/bash

OUTPUT_DIR="./disk_fill"
STATUS_FILE="/usr/share/nginx/html/disk_fill_status.html"

mkdir -p "$OUTPUT_DIR"

INITIAL_AVAILABLE_SPACE=$(df "$OUTPUT_DIR" | awk 'NR==2 {print $4}')
_THRESHOLD=$(echo "$INITIAL_AVAILABLE_SPACE * 0.3" | bc)
THRESHOLD=${_THRESHOLD%.*}

echo "<html><body><pre>" > "$STATUS_FILE"
echo "Initial available space: $INITIAL_AVAILABLE_SPACE KB" >> "$STATUS_FILE"
echo "Usage threshold: $THRESHOLD KB" >> "$STATUS_FILE"

while true; do
    FILE_NAME=$(uuidgen)
    head -c 10M </dev/urandom >"${OUTPUT_DIR}/${FILE_NAME}.bin"
    echo "Created file: ${OUTPUT_DIR}/${FILE_NAME}.bin" >> "$STATUS_FILE"

    CURRENT_AVAILABLE_SPACE=$(df "$OUTPUT_DIR" | awk 'NR==2 {print $4}')
    USED_SPACE=$(($INITIAL_AVAILABLE_SPACE - $CURRENT_AVAILABLE_SPACE))

    if [ "$USED_SPACE" -ge "$THRESHOLD" ]; then
        echo "More than 30% of the initial available space has been used. Exiting." >> "$STATUS_FILE"
        break
    fi

    sleep 1
done

echo "</pre></body></html>" >> "$STATUS_FILE"