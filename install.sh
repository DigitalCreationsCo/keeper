#!/bin/bash
set -e

KEEPER_VERSION="{{VERSION}}"

echo "📚 Installing Keeper v$KEEPER_VERSION..."

if [ ! -d ".git" ]; then
    echo "❌ Error: Not a git repository. Please run from your project root."
    exit 1
fi

mkdir -p .keeper

KEEPER_DIR=".keeper"
CONFIG_FILE="$KEEPER_DIR/config.json"
KEEPER_README_FILE="$KEEPER_DIR/README.md"

# Clean up obsolete files from previous versions
echo "🧹 Cleaning up old files..."
rm -f "$KEEPER_DIR/prompt-template.md"
rm -f "$KEEPER_DIR/config.json.backup"
rm -f "$KEEPER_DIR/.keeper.lock"

# Backup existing config in memory only (don't write to disk)
if [ -f "$CONFIG_FILE" ]; then
    echo "💾 Preserving existing configuration..."
    EXISTING_CONFIG=$(cat "$CONFIG_FILE")
else
    EXISTING_CONFIG=""
fi

echo "⬇️  Downloading files..."

# Download hook.sh from release
curl -fsSL "https://github.com/digitalcreationsco/keeper/releases/download/v$KEEPER_VERSION/hook.sh" -o .keeper/hook.sh
chmod +x .keeper/hook.sh

# Create or merge config.json
if [ -n "$EXISTING_CONFIG" ]; then
    echo "🔄 Merging existing configuration..."
    
    # Extract existing values from memory
    EXISTING_TRIGGER_MODE=$(echo "$EXISTING_CONFIG" | jq -r ".trigger_mode // \"interactive\"")
    EXISTING_AUTO_COMMIT=$(echo "$EXISTING_CONFIG" | jq -r ".auto_commit // false")
    EXISTING_AGENT=$(echo "$EXISTING_CONFIG" | jq -r ".agent // \"\"")
    EXISTING_AGENT_COMMAND=$(echo "$EXISTING_CONFIG" | jq -r ".agent_command // \"\"")
    EXISTING_DEBUG=$(echo "$EXISTING_CONFIG" | jq -r ".debug // false")
    
    # Create new config with existing values
    cat > "$CONFIG_FILE" << CONFIG_EOF
{
  "trigger_mode": "$EXISTING_TRIGGER_MODE",
  "auto_commit": $EXISTING_AUTO_COMMIT,
  "debug": $EXISTING_DEBUG,
  "agent": "$EXISTING_AGENT",
  "agent_command": "$EXISTING_AGENT_COMMAND",
  "files_to_update": $(echo "$EXISTING_CONFIG" | jq -c ".files_to_update // [\"README.md\", \"docs/\"]"),
  "exclude": $(echo "$EXISTING_CONFIG" | jq -c ".exclude // [\".keeper/*\", \"*.lock\", \"package.json\"]")
}
CONFIG_EOF
    
    echo "✅ Configuration merged successfully"
else
    echo "📝 Creating default configuration..."
    curl -fsSL "https://github.com/digitalcreationsco/keeper/releases/download/v$KEEPER_VERSION/config.json" -o "$CONFIG_FILE"
fi

# Download README
curl -fsSL "https://github.com/digitalcreationsco/keeper/releases/download/v$KEEPER_VERSION/README.md" -o "$KEEPER_README_FILE"

echo "🔗 Installing git hook..."
cat > .git/hooks/post-commit << 'HOOK_CALLER_EOF'
#!/bin/bash
.keeper/hook.sh
HOOK_CALLER_EOF

chmod +x .git/hooks/post-commit

echo ""
echo "✅ Keeper v$KEEPER_VERSION installed successfully!"
echo ""
if [ -n "$EXISTING_CONFIG" ]; then
    echo "💾 Your existing configuration has been preserved"
    echo ""
fi
echo "📖 Read .keeper/README.md for usage instructions"
echo ""
echo "🎉 Try it: Make a code change, commit it, and Keeper will help keep your docs updated!"
echo ""