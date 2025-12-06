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
.DS_Store README.md install.sh release.sh
```

## Code Changes:
```diff
diff --git a/.DS_Store b/.DS_Store
deleted file mode 100644
index ca2b787..0000000
Binary files a/.DS_Store and /dev/null differ
diff --git a/README.md b/README.md
index 6d1779a..fb3fdc8 100644
--- a/README.md
+++ b/README.md
@@ -37,20 +37,3 @@ To get the latest version, you can use the following command:
 ```bash
 curl -fsSL https://github.com/digitalcreationsco/keeper/releases/latest/download/install.sh | bash
 ```
-
-### Custom Domain (Optional)
-
-If you want `dockeeper.dev`:
-
-1. Buy domain from any registrar
-2. Add `CNAME` file to `/docs`:
-
-```
-dockeeper.dev
-```
-
-3. Configure DNS:
-
-```
-CNAME: dockeeper.dev → username.github.io
-```
\ No newline at end of file
diff --git a/install.sh b/install.sh
index 41123d2..e9afa39 100755
--- a/install.sh
+++ b/install.sh
@@ -200,7 +200,8 @@ cat > "$CONFIG_FILE" << 'CONFIG_EOF'
   "exclude": [
     ".keeper/*",
     "*.lock",
-    "package.json"
+    "package.json",
+    ".gitignore"
   ]
 }
 CONFIG_EOF
diff --git a/release.sh b/release.sh
index b4f6ab5..749b750 100644
--- a/release.sh
+++ b/release.sh
@@ -1,10 +1,6 @@
 git add .
 git commit -m "release: $VERSION"
 
-# 2. Update version in install.sh and docs/index.html
-# Update VERSION="1.1.0"
-
-# 3. Create and push tag
 git tag -a $VERSION -m "Release $VERSION"
 git push origin main
 git push origin $VERSION
@@ -17,17 +13,4 @@ git push origin $VERSION
 
 # 5. Users automatically get latest version via:
 # /releases/latest/download/install.sh
-# ```
-
-# ### 7. Custom Domain (Optional)
-
-# If you want `dockeeper.dev`:
-
-# 1. Buy domain from any registrar
-# 2. Add `CNAME` file to `/docs`:
-# ```
-#    dockeeper.dev
-# ```
-# 3. Configure DNS:
-# ```
-#    CNAME: dockeeper.dev → username.github.io
\ No newline at end of file
+# ```
\ No newline at end of file
```
