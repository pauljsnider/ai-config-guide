# Kiro IDE - Configuration Guide

Configuration guide for Kiro IDE covering MCP servers, hooks, specs, steering, and advanced features.

## Overview

Kiro IDE is AWS's agentic IDE that brings AI-powered development assistance directly into your editor. This guide provides configuration documentation for Kiro IDE features.

## What is Kiro IDE?

Kiro IDE is an AI-native integrated development environment in Public Preview that provides:
- AI-powered code generation and completion
- Natural language to code conversion
- Browser automation integration
- MCP server support for external tools
- Event-driven hooks for automation
- Spec-driven development workflow
- Persistent project knowledge through steering
- Optional VS Code settings import

**Current Status:** Public Preview (may require waitlist or invitation)

## Configuration Types

| Configuration | Supported | Description |
|--------------|-----------|-------------|
| **[MCP Servers](./mcp/)** | ✅ | External tool and data source integration |
| **[Hooks](./hooks/)** | ✅ | Event-driven automation with `.kiro.hook` files |
| **[Specs](./specs/)** | ✅ | Spec-driven development with requirements, design, and tasks |
| **[Steering](./steering/)** | ✅ | Persistent project knowledge through markdown files |
| **Agents** | ❌ | Not supported (Amazon Q CLI only) |
| **Rules** | ❌ | Not supported (Amazon Q CLI only) |

## Quick Start

### Prerequisites

- Windows, macOS, or Linux
- GitHub, Google, AWS Builder ID, or AWS IAM Identity Center account
- Internet connection for initial setup

### Installation

1. Visit https://kiro.dev/downloads/
2. Download installer for your platform:
   - Mac (Apple Silicon)
   - Mac (Intel)
   - Windows
   - Linux (Debian/Ubuntu or Universal)
3. Install and launch Kiro IDE
4. Login with your account
5. Optional: Import VS Code settings

### Basic Setup

1. **Configure MCP Servers** (optional)
   - See [MCP Configuration Guide](./mcp/README.md)
   - Edit `~/.kiro/settings/mcp.json`

2. **Create Hooks** (optional)
   - See [Hooks Configuration Guide](./hooks/README.md)
   - Create files in `~/.kiro/hooks/`

3. **Setup Project Steering** (optional)
   - See [Steering Configuration Guide](./steering/README.md)
   - Create foundational files in `.kiro/steering/`

4. **Initialize Specs** (optional)
   - See [Specs Configuration Guide](./specs/README.md)
   - Create feature directories in `.kiro/specs/`

5. **Start Coding**
   - Open a project
   - Use AI chat for assistance
   - Leverage hooks for automation
   - Follow spec-driven workflow

## Configuration Structure

```
~/.kiro/
├── settings/
│   └── mcp.json                # MCP server configurations (global)
└── hooks/
    └── *.kiro.hook             # Hook configurations (global)

project/
└── .kiro/
    ├── steering/
    │   └── *.md                # Project knowledge files
    └── specs/
        └── {feature-name}/
            ├── requirements.md  # Feature requirements
            ├── design.md        # Technical design
            └── tasks.md         # Implementation tasks
```

## Configuration Guides

### [MCP Servers](./mcp/)

Configure external tool integrations for Kiro IDE.

**What you'll find:**
- MCP server installation commands
- Configuration examples for Kiro IDE
- Credential setup
- Automated installation script
- Troubleshooting

**Common MCP Servers:**
- Memory (persistent context)
- Fetch (web content)
- Playwright (browser automation)
- Git (repository operations)
- Docker Gateway (container management)

### [Hooks](./hooks/)

Event-driven automation for Kiro IDE.

**What you'll find:**
- Hook file structure (`.kiro.hook`)
- Event types and triggers
- Configuration examples
- AI agent integration
- Best practices

**Hook Capabilities:**
- `fileEdited` - Trigger on file save
- Natural language prompts
- AI agent integration
- Pattern-based file matching

### [Specs](./specs/)

Spec-driven development workflow for Kiro IDE.

**What you'll find:**
- Three-file structure (requirements, design, tasks)
- EARS notation for acceptance criteria
- Incremental implementation workflow
- Complete examples
- Best practices

