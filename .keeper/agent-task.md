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
index e8a15cb..41123d2 100755
--- a/install.sh
+++ b/install.sh
@@ -81,6 +81,7 @@ if [ ${#FILES_TO_PROCESS[@]} -eq 0 ]; then
 fi
 
 echo "Keeper: Processing the following files:"
+sleep 1
 for file in "${FILES_TO_PROCESS[@]}"; do
     echo "- $file"
 done
@@ -120,6 +121,7 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
     echo ""
     echo " Keeper has prepared a documentation update task"
     echo "📂: $TASK_FILE"
+    sleep 1
     echo ""
     echo "Call your agent as follows:"
     echo ""
```