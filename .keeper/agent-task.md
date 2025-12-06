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
README.md docs/index.html install.sh
```

## Code Changes:
```diff
diff --git a/README.md b/README.md
index e69de29..53dddb4 100644
--- a/README.md
+++ b/README.md
@@ -0,0 +1,28 @@
+# Keeper
+
+Keeper is a developer tool that helps keep your documentation in sync with your code. It automatically generates documentation update tasks for an AI agent to complete after you commit your code.
+
+## How it Works
+
+1.  **Git Hook**: Keeper installs a `post-commit` Git hook that runs after each commit.
+2.  **Task Generation**: The hook generates a Markdown file with the code changes and instructions for an AI agent to update the documentation.
+3.  **AI Agent**: You can then use your preferred AI agent to complete the task in the generated file.
+
+## Installation
+
+```bash
+curl -fsSL https://github.com/digitalcreationsco/keeper/releases/latest/download/install.sh | bash
+```
+
+## Configuration
+
+Keeper can be configured using the `.keeper/config.json` file in your repository.
+
+### `auto_commit`
+
+By default, Keeper does not automatically commit the documentation changes. To enable this feature, set `auto_commit` to `true` in your config file:
+
+```json
+{
+  "auto_commit": true
+}
\ No newline at end of file
diff --git a/docs/index.html b/docs/index.html
index 4c8169a..874aa41 100644
--- a/docs/index.html
+++ b/docs/index.html
@@ -363,11 +363,8 @@
             </p>
             <div class="agents-grid">
                 <div class="agent-badge">🤖 Claude Code</div>
-                <div class="agent-badge">💬 GitHub Copilot</div>
-                <div class="agent-badge">🔧 Cline</div>
-                <div class="agent-badge">⚡ Cursor</div>
-                <div class="agent-badge">➡️ Continue.dev</div>
                 <div class="agent-badge">🎯 Aider</div>
+                <div class="agent-badge">🔧 Cline</div>
                 <div class="agent-badge">✨ Your Custom Agent</div>
             </div>
         </div>
diff --git a/install.sh b/install.sh
index 5bf2764..e8a15cb 100755
--- a/install.sh
+++ b/install.sh
@@ -125,7 +125,7 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
     echo ""
     case "$AGENT_NAME" in
         "cline")
-            echo "  cline 'Read and complete the task in $TASK_FILE'"
+            echo "  cline -m act 'Read and complete the task in $TASK_FILE'"
             ;;
         "aider")
             echo "  aider 'Read and complete the task in $TASK_FILE'"
```
