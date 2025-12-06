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

### Custom Domain (Optional)

If you want `dockeeper.dev`:

1. Buy domain from any registrar
2. Add `CNAME` file to `/docs`:

```
dockeeper.dev
```

3. Configure DNS:

```
CNAME: dockeeper.dev → username.github.io
```