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
index 473d481..a3030e8 100755
--- a/install.sh
+++ b/install.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # Keeper Installer
 # Usage: curl -fsSL https://keeper.dev/install.sh | bash
-
+# CHASNGE
 set -e
 
 echo "📚 Installing Keeper..."
@@ -33,20 +33,21 @@ CONFIG_FILE="$KEEPER_DIR/config.json"
 TEMPLATE_FILE="$KEEPER_DIR/prompt-template.md"
 
 if [ -f "$CONFIG_FILE" ]; then
-    TRIGGER_MODE=$(jq -r '.trigger_mode // "auto"' "$CONFIG_FILE")
-    AUTO_COMMIT=$(jq -r '.auto_commit // true' "$CONFIG_FILE")
-    AGENT_NAME=$(jq -r '.agent // "cline"' "$CONFIG_FILE")
-    AGENT_COMMAND_OVERRIDE=$(jq -r '.agent_command // ""' "$CONFIG_FILE")
-
+    TRIGGER_MODE=$(jq -r ".trigger_mode // \"auto\"" "$CONFIG_FILE")
+    AUTO_COMMIT=$(jq -r ".auto_commit // true" "$CONFIG_FILE")
+    AGENT_NAME=$(jq -r ".agent // \"cline\"" "$CONFIG_FILE")
+    AGENT_COMMAND_OVERRIDE=$(jq -r ".agent_command // \"\"" "$CONFIG_FILE")
+    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # ADDED DEBUG
+    
     FILES_TO_UPDATE=()
     while IFS= read -r line; do
         FILES_TO_UPDATE+=("$line")
-    done < <(jq -r '.files_to_update[]' "$CONFIG_FILE")
+    done < <(jq -r ".files_to_update[]" "$CONFIG_FILE")
 
     EXCLUDE_PATTERNS=()
     while IFS= read -r line; do
         EXCLUDE_PATTERNS+=("$line")
-    done < <(jq -r '.exclude[]' "$CONFIG_FILE")
+    done < <(jq -r ".exclude[]" "$CONFIG_FILE")
 else
     TRIGGER_MODE="auto"
     AUTO_COMMIT="true"
@@ -98,6 +99,10 @@ else
     COMMIT_INSTRUCTION="The documentation files have been updated. Please review and commit them."
 fi
 
+echo "DEBUG: PROMPT_TEMPLATE content starts here:" # ADDED DEBUG
+cat "$TEMPLATE_FILE" # ADDED DEBUG
+echo "DEBUG: PROMPT_TEMPLATE content ends here." # ADDED DEBUG
+echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # ADDED DEBUG
 PROMPT_TEMPLATE=$(cat "$TEMPLATE_FILE")
 TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s/{{COMMIT_INSTRUCTION}}/$COMMIT_INSTRUCTION/g")
 TASK_CONTENT=$(echo "$TASK_CONTENT" | sed "s|{{FILES_TO_UPDATE}}|${FILES_TO_UPDATE[*]}|g")
@@ -127,13 +132,13 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
     echo ""
     case "$AGENT_NAME" in
         "cline")
-            echo "  cline -m act 'Read and complete the task in $TASK_FILE'"
+            echo "  cline -m act \'Read and complete the task in $TASK_FILE\'"
             ;;
         "aider")
-            echo "  aider 'Read and complete the task in $TASK_FILE'"
+            echo "  aider \'Read and complete the task in $TASK_FILE\'"
             ;;
         "claude")
-            echo "  claude 'Read and complete the task in $TASK_FILE'"
+            echo "  claude \'Read and complete the task in $TASK_FILE\'"
             ;;
         *)
             echo "  Please ask your coding agent to read and complete the task in $TASK_FILE"
@@ -142,7 +147,7 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
     echo ""
     echo "After the agent responds, it will update your docs automatically."
     echo ""
-    echo "Want to run Keeper in autonomous mode? Change $CONFIG_FILE.trigger_mode to 'auto'."
+    echo "Want to run Keeper in autonomous mode? Change $CONFIG_FILE.trigger_mode to \'auto\'."
     echo "Read $KEEPER_README_FILE for usage instructions"
     exit 0
 fi
@@ -163,7 +168,7 @@ if [ "$TRIGGER_MODE" = "auto" ]; then
                 AGENT_COMMAND="claude {{TASK_FILE}}"
                 ;;
             *)
-                echo "Keeper: Unknown agent '$AGENT_NAME'. Please configure 'agent_command' in your config.json."
+                echo "Keeper: Unknown agent \'$AGENT_NAME\'. Please configure \'agent_command\' in your config.json."
                 exit 1
                 ;;
         esac
@@ -172,7 +177,7 @@ if [ "$TRIGGER_MODE" = "auto" ]; then
     FINAL_COMMAND=$(echo "$AGENT_COMMAND" | sed "s|{{TASK_FILE}}|$TASK_FILE|g")
 
     echo ""
-    echo " Keeper is calling the AI agent '$AGENT_NAME'. Please wait, this may take a few moments..."
+    echo " Keeper is calling the AI agent \'$AGENT_NAME\'. Please wait, this may take a few moments..."
     echo ""
     eval "$FINAL_COMMAND"
     echo ""
```
