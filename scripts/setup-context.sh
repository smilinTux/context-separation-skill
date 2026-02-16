#!/bin/bash
# Context Separation - Setup Context
# Usage: ./setup-context.sh "context_name" "channel_id" "allowed_topics"

CONTEXT_NAME="$1"
CHANNEL_ID="$2"
ALLOWED_TOPICS="$3"

if [ -z "$CONTEXT_NAME" ] || [ -z "$CHANNEL_ID" ] || [ -z "$ALLOWED_TOPICS" ]; then
    echo "Usage: $0 <context_name> <channel_id> <allowed_topics>"
    echo "Example: $0 'business' 'telegram:-1003785842091' 'revenue,security,platform'"
    exit 1
fi

CONFIG_FILE="${HOME}/clawd/skills/context-separation/contexts.json"
mkdir -p "$(dirname "$CONFIG_FILE")"

# Create config if it doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    echo '{}' > "$CONFIG_FILE"
fi

# Add context to config
jq --arg name "$CONTEXT_NAME" \
   --arg channel "$CHANNEL_ID" \
   --arg topics "$ALLOWED_TOPICS" \
   '.[$name] = {
     "channels": [$channel],
     "allowed_topics": ($topics | split(",")),
     "created": (now | strftime("%Y-%m-%dT%H:%M:%SZ"))
   }' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"

echo "✅ Context '$CONTEXT_NAME' configured"
echo "   Channel: $CHANNEL_ID"
echo "   Topics: $ALLOWED_TOPICS"
echo "   Config: $CONFIG_FILE"