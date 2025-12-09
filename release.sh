# 1. Update version
npm version patch

# 2. Push tag
git push origin main --tags

# 3. GitHub Actions automatically:
#    - Builds all files with correct version
#    - Creates release
#    - Uploads: install.sh, hook.sh, config.json, README.md