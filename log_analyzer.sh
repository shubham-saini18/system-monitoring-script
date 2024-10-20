#!/bin/bash

# Log Analyzer and Report Generator Script
# Author: Shubham Saini
# Date: 20-10-2024
# Description: This script analyzes a log file to count errors, find critical events, identify the top error messages, and generate a summary report.

# Check if the log file path is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <path_to_log_file>"
    exit 1
fi

LOG_FILE="$1"

# Check if the log file actually exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: The file '$LOG_FILE' does not exist. Are you sure you gave me the right path?"
    exit 1
fi

# Initialize variables
ERROR_COUNT=0
CRITICAL_EVENTS=()
declare -A ERROR_MESSAGES

# Process the log file
while IFS= read -r LINE || [ -n "$LINE" ]; do
    # Increment total line counter
    ((TOTAL_LINES++))

    # Check for error messages containing "ERROR" or "Failed"
    if echo "$LINE" | grep -q -E "(ERROR|Failed)"; then
        ((ERROR_COUNT++))

        # Extract the error message content
        ERROR_MSG=$(echo "$LINE" | awk -F'[:]' '{print $2}' | xargs)
        ((ERROR_MESSAGES["$ERROR_MSG"]++))
    fi

    # Check if the line has "CRITICAL" events
    if echo "$LINE" | grep -q "CRITICAL"; then
        CRITICAL_EVENTS+=("Line $TOTAL_LINES: $LINE")
    fi
done <"$LOG_FILE"

# Create the summary report
REPORT_FILE="log_report_$(date +%F).txt"
{
    echo "Log Analysis Report - $(date)"
    echo "Log File: $LOG_FILE"
    echo "Total Lines Processed: $TOTAL_LINES"
    echo "Total Error Count: $ERROR_COUNT"
    echo ""
    echo "Top 5 Most Common Error Messages:"

    for ERROR in "${!ERROR_MESSAGES[@]}"; do
        echo "${ERROR_MESSAGES["$ERROR"]} occurrences: $ERROR"
    done | sort -nr | head -n 5

    echo ""
    echo "List of Critical Events:"
    for EVENT in "${CRITICAL_EVENTS[@]}"; do
        echo "$EVENT"
    done
} >"$REPORT_FILE"

echo "Log analysis done! Your report is ready: $REPORT_FILE"

# Bonus: Archive the log file after processing
ARCHIVE_DIR="archived_logs"
mkdir -p "$ARCHIVE_DIR"
mv "$LOG_FILE" "$ARCHIVE_DIR/$(basename "$LOG_FILE")_$(date +%F)"

echo "Log file has been archived in: $ARCHIVE_DIR"
