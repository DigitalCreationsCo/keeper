#!/bin/bash

KEEPER_VERSION="{{VERSION}}"

# Exit early if a rebase is in progress (silent exit)
if git rev-parse --is-inside-work-tree >/dev/null 2>&1 && \
   ( [ -d ".git/rebase-merge" ] || [ -d ".git/rebase-apply" ] ); then
    exit 0
fi

# Exit if we're in the middle of a merge
if [ -f ".git/MERGE_HEAD" ]; then
    exit 0
fi

# Prevent recursive hook calls
if [ -n "$KEEPER_RUNNING" ]; then
    exit 0
fi
export KEEPER_RUNNING=1

KEEPER_DIR=".keeper"
KEEPER_README_FILE="$KEEPER_DIR/README.md"
TASK_FILE="$KEEPER_DIR/agent-task.md"
CONFIG_FILE="$KEEPER_DIR/config.json"
VERSION_CHECK_FILE="$KEEPER_DIR/.version_check"

keeper_update_check() {
    if [ ! -f "$VERSION_CHECK_FILE" ] || [ $(($(date +%s) - $(cat "$VERSION_CHECK_FILE" 2>/dev/null || echo 0))) -gt 604800 ]; then
        LATEST=$(curl -s https://api.github.com/repos/digitalcreationsco/keeper/releases/latest 2>/dev/null | grep -o '"tag_name": *"[^"]*"' | sed 's/"tag_name": *"v\?\([^"]*\)"/\1/' || echo "")
        echo $(date +%s) > "$VERSION_CHECK_FILE" 2>/dev/null
        
        if [ -n "$LATEST" ] && [ "$LATEST" != "$KEEPER_VERSION" ]; then
            echo ""
            echo "📦 Keeper v$LATEST is available (you have v$KEEPER_VERSION)"
            echo "Update: curl -fsSL https://github.com/digitalcreationsco/keeper/releases/latest/download/install.sh | bash"
            echo ""
        fi
    fi
}

keeper_update_check &&

if [ -f "$CONFIG_FILE" ]; then
    TRIGGER_MODE=$(jq -r ".trigger_mode // \"interactive\"" "$CONFIG_FILE")
    AUTO_COMMIT=$(jq -r ".auto_commit // false" "$CONFIG_FILE")
    AGENT_NAME=$(jq -r ".agent // \"cline\"" "$CONFIG_FILE")
    AGENT_COMMAND_OVERRIDE=$(jq -r ".agent_command // \"\"" "$CONFIG_FILE")
    DEBUG_MODE=$(jq -r ".debug // false" "$CONFIG_FILE")

    if [ "$DEBUG_MODE" = "true" ]; then 
        echo "DEBUG: CONFIG_FILE path is $CONFIG_FILE"
        echo "DEBUG: Does config.json exist? $([ -f \"$CONFIG_FILE\" ] && echo \"yes\" || echo \"no\")"
        echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT"
        echo "DEBUG: TRIGGER_MODE is $TRIGGER_MODE"
    fi
    
    FILES_TO_UPDATE=()
    while IFS= read -r line; do
        FILES_TO_UPDATE+=("$line")
    done < <(jq -r ".files_to_update[]" "$CONFIG_FILE")

    EXCLUDE_PATTERNS=()
    while IFS= read -r line; do
        EXCLUDE_PATTERNS+=("$line")
    done < <(jq -r ".exclude[]" "$CONFIG_FILE")
else
    TRIGGER_MODE="interactive"
    AUTO_COMMIT="false"
    AGENT_NAME="cline"
    AGENT_COMMAND_OVERRIDE=""
    DEBUG_MODE="false"
    FILES_TO_UPDATE=("README.md" "docs/")
    EXCLUDE_PATTERNS=(".keeper/*" "keeper/*")
fi

# Use git show to safely get the diff from the last commit
ALL_CHANGED_FILES=($(git diff-tree --no-commit-id --name-only -r HEAD))

FILES_TO_PROCESS=()
for file in "${ALL_CHANGED_FILES[@]}"; do
    is_excluded=false
    
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        if [ -z "$pattern" ]; then
            continue
        fi

        case "$file" in
            $pattern)
                is_excluded=true
                break
                ;;
        esac
    done
    
    if [ "$is_excluded" = false ]; then
        FILES_TO_PROCESS+=("$file")
    fi
