#!/bin/bash
# This script runs the bats tests with kcov for code coverage.

# Check if kcov and bats are installed
if ! command -v kcov &> /dev/null || ! command -v bats &> /dev/null; then
    echo "Error: kcov and bats are not installed."
    echo "Please install them to run the tests."
    echo "On macOS: brew install kcov bats-core"
    echo "On Debian/Ubuntu: sudo apt-get install kcov bats"
    exit 1
fi

# Create a directory for the coverage report
mkdir -p coverage

# Run kcov
kcov --include-pattern=keeper/install.sh,.keeper/hook.sh \
     --bash-dont-parse-binary-dir \
     coverage \
     bats tests.bats
