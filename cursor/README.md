# Cursor IDE & Cursor Agent – Configuration Guide

Configuration reference for Cursor’s desktop IDE and the `cursor-agent` CLI, covering Model Context Protocol (MCP) setup along with rules, commands, custom agents, and workspace settings.

## Overview

Cursor ships two surfaces that share the same configuration formats:

- **Cursor Agent (CLI):** Installs via the official shell script at `https://cursor.com/install`, placing the binary at `~/.local/bin/cursor-agent`.
- **Cursor IDE:** The desktop editor available at https://cursor.sh/ that consumes the same MCP and rules files.

### Configuration Types

| Configuration | Cursor Agent | Cursor IDE | Description |
|---------------|--------------|------------|-------------|
| **[MCP Servers](./mcp/)** | ✅ | ✅ | JSON registry of external tools in `~/.cursor/mcp.json` or project-level `./.cursor/mcp.json` (documented by community integrations such as [umijs/umi-mcp](https://github.com/umijs/umi-mcp/blob/e46df5906f8e6e788c6aa77b394994cdefe71e1a/README.md) and [ArcadeAI/arcade-mcp](https://github.com/ArcadeAI/arcade-mcp/blob/d7107c107d941c0756e74496345742001bb68461/libs/arcade-mcp-server/docs/clients/cursor.md)) |
| **[Rules](./rules/)** | ✅ | ✅ | `.cursorrules` and `.cursor/rules/*.mdc` project guides used by Cursor AI (see [patrickjs/awesome-cursorrules](https://github.com/patrickjs/awesome-cursorrules) and examples in `.cursor/rules` repositories) |
| **[Commands](./commands/)** | ✅ | ✅ | Slash-style automations stored under `.cursor/commands/*.md` that define multi-step workflows (used across projects like [wisarootl/leetcode-py](https://github.com/wisarootl/leetcode-py/blob/85bbb073e16c2344042071838875d46b75d8f427/.cursor/commands/batch-problem-creation.md)) |
| **[Agents](./agents/)** | ✅ | ✅ | Front-matter driven agents stored in `.cursor/agents/*.mdc` to run background workflows (e.g. [jukangpark/Code_King_Builder](https://github.com/jukangpark/Code_King_Builder/blob/27ad40386a6c9a140f7225e1635ee667c75ed518/.cursor/agents/readme-agent.mdc)) |
| **[Workspace Settings](./settings/)** | ✅ | ✅ | `.cursor/settings.json` for editor preferences and MCP server entries (used by projects such as [matcharr/code-snippet-manager](https://github.com/matcharr/code-snippet-manager/blob/fe3d2e8feba407143f6fc374c366c8e4922f62dd/.cursor/settings.json)) |

## Prerequisites

### Cursor Agent (CLI)

Install and verify the Cursor command-line agent using the official installer script:

```bash
curl https://cursor.com/install -fsSL | bash
cursor-agent --version
```

The installer detects `linux`/`darwin` platforms, downloads a versioned archive (for example `downloads.cursor.com/lab/…/agent-cli-package.tar.gz`), extracts it to `~/.local/share/cursor-agent/versions/<version>`, and symlinks `~/.local/bin/cursor-agent`.

Ensure `~/.local/bin` is on your `PATH` (the installer prints shell-specific instructions).

### Cursor IDE

- Download: https://cursor.sh/ ("Download for macOS" and additional installers are linked from the landing page)
- Sign in with your Cursor account to sync settings between the IDE and the CLI

### Model Context Protocol

Cursor consumes standard MCP JSON definitions. Familiarity with the protocol is helpful when wiring additional servers:

- Specification: https://modelcontextprotocol.io/
- Server directory: https://github.com/modelcontextprotocol/servers

## Quick Start

### 1. Install Cursor Agent

```bash
curl https://cursor.com/install -fsSL | bash
```

### 2. Configure MCP Servers

```bash
cd cursor/mcp
./install-mcp.sh
```

The script backs up any existing `~/.cursor/mcp.json` before copying the reference configuration. Update environment variables (for example Bitbucket credentials) before reloading Cursor.

### 3. Add Project Rules

```bash
cp cursor/rules/example.cursorrules /path/to/project/.cursorrules
```

Extend the template with architecture, style, and workflow guidance specific to your repository. Optional `.cursor/rules/*.mdc` files follow the Markdown-with-front-matter format used across community catalogs such as [cursor.directory](https://cursor.directory/).

### 4. Define Commands and Agents (Optional)

```bash
cp cursor/commands/example-command.md /path/to/project/.cursor/commands/my-command.md
cp cursor/agents/example-agent.mdc /path/to/project/.cursor/agents/my-agent.mdc
```

Commands provide repeatable task checklists, and agents run background routines. Both patterns mirror the community repositories linked above.

### 5. Customize Workspace Settings

```bash
cp cursor/settings/example-settings.json /path/to/project/.cursor/settings.json
```

Add editor preferences or additional `mcp.servers` entries. Cursor merges workspace settings with global preferences when the project opens.

## Directory Layout

```
cursor/
├── README.md                     # Tool overview (this file)
├── mcp/
│   ├── README.md                 # MCP server guide and verification steps
│   ├── mcp.json                  # Example MCP configuration
│   └── install-mcp.sh            # Automated installer with backups
├── rules/
│   ├── README.md                 # .cursorrules and .mdc usage guide
│   └── example.cursorrules       # Project-scoped rule template
├── commands/
│   ├── README.md                 # Command file format and usage
│   └── example-command.md        # Sample Cursor command workflow
├── agents/
│   ├── README.md                 # Background agent configuration guide
│   └── example-agent.mdc         # Sample agent with front matter
└── settings/
    ├── README.md                 # Workspace settings & MCP overrides
    └── example-settings.json     # Sample `.cursor/settings.json`
```

## Additional Resources

- Cursor product overview: https://cursor.sh/
- CLI installer source: https://cursor.com/install
- `.cursorrules` catalog: https://github.com/patrickjs/awesome-cursorrules
- Community MCP & rules directory: https://cursor.directory/

---

**Last Reviewed:** 2025-10-04

All configuration examples include placeholders—replace them with your organization’s actual values.
