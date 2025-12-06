# 🤖 Keeper Agent Task

## Task
Update the following documentation files to reflect recent code changes:
README.md docs/

## Scope of Work
You are strictly limited to the following actions:
1. **Update Documentation**: Modify the documentation files to accurately reflect the code changes.
2. **Follow Commit Instructions**: Adhere to the commit instruction provided at the end of this task.

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

## Code Changes
```diff
diff --git a/install.sh b/install.sh
index e89cba3..72b5904 100644
--- a/install.sh
+++ b/install.sh
@@ -16,9 +16,15 @@ KEEPER_README_FILE="$KEEPER_DIR/README.md"
 
 echo "⬇️  Downloading files..."
 
-cat > .keeper/hook.sh << 'EOF'
+cat > .keeper/hook.sh << 'HOOK_EOF'
 #!/bin/bash
 
+# Exit early if a rebase is in progress (silent exit)
+if git rev-parse --is-inside-work-tree >/dev/null 2>&1 && \
+   ( [ -d ".git/rebase-merge" ] || [ -d ".git/rebase-apply" ] ); then
+    exit 0
+fi
+
 KEEPER_DIR=".keeper"
 KEEPER_README_FILE="$KEEPER_DIR/README.md"
 TASK_FILE="$KEEPER_DIR/agent-task.md"
@@ -34,7 +40,7 @@ if [ -f "$CONFIG_FILE" ]; then
 
     if [ "$DEBUG_MODE" = "true" ]; then 
         echo "DEBUG: CONFIG_FILE path is $CONFIG_FILE"
-        echo "DEBUG: Does config.json exist? $([ -f "$CONFIG_FILE" ] && echo "yes" || echo "no")"
+        echo "DEBUG: Does config.json exist? $([ -f \"$CONFIG_FILE\" ] && echo \"yes\" || echo \"no\")"
         echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT"
     fi
     
@@ -118,7 +124,7 @@ echo "$TASK_CONTENT" > "$TASK_FILE"
 echo "" >> "$TASK_FILE"
 echo "## Changed Files" >> "$TASK_FILE"
 echo "\`\`\`" >> "$TASK_FILE"
-printf '%s\n' "${FILES_TO_PROCESS[@]}" >> "$TASK_FILE"
+printf \'%s\n\' "${FILES_TO_PROCESS[@]}" >> "$TASK_FILE"
 echo "\`\`\`" >> "$TASK_FILE"
 echo "" >> "$TASK_FILE"
 echo "## Code Changes" >> "$TASK_FILE"
@@ -137,13 +143,13 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
     
     case "$AGENT_NAME" in
         "cline")
-            echo " cline -m act 'Read and complete the task in $TASK_FILE'"
+            echo " cline -m act \'Read and complete the task in $TASK_FILE\'"
             ;;
         "aider")
-            echo " aider 'Read and complete the task in $TASK_FILE'"
+            echo " aider \'Read and complete the task in $TASK_FILE\'"
             ;;
         "claude")
-            echo " claude 'Read and complete the task in $TASK_FILE'"
+            echo " claude \'Read and complete the task in $TASK_FILE\'"
             ;;
         *)
             echo " Please ask your coding agent to read and complete the task in $TASK_FILE"
@@ -155,7 +161,7 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
     echo ""
     echo ""
     echo "💡 Want to run Keeper in autonomous mode?"
-    echo "   Change trigger_mode to 'auto' in .keeper/config.json"
+    echo "   Change trigger_mode to \'auto\' in .keeper/config.json"
     echo ""
     echo "📖 Read $KEEPER_README_FILE for more information"
     echo ""
@@ -179,7 +185,7 @@ if [ "$TRIGGER_MODE" = "auto" ]; then
                 AGENT_COMMAND="claude {{TASK_FILE}}"
                 ;;
             *)
-                echo "Keeper: Unknown agent '$AGENT_NAME'. Please configure 'agent_command' in your config.json."
+                echo "Keeper: Unknown agent \'$AGENT_NAME\'. Please configure \'agent_command\' in your config.json."
                 exit 1
                 ;;
         esac
@@ -188,7 +194,7 @@ if [ "$TRIGGER_MODE" = "auto" ]; then
     FINAL_COMMAND=$(echo "$AGENT_COMMAND" | sed "s|{{TASK_FILE}}|$TASK_FILE|g")
 
     echo ""
-    echo "🤖 Keeper is calling the AI agent '$AGENT_NAME'. Please wait..."
+    echo "🤖 Keeper is calling the AI agent \'$AGENT_NAME\'. Please wait..."
     echo ""
     eval "$FINAL_COMMAND"
     echo ""
@@ -231,8 +237,7 @@ cat > "$CONFIG_FILE" << 'CONFIG_EOF'
   "exclude": [
     ".keeper/*",
     "*.lock",
-    "package.json",
-    ".gitignore"
+    "package.json"
   ]
 }
 CONFIG_EOF
@@ -246,8 +251,8 @@ Update the following documentation files to reflect recent code changes:
 
 ## Scope of Work
 You are strictly limited to the following actions:
-1. **Update Documentation**: Modify the documentation files to accurately reflect the code changes.
-2. **Follow Commit Instructions**: Adhere to the commit instruction provided at the end of this task.
+1.  **Update Documentation**: Modify the documentation files to accurately reflect the code changes.
+2.  **Follow Commit Instructions**: Adhere to the commit instruction provided at the end of this task.
 
 **IMPORTANT**: Do not perform any other actions. Do not diagnose issues, suggest other code changes, or try to fix anything that is not directly related to the documentation update. If no documentation updates are needed, simply complete the task without making any changes.
 
@@ -273,15 +278,13 @@ Agent-powered documentation that stays in sync with your code.
 
 ## Configuration
 
-Edit `.keeper/config.json` to customize:
-
-- `trigger_mode`: "auto" or "interactive"
-- `auto_commit`: `true` or `false`
-- `debug`: `true` or `false`
-- `agent`: The name of your preferred coding agent. Supported agents: `cline`, `aider`, `claude`
-- `agent_command` (optional): Provide a custom command to run your agent. Use `{{TASK_FILE}}` as a placeholder for the task file path
-- `files_to_update`: A list of documentation files and directories to keep updated
-- `exclude`: A list of file patterns to ignore
+Edit `$CONFIG_FILE` to customize:
+- `trigger_mode`: "auto" or "interactive".
+- `auto_commit`: `true` or `false`.
+- `agent`: The name of your preferred coding agent. Supported agents: `cline`, `aider`, `claude`.
+- `agent_command` (optional): Provide a custom command to run your agent. Use `{{TASK_FILE}}` as a placeholder for the task file path.
+- `files_to_update`: A list of documentation files and directories to keep updated.
+- `exclude`: A list of file patterns to ignore.
 
 ## Usage
 
@@ -290,6 +293,7 @@ README_EOF
 
 chmod +x .keeper/hook.sh
 
+# Install git hook
 echo "🔗 Installing git hook..."
 cat > .git/hooks/post-commit << 'HOOK_CALLER_EOF'
 #!/bin/bash
@@ -298,10 +302,9 @@ HOOK_CALLER_EOF
 
 chmod +x .git/hooks/post-commit
 
+echo "✅ Success!"
 echo ""
-echo "✅ Keeper installed successfully!"
+echo "📖 Read $KEEPER_README_FILE for usage instructions"
 echo ""
-echo "📖 Read .keeper/README.md for usage instructions"
+echo "🎉 Try it: Make a code change, commit it, and Keeper will help keep your README and docs updated!"
 echo ""
-echo "🎉 Try it: Make a code change, commit it, and Keeper will help keep your docs updated!"
-echo ""
\ No newline at end of file
```
