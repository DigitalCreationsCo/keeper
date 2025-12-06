#!/bin/bash
# Keeper Git Hook

KEEPER_DIR=".keeper"
KEEPER_README_FILE=".keeper/README.md"
TASK_FILE=".keeper/agent-task.md"
CONFIG_FILE=".keeper/config.json"
TEMPLATE_FILE=".keeper/prompt-template.md"

if [ -f ".keeper/config.json" ]; then
    TRIGGER_MODE=interactive
    AUTO_COMMIT=true
    AGENT_NAME=cline
    AGENT_COMMAND_OVERRIDE=
    DEBUG_MODE=false # ADDED

    if [ "" = "true" ]; then # ADDED
        echo "DEBUG: CONFIG_FILE path is .keeper/config.json"
        echo "DEBUG: Does config.json exist? yes"
        echo "DEBUG: AUTO_COMMIT is "
    fi # ADDED
    
    FILES_TO_UPDATE=()
    while IFS= read -r line; do
        FILES_TO_UPDATE+=("")
    done < <(jq -r ".files_to_update[]" ".keeper/config.json")

    EXCLUDE_PATTERNS=()
    while IFS= read -r line; do
        EXCLUDE_PATTERNS+=("")
    done < <(jq -r ".exclude[]" ".keeper/config.json")
else
    TRIGGER_MODE="auto"
    AUTO_COMMIT="true"
    AGENT_NAME="cline"
    AGENT_COMMAND_OVERRIDE=""
    DEBUG_MODE="false"
    FILES_TO_UPDATE=("README.md" "docs/")
    EXCLUDE_PATTERNS=(".keeper/*" "keeper/*")
fi

# Get the full list of changed files
ALL_CHANGED_FILES=(.keeper/agent-task.md
.keeper/hook.sh
install.sh)

# Filter out excluded files
FILES_TO_PROCESS=()
for file in ""; do
    is_excluded=false
    for pattern in ""; do
        if [[ "" ==  ]]; then
            is_excluded=true
            break
        fi
    done
    if [ "" = false ]; then
        FILES_TO_PROCESS+=("")
    fi
done

# If no files are left to process, exit
if [ 0 -eq 0 ]; then
    echo "Keeper: All changed files are in the exclude list. Skipping."
    exit 0
fi

echo "Keeper: Processing the following files:"
sleep 1
for file in ""; do
    echo "- "
done

