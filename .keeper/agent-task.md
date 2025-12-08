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
index c11508f..ec86ca4 100644
--- a/install.sh
+++ b/install.sh
@@ -124,14 +124,14 @@ TASK_CONTENT=$(echo "$TASK_CONTENT" | sed "s|{{FILES_TO_UPDATE}}|${FILES_TO_UPDA
 echo "$TASK_CONTENT" > "$TASK_FILE"
 echo "" >> "$TASK_FILE"
 echo "## Changed Files" >> "$TASK_FILE"
-echo "\`\`\`" >> "$TASK_FILE"
-printf \'%s\n\' "${FILES_TO_PROCESS[@]}" >> "$TASK_FILE"
-echo "\`\`\`" >> "$TASK_FILE"
+echo '```' >> "$TASK_FILE"
+printf '%s\n' "${FILES_TO_PROCESS[@]}" >> "$TASK_FILE"
+echo '```' >> "$TASK_FILE"
 echo "" >> "$TASK_FILE"
 echo "## Code Changes" >> "$TASK_FILE"
-echo "\`\`\`diff" >> "$TASK_FILE"
+echo '```diff' >> "$TASK_FILE"
 echo "$DIFF" >> "$TASK_FILE"
-echo "\`\`\`" >> "$TASK_FILE"
+echo '```' >> "$TASK_FILE"
 
 if [ "$TRIGGER_MODE" = "interactive" ]; then
     echo ""
@@ -291,7 +291,7 @@ Apply ALL necessary changes in a single batch:
 
 **If aborting:**
 "Cannot complete in 2 commands. Requires X commands for: [specific items]"
-f
+
 ---
 
 ## Example Changes Summary
@@ -300,7 +300,7 @@ Modified files: 2
 Changes:
 README.md: 
 - New main entry point (replaces index.js)
-docs/api: f
+docs/api: 
 - startReference/endReference (replaces lastReferenceUrl)
 - Model defaults: Added fallbacks for model_name
 - Evaluation: buildEvalPrompt
```
