---
name: context-separation
description: Prevent context conflation in multi-channel environments. Automatically validates communication context appropriateness before posting to business channels, personal chats, or client groups. Essential for AI agents managing professional boundaries.
---

# Context Separation

Prevents embarrassing conflation by validating message context before posting. Essential for agents working across business/personal boundaries or serving multiple clients.

## Problem Solved

AI agents frequently mix contexts inappropriately:
- Personal requests in business channels
- Client A information in Client B updates  
- Infrastructure issues in revenue discussions
- Social media setup in trustee reports

## Core Commands

```bash
# Setup contexts
./scripts/setup-context.sh "business" "telegram:group123" "revenue,security,platform"
./scripts/setup-context.sh "personal" "telegram:dm456" "social,accounts,infrastructure"

# Validate before posting
./scripts/check-context.sh --message "Moltbook account needs claiming" --context "business"
# Output: ❌ VIOLATION: Personal request in business context

# Integrate with heartbeat
./scripts/heartbeat-check.sh
# Validates context rules before routine updates
```

## Configuration

### 1. Define Your Contexts

Create `contexts.json`:
```json
{
  "business": {
    "channels": ["telegram:-1003785842091"],
    "allowed_topics": ["revenue", "security", "platform", "deployment"],
    "forbidden_topics": ["personal", "social_media", "domains"]
  },
  "personal": {
    "channels": ["telegram:1594678363"],
    "allowed_topics": ["infrastructure", "domains", "personal", "social_media"]
  }
}
```

### 2. Add Heartbeat Integration

In your `HEARTBEAT.md`:
```markdown
## Context Separation Check
Run `./skills/context-separation/scripts/heartbeat-check.sh` before business updates
```

## Validation Rules

**Before posting, ask:**
- Is this ONLY about the target context?
- Am I mixing unrelated topics?
- Would stakeholders find this appropriate?

**When in doubt, use personal/general channel.**

## Advanced Features

### Learning System
Tracks violations to improve over time:
```bash
./scripts/log-violation.sh "mixed personal request in business update"
./scripts/review-violations.sh  # Shows patterns
```

### Multi-Client Support
```bash
# Client-specific contexts
./scripts/setup-context.sh "client-alpha" "slack:C123" "alpha-project,alpha-revenue"
./scripts/setup-context.sh "client-beta" "teams:456" "beta-deployment,beta-support"
```

## Benefits

- **Professional boundaries** maintained automatically
- **Stakeholder-appropriate** communication
- **Violation tracking** prevents repeat mistakes  
- **Multi-channel awareness** scales with complexity
- **Heartbeat integration** catches issues proactively

Perfect for business agents, multi-client operations, or any professional AI deployment.