# AI Configuration Guide

Configuration guides for AI development tools including Amazon Q CLI, Cursor IDE/Agent, and Kiro IDE.

## Overview

This repository provides comprehensive configuration documentation for modern AI-powered development tools, organized by tool and feature type.

It exists because AI tools often lose track of how they are configured: where settings live, which MCPs are enabled, and which CLIs or integrations you rely on most. The docs here keep those reminders close at hand so the tools stay aligned with your preferred connections and workflows.

## Tools Covered

### [Claude Code](./claude/)

Anthropic's official CLI for Claude with AI-powered development assistance.

**Configurations:**
- **[Skills](./claude/skills/)** - Self-contained AI capabilities with custom tools and workflows

### [Amazon Q CLI](./amazon-q-cli/)

AWS's agentic command-line interface for AI-powered development assistance.

**Configurations:**
- **[MCP Servers](./amazon-q-cli/mcp/)** - External tool and data source integration
- **[Agents](./amazon-q-cli/agents/)** - Custom AI assistants with specialized behaviors
- **[Hooks](./amazon-q-cli/hooks/)** - Event-driven automation and validation
- **[Rules](./amazon-q-cli/rules/)** - Project-specific coding standards and guidelines

### [Cursor (IDE & Agent)](./cursor/)

Cursor's desktop IDE and `cursor-agent` CLI for AI pair-programming.

**Configurations:**
- **[MCP Servers](./cursor/mcp/)** - Register external tools via `~/.cursor/mcp.json`
- **[Rules](./cursor/rules/)** - Define `.cursorrules` and `.cursor/rules/*.mdc` guidance
- **[Commands](./cursor/commands/)** - Share repeatable automations in `.cursor/commands/*.md`
- **[Agents](./cursor/agents/)** - Configure background workflows in `.cursor/agents/*.mdc`
- **[Workspace Settings](./cursor/settings/)** - Project-level preferences and extra `mcp.servers`

### [Kiro IDE](./kiro-ide/)

AWS's agentic IDE in Public Preview for AI-native development.

**Configurations:**
- **[MCP Servers](./kiro-ide/mcp/)** - External tool and data source integration
- **[Hooks](./kiro-ide/hooks/)** - Event-driven automation with .kiro.hook files
- **[Specs](./kiro-ide/specs/)** - Spec-driven development with requirements, design, and tasks
- **[Steering](./kiro-ide/steering/)** - Persistent project knowledge through markdown files

### [Kiro CLI (Steering)](./kiro-cli/steering/)

Kiro CLI steering files for global reminders and consistent tool behavior.

**Configurations:**
- **[Steering Files](./kiro-cli/steering/README.md)** - Global steering and examples for common integrations

## Prerequisites

### GitHub CLI

GitHub CLI provides command-line access to GitHub repositories for cloning and managing this configuration guide.

**Installation:**

**macOS:**
```bash
brew install gh
```

**Windows:**
```bash
winget install --id GitHub.cli
```

**Linux (Debian/Ubuntu):**
```bash
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y
```

**Authentication:**
```bash
gh auth login
```

**Documentation:**
- Official Website: https://cli.github.com/
- Manual: https://cli.github.com/manual/
- GitHub Repository: https://github.com/cli/cli

### AWS CLI

AWS CLI provides command-line access to AWS services with advanced commands beyond MCP servers.

**Installation:**

**macOS:**
```bash
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
aws --version
```

**Windows:**
```bash
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi
```

**Linux:**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

**Configuration:**
```bash
aws configure
# Prompts for:
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region
# - Default output format
```

**Documentation:**
- Installation Guide: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
- Command Reference: https://docs.aws.amazon.com/cli/latest/reference/
- Official Website: https://aws.amazon.com/cli/

## Quick Start

### Claude Code

1. **Install Claude Code:**
   ```bash
   # macOS/Linux
   curl -fsSL https://raw.githubusercontent.com/anthropics/claude-code/main/install.sh | sh

   # Or via npm
   npm install -g @anthropics/claude
   ```

2. **Configure Skills:**
   ```bash
   # Create skills directory
   mkdir -p ~/.claude/skills

   # Copy Microsoft Graph toolkit skill
   cp -r claude/skills/ms-graph-toolkit ~/.claude/skills/
   ```

