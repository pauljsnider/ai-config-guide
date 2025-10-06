# Cursor Workspace Settings

Cursor merges global preferences with project-level `.cursor/settings.json`. The file accepts VS Code–style settings along with `mcp.servers` entries.

## Examples in the Wild

- [ArcadeAI/arcade-mcp](https://github.com/ArcadeAI/arcade-mcp/blob/d7107c107d941c0756e74496345742001bb68461/libs/arcade-mcp-server/docs/clients/cursor.md) documents `mcp.servers` configuration blocks.
- [matcharr/code-snippet-manager](https://github.com/matcharr/code-snippet-manager/blob/fe3d2e8feba407143f6fc374c366c8e4922f62dd/.cursor/settings.json) combines formatter preferences with TypeScript SDK overrides.

## Common Keys

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "typescript.tsdk": "node_modules/typescript/lib",
  "mcp.servers": {
    "project-tools": {
      "command": "python",
      "args": ["-m", "arcade_mcp", "stdio"],
      "cwd": "${workspaceFolder}",
      "env": {
        "ARCADE_API_KEY": "${env:ARCADE_API_KEY}"
      }
    }
  }
}
```

### Path Tokens

Settings support VS Code tokens such as `${workspaceFolder}` and `${env:VAR_NAME}`, which makes it straightforward to reference environment variables without committing secrets.

## Placement

- **Global:** `~/Library/Application Support/Cursor/User/settings.json` (macOS) or the equivalent platform directory.
- **Project:** `./.cursor/settings.json`

The workspace file is ideal for sharing formatter defaults, TypeScript SDK selection, and per-project MCP servers with your team.

See [example-settings.json](./example-settings.json) for a baseline template you can copy into your repository.
