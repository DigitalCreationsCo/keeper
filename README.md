# Keeper

Agent-powered documentation that stays in sync with your code.

## How it Works

1.  **Git Hook**: Keeper installs a `post-commit` Git hook that runs after each commit.
2.  **Task Generation**: The hook generates a Markdown file with the code changes and instructions for an AI agent to update the documentation.
3.  **AI Agent**: You can then use your preferred AI agent to complete the task in the generated file.

## Installation

```bash
curl -fsSL https://github.com/digitalcreationsco/keeper/releases/latest/download/install.sh | bash
```

## Configuration

Edit `.keeper/config.json` to customize:

- `trigger_mode`: "interactive" or "auto"
- `auto_commit`: `false` or `true`
- `debug`: `true` or `false`
- `agent`: The name of your preferred coding agent. Supported agents: `cline`, `aider`, `claude`
- `agent_command` (optional): Provide a custom command to run your agent. Use `{{TASK_FILE}}` as a placeholder for the task file path
- `files_to_update`: A list of documentation files and directories to keep updated
- `exclude`: A list of file patterns to ignore

## Usage

After committing code, Keeper creates a task file and (in `interactive` mode) waits for you to call your configured AI agent. The agent will update documentation and then execute the required commit command provided in the task file.

## Releases

New versions are released regularly. You can find the latest release on the [GitHub Releases page](https://github.com/digitalcreationsco/keeper/releases).

## Updating Keeper

Run the same install command to update:
```bash
curl -fsSL https://github.com/digitalcreationsco/keeper/releases/latest/download/install.sh | bash
```

Your configuration will be preserved during updates.

## Uninstalling Keeper

To completely remove Keeper from your repository:
```bash
rm -rf .keeper
rm .git/hooks/post-commit
```