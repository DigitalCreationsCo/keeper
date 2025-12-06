# Keeper

Keeper is a developer tool that helps keep your documentation in sync with your code. It automatically generates documentation update tasks for an AI agent to complete after you commit your code.

## How it Works

1.  **Git Hook**: Keeper installs a `post-commit` Git hook that runs after each commit.
2.  **Task Generation**: The hook generates a Markdown file with the code changes and instructions for an AI agent to update the documentation.
3.  **AI Agent**: You can then use your preferred AI agent to complete the task in the generated file.

## Installation

```bash
curl -fsSL https://github.com/digitalcreationsco/keeper/releases/latest/download/install.sh | bash
```

## Configuration

Keeper can be configured using the `.keeper/config.json` file in your repository.

### `auto_commit`

By default, Keeper does not automatically commit the documentation changes. To enable this feature, set `auto_commit` to `true` in your config file:

```json
{
  "auto_commit": true
}
```

## Releases

New versions are released regularly. You can find the latest release on the [GitHub Releases page](https://github.com/digitalcreationsco/keeper/releases).

To get the latest version, you can use the following command:

```bash
curl -fsSL https://github.com/digitalcreationsco/keeper/releases/latest/download/install.sh | bash
```

Edit `.keeper/config.json` to customize:

- `trigger_mode`: "auto" or "interactive"
- `auto_commit`: `true` or `false`
- `agent`: The name of your preferred coding agent. Supported agents: `cline`, `aider`, `claude`
- `agent_command` (optional): Provide a custom command to run your agent. Use `{{TASK_FILE}}` as a placeholder for the task file path
- `files_to_update`: A list of documentation files and directories to keep updated
- `exclude`: A list of file patterns to ignore


📖 Read $KEEPER_README_FILE for usage instructions

🎉 Try it: Make a code change, commit it, and Keeper will help keep your README and docs updated!