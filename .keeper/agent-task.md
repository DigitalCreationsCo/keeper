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
index 72b5904..893f68a 100644
--- a/install.sh
+++ b/install.sh
@@ -222,7 +222,7 @@ if [ "$TRIGGER_MODE" = "auto" ]; then
     fi
     exit 0
 fi
-EOF
+HOOK_EOF
 
 cat > "$CONFIG_FILE" << 'CONFIG_EOF'
 {
```
