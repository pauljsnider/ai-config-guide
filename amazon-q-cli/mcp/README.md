# Amazon Q CLI - MCP Server Configuration Guide

This guide helps you set up Model Context Protocol (MCP) servers for Amazon Q CLI.

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

Model Context Protocol (MCP) is an open standard that enables AI systems to securely connect to external data sources and tools. For Amazon Q CLI, MCP servers provide access to:

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

### Amazon Q CLI

**System Requirements:**
- macOS, Linux (Ubuntu/Debian), or Windows
- Internet connection for initial setup

**Installation Options:**

**macOS:**
```bash
# Option 1: Direct Download
# Download from: https://desktop-release.q.us-east-1.amazonaws.com/latest/Amazon%20Q.dmg
# Then drag to Applications folder

# Option 2: Homebrew
brew install --cask amazon-q
```

**Ubuntu/Debian:**
```bash
wget https://desktop-release.q.us-east-1.amazonaws.com/latest/amazon-q.deb
sudo dpkg -i amazon-q.deb
sudo apt-get install -f
```

**Linux (AppImage):**
```bash
wget https://desktop-release.q.us-east-1.amazonaws.com/latest/amazon-q.appimage
chmod +x amazon-q.appimage
./amazon-q.appimage
```

**Authentication:**
- AWS Builder ID (recommended for individual developers)
- AWS IAM Identity Center (for organizations)

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

Use the provided installation script to automatically install the MCP configuration for Amazon Q CLI:

```bash
# Navigate to the mcp directory
cd amazon-q-cli/mcp

# Run the installation script
./install-mcp.sh
```

**What the script does:**
- Detects if Amazon Q CLI is installed
- Creates timestamped backup of existing `mcp.json` (e.g., `mcp.json.backup.20251004_213008`)
- Copies the `mcp.json` configuration to `~/.aws/amazonq/`
- Provides color-coded status messages

**After installation:**
1. Review the installed `mcp.json` file at `~/.aws/amazonq/mcp.json`
2. Update any placeholder values (credentials, paths, etc.)
3. Restart Amazon Q CLI

### Manual Installation

If you prefer to install manually or customize the configuration:

**Configuration File Location:**
- `~/.aws/amazonq/mcp.json`

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
        "ATLASSIAN_USER_EMAIL": "your.email@company.com",
        "ATLASSIAN_API_TOKEN": "your_scoped_api_token"
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

**Manual Installation Steps:**
1. Create or edit `~/.aws/amazonq/mcp.json`
2. Copy the configuration from `mcp.json` in this directory
3. Update placeholder values (credentials, etc.)
4. Restart Amazon Q CLI

**Verification:**
```bash
# Check Amazon Q is installed
q --help

# Run diagnostics
q doctor
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
    "env": {
      "MEMORY_FILE_PATH": "/path/to/custom/memory.json"
    }
  }
}
```

**Documentation:**
- GitHub: https://github.com/modelcontextprotocol/servers/tree/main/src/memory
- Package: `@modelcontextprotocol/server-memory`

---

### 2. Fetch Server

**Description:** Web content retrieval and HTML to markdown conversion

**Installation:**
```bash
# Recommended: Using uvx
uvx mcp-server-fetch

# Alternative: Using pip
pip install mcp-server-fetch
python -m mcp_server_fetch
```

**Configuration:**
```json
{
  "fetch": {
    "command": "uvx",
    "args": ["mcp-server-fetch"]
  }
}
```

**Documentation:**
- GitHub: https://github.com/modelcontextprotocol/servers/tree/main/src/fetch
- Package: `mcp-server-fetch`

---

### 3. Playwright Server

**Description:** Browser automation and web testing capabilities

**Installation:**
```bash
npx @playwright/mcp@latest
```

**Configuration:**
```json
{
  "playwright": {
    "command": "npx",
    "args": ["@playwright/mcp@latest"]
  }
}
```

**Documentation:**
- GitHub: https://github.com/microsoft/playwright-mcp
- Package: `@playwright/mcp`

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
      "ATLASSIAN_USER_EMAIL": "your.email@company.com",
      "ATLASSIAN_API_TOKEN": "your_scoped_api_token"
    }
  }
}
```

**Requires Credentials:** See [Bitbucket Credentials](#bitbucket-credentials) section

**Documentation:**
- GitHub: https://github.com/aashari/mcp-server-atlassian-bitbucket
- Package: `@aashari/mcp-server-atlassian-bitbucket`

---

### 5. Atlassian Server

**Description:** Remote Atlassian services (Jira, Confluence) via OAuth

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
      "ATLASSIAN_API_TOKEN": "your_scoped_api_token"
    }
  }
}
```

**Requires Credentials:** OAuth authentication via web browser on first use

**Documentation:**
- Official: https://support.atlassian.com/atlassian-rovo-mcp-server/
- Package: `mcp-remote`

---

### 6. Docker Gateway

**Description:** Docker container management via MCP

