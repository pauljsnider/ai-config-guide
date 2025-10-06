# Amazon Q Developer for VS Code - Configuration Guide

Comprehensive configuration guide for Amazon Q Developer VS Code extension covering MCP servers, inline completions, and advanced features.

## Overview

Amazon Q Developer for VS Code is AWS's AI-powered coding assistant that integrates directly into Visual Studio Code. This guide provides complete configuration documentation for the extension.

## What is Amazon Q Developer for VS Code?

Amazon Q Developer for VS Code provides:
- **Inline code completion** - Real-time code suggestions as you type
- **AI-powered chat** - Natural language coding assistance with @workspace context
- **Feature development** - Generate entire features from natural language
- **Security scanning** - Identify and fix security vulnerabilities
- **Code transformation** - Upgrade code versions and refactor
- **Test generation** - Create unit tests with /test command
- **MCP integration** - Connect to external tools and data sources

**Platform:** Visual Studio Code on Windows, macOS, and Linux

## Configuration Types

| Configuration | Description | Location |
|--------------|-------------|----------|
| **[MCP Servers](#mcp-servers)** | External tool and data source integration | `~/.aws/amazonq/default.json` or `mcp.json` |
| **[Inline Completions](#inline-completions)** | Code suggestion settings | VS Code settings |
| **[Chat Settings](#chat-settings)** | Chat panel configuration | VS Code settings |
| **[Security Scanning](#security-scanning)** | Vulnerability detection settings | VS Code settings |

## Quick Start

### Prerequisites

- **Visual Studio Code** - Latest version recommended
- **AWS Builder ID** or **AWS IAM Identity Center** account
- **Internet connection** for initial setup

### Installation

1. **Install from VS Code Marketplace:**
   ```
   1. Open VS Code
   2. Go to Extensions (Ctrl+Shift+X / Cmd+Shift+X)
   3. Search for "Amazon Q"
   4. Click Install on "Amazon Q" by Amazon Web Services
   ```

   Or visit: https://marketplace.visualstudio.com/items?itemName=AmazonWebServices.amazon-q-vscode

2. **Authenticate:**
   ```
   1. Click "Amazon Q" in the status bar
   2. Choose authentication method:
      - AWS Builder ID (recommended for individuals)
      - AWS IAM Identity Center (for organizations)
   3. Complete authentication in browser
   ```

3. **Verify Installation:**
   - Amazon Q icon appears in VS Code sidebar
   - Chat panel is accessible
   - Inline suggestions work in code files

### Basic Setup

1. **Configure MCP Servers** (optional)
   - See [MCP Servers section](#mcp-servers)
   - Use GUI or edit `~/.aws/amazonq/default.json`

2. **Customize Settings** (optional)
   - Open VS Code Settings (Ctrl+,  / Cmd+,)
   - Search for "Amazon Q"
   - Adjust inline completion and chat settings

3. **Start Coding**
   - Open a file and start typing for inline suggestions
   - Open Chat panel for AI assistance
   - Use @workspace for project-wide context

---

## MCP Servers

Amazon Q Developer for VS Code **shares MCP configuration with Amazon Q CLI**. MCP servers extend the extension's capabilities by connecting to external tools and data sources.

### Configuration Location

**Recommended (Current):**
- Global: `~/.aws/amazonq/default.json`
- Workspace: `.amazonq/default.json`

**Legacy (Supported):**
- Global: `~/.aws/amazonq/mcp.json`
- Workspace: `.amazonq/mcp.json`

**Note:** The `default.json` file is the current standard. Legacy `mcp.json` files are still supported when `useLegacyMcpJson` is set to `true` in the global `default.json`.

### Configuration Methods

#### Method 1: GUI Configuration (Recommended)

**Access MCP Configuration UI:**

1. Open VS Code
2. Open Amazon Q panel (sidebar icon)
3. Open Chat panel
4. Click the **tools icon** (⚙️)

**Add MCP Server:**

1. Click the **plus (+)** symbol
2. Select scope:
   - **Global** - Available across all projects
   - **Local** - Available in current workspace only
3. Enter MCP server details (see examples below)
4. Click **Save**
5. Review and adjust tool permissions

**Tool Permissions:**
- **Ask** - Prompt each time the tool is used
- **Always allow** - Run without prompting
- **Deny** - Do not use this tool

#### Method 2: Manual Configuration

**Edit Configuration File:**

Global configuration:
```bash
# macOS/Linux
~/.aws/amazonq/default.json

# Windows
%USERPROFILE%\.aws\amazonq\default.json
```

Workspace configuration:
```bash
{workspace}/.amazonq/default.json
```

**Example Configuration:**

```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "transport": "stdio",
      "disabled": false,
      "autoApprove": []
    },
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"],
      "transport": "stdio",
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

### MCP Server Examples

#### STDIO Transport Example (Memory Server)

**GUI Configuration:**

1. **Name:** `memory`
2. **Transport:** `stdio`
3. **Command:** `npx`
4. **Arguments:**
   - `-y`
   - `@modelcontextprotocol/server-memory`
5. **Environment Variables:** (optional)
   - Name: `MEMORY_FILE_PATH`
   - Value: `/path/to/memory.json`
6. **Timeout:** `60` seconds

**Manual Configuration:**

```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "transport": "stdio",
      "env": {
        "MEMORY_FILE_PATH": "/path/to/memory.json"
      },
      "timeout": 60,
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

#### HTTP Transport Example (Atlassian)

**GUI Configuration:**

1. **Name:** `atlassian`
2. **Transport:** `http`
3. **URL:** `https://mcp.atlassian.com/v1/sse`
4. **Headers:** (optional)
   - Key: `Authorization`
   - Value: `Bearer {token}`
5. **Timeout:** `60` seconds

**Manual Configuration:**

```json
{
  "mcpServers": {
    "atlassian": {
      "transport": "http",
      "url": "https://mcp.atlassian.com/v1/sse",
      "headers": {
        "Authorization": "Bearer your-token-here"
      },
      "timeout": 60,
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

**Note:** HTTP servers requiring authorization will automatically open a browser for OAuth flow.

#### AWS Documentation MCP Server

**GUI Configuration:**

1. **Name:** `aws-documentation`
2. **Transport:** `stdio`
3. **Command:** `uvx`
4. **Arguments:**
   - `awslabs.aws-documentation-mcp-server@latest`
5. **Environment Variables:**
   - Name: `FASTMCP_LOG_LEVEL`
   - Value: `ERROR`
   - Name: `AWS_DOCUMENTATION_PARTITION`
   - Value: `aws`
6. **Timeout:** `60` seconds

**Manual Configuration:**

```json
{
  "mcpServers": {
    "aws-documentation": {
      "command": "uvx",
      "args": ["awslabs.aws-documentation-mcp-server@latest"],
      "transport": "stdio",
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR",
        "AWS_DOCUMENTATION_PARTITION": "aws"
      },
      "timeout": 60,
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

### Shared MCP Servers with CLI

**Amazon Q VS Code extension and Amazon Q CLI share the same MCP configuration files.**

**What this means:**
- MCP servers configured in VS Code are available in CLI
- MCP servers configured in CLI are available in VS Code
- Use the same installation script for both tools
- Manage all MCP servers from one location

**Installation Script:**

```bash
# Use the shared MCP installation script
cd amazon-q-cli/mcp
./install-mcp.sh

# This installs MCP configuration for both:
# - Amazon Q CLI: ~/.aws/amazonq/mcp.json
# - Amazon Q VS Code: ~/.aws/amazonq/mcp.json (same file)
```

### Managing MCP Servers

**Enable Server:**

1. Open MCP Servers panel (tools icon in Chat)
2. Find disabled server
3. Click **Enable**

**Disable Server:**

1. Open MCP Servers panel
2. Click on server name
3. Click three dots next to "Edit setup"
4. Choose **Disable MCP Server**

**Delete Server:**

1. Open MCP Servers panel
2. Click on server name (if enabled) or **Delete** button (if disabled)
3. For enabled servers: Click three dots → **Delete MCP server**
4. Confirm deletion

**Edit Server:**

1. Open MCP Servers panel
2. Click on server name
3. Click **Edit setup**
4. Make changes
5. Click **Save**

### Troubleshooting MCP

**Connection Issues:**

If an alert appears at the top of the MCP panel:
1. Click **Fix Configuration**
2. Review server settings
3. Check command/URL is correct
4. Verify environment variables
5. Test server independently

**Common Issues:**

**Server not connecting:**
- Verify command is executable (`which npx`, `which uvx`)
- Check environment variables are set correctly
- Ensure server package is installed
- Review timeout settings

**Windows-specific issues:**
- Amazon Q runs using PowerShell
- Ensure PowerShell can access commands like `uvx`
- May need to add commands to PowerShell PATH
- Consider using full paths to executables

**Tools not appearing:**
- Restart VS Code after configuration changes
- Check server is enabled (not disabled)
- Verify tool permissions are not set to "Deny"
- Review connection alerts in MCP panel

---

## Inline Completions

Configure how Amazon Q provides inline code suggestions as you type.

### Accessing Settings

1. Open VS Code Settings (Ctrl+, / Cmd+,)
2. Search for "Amazon Q"
3. Navigate to completion-related settings

### Key Settings

**Enable/Disable Inline Suggestions:**
- Setting: `amazonQ.inlineSuggestions.enabled`
- Default: `true`
- Description: Turn inline code suggestions on or off

**Auto-Trigger Suggestions:**
- Setting: `amazonQ.inlineSuggestions.autoTrigger`
- Default: `true`
- Description: Automatically show suggestions as you type

**Suggestion Delay:**
- Setting: `amazonQ.inlineSuggestions.delay`
- Default: `300` ms
- Description: Delay before showing suggestions after typing stops

**Code Reference Tracking:**
- Setting: `amazonQ.codeReference.enabled`
- Default: `true`
- Description: Show references when suggestions match public code

### Accepting Suggestions

**Keyboard Shortcuts:**
- **Tab** - Accept entire suggestion
- **Ctrl+→** / **Cmd+→** - Accept word-by-word
- **Esc** - Reject suggestion

**Configure Keybindings:**

1. Open Keyboard Shortcuts (Ctrl+K Ctrl+S / Cmd+K Cmd+S)
2. Search for "Amazon Q"
3. Customize keybindings as needed

### Suggestion Types

**Single-line Completion:**
- Completes current line based on context
- Triggered automatically as you type

**Block Completion:**
- Suggests entire code blocks (if/for/while/try)
- Completes functions and classes

**Comment-to-Code:**
- Generates code from natural language comments
- Example:
  ```python
  # Create a function to calculate fibonacci numbers
  # [Amazon Q generates the function]
  ```

### Customization for Teams

**Amazon Q Developer Pro users can:**
- Customize suggestions to team libraries
- Enforce coding standards
- Use organizational style guides

See AWS documentation for Pro customization features.

---

## Chat Settings

Configure the Amazon Q chat panel for AI-assisted development.

### Accessing Chat

**Open Chat Panel:**
- Click Amazon Q icon in sidebar
- Use keyboard shortcut (varies by configuration)
- Command Palette: "Amazon Q: Open Chat"

### Chat Features

**@workspace Context:**
- Add `@workspace` to include all project files in context
- Example: `@workspace explain how authentication works`
- Provides project-wide understanding

**Slash Commands:**

| Command | Description |
|---------|-------------|
| `/dev` | Develop a new feature |
| `/test` | Generate unit tests |
| `/review` | Review code for issues |
| `/doc` | Generate documentation |
| `/fix` | Fix code issues |
| `/transform` | Transform/upgrade code |

**Example:**
```
/test generate tests for the authentication module
```

**Chat History:**
- Conversations persist between sessions
- Export transcripts in Markdown or HTML
- Search conversation history
- Click export icon in chat panel

### VS Code Settings

**Chat Panel Position:**
- Setting: `amazonQ.chatPanel.position`
- Options: `sidebar`, `panel`, `editor`
- Default: `sidebar`

**Context Limits:**
- Automatically managed by Amazon Q
- Increased context limits in recent updates
- Workspace context may have limits on very large projects

---

## Security Scanning

Amazon Q Developer automatically scans your code for security vulnerabilities.

### Automatic Scanning

**Triggers:**
- On file save
- Before commit (if configured)
- On-demand via command palette

**Scan Coverage:**
- Security vulnerabilities
- Code quality issues
- Best practice violations
- AWS-specific security patterns

### Security Scan Results

**View Results:**
1. Open "Problems" panel (Ctrl+Shift+M / Cmd+Shift+M)
2. Filter by "Amazon Q Security"
3. Click issue for details and suggested fixes

**Issue Severity:**
- 🔴 Critical - Fix immediately
- 🟠 High - Fix soon
- 🟡 Medium - Consider fixing
- 🔵 Low - Informational

**Auto-Fix:**
- Many issues include automatic fixes
- Click "Quick Fix" lightbulb icon
- Review and apply suggested fix

### Settings

**Enable/Disable Security Scanning:**
- Setting: `amazonQ.securityScan.enabled`
- Default: `true`

**Scan on Save:**
- Setting: `amazonQ.securityScan.onSave`
- Default: `true`

**Scan Scope:**
- Scans files in current workspace
- Respects .gitignore patterns
- Configurable file type filters

---

## Feature Development

Use Amazon Q to develop entire features from natural language descriptions.

### Using /dev Command

**Syntax:**
```
/dev create a REST API for user authentication with JWT tokens
```

**Process:**
1. Amazon Q analyzes request
2. Generates implementation plan
3. Creates/modifies multiple files
4. Shows diff for review
5. Applies changes after approval

**Workflow:**
1. Describe feature in chat with `/dev`
2. Review proposed changes
3. Accept or request modifications
4. Amazon Q updates files
5. Verify and test implementation

**Best Practices:**
- Be specific in feature descriptions
- Mention frameworks/libraries to use
- Include acceptance criteria
- Review all changes before accepting
- Test generated code

---

## Advanced Configuration

### Proxy Settings

**Configure HTTP Proxy:**

```json
{
  "http.proxy": "http://proxy.company.com:8080",
  "http.proxyStrictSSL": false
}
```

### Offline Mode

Amazon Q requires internet connection for:
- Authentication
- AI model access
- MCP server communication

**Limited offline functionality:**
- Previously accepted suggestions may be cached
- Chat history remains accessible
- Some features unavailable

### Workspace-Specific Settings

**Create `.vscode/settings.json` in project:**

```json
{
  "amazonQ.inlineSuggestions.enabled": true,
  "amazonQ.securityScan.onSave": true,
  "amazonQ.mcpServers": {
    "project-specific-server": {
      "command": "npx",
      "args": ["-y", "custom-mcp-server"],
      "transport": "stdio"
    }
  }
}
```

---

## Troubleshooting

### Extension Not Working

**Check Installation:**
1. Verify extension is installed and enabled
2. Check for extension updates
3. Restart VS Code

**Check Authentication:**
1. Click Amazon Q in status bar
2. Verify you're logged in
3. Re-authenticate if needed

**Check Logs:**
1. Open Output panel (Ctrl+Shift+U / Cmd+Shift+U)
2. Select "Amazon Q" from dropdown
3. Review error messages

### Inline Suggestions Not Appearing

**Verify Settings:**
- `amazonQ.inlineSuggestions.enabled` is `true`
- `amazonQ.inlineSuggestions.autoTrigger` is `true`
- No conflicting extensions (Copilot, TabNine)

**Try Manual Trigger:**
- Position cursor in code
- Press `Alt+C` (default keybinding)

**Check File Type:**
- Amazon Q supports many languages
- See [supported languages](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/q-language-ide-support.html)

### Chat Not Responding

**Connection Issues:**
- Check internet connection
- Verify proxy settings (if applicable)
- Check AWS service status

**Context Too Large:**
- Remove `@workspace` for large projects
- Be more specific in queries
- Break into smaller questions

### MCP Servers Not Loading

See [Troubleshooting MCP section](#troubleshooting-mcp)

---

## Best Practices

### Code Quality

- **Review all suggestions** - Don't blindly accept code
- **Test generated code** - Verify functionality
- **Understand the code** - Learn from suggestions
- **Use descriptive comments** - Better suggestions from clear context

### Security

- **Review security scan results** - Address critical issues first
- **Validate credentials** - Don't commit secrets suggested by AI
- **Use MCP carefully** - Only install trusted MCP servers
- **Audit permissions** - Review MCP tool permissions regularly

### Productivity

- **Learn keyboard shortcuts** - Faster workflow
- **Use slash commands** - Quick access to features
- **Leverage @workspace** - Project-wide understanding
- **Export conversations** - Save useful interactions

### Team Collaboration

- **Share MCP configurations** - Commit `.amazonq/default.json` to git
- **Document custom settings** - Help team members configure
- **Use Amazon Q Pro** - For team customization features
- **Establish guidelines** - When to use AI assistance

---

## Additional Resources

### Official Documentation

- Installation Guide: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/q-in-IDE-setup.html
- IDE Features: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/q-in-IDE.html
- MCP Configuration: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/mcp-ide.html
- Supported Languages: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/q-language-ide-support.html
- Security Scanning: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/security-scans.html

### VS Code Marketplace

- Extension Page: https://marketplace.visualstudio.com/items?itemName=AmazonWebServices.amazon-q-vscode
- Reviews and Ratings: View on marketplace
- Changelog: https://aws.amazon.com/developer/generative-ai/amazon-q/change-log/

### GitHub

- AWS Toolkit for VS Code: https://github.com/aws/aws-toolkit-vscode
- Amazon Q CLI: https://github.com/aws/amazon-q-developer-cli
- Issue Reporting: GitHub Issues on toolkit repo

### Blogs and Tutorials

- MCP with Amazon Q: https://aws.amazon.com/blogs/devops/use-model-context-protocol-with-amazon-q-developer-for-context-aware-ide-workflows/
- Feature Announcements: https://aws.amazon.com/about-aws/whats-new/

### Related Guides

- [Amazon Q CLI Configuration](../amazon-q-cli/README.md)
- [Amazon Q CLI MCP Guide](../amazon-q-cli/mcp/README.md) - Shared MCP configuration
- [Kiro IDE Configuration](../kiro-ide/README.md)
- [Main Repository Guide](../README.md)

---

**Last Updated:** 2025-10-04

**Note:** All configuration examples use placeholder values. Replace with your actual settings and credentials.
