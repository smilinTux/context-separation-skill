# Context Separation Skill

Professional context management for AI agents working across multiple channels and stakeholder groups.

## Quick Start

```bash
# Setup business context
./scripts/setup-context.sh "business" "telegram:-1003785842091" "revenue,security,platform"

# Check message before posting  
./scripts/check-context.sh --message "Platform revenue update" --context "business"
# ✅ Message appropriate for 'business' context

./scripts/check-context.sh --message "Need to claim my Moltbook account" --context "business"  
# ❌ CONTEXT VIOLATION: Personal request in business context

# Add to heartbeat
echo './skills/context-separation/scripts/heartbeat-check.sh' >> HEARTBEAT.md
```

## Files

- `SKILL.md` - Main skill documentation
- `scripts/setup-context.sh` - Configure contexts
- `scripts/check-context.sh` - Validate messages  
- `scripts/heartbeat-check.sh` - Periodic rule review
- `scripts/log-violation.sh` - Track mistakes
- `scripts/review-violations.sh` - Learn from patterns
- `references/common-contexts.md` - Context examples

## Configuration

Creates `contexts.json` with your defined contexts and validation rules.

## Integration

Add heartbeat check to automatically review context rules before routine updates.

Perfect for business agents, multi-client operations, or any professional AI deployment.