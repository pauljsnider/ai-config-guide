# Claude Code Configuration Guide

Claude Code is Anthropic's official command-line interface for Claude, providing AI-powered development assistance directly in your terminal.

## Overview

Claude Code extends Claude's capabilities through a skill system that allows you to create custom AI workflows with specialized tools and knowledge. Skills are self-contained packages that Claude can invoke to perform complex tasks.

## Key Features

- **Interactive CLI** - Chat with Claude directly in your terminal
- **Skills System** - Extend Claude with custom capabilities
- **Tool Integration** - Access to file operations, bash commands, and more
- **Context Awareness** - Maintains conversation history and project context
- **SDK Support** - Build custom agents with the Claude Agent SDK

## Configuration Types

### [Skills](./skills/)

Self-contained AI capabilities that extend Claude's functionality. Each skill:
- Has its own markdown-based configuration (SKILL.md)
- Defines allowed tools and permissions
- Can include scripts, resources, and documentation
- Is invoked automatically when relevant to the task

**Use Cases:**
- API integrations (Microsoft Graph, GitHub, AWS)
- Custom workflows and automations
- Domain-specific tooling
- Project scaffolding

## Installation

### Prerequisites

- Node.js 18+ or Python 3.8+
- npm or pip package manager

### Install Claude Code

**Via npm (recommended):**
```bash
npm install -g @anthropics/claude
```

**Via installation script:**
```bash
curl -fsSL https://raw.githubusercontent.com/anthropics/claude-code/main/install.sh | sh
```

**Verify installation:**
```bash
claude --version
```

### Authentication

Set your Anthropic API key:
```bash
export ANTHROPIC_API_KEY="your-api-key"
```

Or create a config file at `~/.claude/config.json`:
```json
{
  "apiKey": "your-api-key"
}
```

## Quick Start

### Basic Usage

Start an interactive session:
```bash
claude
```

Run a one-off command:
```bash
claude "analyze the code in src/"
```

### Setting Up Skills

1. **Create skills directory:**
   ```bash
   mkdir -p ~/.claude/skills
   ```

2. **Install a skill:**
   ```bash
   # Copy from this repository
   cp -r claude/skills/ms-graph-toolkit ~/.claude/skills/

   # Or clone directly
   cd ~/.claude/skills
   git clone <skill-repo-url>
   ```

3. **Use the skill:**
   ```bash
   claude
   > Find my availability for meetings next week
   # Claude will automatically use ms-graph-toolkit skill
   ```

## Skills

Skills are stored in `~/.claude/skills/` and automatically discovered by Claude Code.

### Available Skills in This Repository

- **[ms-graph-toolkit](./skills/ms-graph-toolkit/)** - Microsoft Graph API integration for Calendar, Teams, Outlook, OneDrive, and more

### Skill Structure

Each skill contains:
```
skill-name/
├── SKILL.md           # Main configuration and documentation
├── scripts/           # Executable scripts (optional)
├── resources/         # Additional resources (optional)
└── README.md          # User-facing documentation (optional)
```

### Creating Custom Skills

See the [Skills Guide](./skills/README.md) for detailed instructions on creating your own skills.

## Common Workflows

### Microsoft 365 Integration

Use the ms-graph-toolkit to interact with Microsoft services:
```bash
claude "Schedule a meeting with alice@company.com next Tuesday at 2pm"
claude "Search my OneDrive for quarterly reports"
claude "List my calendar for this week"
```

**Note:** Microsoft Graph access tokens expire after 69-90 minutes. You'll paste a new token when Claude prompts you.

### Development Tasks

```bash
# Code review
claude "Review the changes in src/auth.js"

# Refactoring
claude "Refactor this component to use TypeScript"

# Bug fixing
claude "Fix the authentication error in the login flow"
```

### Documentation

```bash
# Generate docs
claude "Create API documentation from src/api/"

# Explain code
claude "Explain how the caching system works"
```

## Configuration Files

### Global Config: `~/.claude/config.json`

```json
{
  "apiKey": "your-api-key",
  "model": "claude-sonnet-4",
  "temperature": 0.7,
  "maxTokens": 4096
}
```

### Project Config: `./.claude/config.json`

Project-specific overrides:
```json
{
  "rules": [
    "Always use TypeScript",
    "Follow the style guide in CONTRIBUTING.md"
  ],
  "skills": {
    "enabled": ["ms-graph-toolkit"],
    "disabled": []
  }
}
```

## Best Practices

### Security

- **Never commit API keys** - Use environment variables or config files
- **Review permissions** - Skills declare required tools; understand what they can access
- **Sanitize outputs** - Be cautious when sharing command outputs
- **Token management** - Rotate access tokens regularly (e.g., MS Graph tokens)

### Skill Development

- **Start simple** - Begin with basic functionality, iterate based on usage
- **Document thoroughly** - Clear documentation helps Claude use skills effectively
- **Test locally** - Verify scripts work before adding to skills
- **Version control** - Track skill changes in git
- **Portable scripts** - Avoid hardcoded paths or credentials

### Performance

- **Cache when possible** - Skills can store frequently accessed data
- **Batch operations** - Combine related API calls to reduce latency
- **Stream responses** - Use streaming for long-running tasks

## Troubleshooting

### Skill Not Found

```
Error: Skill 'ms-graph-toolkit' not found
```

**Solution:**
- Verify skill is in `~/.claude/skills/`
- Check SKILL.md exists and is valid markdown
- Restart Claude Code session

### Permission Denied

```
Error: Tool 'Bash' not allowed for this skill
```

**Solution:**
- Check the `allowed-tools` list in SKILL.md front matter
- Update skill configuration to include required tools

### API Authentication Errors

```
Error: Invalid or expired token
```

**Solution:**
- Refresh access tokens (see skill documentation)
- Verify environment variables are set
- Check API key permissions

## Additional Resources

### Documentation

- **Claude Code Docs**: https://docs.anthropic.com/claude/docs/claude-code
- **API Reference**: https://docs.anthropic.com/claude/reference
- **Skills Guide**: https://docs.anthropic.com/claude/docs/skills
- **Agent SDK**: https://docs.anthropic.com/claude/docs/agent-sdk

### Community

- **GitHub**: https://github.com/anthropics/claude-code
- **Discord**: https://discord.gg/anthropic
- **Forum**: https://community.anthropic.com

### Microsoft Graph Resources

- **Graph Explorer**: https://developer.microsoft.com/en-us/graph/graph-explorer
- **API Reference**: https://learn.microsoft.com/en-us/graph/api/overview
- **Permissions Reference**: https://learn.microsoft.com/en-us/graph/permissions-reference
- **Quick Start Guide**: https://learn.microsoft.com/en-us/graph/tutorials

---

**Last Updated:** 2026-01-11

**Note:** This is a community-maintained configuration guide. Always verify configurations match your environment and security requirements.
