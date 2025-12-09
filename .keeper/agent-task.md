# 🤖 Keeper Agent Task

## Mission
Update documentation files (README.md docs/) to reflect code changes. **Complete in ≤2 commands or abort.**

## Hard Constraints
1. **Command Limit**: Maximum 2 commands total
2. **Scope Lock**: Documentation updates ONLY
3. **No Diagnosis**: Do not analyze, troubleshoot, or suggest fixes
4. **No Side Quests**: Ignore unrelated issues in code/docs

### Step 1: Analyze (Mental Only - No Output)
Scan code changes for documentation-impacting items:
- New/removed files
- New/modified functions
- Changed APIs
- Updated dependencies
- Modified workflows

### Step 2: Update Documentation (Command 1)
Apply ALL necessary changes in a single batch:
- Update technical details (file paths, function names, APIs)
- Reflect architectural changes (new agents, workflow phases)
- Fix broken references (renamed fields, removed functions)
- Maintain existing tone/structure

**Critical**: Bundle all changes into ONE update operation.

### Step 3: Commit (Command 2)
After completing this task, run: ```bash
git add . && git commit -m "docs: update documentation"
```

## Decision Tree
- **Can complete in 2 commands?** → Execute
- **Need 3+ commands?** → Abort and report: "Task requires X commands. Changes needed: [list]"
- **No changes needed?** → Report: "Documentation already current" (0 commands)

## Quality Checklist (Internal - No Output)
- [ ] All new features documented
- [ ] Deprecated items removed
- [ ] Technical accuracy verified
- [ ] No scope creep

## Output Format
**If executing:**
[Brief summary of changes made]

**If aborting:**
"Cannot complete in 2 commands. Requires X commands for: [specific items]"

---

## Example Changes Summary
```
Modified files: 2
Changes:
README.md: 
- New main entry point (replaces index.js)
docs/api: 
- startReference/endReference (replaces lastReferenceUrl)
- Model defaults: Added fallbacks for model_name
- Evaluation: buildEvalPrompt
```

**Now execute with maximum efficiency.**

---

## Changed Files
```
README.md
docs/index.html
```

## Code Changes
```diff
diff --git a/README.md b/README.md
index d6c406d..f7cc10a 100644
--- a/README.md
+++ b/README.md
@@ -18,8 +18,8 @@ curl -fsSL https://github.com/digitalcreationsco/keeper/releases/latest/download
 
 Edit `.keeper/config.json` to customize:
 
-- `trigger_mode`: "auto" or "interactive"
-- `auto_commit`: `true` or `false`
+- `trigger_mode`: "interactive" or "auto"
+- `auto_commit`: `false` or `true`
 - `debug`: `true` or `false`
 - `agent`: The name of your preferred coding agent. Supported agents: `cline`, `aider`, `claude`
 - `agent_command` (optional): Provide a custom command to run your agent. Use `{{TASK_FILE}}` as a placeholder for the task file path
@@ -28,7 +28,7 @@ Edit `.keeper/config.json` to customize:
 
 ## Usage
 
-After committing code, Keeper creates a task file and (in `auto` mode) calls your configured AI agent.
+After committing code, Keeper creates a task file and (in `interactive` mode) waits for you to call your configured AI agent.
 
 ## Releases
 
diff --git a/docs/index.html b/docs/index.html
index dcec73c..ac5e530 100644
--- a/docs/index.html
+++ b/docs/index.html
@@ -382,9 +382,9 @@ claude code "Complete the task in .keeper/agent-task.md"
 
 ✅ Documentation updated!
 
-# Commit the docs
-git add README.md
-git commit -m "docs: update authentication section"</code>
+# Note: The agent should handle the commit itself
+# git add README.md
+# git commit -m "docs: update authentication section"</code>
             </div>
         </div>
 
```
