git add .
git commit -m "release: $VERSION"

git tag -a $VERSION -m "Release $VERSION"
git push origin main
git push origin $VERSION

# 4. Create GitHub Release
# - Go to Releases → Draft new release
# - Tag: v1.1.0
# - Upload: install.sh, hook.sh, config.json, etc.
# - Publish

# 5. Users automatically get latest version via:
# /releases/latest/download/install.sh
# ```