**Prerequisites:**
- Docker Desktop with MCP enabled (Settings → Beta Features → Enable "Docker MCP Toolkit")

**Installation:**
```bash
# Initialize Docker MCP catalog
docker mcp catalog init

# Enable specific servers (optional)
docker mcp server enable google-maps brave
```

**Configuration:**
```json
{
  "docker-gateway": {
    "command": "docker",
    "args": ["mcp", "gateway", "run"]
  }
}
```

**Documentation:**
- GitHub: https://github.com/docker/mcp-gateway
- Docs: https://docs.docker.com/ai/mcp-gateway/

---

## Credential Setup

### Bitbucket Credentials

**⚠️ IMPORTANT:** Bitbucket App Passwords are deprecated and will be removed by **June 2026**. Use **Scoped API Tokens** for new setups.

**Recommended: Scoped API Token**

1. Go to https://id.atlassian.com/manage-profile/security/api-tokens
2. Click **"Create API token with scopes"**
3. Select **"Bitbucket"** as the product
4. Choose scopes:
   - **Read-only**: `repository`, `workspace`
   - **Full access**: `repository`, `workspace`, `pullrequest`
5. Copy the token (starts with `ATATT`)
6. Use with your Atlassian email

**Environment Variables:**
```bash
export ATLASSIAN_USER_EMAIL="your.email@company.com"
export ATLASSIAN_API_TOKEN="ATATT3xFfGF0..."
```

**Legacy: App Password (deprecated)**

1. Go to https://bitbucket.org/account/settings/app-passwords/
2. Click "Create app password"
3. Select permissions:
   - Workspaces: Read
   - Repositories: Read (+ Write for PRs/comments)
   - Pull Requests: Read (+ Write for PR management)

**Environment Variables:**
```bash
export ATLASSIAN_BITBUCKET_USERNAME="your_username"
export ATLASSIAN_BITBUCKET_APP_PASSWORD="your_app_password"
```

### Atlassian OAuth Credentials

The Atlassian MCP server uses OAuth 2.1 authentication. On first use:

1. Run the MCP server
2. A browser window will open for authentication
3. Log in with your Atlassian account
4. Grant permissions to the MCP server
5. Credentials are cached automatically

**Required:** Atlassian Cloud account with access to Jira/Confluence

---

## Troubleshooting

### Amazon Q CLI Issues

**Check Installation:**
```bash
q doctor
```

**Common Issues:**
- **Authentication failures:** Run `q login` to re-authenticate
- **Autocomplete not working:** Ensure shell integration is enabled
- **Command not found:** Add Amazon Q to your PATH

**Diagnostics:**
```bash
# Re-authenticate
q login

# Report issues
q issue
```

### Kiro IDE Issues

**MCP Server Not Loading:**
1. Verify configuration file syntax (valid JSON)
2. Check file location: `~/.kiro/settings/mcp.json`
3. Restart Kiro IDE
4. Check IDE logs for errors

**Shell Integration:**
- Ensure shell integration was enabled during first run
- Allows agents to execute commands

### MCP Server Issues

**Memory Server:**
```bash
# Test installation
npx -y @modelcontextprotocol/server-memory --version
```

**Fetch Server:**
```bash
# Test installation
uvx mcp-server-fetch --help
```

**Playwright:**
```bash
# Test installation
npx @playwright/mcp@latest --help
```

**Bitbucket:**
```bash
# Test credentials
npx -y @aashari/mcp-server-atlassian-bitbucket ls-workspaces
```

**Docker Gateway:**
```bash
# Verify Docker MCP is enabled
docker mcp catalog init
```

---

## Additional Resources

**Amazon Q CLI:**
- Official Documentation: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line.html
- GitHub Repository: https://github.com/aws/amazon-q-developer-cli
- Installation Guide: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-installing.html
- Command Reference: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-reference.html

**MCP Protocol:**
- MCP Specification: https://modelcontextprotocol.io/
- Server Directory: https://github.com/modelcontextprotocol/servers
- Documentation: https://modelcontextprotocol.io/docs

**MCP Server Repositories:**
- Memory: https://github.com/modelcontextprotocol/servers/tree/main/src/memory
- Fetch: https://github.com/modelcontextprotocol/servers/tree/main/src/fetch
- Playwright: https://github.com/microsoft/playwright-mcp
- Bitbucket: https://github.com/aashari/mcp-server-atlassian-bitbucket
- Atlassian: https://developer.atlassian.com/platform/model-context-protocol/
- Docker Gateway: https://docs.docker.com/desktop/mcp/

**Related Guides:**
- [Amazon Q CLI Overview](../README.md)
- [Agents Configuration](../agents/README.md)
- [Hooks Configuration](../hooks/README.md)
- [Rules Configuration](../rules/README.md)
- [Kiro IDE MCP Guide](../../kiro-ide/mcp/README.md)

---

**Last Updated:** 2025-10-04

**Note:** All configuration examples use placeholder values. Replace with your actual credentials and settings.