done

if [ ${#FILES_TO_PROCESS[@]} -eq 0 ]; then
    if [ "$DEBUG_MODE" = "true" ]; then
        echo "Keeper: All changed files are in the exclude list. Skipping."
    fi
    exit 0
fi

echo "📝 Keeper: Processing the following files:"
for file in "${FILES_TO_PROCESS[@]}"; do
    echo "  - $file"
done

# Use git show to get the diff safely
DIFF=$(git diff-tree --no-commit-id -p -r HEAD -- "${FILES_TO_PROCESS[@]}")
if [ -z "$DIFF" ]; then
    exit 0
fi

# Set commit instruction based on auto_commit setting
if [ "$AUTO_COMMIT" = "true" ]; then
    COMMIT_INSTRUCTION="After updating the documentation, commit your changes:
\`\`\`bash
git add .
git commit -m \"docs: update documentation\"
\`\`\`"
else
    COMMIT_INSTRUCTION="After updating the documentation, save your changes. Do not commit them - the user will review and commit manually."
fi

if [ "$DEBUG_MODE" = "true" ]; then
    echo "DEBUG: DIFF length is ${#DIFF}"
    echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION"
fi

cat > "$TASK_FILE" << TASK_EOF
# 🤖 Keeper Agent Task

## Mission
Update documentation files to reflect recent code changes.

## Documentation Files to Update
$(for f in "${FILES_TO_UPDATE[@]}"; do echo "- $f"; done)

## Instructions
1. Read the code changes below carefully
2. Update the documentation files listed above to reflect:
   - New features or functions added
   - Modified APIs or interfaces  
   - Changed dependencies or requirements
   - Updated installation or usage instructions
3. Maintain the existing tone and structure of the documentation
4. Be concise but complete

## Changed Files
\`\`\`
$(printf '%s\n' "${FILES_TO_PROCESS[@]}")
\`\`\`

## Code Changes
\`\`\`diff
$DIFF
\`\`\`

---

## Next Steps
$COMMIT_INSTRUCTION
TASK_EOF

if [ "$TRIGGER_MODE" = "interactive" ]; then
    echo ""
    echo "✨ Keeper: Task created"
    echo "📂 $TASK_FILE"
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
    echo "💡 Want to run Keeper in autonomous mode?"
    echo "   Change trigger_mode to 'auto' in .keeper/config.json"
    echo ""
    echo "📖 Read $KEEPER_README_FILE for more information"
    echo ""
    exit 0
fi

if [ "$TRIGGER_MODE" = "auto" ]; then
    AGENT_COMMAND=""
    
    if [ -n "$AGENT_COMMAND_OVERRIDE" ]; then
        AGENT_COMMAND="$AGENT_COMMAND_OVERRIDE"
    else
        case "$AGENT_NAME" in
            "cline")
                AGENT_COMMAND="cline --yolo -m \"Read and complete the task in $TASK_FILE\""
                ;;
            "aider")
                AGENT_COMMAND="aider --yes --message \"Read and complete the task in $TASK_FILE\""
                ;;
            "claude")
                AGENT_COMMAND="claude --message \"Read and complete the task in $TASK_FILE\""
                ;;
            *)
                echo "Keeper: Unknown agent '$AGENT_NAME'. Please configure 'agent_command' in your config.json."
                exit 1
                ;;
        esac
    fi

    echo ""
    echo "🤖 Keeper is calling the AI agent '$AGENT_NAME'. Please wait..."
    echo ""
    
    if [ "$DEBUG_MODE" = "true" ]; then
        echo "DEBUG: Running command: $AGENT_COMMAND"
    fi
    
    # Run agent command
    eval "$AGENT_COMMAND"
    
    echo ""
    echo "✅ Agent execution complete"
    echo ""
    
    exit 0
fi