# Get a diff of only the files to be processed
DIFF=diff --git a/.keeper/agent-task.md b/.keeper/agent-task.md
index 2efd729..4a65d0e 100755
--- a/.keeper/agent-task.md
+++ b/.keeper/agent-task.md
@@ -32,15 +32,100 @@ install.sh
 ## Code Changes:
 ```diff
 diff --git a/install.sh b/install.sh
-index 8262c15..473d481 100755
+index 473d481..a3030e8 100755
 --- a/install.sh
 +++ b/install.sh
-@@ -2,7 +2,6 @@
+@@ -1,7 +1,7 @@
+ #!/bin/bash
  # Keeper Installer
  # Usage: curl -fsSL https://keeper.dev/install.sh | bash
- 
--# adding arbitrary comment for changes
+-
++# CHASNGE
  set -e
  
  echo "📚 Installing Keeper..."
+@@ -33,20 +33,21 @@ CONFIG_FILE="$KEEPER_DIR/config.json"
+ TEMPLATE_FILE="$KEEPER_DIR/prompt-template.md"
+ 
+ if [ -f "$CONFIG_FILE" ]; then
+-    TRIGGER_MODE=$(jq -r '.trigger_mode // "auto"' "$CONFIG_FILE")
+-    AUTO_COMMIT=$(jq -r '.auto_commit // true' "$CONFIG_FILE")
+-    AGENT_NAME=$(jq -r '.agent // "cline"' "$CONFIG_FILE")
+-    AGENT_COMMAND_OVERRIDE=$(jq -r '.agent_command // ""' "$CONFIG_FILE")
+-
++    TRIGGER_MODE=$(jq -r ".trigger_mode // \"auto\"" "$CONFIG_FILE")
++    AUTO_COMMIT=$(jq -r ".auto_commit // true" "$CONFIG_FILE")
++    AGENT_NAME=$(jq -r ".agent // \"cline\"" "$CONFIG_FILE")
++    AGENT_COMMAND_OVERRIDE=$(jq -r ".agent_command // \"\"" "$CONFIG_FILE")
++    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # ADDED DEBUG
++    
+     FILES_TO_UPDATE=()
+     while IFS= read -r line; do
+         FILES_TO_UPDATE+=("$line")
+-    done < <(jq -r '.files_to_update[]' "$CONFIG_FILE")
++    done < <(jq -r ".files_to_update[]" "$CONFIG_FILE")
+ 
+     EXCLUDE_PATTERNS=()
+     while IFS= read -r line; do
+         EXCLUDE_PATTERNS+=("$line")
+-    done < <(jq -r '.exclude[]' "$CONFIG_FILE")
++    done < <(jq -r ".exclude[]" "$CONFIG_FILE")
+ else
+     TRIGGER_MODE="auto"
+     AUTO_COMMIT="true"
+@@ -98,6 +99,10 @@ else
+     COMMIT_INSTRUCTION="The documentation files have been updated. Please review and commit them."
+ fi
+ 
++echo "DEBUG: PROMPT_TEMPLATE content starts here:" # ADDED DEBUG
++cat "$TEMPLATE_FILE" # ADDED DEBUG
++echo "DEBUG: PROMPT_TEMPLATE content ends here." # ADDED DEBUG
++echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # ADDED DEBUG
+ PROMPT_TEMPLATE=$(cat "$TEMPLATE_FILE")
+ TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s/{{COMMIT_INSTRUCTION}}/$COMMIT_INSTRUCTION/g")
+ TASK_CONTENT=$(echo "$TASK_CONTENT" | sed "s|{{FILES_TO_UPDATE}}|${FILES_TO_UPDATE[*]}|g")
+@@ -127,13 +132,13 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
+     echo ""
+     case "$AGENT_NAME" in
+         "cline")
+-            echo "  cline -m act 'Read and complete the task in $TASK_FILE'"
++            echo "  cline -m act \'Read and complete the task in $TASK_FILE\'"
+             ;;
+         "aider")
+-            echo "  aider 'Read and complete the task in $TASK_FILE'"
++            echo "  aider \'Read and complete the task in $TASK_FILE\'"
+             ;;
+         "claude")
+-            echo "  claude 'Read and complete the task in $TASK_FILE'"
++            echo "  claude \'Read and complete the task in $TASK_FILE\'"
+             ;;
+         *)
+             echo "  Please ask your coding agent to read and complete the task in $TASK_FILE"
+@@ -142,7 +147,7 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
+     echo ""
+     echo "After the agent responds, it will update your docs automatically."
+     echo ""
+-    echo "Want to run Keeper in autonomous mode? Change $CONFIG_FILE.trigger_mode to 'auto'."
++    echo "Want to run Keeper in autonomous mode? Change $CONFIG_FILE.trigger_mode to \'auto\'."
+     echo "Read $KEEPER_README_FILE for usage instructions"
+     exit 0
+ fi
+@@ -163,7 +168,7 @@ if [ "$TRIGGER_MODE" = "auto" ]; then
+                 AGENT_COMMAND="claude {{TASK_FILE}}"
+                 ;;
+             *)
+-                echo "Keeper: Unknown agent '$AGENT_NAME'. Please configure 'agent_command' in your config.json."
++                echo "Keeper: Unknown agent \'$AGENT_NAME\'. Please configure \'agent_command\' in your config.json."
+                 exit 1
+                 ;;
+         esac
+@@ -172,7 +177,7 @@ if [ "$TRIGGER_MODE" = "auto" ]; then
+     FINAL_COMMAND=$(echo "$AGENT_COMMAND" | sed "s|{{TASK_FILE}}|$TASK_FILE|g")
+ 
+     echo ""
+-    echo " Keeper is calling the AI agent '$AGENT_NAME'. Please wait, this may take a few moments..."
++    echo " Keeper is calling the AI agent \'$AGENT_NAME\'. Please wait, this may take a few moments..."
+     echo ""
+     eval "$FINAL_COMMAND"
+     echo ""
 ```
diff --git a/.keeper/hook.sh b/.keeper/hook.sh
index b735de9..2218ef1 100755
--- a/.keeper/hook.sh
+++ b/.keeper/hook.sh
@@ -7,12 +7,15 @@ TASK_FILE="$KEEPER_DIR/agent-task.md"
 CONFIG_FILE="$KEEPER_DIR/config.json"
 TEMPLATE_FILE="$KEEPER_DIR/prompt-template.md"
 
+echo "DEBUG: CONFIG_FILE path is $CONFIG_FILE" # ADDED DEBUG
+echo "DEBUG: Does config.json exist? $([ -f "$CONFIG_FILE" ] && echo "yes" || echo "no")" # ADDED DEBUG
+
 if [ -f "$CONFIG_FILE" ]; then
     TRIGGER_MODE=$(jq -r ".trigger_mode // \"auto\"" "$CONFIG_FILE")
     AUTO_COMMIT=$(jq -r ".auto_commit // true" "$CONFIG_FILE")
     AGENT_NAME=$(jq -r ".agent // \"cline\"" "$CONFIG_FILE")
     AGENT_COMMAND_OVERRIDE=$(jq -r ".agent_command // \"\"" "$CONFIG_FILE")
