# 1. Update version
npm version patch

# 2. Commit source
git add .
git commit -m "release: $VERSION"

# 3. Push tag
git tag -a "$VERSION" -m "Release $VERSION"
git push origin main
git push origin $VERSION

# 4. GitHub Actions automatically:
#    - Builds all files with correct version
#    - Creates release
#    - Uploads: install.sh, hook.sh, config.json, README.md