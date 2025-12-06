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
    AGENT_NAME=$(jq -r '.agent // "cline"' "$CONFIG_FILE")
    AGENT_COMMAND_OVERRIDE=$(jq -r '.agent_command // ""' "$CONFIG_FILE")

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
    AGENT_NAME="cline"
    AGENT_COMMAND_OVERRIDE=""
    FILES_TO_UPDATE=("README.md" "docs/")
    EXCLUDE_PATTERNS=(".keeper/*" "keeper/*")
fi

# Get the full list of changed files
ALL_CHANGED_FILES=($(git diff HEAD~1 HEAD --name-only))

# Filter out excluded files
FILES_TO_PROCESS=()
for file in "${ALL_CHANGED_FILES[@]}"; do
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

# If no files are left to process, exit
if [ ${#FILES_TO_PROCESS[@]} -eq 0 ]; then
    echo "Keeper: All changed files are in the exclude list. Skipping."
    exit 0
fi

echo "Keeper: Processing the following files:"
for file in "${FILES_TO_PROCESS[@]}"; do
    echo "- $file"
done

# Get a diff of only the files to be processed
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

echo "$TASK_CONTENT" > "$TASK_FILE"

echo "" >> "$TASK_FILE"
echo "## Changed Files" >> "$TASK_FILE"
echo "\`\`\`" >> "$TASK_FILE"
echo "${FILES_TO_PROCESS[*]}" >> "$TASK_FILE"
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
    echo "📂: $TASK_FILE"
    echo ""
    echo "Call your agent as follows:"
    echo ""
    case "$AGENT_NAME" in
        "cline")
            echo "  cline -m act 'Read and complete the task in $TASK_FILE'"
            ;;
        "aider")
            echo "  aider 'Read and complete the task in $TASK_FILE'"
            ;;
        "claude")
            echo "  claude 'Read and complete the task in $TASK_FILE'"
            ;;
        *)
            echo "  Please ask your coding agent to read and complete the task in $TASK_FILE"
            ;;
    esac
    echo ""
    echo "After the agent responds, it will update your docs automatically."
    echo ""
    echo "Want to run Keeper in autonomous mode? Change $CONFIG_FILE.trigger_mode to 'auto'."
    echo "Read $KEEPER_README_FILE for usage instructions"
    exit 0
fi

if [ "$TRIGGER_MODE" = "auto" ]; then
    AGENT_COMMAND=""
    if [ -n "$AGENT_COMMAND_OVERRIDE" ]; then
        AGENT_COMMAND="$AGENT_COMMAND_OVERRIDE"
    else
        case "$AGENT_NAME" in
            "cline")
                AGENT_COMMAND="cat {{TASK_FILE}} | cline --yolo"
                ;;
            "aider")
                AGENT_COMMAND="aider {{TASK_FILE}}"
                ;;
            "claude")
                AGENT_COMMAND="claude {{TASK_FILE}}"
                ;;
            *)
                echo "Keeper: Unknown agent '$AGENT_NAME'. Please configure 'agent_command' in your config.json."
                exit 1
                ;;
        esac
    fi

    FINAL_COMMAND=$(echo "$AGENT_COMMAND" | sed "s/{{TASK_FILE}}/$TASK_FILE/g")

    echo ""
    echo " Keeper is calling the AI agent '$AGENT_NAME'. Please wait, this may take a few moments..."
    echo ""
    eval "$FINAL_COMMAND"
    echo ""

    if [ "$AUTO_COMMIT" = "true" ]; then
        CHANGED_FILES_BY_AGENT=$(git diff HEAD~1 HEAD --name-only | wc -l)
        if [ "$CHANGED_FILES_BY_AGENT" -gt 0 ]; then
            echo " Keeper updated $CHANGED_FILES_BY_AGENT documentation file(s)"
        fi
    fi
    exit 0
fi
HOOK_EOF

cat > "$CONFIG_FILE" << 'CONFIG_EOF'
{
  "trigger_mode": "interactive",
  "auto_commit": false,
  "agent": "cline",
  "agent_command": "",
  "files_to_update": [
    "README.md",
    "docs/"
  ],
  "exclude": [
    ".keeper/*",
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
- `trigger_mode`: "auto" or "interactive".
- `auto_commit`: `true` or `false`.
- `agent`: The name of your preferred coding agent. Supported agents: `cline`, `aider`, `claude`.
- `agent_command` (optional): Provide a custom command to run your agent. Use `{{TASK_FILE}}` as a placeholder for the task file path.
- `files_to_update`: A list of documentation files and directories to keep updated.
- `exclude`: A list of file patterns to ignore.

## Usage

After committing code, Keeper creates a task file and (in `auto` mode) calls your configured AI agent.
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
