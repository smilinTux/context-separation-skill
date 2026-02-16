#!/bin/bash
# Context Separation - Check Message Context
# Usage: ./check-context.sh --message "text" --context "context_name"

MESSAGE=""
CONTEXT=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --message)
            MESSAGE="$2"
            shift 2
            ;;
        --context)
            CONTEXT="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [ -z "$MESSAGE" ] || [ -z "$CONTEXT" ]; then
    echo "Usage: $0 --message 'your message' --context 'context_name'"
    exit 1
fi

CONFIG_FILE="${HOME}/clawd/skills/context-separation/contexts.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ No contexts configured. Run setup-context.sh first."
    exit 1
fi

# Get context configuration
ALLOWED_TOPICS=$(jq -r --arg ctx "$CONTEXT" '.[$ctx].allowed_topics[]?' "$CONFIG_FILE" 2>/dev/null)
FORBIDDEN_TOPICS=$(jq -r --arg ctx "$CONTEXT" '.[$ctx].forbidden_topics[]?' "$CONFIG_FILE" 2>/dev/null)

if [ -z "$ALLOWED_TOPICS" ]; then
    echo "❌ Context '$CONTEXT' not found in configuration"
    exit 1
fi

# Simple keyword matching for validation
MESSAGE_LOWER=$(echo "$MESSAGE" | tr '[:upper:]' '[:lower:]')
VIOLATIONS=""

# Check for forbidden topics
if [ -n "$FORBIDDEN_TOPICS" ]; then
    while IFS= read -r topic; do
        if echo "$MESSAGE_LOWER" | grep -qi "$topic"; then
            VIOLATIONS="$VIOLATIONS\n  - Contains forbidden topic: $topic"
        fi
    done <<< "$FORBIDDEN_TOPICS"
fi

# Additional common violations
if echo "$MESSAGE_LOWER" | grep -qi "moltbook\|social.*media\|personal.*account"; then
    if [ "$CONTEXT" = "business" ]; then
        VIOLATIONS="$VIOLATIONS\n  - Personal request in business context"
    fi
fi

if echo "$MESSAGE_LOWER" | grep -qi "domain\|namecheap\|website"; then
    if [ "$CONTEXT" = "business" ] && echo "$MESSAGE_LOWER" | grep -qv "platform\|revenue"; then
        VIOLATIONS="$VIOLATIONS\n  - Website/domain issue in business context"
    fi
fi

# Output result
if [ -n "$VIOLATIONS" ]; then
    echo "❌ CONTEXT VIOLATION:"
    echo -e "$VIOLATIONS"
    echo ""
    echo "Suggestion: Use main/personal chat instead"
    exit 1
else
    echo "✅ Message appropriate for '$CONTEXT' context"
    exit 0
fi