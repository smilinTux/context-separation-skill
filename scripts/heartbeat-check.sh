#!/bin/bash
# Context Separation - Heartbeat Check
# Validates context separation rules before routine updates

SKILL_DIR="$(dirname "$0")/.."
CONFIG_FILE="${HOME}/clawd/skills/context-separation/contexts.json"
RULES_FILE="${HOME}/clawd/CONTEXT-SEPARATION-RULES.md"

echo "🎯 Context Separation Check..."

# Check if rules file exists
if [ ! -f "$RULES_FILE" ]; then
    echo "⚠️  No CONTEXT-SEPARATION-RULES.md found"
    echo "   Creating from template..."
    
    cat > "$RULES_FILE" << 'EOF'
# CONTEXT SEPARATION RULES

## Business Context (SKGentis, Client Updates):
- Revenue generation, security, platform status
- Agent workstream progress, deployment updates
- Technical milestone reports

## Personal/Main Context (Everything Else):
- Website management, personal accounts
- Infrastructure issues, domain problems
- Social media setup, general requests

## Rule: When in doubt, use personal/main chat!
EOF
    
    echo "✅ Rules template created at $RULES_FILE"
fi

# Check if contexts are configured
if [ ! -f "$CONFIG_FILE" ]; then
    echo "ℹ️  No contexts configured yet"
    echo "   Run: ./scripts/setup-context.sh to configure"
    return 0
fi

# Display current context status
echo "📋 Active Contexts:"
jq -r 'keys[]' "$CONFIG_FILE" 2>/dev/null | while read -r context; do
    channels=$(jq -r --arg ctx "$context" '.[$ctx].channels[]?' "$CONFIG_FILE" 2>/dev/null | wc -l)
    topics=$(jq -r --arg ctx "$context" '.[$ctx].allowed_topics | length' "$CONFIG_FILE" 2>/dev/null)
    echo "   • $context: $channels channels, $topics allowed topics"
done

echo ""
echo "✅ Context separation rules reviewed"
echo "💡 Remember: Business contexts require business-only content!"

return 0