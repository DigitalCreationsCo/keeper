# Keeper

Agent-powered documentation that stays in sync with your code.

## Configuration

Edit `$CONFIG_FILE` to customize:
- `trigger_mode`: "auto" or "interactive".
- `auto_commit`: `true` or `false`.
- `agent`: The name of your preferred coding agent. Supported agents: `cline`, `aider`, `claude`.
- `agent_command` (optional): Provide a custom command to run your agent. Use `{{TASK_FILE}}` as a placeholder for the task file path.
- `files_to_update`: A list of documentation files and directories to keep updated.
- `exclude`: A list of file patterns to ignore.

## Usage

After committing code, Keeper creates a task file and (in `auto` mode) calls your configured AI agent.
