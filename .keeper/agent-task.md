# 🤖 Keeper Agent Task

## Task
Update the following documentation files to reflect recent code changes:
README.md docs/

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
5. After completing this task, run: git add . {{COMMIT_INSTRUCTION}}{{COMMIT_INSTRUCTION}} git commit -m "docs: update documentation"

---

## Changed Files
```
install.sh
```

## Code Changes:
```diff
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
```
