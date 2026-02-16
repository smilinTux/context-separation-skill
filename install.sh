#!/bin/bash
# Context Separation Skill - Easy Install
# Usage: curl -sSL https://raw.githubusercontent.com/[repo]/install.sh | bash

SKILL_NAME="context-separation"
INSTALL_DIR="${HOME}/clawd/skills/${SKILL_NAME}"

echo "🎯 Installing Context Separation Skill..."

# Create skills directory if it doesn't exist
mkdir -p "${HOME}/clawd/skills"

# Clone or download the skill
if command -v git &> /dev/null; then
    echo "📥 Cloning from GitHub..."
    git clone "https://github.com/smilinTux/context-separation-skill.git" "$INSTALL_DIR" 2>/dev/null || {
        echo "⚠️  Git clone failed, trying direct download..."
        # Fallback to direct download if needed
    }
else
    echo "⚠️  Git not found, please download manually"
    echo "   Visit: https://github.com/smilinTux/context-separation-skill"
    exit 1
fi

# Make scripts executable
chmod +x "${INSTALL_DIR}/scripts"/*.sh

echo "✅ Context Separation Skill installed!"
echo ""
echo "🚀 Quick Start:"
echo "   cd $INSTALL_DIR"
echo "   ./scripts/setup-context.sh 'business' 'your-channel-id' 'revenue,security'"
echo "   ./scripts/check-context.sh --message 'test message' --context 'business'"
echo ""
echo "📚 Read SKILL.md for full documentation"
echo "🎯 Professional context management activated!"