-    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # ADDED DEBUG
+    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # Existing DEBUG
     
     FILES_TO_UPDATE=()
     while IFS= read -r line; do
@@ -74,12 +77,12 @@ else
     COMMIT_INSTRUCTION="The documentation files have been updated. Please review and commit them."
 fi
 
-echo "DEBUG: PROMPT_TEMPLATE content starts here:" # ADDED DEBUG
-cat "$TEMPLATE_FILE" # ADDED DEBUG
-echo "DEBUG: PROMPT_TEMPLATE content ends here." # ADDED DEBUG
-echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # ADDED DEBUG
+echo "DEBUG: PROMPT_TEMPLATE content starts here:" # Existing DEBUG
+cat "$TEMPLATE_FILE" # Existing DEBUG
+echo "DEBUG: PROMPT_TEMPLATE content ends here." # Existing DEBUG
+echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # Existing DEBUG
 PROMPT_TEMPLATE=$(cat "$TEMPLATE_FILE")
-TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s/{{COMMIT_INSTRUCTION}}/$COMMIT_INSTRUCTION/g")
+TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s#{{COMMIT_INSTRUCTION}}#$COMMIT_INSTRUCTION#g") # CHANGED DELIMITER
 TASK_CONTENT=$(echo "$TASK_CONTENT" | sed "s|{{FILES_TO_UPDATE}}|${FILES_TO_UPDATE[*]}|g")
 
 echo "$TASK_CONTENT" > "$TASK_FILE"
@@ -107,13 +110,13 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
     echo ""
     case "$AGENT_NAME" in
         "cline")
-            echo "  cline -m act \'Read and complete the task in $TASK_FILE\'"
+            echo "  cline -m act \'Read and complete the task in $TASK_FILE\''"
             ;;
         "aider")
-            echo "  aider \'Read and complete the task in $TASK_FILE\'"
+            echo "  aider \'Read and complete the task in $TASK_FILE\''"
             ;;
         "claude")
-            echo "  claude \'Read and complete the task in $TASK_FILE\'"
+            echo "  claude \'Read and complete the task in $TASK_FILE\''"
             ;;
         *)
             echo "  Please ask your coding agent to read and complete the task in $TASK_FILE"
diff --git a/install.sh b/install.sh
index a3030e8..8038c15 100755
--- a/install.sh
+++ b/install.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # Keeper Installer
 # Usage: curl -fsSL https://keeper.dev/install.sh | bash
-# CHASNGE
+
 set -e
 
 echo "📚 Installing Keeper..."
@@ -32,12 +32,15 @@ TASK_FILE="$KEEPER_DIR/agent-task.md"
 CONFIG_FILE="$KEEPER_DIR/config.json"
 TEMPLATE_FILE="$KEEPER_DIR/prompt-template.md"
 
+echo "DEBUG: CONFIG_FILE path is $CONFIG_FILE" # ADDED DEBUG
+echo "DEBUG: Does config.json exist? $([ -f "$CONFIG_FILE" ] && echo "yes" || echo "no")" # ADDED DEBUG
+
 if [ -f "$CONFIG_FILE" ]; then
     TRIGGER_MODE=$(jq -r ".trigger_mode // \"auto\"" "$CONFIG_FILE")
     AUTO_COMMIT=$(jq -r ".auto_commit // true" "$CONFIG_FILE")
     AGENT_NAME=$(jq -r ".agent // \"cline\"" "$CONFIG_FILE")
     AGENT_COMMAND_OVERRIDE=$(jq -r ".agent_command // \"\"" "$CONFIG_FILE")
-    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # ADDED DEBUG
+    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # Existing DEBUG
     
     FILES_TO_UPDATE=()
     while IFS= read -r line; do
@@ -99,12 +102,12 @@ else
     COMMIT_INSTRUCTION="The documentation files have been updated. Please review and commit them."
 fi
 
-echo "DEBUG: PROMPT_TEMPLATE content starts here:" # ADDED DEBUG
-cat "$TEMPLATE_FILE" # ADDED DEBUG
-echo "DEBUG: PROMPT_TEMPLATE content ends here." # ADDED DEBUG
-echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # ADDED DEBUG
+echo "DEBUG: PROMPT_TEMPLATE content starts here:" # Existing DEBUG
+cat "$TEMPLATE_FILE" # Existing DEBUG
+echo "DEBUG: PROMPT_TEMPLATE content ends here." # Existing DEBUG
+echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # Existing DEBUG
 PROMPT_TEMPLATE=$(cat "$TEMPLATE_FILE")
-TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s/{{COMMIT_INSTRUCTION}}/$COMMIT_INSTRUCTION/g")
+TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s#{{COMMIT_INSTRUCTION}}#$COMMIT_INSTRUCTION#g") # CHANGED DELIMITER
 TASK_CONTENT=$(echo "$TASK_CONTENT" | sed "s|{{FILES_TO_UPDATE}}|${FILES_TO_UPDATE[*]}|g")
 
 echo "$TASK_CONTENT" > "$TASK_FILE"
@@ -132,13 +135,13 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
     echo ""
     case "$AGENT_NAME" in
         "cline")
-            echo "  cline -m act \'Read and complete the task in $TASK_FILE\'"
+            echo "  cline -m act \'Read and complete the task in $TASK_FILE\''"
             ;;
         "aider")
-            echo "  aider \'Read and complete the task in $TASK_FILE\'"
+            echo "  aider \'Read and complete the task in $TASK_FILE\''"
             ;;
         "claude")
-            echo "  claude \'Read and complete the task in $TASK_FILE\'"
+            echo "  claude \'Read and complete the task in $TASK_FILE\''"
             ;;
         *)
             echo "  Please ask your coding agent to read and complete the task in $TASK_FILE"
if [ -z "" ]; then
    exit 0
fi

if [ "" = "true" ]; then
    COMMIT_INSTRUCTION="After completing this task, run: git add . && git commit -m \"docs: update documentation\""
else
    COMMIT_INSTRUCTION="The documentation files have been updated. Please review and commit them."
fi

if [ "" = "true" ]; then # ADDED
    echo "DEBUG: PROMPT_TEMPLATE content starts here:"
    cat ""
    echo "DEBUG: PROMPT_TEMPLATE content ends here."
    echo "DEBUG: COMMIT_INSTRUCTION is "
fi # ADDED
PROMPT_TEMPLATE=
TASK_CONTENT= # CHANGED DELIMITER
TASK_CONTENT=

echo "" > ""

echo "" >> ""
echo "## Changed Files" >> ""
echo "```" >> ""
echo "" >> ""
echo "```" >> ""
echo "" >> ""
echo "## Code Changes:" >> ""
echo "```diff" >> ""
echo "" >> ""
echo "```" >> ""

chmod +x 

if [ "" = "interactive" ]; then
    echo ""
    echo " Keeper has prepared a documentation update task"
    echo "📂: "
    sleep 1
    echo ""
    echo "Call your agent as follows:"
    echo ""
    case "" in
        "cline")
            echo "  cline -m act \'Read and complete the task in \'"
            ;;
        "aider")
            echo "  aider \'Read and complete the task in \'"
            ;;
        "claude")
            echo "  claude \'Read and complete the task in \'"
            ;;
        *)
            echo "  Please ask your coding agent to read and complete the task in "
            ;;
    esac
    echo ""
    echo "After the agent responds, it will update your docs automatically."
    echo ""
    echo "Want to run Keeper in autonomous mode? Change .keeper/config.json.trigger_mode to \'auto\'."
    echo "Read .keeper/README.md for usage instructions"
    exit 0
fi

if [ "" = "auto" ]; then
    AGENT_COMMAND=""
    if [ -n "" ]; then
        AGENT_COMMAND=""
    else
        case "" in
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
                echo "Keeper: Unknown agent \'\'. Please configure \'agent_command\' in your config.json."
                exit 1
                ;;
        esac
    fi

    FINAL_COMMAND=

    echo ""
    echo " Keeper is calling the AI agent \'\'. Please wait, this may take a few moments..."
    echo ""
    eval ""
    echo ""

    if [ "" = "true" ]; then
        # Get files changed by the agent
        AGENT_CHANGED_FILES=(.keeper/agent-task.md
.keeper/hook.sh
install.sh)
        CHANGED_FILES_BY_AGENT=0

        if [ "" -gt 0 ]; then
            echo " Keeper updated the following documentation file(s):"
            for file in ""; do
                echo "  - "
            done
            echo ""

            echo "## Agent-Generated Documentation Changes:"
            for file in ""; do
                echo "### Diff for "
                echo "```diff"
                git diff HEAD~1 HEAD -- "" # Show diff for individual file
                echo "```"
                echo ""
            done
        fi
    fi
    exit 0