3. **Launch:**
   ```bash
   claude
   ```

See [Claude Code Guide](./claude/README.md)

### Amazon Q CLI

1. **Install Amazon Q CLI:**
   ```bash
   # macOS
   brew install --cask amazon-q

   # Ubuntu/Debian
   wget https://desktop-release.q.us-east-1.amazonaws.com/latest/amazon-q.deb
   sudo dpkg -i amazon-q.deb
   ```

2. **Configure MCP Servers:**
   ```bash
   cd amazon-q-cli/mcp
   ./install-mcp.sh
   ```

3. **Launch:**
   ```bash
   q chat
   ```

See [Amazon Q CLI Guide](./amazon-q-cli/README.md)

### Cursor IDE & Agent

1. **Install Cursor Agent CLI:**
   ```bash
   curl https://cursor.com/install -fsSL | bash
   ```

2. **Configure MCP Servers:**
   ```bash
   cd cursor/mcp
   ./install-mcp.sh
   ```

3. **Add Project Rules:**
   ```bash
   cp cursor/rules/example.cursorrules /path/to/project/.cursorrules
   ```

4. **Optional extras:**
   ```bash
   cp cursor/commands/example-command.md /path/to/project/.cursor/commands/update-deps.md
   cp cursor/agents/example-agent.mdc /path/to/project/.cursor/agents/docs-guardian.mdc
   cp cursor/settings/example-settings.json /path/to/project/.cursor/settings.json
   ```

Restart the Cursor IDE or re-run `cursor-agent` after updating configurations. See [Cursor Guide](./cursor/README.md).

### Kiro IDE

1. **Install Kiro IDE:**
   - Download from https://kiro.dev/downloads/
   - Install and login

2. **Configure MCP Servers:**
   ```bash
   cd kiro-ide/mcp
   ./install-mcp.sh
   ```

3. **Open a project and start coding**

See [Kiro IDE Guide](./kiro-ide/README.md)

## Repository Structure

```
ai-config-guide/
├── README.md                          # This file
├── claude/
│   ├── README.md                      # Claude Code overview
│   └── skills/
│       ├── README.md                  # Skills guide
│       └── ms-graph-toolkit/
│           ├── SKILL.md               # Microsoft Graph toolkit skill
│           └── scripts/               # Auto-generated scripts
├── amazon-q-cli/
│   ├── README.md                      # Amazon Q CLI overview
│   ├── mcp/
│   │   ├── README.md                  # MCP servers guide
│   │   ├── mcp.json                   # Example configuration
│   │   └── install-mcp.sh             # Automated installer
│   ├── agents/
│   │   ├── README.md                  # Agents guide
│   │   └── example-agent.json         # Example agent
│   ├── hooks/
│   │   ├── README.md                  # Hooks guide
│   │   └── example-hooks.json         # Example hooks
│   └── rules/
│       ├── README.md                  # Rules guide
│       └── example-coding-standards.md # Example rules
├── cursor/
│   ├── README.md                      # Cursor IDE/Agent overview
│   ├── mcp/
│   │   ├── README.md                  # MCP servers guide
│   │   ├── mcp.json                   # Example configuration
│   │   └── install-mcp.sh             # Automated installer
│   └── rules/
│       ├── README.md                  # Rules guide
│       └── example.cursorrules        # Example .cursorrules template
└── kiro-ide/
    ├── README.md                      # Kiro IDE overview
    ├── mcp/
    │   ├── README.md                  # MCP servers guide
    │   ├── mcp.json                   # Example configuration
    │   └── install-mcp.sh             # Automated installer
    ├── hooks/
    │   ├── README.md                  # Hooks guide
    │   └── example-hook.kiro.hook     # Example hook
    ├── specs/
    │   └── README.md                  # Specs guide
    └── steering/
        └── README.md                  # Steering guide
├── kiro-cli/
│   └── steering/
│       ├── README.md                  # Kiro CLI steering overview
│       ├── aws-cli.md                 # AWS CLI steering
│       ├── atlassian-mcp.md           # Atlassian MCP steering
│       ├── github-cli.md              # GitHub CLI steering
│       └── kiro-configuration.md      # Kiro config paths
```

