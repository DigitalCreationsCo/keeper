#!/bin/bash

KEEPER_DIR=".keeper"
KEEPER_README_FILE="$KEEPER_DIR/README.md"
TASK_FILE="$KEEPER_DIR/agent-task.md"
CONFIG_FILE="$KEEPER_DIR/config.json"
TEMPLATE_FILE="$KEEPER_DIR/prompt-template.md"

if [ -f "$CONFIG_FILE" ]; then
    TRIGGER_MODE=$(jq -r ".trigger_mode // \"auto\"" "$CONFIG_FILE")
    AUTO_COMMIT=$(jq -r ".auto_commit // true" "$CONFIG_FILE")
    AGENT_NAME=$(jq -r ".agent // \"cline\"" "$CONFIG_FILE")
    AGENT_COMMAND_OVERRIDE=$(jq -r ".agent_command // \"\"" "$CONFIG_FILE")
    DEBUG_MODE=$(jq -r ".debug // false" "$CONFIG_FILE")

    if [ "$DEBUG_MODE" = "true" ]; then 
        echo "DEBUG: CONFIG_FILE path is $CONFIG_FILE"
        echo "DEBUG: Does config.json exist? $([ -f "$CONFIG_FILE" ] && echo "yes" || echo "no")"
        echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT"
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
    TRIGGER_MODE="auto"
    AUTO_COMMIT="true"
    AGENT_NAME="cline"
    AGENT_COMMAND_OVERRIDE=""
    DEBUG_MODE="false"
    FILES_TO_UPDATE=("README.md" "docs/")
    EXCLUDE_PATTERNS=(".keeper/*" "keeper/*")
fi

ALL_CHANGED_FILES=($(git diff HEAD~1 HEAD --name-only))

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
    echo "Keeper: All changed files are in the exclude list. Skipping."
    exit 0
fi

echo "Keeper: Processing the following files:"
sleep 1
for file in "${FILES_TO_PROCESS[@]}"; do
    echo "  - $file"
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

if [ "$DEBUG_MODE" = "true" ]; then
    echo "DEBUG: PROMPT_TEMPLATE content starts here:"
    cat "$TEMPLATE_FILE"
    echo "DEBUG: PROMPT_TEMPLATE content ends here."
    echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION"
fi

PROMPT_TEMPLATE=$(cat "$TEMPLATE_FILE")
TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s|{{COMMIT_INSTRUCTION}}|$COMMIT_INSTRUCTION|g")
TASK_CONTENT=$(echo "$TASK_CONTENT" | sed "s|{{FILES_TO_UPDATE}}|${FILES_TO_UPDATE[*]}|g")

echo "$TASK_CONTENT" > "$TASK_FILE"
echo "" >> "$TASK_FILE"
echo "## Changed Files" >> "$TASK_FILE"
echo "\`\`\`" >> "$TASK_FILE"
printf '%s\n' "${FILES_TO_PROCESS[@]}" >> "$TASK_FILE"
echo "\`\`\`" >> "$TASK_FILE"
echo "" >> "$TASK_FILE"
echo "## Code Changes" >> "$TASK_FILE"
echo "\`\`\`diff" >> "$TASK_FILE"
echo "$DIFF" >> "$TASK_FILE"
echo "\`\`\`" >> "$TASK_FILE"

if [ "$TRIGGER_MODE" = "interactive" ]; then
    echo ""
    echo " Keeper: Task created"
    echo "📂: $TASK_FILE"
    sleep 1
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

    FINAL_COMMAND=$(echo "$AGENT_COMMAND" | sed "s|{{TASK_FILE}}|$TASK_FILE|g")

    echo ""
    echo "🤖 Keeper is calling the AI agent '$AGENT_NAME'. Please wait..."
    echo ""
    eval "$FINAL_COMMAND"
    echo ""

    if [ "$AUTO_COMMIT" = "true" ]; then
        AGENT_CHANGED_FILES=($(git diff --name-only))
        CHANGED_FILES_BY_AGENT=${#AGENT_CHANGED_FILES[@]}

        if [ "$CHANGED_FILES_BY_AGENT" -gt 0 ]; then
            echo "✅ Keeper updated the following file(s):"
            for file in "${AGENT_CHANGED_FILES[@]}"; do
                echo "  - $file"
            done
            echo ""

            echo "📝 Documentation Changes:"
            for file in "${AGENT_CHANGED_FILES[@]}"; do
                echo "### Diff for $file"
                echo "\`\`\`diff"
                git diff -- "$file"
                echo "\`\`\`"
                echo ""
            done
        fi
    fi
    exit 0
fi
