# 🤖 Keeper Agent Task - EFFICIENCY MODE

## Mission
Update documentation files (README.md, workflow.md) to reflect code changes. **Complete in ≤2 commands or abort.**

## Hard Constraints
1. **Command Limit**: Maximum 2 commands total
2. **Scope Lock**: Documentation updates ONLY
3. **No Diagnosis**: Do not analyze, troubleshoot, or suggest fixes
4. **No Side Quests**: Ignore unrelated issues in code/docs

## Execution Protocol

### Step 1: Analyze (Mental Only - No Output)
Scan code changes for documentation-impacting items:
- New/removed files (graph.ts replaces index.js)
- New/modified functions (generateSceneFramesBatch, evaluateFrameQuality)
- Changed APIs (startFrameUrl/endFrameUrl replacing lastFrameUrl)
- Updated dependencies (new imports, model changes)
- Modified workflows (frame generation phase, quality checks)

### Step 2: Update Documentation (Command 1)
Apply ALL necessary changes in a single batch:
- Update technical details (file paths, function names, APIs)
- Reflect architectural changes (new agents, workflow phases)
- Fix broken references (renamed fields, removed functions)
- Maintain existing tone/structure

**Critical**: Bundle all changes into ONE update operation.

### Step 3: Commit (Command 2)
```bash
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

## Example Code Changes Summary
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

## Changed Files
```
'install.shn'```

## Code Changes
```diff
diff --git a/install.sh b/install.sh
index 893f68a..c11508f 100644
--- a/install.sh
+++ b/install.sh
@@ -93,7 +93,6 @@ if [ ${#FILES_TO_PROCESS[@]} -eq 0 ]; then
 fi
 
 echo " Keeper: Processing the following files:"
-sleep 1
 for file in "${FILES_TO_PROCESS[@]}"; do
     echo "  - $file"
 done
@@ -104,7 +103,9 @@ if [ -z "$DIFF" ]; then
 fi
 
 if [ "$AUTO_COMMIT" = "true" ]; then
-    COMMIT_INSTRUCTION="After completing this task, run: git add . && git commit -m \"docs: update documentation\""
+    COMMIT_INSTRUCTION="After completing this task, run: ```bash
+git add . && git commit -m "docs: update documentation"
+```"
 else
     COMMIT_INSTRUCTION="The documentation files have been updated. Please review and commit them."
 fi
@@ -136,7 +137,6 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
     echo ""
     echo " Keeper: Task created"
     echo " 📂: $TASK_FILE"
-    sleep 1
     echo ""
     echo "Call your agent as follows:"
     echo ""
@@ -245,30 +245,68 @@ CONFIG_EOF
 cat > .keeper/prompt-template.md << 'TEMPLATE_EOF'
 # 🤖 Keeper Agent Task
 
-## Task
-Update the following documentation files to reflect recent code changes:
-{{FILES_TO_UPDATE}}
-
-## Scope of Work
-You are strictly limited to the following actions:
-1.  **Update Documentation**: Modify the documentation files to accurately reflect the code changes.
-2.  **Follow Commit Instructions**: Adhere to the commit instruction provided at the end of this task.
-
-**IMPORTANT**: Do not perform any other actions. Do not diagnose issues, suggest other code changes, or try to fix anything that is not directly related to the documentation update. If no documentation updates are needed, simply complete the task without making any changes.
-
-## Instructions
-1. Analyze the code changes below
-2. Update the documentation to reflect:
-   - New features or functions added
-   - Modified APIs or interfaces
-   - Changed dependencies or requirements
-   - Updated installation or usage instructions
-3. Maintain the existing tone and structure
-4. Be concise but complete
-5. {{COMMIT_INSTRUCTION}}
-
+## Mission
+Update documentation files ({{FILES_TO_UPDATE}}) to reflect code changes. **Complete in ≤2 commands or abort.**
+
+## Hard Constraints
+1. **Command Limit**: Maximum 2 commands total
+2. **Scope Lock**: Documentation updates ONLY
+3. **No Diagnosis**: Do not analyze, troubleshoot, or suggest fixes
+4. **No Side Quests**: Ignore unrelated issues in code/docs
+
+### Step 1: Analyze (Mental Only - No Output)
+Scan code changes for documentation-impacting items:
+- New/removed files
+- New/modified functions
+- Changed APIs
+- Updated dependencies
+- Modified workflows
+
+### Step 2: Update Documentation (Command 1)
+Apply ALL necessary changes in a single batch:
+- Update technical details (file paths, function names, APIs)
+- Reflect architectural changes (new agents, workflow phases)
+- Fix broken references (renamed fields, removed functions)
+- Maintain existing tone/structure
+
+**Critical**: Bundle all changes into ONE update operation.
+
+### Step 3: Commit (Command 2)
+{{COMMIT_INSTRUCTION}}
+
+## Decision Tree
+- **Can complete in 2 commands?** → Execute
+- **Need 3+ commands?** → Abort and report: "Task requires X commands. Changes needed: [list]"
+- **No changes needed?** → Report: "Documentation already current" (0 commands)
+
+## Quality Checklist (Internal - No Output)
+- [ ] All new features documented
+- [ ] Deprecated items removed
+- [ ] Technical accuracy verified
+- [ ] No scope creep
+
+## Output Format
+**If executing:**
+[Brief summary of changes made]
+
+**If aborting:**
+"Cannot complete in 2 commands. Requires X commands for: [specific items]"
+f
 ---
 
+## Example Changes Summary
+```
+Modified files: 2
+Changes:
+README.md: 
+- New main entry point (replaces index.js)
+docs/api: f
+- startReference/endReference (replaces lastReferenceUrl)
+- Model defaults: Added fallbacks for model_name
+- Evaluation: buildEvalPrompt
+```
+
+**Now execute with maximum efficiency.**
 TEMPLATE_EOF
 
 cat > "$KEEPER_README_FILE" << 'README_EOF'
```
