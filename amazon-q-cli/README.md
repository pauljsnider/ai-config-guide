# Amazon Q CLI - Configuration Guide

Comprehensive configuration guide for Amazon Q CLI covering MCP servers, agents, hooks, rules, and advanced features.

## Overview

Amazon Q CLI is AWS's agentic command-line interface that brings AI-powered development assistance to your terminal. This guide provides complete configuration documentation organized by feature type.

## What is Amazon Q CLI?

Amazon Q CLI provides:
- **Agentic Chat** - AI-powered conversations about your code
- **Custom Agents** - Specialized AI assistants with unique behaviors
- **MCP Integration** - Connect to external tools and data sources
- **Event Hooks** - Automate workflows with custom commands
- **Project Rules** - Enforce coding standards and guidelines

## Configuration Types

| Configuration | Description | Location |
|--------------|-------------|----------|
| **[MCP Servers](./mcp/)** | External tool and data source integration | `~/.aws/amazonq/mcp.json` |
| **[Agents](./agents/)** | Custom AI assistants with specialized behaviors | `~/.aws/amazonq/cli-agents/*.json` |
| **[Hooks](./hooks/)** | Event-driven automation and validation | Agent JSON files |
| **[Rules](./rules/)** | Project-specific coding standards and guidelines | `.amazonq/rules/**/*.md` |

## Quick Start

### Installation

**Prerequisites:**
- macOS, Linux (Ubuntu/Debian), or Windows
- AWS Builder ID or AWS IAM Identity Center account

**macOS:**
```bash
# Homebrew
brew install --cask amazon-q
```

**Ubuntu/Debian:**
```bash
wget https://desktop-release.q.us-east-1.amazonaws.com/latest/amazon-q.deb
sudo dpkg -i amazon-q.deb
```

**Linux (AppImage):**
```bash
wget https://desktop-release.q.us-east-1.amazonaws.com/latest/amazon-q.appimage
chmod +x amazon-q.appimage
./amazon-q.appimage
```

**Verify Installation:**
```bash
# Check installation
q --help

# Run diagnostics
q doctor

# Launch default agent
q chat
```

## Configuration Structure

```
~/.aws/amazonq/
├── mcp.json                    # MCP server configurations (global)
├── cli-agents/
│   └── *.json                  # Agent configurations
└── config.yaml                 # Rules and profiles

project/
└── .amazonq/
    ├── mcp.json                # MCP servers (workspace)
    └── rules/
        └── *.md                # Project rules
```

## Configuration Guides

### [MCP Servers](./mcp/)

Configure external tool integrations for Amazon Q CLI.

**What you'll find:**
- MCP server installation commands
- Configuration examples
- Credential setup
- Automated installation script
- Troubleshooting

**Common MCP Servers:**
- Memory (persistent context)
- Fetch (web content)
- Playwright (browser automation)
- Git (repository operations)
- Docker Gateway (container management)

### [Agents](./agents/)

Create custom AI assistants with specialized behaviors.

**What you'll find:**
- Agent JSON structure and schema
- Tool management and permissions
- Resource configuration
- Hook integration
- Complete examples

**Agent Capabilities:**
- Custom system prompts
- Per-agent MCP servers
- Tool wildcards and aliases
- Auto-approved tools
- Resource file loading

### [Hooks](./hooks/)

Event-driven automation for Amazon Q CLI.

**What you'll find:**
- Hook types and triggers
- Configuration examples
- Tool matchers
- Exit code handling
- Best practices

**Hook Types:**
- `agentSpawn` - Agent initialization
- `userPromptSubmit` - User message
- `preToolUse` - Before tool execution
- `postToolUse` - After tool execution
- `stop` - End of response

### [Rules](./rules/)

Project-specific coding standards and guidelines.

**What you'll find:**
- Rule categories and examples
- Markdown formatting
- Integration with agents
- Best practices

**Rule Categories:**
- Coding standards
- Architecture patterns
- Security policies
- Team conventions
- Performance guidelines

## Common Workflows

### 1. Setup MCP Servers

1. Edit `~/.aws/amazonq/mcp.json` or use the install script
2. Add MCP server configurations
3. Restart Amazon Q CLI

See [MCP Configuration Guide](./mcp/README.md)

### 2. Create Custom Agent

1. Create `~/.aws/amazonq/cli-agents/my-agent.json`
2. Configure tools, resources, and hooks
3. Launch: `q chat --agent my-agent`

See [Agents Configuration Guide](./agents/README.md)

### 3. Add Event Hooks

1. Add `hooks` field to agent JSON
2. Configure hook types and matchers
3. Test hook execution

See [Hooks Configuration Guide](./hooks/README.md)

### 4. Define Project Rules

1. Create `.amazonq/rules/` directory
2. Add markdown files with guidelines
3. Reference in agent resources
4. Rules auto-load in default agent

See [Rules Configuration Guide](./rules/README.md)

## Best Practices

### General

- **Start simple** - Begin with basic configurations, expand as needed
- **Version control** - Track configuration files in git
- **Documentation** - Document custom configurations
- **Test thoroughly** - Validate configurations before deploying

### Security

- **Credential management** - Use environment variables for sensitive data
- **Tool permissions** - Grant minimal necessary permissions
- **Review hooks** - Audit hook commands for security
- **Rule compliance** - Enforce security policies via rules

### Organization

- **Separate concerns** - Use dedicated folders for each config type
- **Descriptive names** - Use clear, meaningful names
- **Consistent structure** - Follow established patterns
- **Regular reviews** - Update configurations as needs evolve

## Troubleshooting

### Configuration Not Loading

```bash
# Verify installation
q doctor

# Validate JSON syntax
jq . ~/.aws/amazonq/mcp.json
jq . ~/.aws/amazonq/cli-agents/agent-name.json

# Check agent list
q agent list
```

### Common Issues

**MCP Servers:**
- Verify command is executable
- Check environment variables are set
- Review server logs for errors

**Agents:**
- Validate JSON schema
- Check tool names and matchers
- Verify resource file paths exist

**Hooks:**
- Test hook commands independently
- Check exit codes and STDERR
- Verify tool matchers are correct

**Rules:**
- Confirm files are in `.amazonq/rules/`
- Verify markdown syntax is valid
- Check agent includes rules in resources

## Additional Resources

### Official Documentation

- Installation: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-installing.html
- Command Reference: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-reference.html
- Project Rules: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-project-rules.html
- Built-in Tools: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-built-in-tools.html

### GitHub

- Main Repository: https://github.com/aws/amazon-q-developer-cli
- Agent Format: https://github.com/aws/amazon-q-developer-cli/blob/main/docs/agent-format.md
- Hooks Documentation: https://github.com/aws/amazon-q-developer-cli/blob/main/docs/hooks.md
- Knowledge Management: https://github.com/aws/amazon-q-developer-cli/blob/main/docs/knowledge-management.md

### Related Guides

- [Main Repository Guide](../README.md)
- [Kiro IDE Configuration](../kiro-ide/README.md)

---

**Last Updated:** 2025-10-04

**Note:** All configuration examples use placeholder values. Replace with your actual settings and credentials.
