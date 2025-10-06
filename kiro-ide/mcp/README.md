# Kiro IDE - MCP Server Configuration Guide

This guide helps you set up Model Context Protocol (MCP) servers for Kiro IDE.

## Table of Contents

- [What is MCP?](#what-is-mcp)
- [Prerequisites](#prerequisites)
- [MCP Servers Overview](#mcp-servers-overview)
- [Installation & Setup](#installation--setup)
  - [Quick Install (Automated)](#quick-install-automated)
  - [Manual Installation](#manual-installation)
- [MCP Server Configuration](#mcp-server-configuration)
- [Credential Setup](#credential-setup)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)

---

## What is MCP?

Model Context Protocol (MCP) is an open standard that enables AI systems to securely connect to external data sources and tools. For Kiro IDE, MCP servers provide access to:

- **Memory systems** - Persistent conversation context
- **Web content** - Fetch and process web pages
- **Browser automation** - Control browsers with Playwright
- **Version control** - Git repository operations
- **External services** - Atlassian, Docker, and more

**Benefits:**
- Standardized integration across AI tools
- Secure, sandboxed access to external resources
- Extensible architecture for custom tools

---

## Prerequisites

### Kiro IDE

**System Requirements:**
- Windows, macOS, or Linux
- Internet connection for initial setup

**Installation:**
1. Visit https://kiro.dev/downloads/
2. Download installer for your platform
3. Install and launch Kiro IDE
4. Login with your account (GitHub, Google, AWS Builder ID, or AWS IAM Identity Center)

**Note:** Kiro is currently in Public Preview.

### Node.js and Package Managers

Most MCP servers require Node.js and package managers:

**Node.js:**
```bash
# macOS (Homebrew)
brew install node

# Ubuntu/Debian
sudo apt install nodejs npm

# Windows (download from)
# https://nodejs.org/
```

**Python (for uvx/pipx):**
```bash
# macOS
brew install python

# Ubuntu/Debian
sudo apt install python3 python3-pip

# Install uvx
pip3 install uvx
```

---

## MCP Servers Overview

The following MCP servers are configured in this setup:

| Server | Description | Requires Auth |
|--------|-------------|---------------|
| **Memory** | Persistent conversation memory using knowledge graphs | No |
| **Fetch** | Web content retrieval and HTML to markdown conversion | No |
| **Playwright** | Browser automation and web testing | No |
| **Bitbucket** | Atlassian Bitbucket repository integration | Yes |
| **Atlassian** | Jira, Confluence, and other Atlassian services | Yes |
| **Docker Gateway** | Docker container management | No |

---

## Installation & Setup

### Quick Install (Automated)

Use the provided installation script to automatically install the MCP configuration:

```bash
# Navigate to the mcp directory
cd kiro-ide/mcp

# Run the installation script
./install-mcp.sh
```

**What the script does:**
- Detects if Kiro IDE is installed
- Creates `~/.kiro/settings/` directory if needed
- Creates timestamped backup of existing `mcp.json` (e.g., `mcp.json.backup.20251004_213008`)
- Copies the `mcp.json` configuration to `~/.kiro/settings/`
- Provides color-coded status messages

**After installation:**
1. Review the installed `mcp.json` file
2. Update any placeholder values (credentials, paths, etc.)
3. Restart Kiro IDE

### Manual Installation

If you prefer to install manually or customize the configuration:

**Configuration File Location:**
- `~/.kiro/settings/mcp.json`

**Manual Installation Steps:**
1. Create directory: `mkdir -p ~/.kiro/settings`
2. Create or edit `~/.kiro/settings/mcp.json`
3. Copy the configuration from `mcp.json` in this directory
4. Update placeholder values (credentials, etc.)
5. Restart Kiro IDE

**Complete Configuration Example:**

```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "disabled": false,
      "autoApprove": []
    },
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"],
      "disabled": false,
      "autoApprove": []
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp"],
      "disabled": false,
      "autoApprove": []
    },
    "bitbucket": {
      "command": "npx",
      "args": ["-y", "@aashari/mcp-server-atlassian-bitbucket"],
      "env": {
        "ATLASSIAN_BITBUCKET_USERNAME": "your_bitbucket_username",
        "ATLASSIAN_BITBUCKET_APP_PASSWORD": "your_bitbucket_pat_key"
      },
      "disabled": false,
      "autoApprove": []
    },
    "atlassian": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.atlassian.com/v1/sse"],
      "env": {
        "ATLASSIAN_USER_EMAIL": "your.email@company.com",
        "ATLASSIAN_API_TOKEN": "your_scoped_api_token"
      },
      "disabled": false,
      "autoApprove": []
    },
    "docker-gateway": {
      "command": "docker",
      "args": ["mcp", "gateway", "run"],
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

---

## MCP Server Configuration

### 1. Memory Server

**Description:** Persistent conversation memory using knowledge graphs

**Installation:**
```bash
npx -y @modelcontextprotocol/server-memory
```

**Configuration:**
```json
{
  "memory": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-memory"],
    "disabled": false,
    "autoApprove": []
  }
}
```

**Use Cases:**
- Remember previous conversations
- Build knowledge graph of project context
- Maintain persistent entities and relationships
- Cross-session context retention

**Tools Provided:**
- `create_entities` - Create knowledge graph entities
- `create_relations` - Link entities together
- `search_nodes` - Query knowledge graph
- `read_graph` - View entire graph

---

### 2. Fetch Server

**Description:** Web content retrieval and HTML to markdown conversion

**Installation:**
```bash
# Install uvx first
pip3 install uvx

# Test fetch server
uvx mcp-server-fetch
```

**Configuration:**
```json
{
  "fetch": {
    "command": "uvx",
    "args": ["mcp-server-fetch"],
    "disabled": false,
    "autoApprove": []
  }
}
```

**Use Cases:**
- Fetch web page content
- Convert HTML to markdown
- Research documentation
- Access API documentation
- Read blog posts and articles

**Tools Provided:**
- `fetch` - Retrieve and convert web content

---

### 3. Playwright Server

**Description:** Browser automation and web testing

**Installation:**
```bash
npx -y @playwright/mcp
```

**Configuration:**
```json
{
  "playwright": {
    "command": "npx",
    "args": ["-y", "@playwright/mcp"],
    "disabled": false,
    "autoApprove": []
  }
}
```

**Use Cases:**
- Automated browser testing
- Web scraping
- UI interaction automation
- Screenshot capture
- Form filling and submission

**Tools Provided:**
- `browser_navigate` - Navigate to URLs
- `browser_click` - Click elements
- `browser_type` - Type into inputs
- `browser_snapshot` - Capture page state
- `browser_take_screenshot` - Take screenshots

---

### 4. Bitbucket Server

**Description:** Atlassian Bitbucket repository integration

**Installation:**
```bash
npx -y @aashari/mcp-server-atlassian-bitbucket
```

**Configuration:**
```json
{
  "bitbucket": {
    "command": "npx",
    "args": ["-y", "@aashari/mcp-server-atlassian-bitbucket"],
    "env": {
      "ATLASSIAN_BITBUCKET_USERNAME": "your_bitbucket_username",
      "ATLASSIAN_BITBUCKET_APP_PASSWORD": "your_app_password"
    },
    "disabled": false,
    "autoApprove": []
  }
}
```

**Credential Setup:**
1. Go to Bitbucket Settings → App passwords
2. Create new app password with repository permissions
3. Update `ATLASSIAN_BITBUCKET_USERNAME` and `ATLASSIAN_BITBUCKET_APP_PASSWORD`

**Use Cases:**
- Repository management
- Pull request operations
- Branch management
- Code review

---

### 5. Atlassian Server

**Description:** Jira, Confluence, and other Atlassian services integration

**Installation:**
```bash
npx -y mcp-remote https://mcp.atlassian.com/v1/sse
```

**Configuration:**
```json
{
  "atlassian": {
    "command": "npx",
    "args": ["-y", "mcp-remote", "https://mcp.atlassian.com/v1/sse"],
    "env": {
      "ATLASSIAN_USER_EMAIL": "your.email@company.com",
      "ATLASSIAN_API_TOKEN": "your_api_token"
    },
    "disabled": false,
    "autoApprove": []
  }
}
```

**Credential Setup:**
1. Go to https://id.atlassian.com/manage-profile/security/api-tokens
2. Create API token
3. Update `ATLASSIAN_USER_EMAIL` and `ATLASSIAN_API_TOKEN`

**Use Cases:**
- Jira issue management
- Confluence page editing
- Project tracking
- Sprint planning

---

### 6. Docker Gateway Server

**Description:** Docker container management via Docker Desktop

**Requirements:**
- Docker Desktop with MCP Gateway support

**Installation:**
```bash
# No installation needed - uses Docker Desktop
docker mcp gateway run
```

**Configuration:**
```json
{
  "docker-gateway": {
    "command": "docker",
    "args": ["mcp", "gateway", "run"],
    "disabled": false,
    "autoApprove": []
  }
}
```

**Use Cases:**
- Container management
- Image operations
- Network configuration
- Volume management
- Access to 100+ MCP servers

---

## Credential Setup

### Environment Variables

Store credentials securely using environment variables:

**macOS/Linux (`~/.zshrc` or `~/.bashrc`):**
```bash
export ATLASSIAN_USER_EMAIL="your.email@company.com"
export ATLASSIAN_API_TOKEN="your_api_token"
export ATLASSIAN_BITBUCKET_USERNAME="your_username"
export ATLASSIAN_BITBUCKET_APP_PASSWORD="your_app_password"
```

**Windows (PowerShell):**
```powershell
$env:ATLASSIAN_USER_EMAIL="your.email@company.com"
$env:ATLASSIAN_API_TOKEN="your_api_token"
```

### MCP Configuration

Reference environment variables in `mcp.json`:

```json
{
  "atlassian": {
    "env": {
      "ATLASSIAN_USER_EMAIL": "your.email@company.com",
      "ATLASSIAN_API_TOKEN": "your_api_token"
    }
  }
}
```

---

## Troubleshooting

### MCP Server Not Working

**Verify configuration:**
```bash
# Check JSON syntax
jq . ~/.kiro/settings/mcp.json

# Check file location
ls ~/.kiro/settings/
```

**Test server manually:**
```bash
# Test memory server
npx -y @modelcontextprotocol/server-memory

# Test fetch server
uvx mcp-server-fetch

# Test playwright
npx -y @playwright/mcp
```

**Restart Kiro IDE:**
- Close Kiro IDE completely
- Restart the application
- Check if MCP servers are loaded

### Common Issues

**Command not found:**
- Install Node.js: `brew install node`
- Install Python/uvx: `pip3 install uvx`
- Verify installations: `node --version`, `python3 --version`

**Permission denied:**
```bash
# Fix permissions
chmod +x install-mcp.sh
```

**Environment variables not loading:**
- Restart terminal after setting variables
- Verify with: `echo $ATLASSIAN_API_TOKEN`
- Check Kiro IDE has access to environment

---

## Additional Resources

### Official Documentation

**Kiro IDE:**
- Website: https://kiro.dev/
- Documentation: https://kiro.dev/docs/
- Downloads: https://kiro.dev/downloads/

**MCP Protocol:**
- Specification: https://modelcontextprotocol.io/
- Server Directory: https://github.com/modelcontextprotocol/servers
- Documentation: https://modelcontextprotocol.io/docs

### MCP Server Repositories

- Memory: https://github.com/modelcontextprotocol/servers/tree/main/src/memory
- Fetch: https://github.com/modelcontextprotocol/servers/tree/main/src/fetch
- Playwright: https://github.com/microsoft/playwright-mcp
- Bitbucket: https://github.com/aashari/mcp-server-atlassian-bitbucket
- Atlassian: https://developer.atlassian.com/platform/model-context-protocol/
- Docker Gateway: https://docs.docker.com/desktop/mcp/

### Related Guides

- [Kiro IDE Overview](../README.md)
- [Hooks Configuration](../hooks/README.md)
- [Amazon Q CLI MCP Guide](../../amazon-q-cli/mcp/README.md)

---

**Last Updated:** 2025-10-04

**Note:** All configuration examples use placeholder values. Replace with your actual credentials and settings.
