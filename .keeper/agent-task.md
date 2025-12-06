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
docs/index.html release.sh
```

## Code Changes:
```diff
diff --git a/docs/index.html b/docs/index.html
index 874aa41..8ce502e 100644
--- a/docs/index.html
+++ b/docs/index.html
@@ -289,7 +289,7 @@
     <div class="container">
         <header>
             <div class="logo-row">
-                <div class="logo">📚</div>
+                <div class="logo">📚</div>  
                 <h1>Keeper</h1>
             </div>
             <p class="tagline">Keep your documentation in sync with your code</p>
diff --git a/release.sh b/release.sh
new file mode 100644
index 0000000..b4f6ab5
--- /dev/null
+++ b/release.sh
@@ -0,0 +1,33 @@
+git add .
+git commit -m "release: $VERSION"
+
+# 2. Update version in install.sh and docs/index.html
+# Update VERSION="1.1.0"
+
+# 3. Create and push tag
+git tag -a $VERSION -m "Release $VERSION"
+git push origin main
+git push origin $VERSION
+
+# 4. Create GitHub Release
+# - Go to Releases → Draft new release
+# - Tag: v1.1.0
+# - Upload: install.sh, hook.sh, config.json, etc.
+# - Publish
+
+# 5. Users automatically get latest version via:
+# /releases/latest/download/install.sh
+# ```
+
+# ### 7. Custom Domain (Optional)
+
+# If you want `dockeeper.dev`:
+
+# 1. Buy domain from any registrar
+# 2. Add `CNAME` file to `/docs`:
+# ```
+#    dockeeper.dev
+# ```
+# 3. Configure DNS:
+# ```
+#    CNAME: dockeeper.dev → username.github.io
\ No newline at end of file
```
