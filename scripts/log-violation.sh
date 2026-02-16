#!/bin/bash
# Context Separation - Log Violation
# Usage: ./log-violation.sh "description of violation"

VIOLATION="$1"
if [ -z "$VIOLATION" ]; then
    echo "Usage: $0 'violation description'"
    exit 1
fi

LOG_FILE="${HOME}/clawd/skills/context-separation/violations.log"
TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

mkdir -p "$(dirname "$LOG_FILE")"

echo "[$TIMESTAMP] $VIOLATION" >> "$LOG_FILE"
echo "🚨 Violation logged: $VIOLATION"

# Update violation count in memory
MEMORY_FILE="${HOME}/clawd/memory/context-rules.json"
if [ -f "$MEMORY_FILE" ]; then
    # Increment violation count
    jq --arg ts "$TIMESTAMP" --arg violation "$VIOLATION" \
       '.violation_count += 1 | .last_violation = $ts | .violations += [{"timestamp": $ts, "description": $violation}]' \
       "$MEMORY_FILE" > "${MEMORY_FILE}.tmp" && mv "${MEMORY_FILE}.tmp" "$MEMORY_FILE"
fi

echo "📊 Total violations: $(wc -l < "$LOG_FILE")"