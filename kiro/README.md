# Kiro Setup Guide for Windows

## Quickstart (5 minutes)

```powershell
# 1. Install Kiro from https://kiro.dev/downloads/

# 2. Install prerequisites
winget install OpenJS.NodeJS.LTS
winget install GitHub.cli

# 3. Authenticate GitHub
gh auth login

# 4. Copy MCP config
mkdir ~\.kiro\settings
copy settings\mcp.json ~\.kiro\settings\

# 5. Copy steering files
mkdir ~\.kiro\steering
copy steering\*.md ~\.kiro\steering\

# 6. Copy agents and hooks
mkdir ~\.kiro\agents
mkdir ~\.kiro\hooks
copy agents\*.json ~\.kiro\agents\
copy hooks\*.json ~\.kiro\hooks\

# 7. Install Playwright browsers
npx playwright install chromium
```

Restart Kiro - you're ready to go!

---

## Install Kiro

Download and install Kiro from: [kiro.dev/downloads](https://kiro.dev/downloads/)

---

## Option 1: Install GitHub CLI

The easiest way to authenticate with GitHub on Windows.

### Install

```powershell
# Using Winget (recommended)
winget install GitHub.cli

# Or using Scoop
scoop install gh

# Or using Chocolatey
choco install gh
```

Or download the `.msi` installer from [cli.github.com](https://cli.github.com/)

### Authenticate

```powershell
gh auth login
```

Follow the browser prompts to complete authentication.

### Get Your Token

```powershell
gh auth token
```

This prints your current token for use in MCP configuration.

---

## Option 2: Setup GitHub MCP Server (stdio)

Run the official GitHub MCP server locally on Windows.

### Prerequisites

- Go installed (`winget install GoLang.Go`)
- GitHub Personal Access Token (from Option 1 or [github.com/settings/tokens](https://github.com/settings/tokens))

### Install the Server

```powershell
go install github.com/github/github-mcp-server/cmd/github-mcp-server@latest
```

This installs to `%USERPROFILE%\go\bin\github-mcp-server.exe`

### MCP Configuration

Add to your MCP config file (e.g., `~/.claude/mcp.json` for Claude Code):

```json
{
  "mcpServers": {
    "github": {
      "command": "github-mcp-server",
      "args": ["stdio"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_your_token_here"
      }
    }
  }
}
```

### Optional Environment Variables

| Variable | Description |
|----------|-------------|
| `GITHUB_READ_ONLY=1` | Prevent write operations |
| `GITHUB_TOOLSETS="repos,issues,pull_requests"` | Limit which tools are loaded |
| `GITHUB_HOST="https://github.mycompany.com"` | GitHub Enterprise Server URL |

### Restart Your MCP Client

After adding the configuration, restart Claude Code, Cursor, or your MCP client to load the server.

---

## MCP Servers

Pre-configured MCP servers are available in the `settings/` folder:

| MCP | Description |
|-----|-------------|
| **Playwright** | Browser automation for testing and web interactions |
| **Atlassian** | Jira and Confluence access via hosted OAuth server |

Copy `settings/mcp.json` to your Kiro config location:
- User config: `~/.kiro/settings/mcp.json`
- Workspace config: `.kiro/settings/mcp.json`

See [`settings/README.md`](settings/README.md) for setup instructions.

---

## Steering Files

Steering files give Kiro persistent knowledge so you don't have to repeat conventions in every chat. They make responses more consistent and task-focused.

Pre-configured steering files are available in the `steering/` folder:

| File | Description |
|------|-------------|
| **aws-cli.md** | AWS CLI usage and credential handling |
| **atlassian-mcp.md** | Hosted Atlassian MCP setup (Jira/Confluence) |
| **github-cli.md** | Safe, repeatable GitHub CLI workflows |
| **kiro-configuration.md** | Kiro config paths and debug references |
| **tech-debt-rules.md** | Tech debt scoring model and collection rules |

### Install Steering Files

```powershell
# Create steering directory
mkdir ~\.kiro\steering

# Copy steering files
copy steering\*.md ~\.kiro\steering\
```

### How Steering Works

- **Global:** `~/.kiro/steering/` applies to all projects
- **Workspace:** `.kiro/steering/` in a project overrides global
- **Auto-loaded:** `product.md`, `structure.md`, `tech.md` load automatically when present

See [`steering/README.md`](steering/README.md) for details and examples.

---

## Agents

Custom agents extend Kiro CLI with specialized behaviors and prompts.

Pre-configured agents are available in the `agents/` folder:

| Agent | Description |
|-------|-------------|
| **tech-debt-collector** | Guides you through collecting and scoring tech debt from multiple sources |

### Install Agents

```powershell
# Create agents directory
mkdir ~\.kiro\agents

# Copy agent files
copy agents\*.json ~\.kiro\agents\
```

### Using Agents

```powershell
# Start with specific agent
kiro-cli --agent tech-debt-collector

# Or swap during a session
/agent swap

# List available agents
/agent list
```

See [`agents/README.md`](agents/README.md) for configuration details.

---

## Hooks

Hooks are automated triggers that execute agent prompts or shell commands.

Pre-configured hooks are available in the `hooks/` folder:

| Hook | Trigger | Description |
|------|---------|-------------|
| **tech-debt-score** | manual | Scores a project for tech debt |

### Install Hooks

```powershell
# Create hooks directory
mkdir ~\.kiro\hooks

# Copy hook files
copy hooks\*.json ~\.kiro\hooks\
```

See [`hooks/README.md`](hooks/README.md) for configuration details.

---

## Resources

- [GitHub MCP Server Repository](https://github.com/github/github-mcp-server)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Create Personal Access Token](https://github.com/settings/tokens)
