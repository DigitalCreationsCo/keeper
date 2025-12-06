git add .
git commit -m "release: $VERSION"

# 2. Update version in install.sh and docs/index.html
# Update VERSION="1.1.0"

# 3. Create and push tag
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

# ### 7. Custom Domain (Optional)

# If you want `dockeeper.dev`:

# 1. Buy domain from any registrar
# 2. Add `CNAME` file to `/docs`:
# ```
#    dockeeper.dev
# ```
# 3. Configure DNS:
# ```
#    CNAME: dockeeper.dev → username.github.io