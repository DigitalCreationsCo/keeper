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

## Next Steps
After updating the documentation, commit your changes:
```bash
git add .
git commit -m "docs: update documentation"
```

---

## Changed Files
```
hook.sh
```

## Code Changes
```diff
diff --git a/hook.sh b/hook.sh
index 9382ae6..bd992c7 100644
--- a/hook.sh
+++ b/hook.sh
@@ -152,9 +152,7 @@ $(for f in "${FILES_TO_UPDATE[@]}"; do echo "- $f"; done)
    - Updated installation or usage instructions
 3. Maintain the existing tone and structure of the documentation
 4. Be concise but complete
-
-## Next Steps
-$COMMIT_INSTRUCTION
+5. $COMMIT_INSTRUCTION
 
 ---
 
```

