# Cursor – MCP Server Configuration

This guide explains how to register Model Context Protocol (MCP) servers for both the Cursor IDE and the `cursor-agent` CLI.

## Configuration Locations

| Scope | Path |
|-------|------|
| Global (all projects) | `~/.cursor/mcp.json` |
| Project workspace | `./.cursor/mcp.json` |

The location and JSON schema are the same ones documented by MCP community projects like [umijs/umi-mcp](https://github.com/umijs/umi-mcp/blob/e46df5906f8e6e788c6aa77b394994cdefe71e1a/README.md).

## Quick Install

Run the helper script to create backups and copy the reference configuration:

```bash
cd cursor/mcp
./install-mcp.sh
```

What the script does:

1. Creates `~/.cursor/` if it does not exist
2. Backs up an existing `mcp.json` to `mcp.json.backup.<timestamp>`
3. Copies `cursor/mcp/mcp.json` into place
4. Prints next steps for editing environment variables and restarting Cursor

## Reference Configuration

`mcp.json` includes three frequently used MCP servers:

```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "env": {
        "MEMORY_FILE_PATH": "~/.cursor/memory.json"
      }
    },
    "docker-gateway": {
      "command": "docker",
      "args": ["mcp", "gateway", "run"]
    },
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"]
    }
  }
}
```

- **Memory:** Persistent knowledge graph storage (ships with the official MCP server collection)
- **Docker Gateway:** Bridges Docker containers as MCP integrations (shipped as part of `docker mcp gateway`)
- **Playwright:** Enables browser automation via the [@playwright/mcp](https://www.npmjs.com/package/@playwright/mcp) server

Adjust paths, environment variables, or add additional servers to suit your workflow.

## Validation

1. **Check JSON syntax:**
   ```bash
   jq . ~/.cursor/mcp.json
   ```
2. **Verify the CLI sees MCP config:**
   ```bash
   cursor-agent --help
   ```
3. **Ensure Docker-based servers are running when invoked:**
   ```bash
   docker ps | grep mcp
   ```

Restart the Cursor IDE (or re-run `cursor-agent`) after making changes.

## Additional Resources

- MCP Spec: https://modelcontextprotocol.io/
- Community server directory: https://github.com/modelcontextprotocol/servers
- Cursor installer script (for reference): https://cursor.com/install
