#!/usr/bin/env bats

setup() {
    # Create a temporary directory for testing
    TEST_DIR=$(mktemp -d)
    cd "$TEST_DIR"

    # Initialize a git repository
    git init
    git config user.email "test@example.com"
    git config user.name "Test User"
    
    # Copy the keeper directory to the test environment.
    # This assumes the tests are run from the project root.
    cp -r ../keeper .

    # Mock the cline command
    mkdir -p bin
    echo '#!/bin/bash' > bin/cline
    echo 'echo "Mock cline called"' >> bin/cline
    echo 'echo "AI agent has updated README.md"' >> bin/cline
    # Simulate the agent updating the README and committing
    echo 'echo "Updated README.md" > README.md' >> bin/cline
    echo 'git add README.md' >> bin/cline
    echo 'git commit -m "docs: update documentation by mock agent"' >> bin/cline
    chmod +x bin/cline
    export PATH="$PWD/bin:$PATH"
}

teardown() {
    # Clean up the temporary directory
    rm -rf "$TEST_DIR"
}

@test "Installer should create all necessary files" {
    run ./keeper/install.sh
    
    [ "$status" -eq 0 ]
    [ -f ".keeper/hook.sh" ]
    [ -f ".keeper/config.json" ]
    [ -f ".keeper/prompt-template.md" ]
    [ -f ".keeper/README.md" ]
    [ -f ".git/hooks/post-commit" ]
}

@test "Hook script should be executable" {
    run ./keeper/install.sh

    [ "$status" -eq 0 ]
    [ -x ".keeper/hook.sh" ]
    [ -x ".git/hooks/post-commit" ]
}

@test "Hook should generate an agent task on commit" {
    # Run the installer
    ./keeper/install.sh

    # Create a file and commit it
    echo "hello" > testfile.txt
    git add testfile.txt
    git commit -m "Test commit"

    # Check that the agent task was created
    [ -f ".keeper/agent-task.md" ]
}

@test "Hook should use the prompt template" {
    ./keeper/install.sh
    echo "hello" > testfile.txt
    git add testfile.txt
    git commit -m "Test commit"

    # Check if the task file contains content from the template
    grep "Scope of Work" ".keeper/agent-task.md"
}

@test "Hook should respect auto_commit: false" {
    ./keeper/install.sh
    # Set auto_commit to false
    jq '.auto_commit = false' .keeper/config.json > .keeper/config.json.tmp && mv .keeper/config.json.tmp .keeper/config.json

    echo "hello" > testfile.txt
    git add testfile.txt
    git commit -m "Test commit"

    grep "Please review and commit them." ".keeper/agent-task.md"
}

@test "Hook should respect auto_commit: true" {
    ./keeper/install.sh
    # Set auto_commit to true
    jq '.auto_commit = true' .keeper/config.json > .keeper/config.json.tmp && mv .keeper/config.json.tmp .keeper/config.json

    echo "hello" > testfile.txt
    git add testfile.txt
    git commit -m "Test commit"

    grep "run: git add . && git commit" ".keeper/agent-task.md"
}
