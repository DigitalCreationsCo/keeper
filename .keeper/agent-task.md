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
README.md
docs/index.html
install.sh
```

## Code Changes
```diff
diff --git a/README.md b/README.md
deleted file mode 100644
index fb3fdc8..0000000
--- a/README.md
+++ /dev/null
@@ -1,39 +0,0 @@
-# Keeper
-
-Keeper is a developer tool that helps keep your documentation in sync with your code. It automatically generates documentation update tasks for an AI agent to complete after you commit your code.
-
-## How it Works
-
-1.  **Git Hook**: Keeper installs a `post-commit` Git hook that runs after each commit.
-2.  **Task Generation**: The hook generates a Markdown file with the code changes and instructions for an AI agent to update the documentation.
-3.  **AI Agent**: You can then use your preferred AI agent to complete the task in the generated file.
-
-## Installation
-
-```bash
-curl -fsSL https://github.com/digitalcreationsco/keeper/releases/latest/download/install.sh | bash
-```
-
-## Configuration
-
-Keeper can be configured using the `.keeper/config.json` file in your repository.
-
-### `auto_commit`
-
-By default, Keeper does not automatically commit the documentation changes. To enable this feature, set `auto_commit` to `true` in your config file:
-
-```json
-{
-  "auto_commit": true
-}
-```
-
-## Releases
-
-New versions are released regularly. You can find the latest release on the [GitHub Releases page](https://github.com/digitalcreationsco/keeper/releases).
-
-To get the latest version, you can use the following command:
-
-```bash
-curl -fsSL https://github.com/digitalcreationsco/keeper/releases/latest/download/install.sh | bash
-```
diff --git a/docs/index.html b/docs/index.html
index d5b0622..03e139e 100644
--- a/docs/index.html
+++ b/docs/index.html
@@ -296,7 +296,7 @@
         </header>
 
         <div class="install-section">
-            <h2 class="install-title">Quick Install <span class="version-badge">v1.1.0</span></h2>
+            <h2 class="install-title">Quick Install <span class="version-badge">v1.2.2</span></h2>
             <div class="command-box">
                 <code
                     id="install-command">curl -fsSL https://github.com/digitalcreationsco/keeper/releases/latest/download/install.sh | bash</code>
@@ -376,10 +376,10 @@
 git add .
 git commit -m "feat: add user authentication"
 
-📝 Keeper: Task created at .keeper/agent-request.md
+📝 Keeper: Task created at .keeper/agent-task.md
 
-# Ask your agent to complete the task
-claude code "Complete the task in .keeper/agent-request.md"
+# Call your agent to complete the task
+claude code "Complete the task in .keeper/agent-task.md"
 
 ✅ Documentation updated!
 
diff --git a/install.sh b/install.sh
index c630e30..f4a8f11 100755
--- a/install.sh
+++ b/install.sh
@@ -128,8 +128,8 @@ echo "\`\`\`" >> "$TASK_FILE"
 
 if [ "$TRIGGER_MODE" = "interactive" ]; then
     echo ""
-    echo " Keeper has prepared a documentation update task"
-    echo "📂 Task file: $TASK_FILE"
+    echo " Keeper: Task created"
+    echo "📂: $TASK_FILE"
     sleep 1
     echo ""
     echo "Call your agent as follows:"
```