**Specs Capabilities:**
- Requirements definition with user stories
- Technical design documentation
- Task breakdown for implementation
- Version-controlled feature documentation

### [Steering](./steering/)

Persistent project knowledge for Kiro IDE.

**What you'll find:**
- Foundational files (product, structure, tech)
- Inclusion modes (always, file-match, manual)
- Custom steering examples
- YAML front matter configuration
- Best practices

**Steering Capabilities:**
- Project context and conventions
- Coding standards and patterns
- Team guidelines and policies
- Persistent AI memory

## Common Workflows

### 1. Setup MCP Servers

1. Edit `~/.kiro/settings/mcp.json` or use the install script
2. Add MCP server configurations
3. Restart Kiro IDE

See [MCP Configuration Guide](./mcp/README.md)

### 2. Create Custom Hooks

1. Create `~/.kiro/hooks/my-hook.kiro.hook`
2. Configure event triggers and prompts
3. Enable hook in Kiro IDE
4. Test hook execution

See [Hooks Configuration Guide](./hooks/README.md)

### 3. Setup Project Steering

1. Create `.kiro/steering/` in your project root
2. Run "Setup Project Steering" command in Kiro IDE
3. Edit generated foundational files (product.md, structure.md, tech.md)
4. Add custom steering files as needed
5. Configure inclusion modes with YAML front matter

See [Steering Configuration Guide](./steering/README.md)

### 4. Create Feature Spec

1. Create `.kiro/specs/{feature-name}/` directory
2. Write `requirements.md` with user stories and EARS criteria
3. Document technical approach in `design.md`
4. Break down into tasks in `tasks.md`
5. Execute tasks incrementally

See [Specs Configuration Guide](./specs/README.md)

## Best Practices

### General

- **Start simple** - Begin with basic configurations
- **Version control** - Track configuration files in git
- **Test thoroughly** - Validate configurations before deploying
- **Documentation** - Document custom configurations

### Security

- **Credential management** - Use environment variables for sensitive data
- **Tool permissions** - Grant minimal necessary permissions
- **Review hooks** - Audit hook commands for security

### Organization

- **Separate concerns** - Use dedicated files for different hooks
- **Descriptive names** - Use clear, meaningful names
- **Consistent structure** - Follow established patterns

## Troubleshooting

### Configuration Not Loading

```bash
# Validate JSON syntax
jq . ~/.kiro/settings/mcp.json
jq . ~/.kiro/hooks/hook-name.kiro.hook

# Check file locations
ls ~/.kiro/settings/
ls ~/.kiro/hooks/
```

### Common Issues

**MCP Servers:**
- Verify command is executable
- Check environment variables are set
- Review server logs for errors
- Restart Kiro IDE after changes

**Hooks:**
- Test hook commands independently
- Check file patterns match correctly
- Verify hook is enabled
- Review Kiro IDE logs

**Steering:**
- Verify files are in `.kiro/steering/`
- Check YAML front matter syntax
- Validate inclusion patterns
- Restart Kiro IDE after changes

**Specs:**
- Ensure three files exist per spec
- Validate markdown formatting
- Check EARS notation syntax
- Commit specs to version control

## Additional Resources

### Official Documentation

- Website: https://kiro.dev/
- Documentation: https://kiro.dev/docs/
- Getting Started: https://kiro.dev/docs/getting-started/
- Downloads: https://kiro.dev/downloads/
- Hooks Guide: https://kiro.dev/docs/hooks/
- Specs Guide: https://kiro.dev/docs/specs/
- Steering Guide: https://kiro.dev/docs/steering/

### GitHub

- Main Repository: https://github.com/kirodotdev/Kiro
- Awesome Kiro: https://github.com/friends-of-kiro/awesome-kiro
- TDD Workflow Files: https://github.com/5capeg0at/kiro-tdd-workflow-files

### MCP Resources

- MCP Protocol: https://modelcontextprotocol.io/
- Server Directory: https://github.com/modelcontextprotocol/servers

### Related Guides

- [Amazon Q CLI Configuration](../amazon-q-cli/README.md)
- [Main Repository Guide](../README.md)

---

**Last Updated:** 2026-01-07

**Note:** Kiro IDE is in Public Preview. Features and configuration may change. All configuration examples use placeholder values.
