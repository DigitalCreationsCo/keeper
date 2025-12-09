# 1. Commit source
git add .
git commit -m "release: $VERSION" --allow-empty

# 2. Push tag
git tag -a "$VERSION" -m "Release $VERSION"
git push origin main --tags

# 3. GitHub Actions automatically:
#    - Builds all files with correct version
#    - Creates release
#    - Uploads: install.sh, hook.sh, config.json, README.md