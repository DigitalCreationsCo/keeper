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
CONFIG_BACKUP="$KEEPER_DIR/config.json.backup"
KEEPER_README_FILE="$KEEPER_DIR/README.md"

# Backup existing config if it exists
if [ -f "$CONFIG_FILE" ]; then
    echo "💾 Backing up existing configuration..."
    cp "$CONFIG_FILE" "$CONFIG_BACKUP"
fi

echo "⬇️  Downloading files..."

# Download hook.sh from release
curl -fsSL "https://github.com/digitalcreationsco/keeper/releases/download/v$KEEPER_VERSION/hook.sh" -o .keeper/hook.sh
chmod +x .keeper/hook.sh

# Create or merge config.json
if [ -f "$CONFIG_BACKUP" ]; then
    echo "🔄 Merging existing configuration..."
    
    # Extract existing values
    EXISTING_TRIGGER_MODE=$(jq -r ".trigger_mode // \"interactive\"" "$CONFIG_BACKUP")
    EXISTING_AUTO_COMMIT=$(jq -r ".auto_commit // false" "$CONFIG_BACKUP")
    EXISTING_AGENT=$(jq -r ".agent // \"cline\"" "$CONFIG_BACKUP")
    EXISTING_AGENT_COMMAND=$(jq -r ".agent_command // \"\"" "$CONFIG_BACKUP")
    EXISTING_DEBUG=$(jq -r ".debug // false" "$CONFIG_BACKUP")
    
    # Create new config with existing values
    cat > "$CONFIG_FILE" << CONFIG_EOF
{
  "trigger_mode": "$EXISTING_TRIGGER_MODE",
  "auto_commit": $EXISTING_AUTO_COMMIT,
  "debug": $EXISTING_DEBUG,
  "agent": "$EXISTING_AGENT",
  "agent_command": "$EXISTING_AGENT_COMMAND",
  "files_to_update": $(jq -c ".files_to_update // [\"README.md\", \"docs/\"]" "$CONFIG_BACKUP"),
  "exclude": $(jq -c ".exclude // [\".keeper/*\", \"*.lock\", \"package.json\"]" "$CONFIG_BACKUP")
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
if [ -f "$CONFIG_BACKUP" ]; then
    echo "💾 Your existing configuration has been preserved"
    echo ""
fi
echo "📖 Read .keeper/README.md for usage instructions"
echo ""
echo "🎉 Try it: Make a code change, commit it, and Keeper will help keep your docs updated!"
echo ""