## Configuration Highlights

### Model Context Protocol (MCP)

**Shared across both tools:**
- Memory server for persistent context
- Fetch server for web content retrieval
- Playwright for browser automation
- Bitbucket and Atlassian integration
- Docker Gateway for container management

### Cursor IDE & Agent Specific

**MCP Configuration:**
- Global JSON lives at `~/.cursor/mcp.json`, with optional project overrides in `./.cursor/mcp.json`.
- Supports community servers such as `@modelcontextprotocol/server-memory`, `@playwright/mcp`, and Docker-based integrations.

**Rules:**
- Repository instructions go in `.cursorrules`, following patterns curated by [patrickjs/awesome-cursorrules](https://github.com/patrickjs/awesome-cursorrules).
- Additional Markdown rules can be stored under `.cursor/rules/*.mdc` with YAML front matter, as seen in community examples like [cursor-agentic-ai](https://github.com/phamhung075/cursor-agentic-ai/tree/0f9724948af01c637864460c90bef7b026bb225e/.cursor/rules).

**Commands & Agents:**
- `.cursor/commands/*.md` provide reusable workflows (see repositories like `wisarootl/leetcode-py`).
- `.cursor/agents/*.mdc` declare background automation with YAML front matter (e.g. `Code_King_Builder`).

**Workspace Settings:**
- `.cursor/settings.json` merges editor preferences with additional `mcp.servers` entries, mirroring guidance from `ArcadeAI/arcade-mcp`.

### Amazon Q CLI Specific

**Agents:**
- Custom AI assistants with specialized system prompts
- Per-agent tool permissions and MCP servers
- Resource file loading
- Hook integration

**Hooks:**
- 5 event types: agentSpawn, userPromptSubmit, preToolUse, postToolUse, stop
- Tool matchers with wildcards
- Exit code control (block with code 2)
- JSON configuration in agent files

**Rules:**
- Markdown files in `.amazonq/rules/`
- Automatically loaded by default agent
- Project-specific coding standards
- Architecture and security guidelines

### Kiro IDE Specific

**Hooks:**
- `.kiro.hook` JSON files
- fileEdited event type
- Natural language prompts
- AI agent integration
- Pattern-based file matching

**Specs:**
- Spec-driven development workflow
- Three-file structure: requirements.md, design.md, tasks.md
- EARS notation for acceptance criteria
- Incremental implementation with validation
- Version-controlled feature documentation

**Steering:**
- Persistent project knowledge in `.kiro/steering/`
- Three foundational files: product.md, structure.md, tech.md
- Three inclusion modes: always, file-match, manual
- YAML front matter configuration
- Custom coding standards and team guidelines

## Best Practices

- **Start simple** - Begin with basic configurations
- **Version control** - Track configuration files in git
- **Test thoroughly** - Validate before deploying
- **Secure credentials** - Use environment variables
- **Document changes** - Maintain configuration documentation

## Additional Resources

### Claude Code

- Official Documentation: https://docs.anthropic.com/claude/docs/claude-code
- GitHub Repository: https://github.com/anthropics/claude-code
- Skills Documentation: https://docs.anthropic.com/claude/docs/skills

### Amazon Q CLI

- Official Documentation: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line.html
- GitHub Repository: https://github.com/aws/amazon-q-developer-cli
- Installation Guide: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-installing.html

### Cursor

- Product page: https://cursor.sh/
- CLI installer source: https://cursor.com/install
- `.cursorrules` catalog: https://github.com/patrickjs/awesome-cursorrules
- Community MCP/rules directory: https://cursor.directory/

### Kiro IDE

- Official Website: https://kiro.dev/
- Documentation: https://kiro.dev/docs/
- Downloads: https://kiro.dev/downloads/
- GitHub: https://github.com/kirodotdev/Kiro

### Model Context Protocol

- MCP Specification: https://modelcontextprotocol.io/
- Server Directory: https://github.com/modelcontextprotocol/servers
- Documentation: https://modelcontextprotocol.io/docs

---

**Last Updated:** 2025-10-04

**Note:** All configuration examples use placeholder values. Replace with your actual settings and credentials.
