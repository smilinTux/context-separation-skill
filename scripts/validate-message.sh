#!/bin/bash
# Context Separation - Message Validation
# Validates message content against context rules before posting

MESSAGE="$1"
CHANNEL="$2"

if [ -z "$MESSAGE" ] || [ -z "$CHANNEL" ]; then
    echo "Usage: $0 \"<message>\" \"<channel_id>\""
    echo "Example: $0 \"SKGentis update\" \"telegram:-1003785842091\""
    exit 1
fi

SKILL_DIR="$(dirname "$0")/.."
CONTEXTS_FILE="$SKILL_DIR/contexts.json"

if [ ! -f "$CONTEXTS_FILE" ]; then
    echo "❌ No contexts configured. Run setup-context.sh first."
    exit 1
fi

# Find which context this channel belongs to
CONTEXT_NAME=""
for context in $(jq -r 'keys[]' "$CONTEXTS_FILE"); do
    if jq -e --arg ch "$CHANNEL" ".\"$context\".channels[] | select(. == \$ch)" "$CONTEXTS_FILE" >/dev/null 2>&1; then
        CONTEXT_NAME="$context"
        break
    fi
done

if [ -z "$CONTEXT_NAME" ]; then
    echo "⚠️  Channel $CHANNEL not configured in any context"
    echo "   Proceeding with caution..."
    exit 0
fi

echo "🔍 Validating message for context: $CONTEXT_NAME"
echo "   Channel: $CHANNEL"
echo ""

# Get allowed and forbidden topics
ALLOWED_TOPICS=$(jq -r ".\"$CONTEXT_NAME\".allowed_topics[]?" "$CONTEXTS_FILE" 2>/dev/null)
FORBIDDEN_TOPICS=$(jq -r ".\"$CONTEXT_NAME\".forbidden_topics[]?" "$CONTEXTS_FILE" 2>/dev/null)

# Convert message to lowercase for checking
MESSAGE_LOWER=$(echo "$MESSAGE" | tr '[:upper:]' '[:lower:]')

# Check for forbidden topics
VIOLATIONS=""
while IFS= read -r topic; do
    if [ -n "$topic" ] && echo "$MESSAGE_LOWER" | grep -q "$topic"; then
        VIOLATIONS="$VIOLATIONS\n   • $topic"
    fi
done <<< "$FORBIDDEN_TOPICS"

if [ -n "$VIOLATIONS" ]; then
    echo "❌ CONTEXT VIOLATION DETECTED!"
    echo "   Context: $CONTEXT_NAME"
    echo "   Forbidden topics found:$VIOLATIONS"
    echo ""
    echo "🚫 DO NOT POST THIS MESSAGE TO $CHANNEL"
    echo ""
    
    # Suggest alternative
    if [ "$CONTEXT_NAME" = "business" ]; then
        PERSONAL_CHANNEL=$(jq -r '.personal.channels[0]' "$CONTEXTS_FILE")
        echo "💡 Suggestion: Post to personal channel ($PERSONAL_CHANNEL) instead"
    elif [ "$CONTEXT_NAME" = "personal" ]; then
        BUSINESS_CHANNEL=$(jq -r '.business.channels[0]' "$CONTEXTS_FILE") 
        echo "💡 Suggestion: Post business-only parts to ($BUSINESS_CHANNEL)"
    fi
    
    # Log violation
    echo "$(date -u '+%Y-%m-%dT%H:%M:%SZ'): $CONTEXT_NAME violation - forbidden topics:$VIOLATIONS" >> "$SKILL_DIR/violations.log"
    
    exit 1
fi

# Check if message contains allowed topics
TOPIC_MATCH=""
while IFS= read -r topic; do
    if [ -n "$topic" ] && echo "$MESSAGE_LOWER" | grep -q "$topic"; then
        TOPIC_MATCH="$TOPIC_MATCH $topic"
    fi
done <<< "$ALLOWED_TOPICS"

if [ -n "$TOPIC_MATCH" ]; then
    echo "✅ Message validated for $CONTEXT_NAME context"
    echo "   Matched topics:$TOPIC_MATCH"
    echo ""
    echo "🟢 SAFE TO POST to $CHANNEL"
else
    echo "⚠️  No explicit topic match found"
    echo "   This might be off-topic for $CONTEXT_NAME context"
    echo "   Allowed topics: $(echo "$ALLOWED_TOPICS" | tr '\n' ' ')"
    echo ""
    echo "🟡 CAUTION: Consider if this belongs in $CONTEXT_NAME context"
fi

exit 0