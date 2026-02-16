#!/bin/bash
# Context Separation - Review Violations
# Shows violation patterns to help improve context awareness

LOG_FILE="${HOME}/clawd/skills/context-separation/violations.log"

if [ ! -f "$LOG_FILE" ]; then
    echo "✅ No violations logged yet!"
    exit 0
fi

echo "📊 Context Separation Violation Report"
echo "======================================"
echo ""

TOTAL=$(wc -l < "$LOG_FILE")
echo "Total violations: $TOTAL"
echo ""

echo "Recent violations:"
tail -5 "$LOG_FILE" | while IFS= read -r line; do
    echo "  $line"
done

echo ""
echo "Common patterns:"
grep -o '\[.*\] .*' "$LOG_FILE" | cut -d' ' -f2- | sort | uniq -c | sort -nr | head -3

echo ""
echo "💡 Suggestions:"
echo "  - Review CONTEXT-SEPARATION-RULES.md"
echo "  - Use context check before posting: ./check-context.sh"  
echo "  - When in doubt, use personal/main chat"