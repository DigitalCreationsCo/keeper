#!/bin/bash
# Keeper Installer
# Usage: curl -fsSL https://keeper.dev/install.sh | bash

set -e

echo "📚 Installing Keeper..."

if [ ! -d ".git" ]; then
    echo "❌ Error: Not a git repository. Please run from your project root."
    exit 1
fi

# Create .keeper directory
mkdir -p .keeper

# Define file paths
KEEPER_DIR=".keeper"
CONFIG_FILE="$KEEPER_DIR/config.json"
KEEPER_README_FILE="$KEEPER_DIR/README.md"

# Download core files
echo "⬇️  Downloading files..."

cat > .keeper/hook.sh << 'HOOK_EOF'
#!/bin/bash
# Keeper Git Hook

KEEPER_DIR=".keeper"
KEEPER_README_FILE="$KEEPER_DIR/README.md"
TASK_FILE="$KEEPER_DIR/agent-task.md"
CONFIG_FILE="$KEEPER_DIR/config.json"
TEMPLATE_FILE="$KEEPER_DIR/prompt-template.md"

if [ -f "$CONFIG_FILE" ]; then
    TRIGGER_MODE=$(jq -r '.trigger_mode // "auto"' "$CONFIG_FILE")
    AUTO_COMMIT=$(jq -r '.auto_commit // true' "$CONFIG_FILE")
    
    FILES_TO_UPDATE=()
    while IFS= read -r line; do
        FILES_TO_UPDATE+=("$line")
    done < <(jq -r '.files_to_update[]' "$CONFIG_FILE")

    EXCLUDE_PATTERNS=()
    while IFS= read -r line; do
        EXCLUDE_PATTERNS+=("$line")
    done < <(jq -r '.exclude[]' "$CONFIG_FILE")
else
    TRIGGER_MODE="auto"
    AUTO_COMMIT="true"
    FILES_TO_UPDATE=("README.md" "docs/")
    EXCLUDE_PATTERNS=(".keeper/*" "keeper/*")
fi

CHANGED_FILES_LIST=($(git diff HEAD~1 HEAD --name-only))

FILES_TO_PROCESS=()
for file in "${CHANGED_FILES_LIST[@]}"; do
    is_excluded=false
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        if [[ "$file" == $pattern ]]; then
            is_excluded=true
            break
        fi
    done
    if [ "$is_excluded" = false ]; then
        FILES_TO_PROCESS+=("$file")
    fi
done

