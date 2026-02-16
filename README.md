# 🎯 Context Separation Skill

[![OpenClaw Skill](https://img.shields.io/badge/OpenClaw-Skill-blue)](https://openclaw.ai)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-green)](https://github.com/smilinTux/context-separation-skill/releases)

**Professional context management for AI agents working across multiple channels and stakeholder groups.**

## 🚨 Problem Solved

Stop embarrassing context violations like:
- ❌ "Please claim my Moltbook account" in business trustee updates
- ❌ Personal social media requests in client reports  
- ❌ Infrastructure issues mixed with revenue discussions
- ❌ Multi-topic messages that confuse stakeholders

## ✅ Solution

**Automatic validation system** that checks message appropriateness before posting:

```bash
# Setup your contexts
./scripts/setup-context.sh "business" "telegram:group123" "revenue,security,platform"

# Validate before posting
./scripts/check-context.sh --message "Platform revenue up 15%" --context "business"
# ✅ Message appropriate for 'business' context

./scripts/check-context.sh --message "Claim my social account" --context "business"  
# ❌ VIOLATION: Personal request in business context
```

## 🚀 Quick Install

```bash
# Clone to your OpenClaw skills directory
cd ~/clawd/skills/
git clone https://github.com/smilinTux/context-separation-skill.git context-separation
cd context-separation

# Setup your first context
./scripts/setup-context.sh "business" "your-channel-id" "revenue,security,platform"

# Add to heartbeat (optional but recommended)
echo './skills/context-separation/scripts/heartbeat-check.sh' >> ../../HEARTBEAT.md
```

## 📋 Features

- ✅ **Multi-channel support** (Telegram, Discord, Slack)
- ✅ **Automatic validation** prevents violations before posting
- ✅ **Learning system** tracks patterns and improvements  
- ✅ **Heartbeat integration** for proactive rule checking
- ✅ **Professional boundaries** maintained automatically
- ✅ **Stakeholder-appropriate** communication enforced

## 🎯 Perfect For

- **Business agents** managing client relationships
- **Multi-tenant deployments** serving different organizations  
- **Professional AI assistants** with work/life boundaries
- **Corporate deployments** requiring communication standards
- **Any agent** working across multiple stakeholder groups

## 📖 Usage

### Setup Contexts

```bash
# Business context  
./scripts/setup-context.sh "business" "telegram:-1003785842091" "revenue,security,platform"

# Personal context
./scripts/setup-context.sh "personal" "telegram:1594678363" "infrastructure,domains,social_media"

# Client-specific context
./scripts/setup-context.sh "client-alpha" "slack:C123456" "alpha-project,alpha-revenue"
```

### Validate Messages

```bash
# Check if a message is appropriate for a context
./scripts/check-context.sh --message "Revenue is up 15% this quarter" --context "business"

# Log violations for learning
./scripts/log-violation.sh "mixed personal request in business update"

# Review violation patterns
./scripts/review-violations.sh
```

### Heartbeat Integration

Add to your `HEARTBEAT.md`:
```bash
./skills/context-separation/scripts/heartbeat-check.sh
```

## 🔧 Configuration

The skill creates a `contexts.json` file with your defined contexts:

```json
{
  "business": {
    "channels": ["telegram:-1003785842091"],
    "allowed_topics": ["revenue", "security", "platform", "deployment"],
    "created": "2026-02-16T05:05:39Z"
  },
  "personal": {
    "channels": ["telegram:1594678363"], 
    "allowed_topics": ["infrastructure", "domains", "personal", "social_media"]
  }
}
```

## 📚 Documentation

- [`SKILL.md`](SKILL.md) - Complete skill documentation
- [`references/common-contexts.md`](references/common-contexts.md) - Context pattern examples
- [Installation Guide](install.sh) - Automated setup script

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌟 Support

- ⭐ **Star this repo** if it helps your AI agent stay professional!
- 🐛 **Report issues** on GitHub Issues
- 💡 **Feature requests** welcome via Issues
- 🤝 **Contributions** encouraged via Pull Requests

## 🏷️ Tags

`openclaw` `ai-agent` `context-management` `professional-ai` `business-automation` `multi-channel` `communication` `skill` `validation`

---

**Created by [smilinTux](https://github.com/smilinTux) for the OpenClaw community** 🐧✨

*Making AI agents more professional, one context at a time.*