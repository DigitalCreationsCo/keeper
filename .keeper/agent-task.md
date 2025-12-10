# 🤖 Keeper Agent Task

## Mission
Update documentation files to reflect recent code changes.

## Documentation Files to Update
- README.md
- docs/

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
```
hook.sh
```

## Code Changes
```diff
diff --git a/hook.sh b/hook.sh
index a007bdd..4aaf3f0 100644
--- a/hook.sh
+++ b/hook.sh
@@ -210,13 +210,13 @@ if [ "$TRIGGER_MODE" = "auto" ]; then
     else
         case "$AGENT_NAME" in
             "cline")
-                AGENT_COMMAND="cline --yolo -m \"Read and complete the task in $TASK_FILE\""
+                AGENT_COMMAND="cat {{TASK_FILE}} | cline --yolo"
                 ;;
             "aider")
-                AGENT_COMMAND="aider --yes --message \"Read and complete the task in $TASK_FILE\""
+                AGENT_COMMAND="aider {{TASK_FILE}}"
                 ;;
             "claude")
-                AGENT_COMMAND="claude --message \"Read and complete the task in $TASK_FILE\""
+                AGENT_COMMAND="claude {{TASK_FILE}}"
                 ;;
             *)
                 echo "Keeper: Unknown agent '$AGENT_NAME'. Please configure 'agent_command' in your config.json."
```

---

## Next Steps
After updating the documentation, save your changes. Do not commit them - the user will review and commit manually.