if [ ${#FILES_TO_PROCESS[@]} -eq 0 ]; then
    echo " Keeper: All changed files are in the exclude list. Skipping."
    exit 0
fi

echo " Keeper: Processing files:"
for file in "${FILES_TO_PROCESS[@]}"; do
    echo "- $file"
done

DIFF=$(git diff HEAD~1 HEAD -- "${FILES_TO_PROCESS[@]}")
if [ -z "$DIFF" ]; then
    exit 0
fi

if [ "$AUTO_COMMIT" = "true" ]; then
    COMMIT_INSTRUCTION="After completing this task, run: git add . && git commit -m \"docs: update documentation\""
else
    COMMIT_INSTRUCTION="The documentation files have been updated. Please review and commit them."
fi

PROMPT_TEMPLATE=$(cat "$TEMPLATE_FILE")
TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s/{{COMMIT_INSTRUCTION}}/$COMMIT_INSTRUCTION/g")
TASK_CONTENT=$(echo "$TASK_CONTENT" | sed "s|{{FILES_TO_UPDATE}}|${FILES_TO_UPDATE[*]}|g")

# Generate agent task
echo "$TASK_CONTENT" > "$TASK_FILE"

# Append dynamic content to the task file
echo "" >> "$TASK_FILE"
echo "## Changed Files" >> "$TASK_FILE"
echo "\`\`\`" >> "$TASK_FILE"
echo "${CHANGED_FILES_LIST[*]}" >> "$TASK_FILE"
echo "\`\`\`" >> "$TASK_FILE"
echo "" >> "$TASK_FILE"
echo "## Code Changes:" >> "$TASK_FILE"
echo "\`\`\`diff" >> "$TASK_FILE"
echo "$DIFF" >> "$TASK_FILE"
echo "\`\`\`" >> "$TASK_FILE"

chmod +x $TASK_FILE

if [ "$TRIGGER_MODE" = "interactive" ]; then
    echo ""
    echo " Keeper has prepared a documentation update task"
    echo ""
    echo "📂: $TASK_FILE"
    echo ""
    echo "Please ask your coding agent (Claude Code, Copilot, Cline, etc.):"
    echo "  'Read and complete the task in $TASK_FILE'"
    echo ""
    echo "After the agent responds, it will update your docs automatically."
    echo ""
    echo "Want to run Keeper in autonomous mode? Change $CONFIG_FILE.trigger_mode to 'auto'."
    echo "Read $KEEPER_README_FILE for usage instructions"
    exit 0
fi

if [ "$TRIGGER_MODE" = "auto" ]; then
    echo ""
    echo " Keeper is calling the AI agent. Please wait, this may take a few moments..."
    echo ""
    cat "$TASK_FILE" | cline --yolo
    echo ""

    # Check the agent's commit and report
    CHANGED_FILES_BY_AGENT=$(git diff HEAD~1 HEAD --name-only | wc -l)
    
    if [ "$CHANGED_FILES_BY_AGENT" -gt 0 ]; then
        echo " Keeper updated $CHANGED_FILES_BY_AGENT documentation file(s)"
    fi
    exit 0
fi
HOOK_EOF

cat > "$CONFIG_FILE" << 'CONFIG_EOF'
{
  "trigger_mode": "auto",
  "auto_commit": false,
  "files_to_update": [
    "README.md",
    "docs/"
  ],
  "exclude": [
    ".keeper/*",
    "keeper/*",
    "*.lock",
    "package.json"
  ]
}
CONFIG_EOF

cat > .keeper/prompt-template.md << 'TEMPLATE_EOF'
# 🤖 Keeper Agent Task

## Task
Update the following documentation files to reflect recent code changes:
{{FILES_TO_UPDATE}}

## Scope of Work
You are strictly limited to the following actions:
1.  **Update Documentation**: Modify the documentation files to accurately reflect the code changes.
2.  **Follow Commit Instructions**: Adhere to the commit instruction provided at the end of this task.

**IMPORTANT**: Do not perform any other actions. Do not diagnose issues, suggest other code changes, or try to fix anything that is not directly related to the documentation update. If no documentation updates are needed, simply complete the task without making any changes.

## Instructions
1. Analyze the code changes below
2. Update the documentation to reflect:
   - New features or functions added
   - Modified APIs or interfaces
   - Changed dependencies or requirements
   - Updated installation or usage instructions
3. Maintain the existing tone and structure
4. Be concise but complete
5. {{COMMIT_INSTRUCTION}}

---

TEMPLATE_EOF

cat > "$KEEPER_README_FILE" << 'README_EOF'
# Keeper

Agent-powered documentation that stays in sync with your code.

## Configuration

Edit `$CONFIG_FILE` to customize:

- `trigger_mode`: "auto" (notify only) or "auto" (call agent)
- `auto_commit`: Auto-commit doc changes
- `files_to_update`: Which docs to maintain
- `exclude`: A list of file patterns to ignore.

## Usage

After committing code, Keeper creates a task file. Ask your agent to read and complete the task in `.keeper/agent-task.md`.
README_EOF

chmod +x .keeper/hook.sh

# Install git hook
echo "🔗 Installing git hook..."
cat > .git/hooks/post-commit << 'HOOK_CALLER_EOF'
#!/bin/bash
.keeper/hook.sh
HOOK_CALLER_EOF

chmod +x .git/hooks/post-commit

echo "✅ Success!"
echo ""
echo "📖 Read $KEEPER_README_FILE for usage instructions"
echo ""
echo "🎉 Try it: Make a code change, commit it, and Keeper will help keep your README and docs updated!"
echo ""
