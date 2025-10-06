# Amazon Q CLI - Agents Configuration Guide

Custom AI assistants with specialized behaviors, tool permissions, and configurations.

## Overview

Agents are JSON configuration files that define custom AI assistants for Amazon Q CLI. Each agent can have its own MCP servers, tool permissions, resource files, hooks, and system prompts.

## Configuration Location

**File Location:** `~/.aws/amazonq/cli-agents/*.json`

The filename (without `.json` extension) becomes the agent's name.

## Basic Agent Structure

```json
{
  "$schema": "https://raw.githubusercontent.com/aws/amazon-q-developer-cli/refs/heads/main/schemas/agent-v1.json",
  "name": "agent-name",
  "description": "Description of what the agent does",
  "prompt": "High-level context for the agent",
  "tools": ["*"],
  "allowedTools": [],
  "resources": [],
  "useLegacyMcpJson": true
}
```

## Configuration Fields

### 1. Name and Description

```json
{
  "name": "aws-expert",
  "description": "An agent specialized for AWS infrastructure tasks"
}
```

**Purpose:** Identification and agent selection

### 2. Prompt (System Prompt)

```json
{
  "prompt": "You are an expert AWS infrastructure specialist. Focus on best practices for scalability, security, and cost optimization."
}
```

**Purpose:** High-level context and behavioral guidance

### 3. Tool Management

#### Available Tools

```json
{
  "tools": [
    "fs_read",           // Built-in tool by name
    "fs_*",              // Wildcard for all fs tools
    "@git",              // All tools from git MCP server
    "@git/status",       // Specific tool from MCP server
    "*"                  // All available tools (built-in + MCP)
  ]
}
```

**Tool Patterns:**
- **Built-in tools**: `fs_read`, `fs_write`, `execute_bash`, `use_aws`, `knowledge`
- **Wildcards**: `fs_*`, `*_test`
- **MCP server (all tools)**: `@server-name`
- **MCP server (specific)**: `@server-name/tool-name`
- **All tools**: `*`

#### Allowed Tools (Auto-Approve)

Tools that can be used without prompting for permission:

```json
{
  "allowedTools": [
    "fs_read",           // Exact match
    "fs_*",              // Prefix wildcard
    "*_test",            // Suffix wildcard
    "@git/status",       // Specific MCP tool
    "@git",              // All tools from git server
    "@server/api_*",     // MCP tool patterns
    "@git-*"             // Server-level permissions
  ]
}
```

**Wildcard Patterns:**
- `*` matches any sequence of characters
- `?` matches exactly one character
- Case-sensitive matching

### 4. Tool Aliases

Resolve naming collisions or create intuitive names:

```json
{
  "toolAliases": {
    "@github-mcp/get_issues": "github_issues",
    "@gitlab-mcp/get_issues": "gitlab_issues",
    "@aws-tools/deploy_stack_with_parameters": "deploy_cf"
  }
}
```

### 5. Tool Settings

Configure specific tools with custom settings:

```json
{
  "toolsSettings": {
    "fs_write": {
      "allowedPaths": ["src/**", "tests/**", "Cargo.toml"]
    },
    "use_aws": {
      "allowedServices": ["s3", "lambda"]
    },
    "execute_bash": {
      "alwaysAllow": [
        {
          "preset": "readOnly"
        }
      ]
    }
  }
}
```

### 6. Resources

Provide context files to the agent:

```json
{
  "resources": [
    "file://README.md",
    "file://docs/**/*.md",
    "file://.amazonq/rules/**/*.md",
    "file://$HOME/path/to/resource.md"
  ]
}
```

**Supported:**
- Specific files: `file://README.md`
- Glob patterns: `file://docs/**/*.md`
- Environment variables: `file://$HOME/...`
- Absolute or relative paths

### 7. MCP Servers (Per-Agent)

Each agent can have its own MCP server configuration:

```json
{
  "mcpServers": {
    "aws-knowledge": {
      "command": "uvx",
      "args": ["awslabs.aws-knowledge-mcp-server@latest"],
      "env": {
        "AWS_REGION": "us-east-1",
        "FASTMCP_LOG_LEVEL": "ERROR"
      },
      "timeout": 60000
    },
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"],
      "env": {},
      "timeout": 120000
    }
  }
}
```

### 8. Hooks

Define commands to run at specific trigger points:

```json
{
  "hooks": {
    "agentSpawn": [
      {
        "command": "git status"
      }
    ],
    "userPromptSubmit": [
      {
        "command": "ls -la"
      }
    ],
    "preToolUse": [
      {
        "matcher": "execute_bash",
        "command": "{ echo \"$(date) - Bash:\"; cat; } >> /tmp/audit.log"
      }
    ],
    "postToolUse": [
      {
        "matcher": "fs_write",
        "command": "cargo fmt --all"
      }
    ]
  }
}
```

See the [Hooks Guide](../hooks/README.md) for detailed information.

### 9. Model Selection

Specify the model ID to use:

```json
{
  "model": "claude-sonnet-4"
}
```

**Note:** Model ID must match available models. Use `/model` command to see available models.

### 10. Legacy MCP Configuration

Include MCP servers from global configuration files:

```json
{
  "useLegacyMcpJson": true
}
```

**Includes:**
- `~/.aws/amazonq/mcp.json` (global)
- `cwd/.amazonq/mcp.json` (workspace)

## Complete Example

See [example-agent.json](./example-agent.json) for a complete agent configuration.

## Usage

### Launch an Agent

```bash
# Start agent by name
q chat --agent agent-name

# Generate new agent (interactive)
/agent generate
```

### List Available Agents

```bash
q agent list
```

### Validate Agent Configuration

```bash
# Validate JSON syntax
jq . ~/.aws/amazonq/cli-agents/agent-name.json

# Test agent launch
q chat --agent agent-name
```

## Agent Use Cases

### 1. Domain-Specific Experts

```json
{
  "name": "aws-architect",
  "description": "AWS cloud architecture and infrastructure specialist",
  "prompt": "You are an AWS Solutions Architect with deep expertise in cloud design patterns, cost optimization, and security best practices.",
  "tools": ["*"],
  "allowedTools": ["fs_read", "@aws-knowledge"],
  "mcpServers": {
    "aws-knowledge": {
      "command": "uvx",
      "args": ["awslabs.aws-knowledge-mcp-server@latest"]
    }
  }
}
```

### 2. Language Specialists

```json
{
  "name": "rust-expert",
  "description": "Rust programming language specialist",
  "prompt": "You are a Rust expert focused on memory safety, performance, and idiomatic code.",
  "tools": ["fs_*", "execute_bash"],
  "resources": [
    "file://.amazonq/rules/rust-standards.md"
  ],
  "hooks": {
    "postToolUse": [
      {
        "matcher": "fs_write",
        "command": "cargo fmt --all"
      }
    ]
  }
}
```

### 3. Security Auditors

```json
{
  "name": "security-auditor",
  "description": "Security review and vulnerability analysis specialist",
  "prompt": "You are a security expert focused on identifying vulnerabilities and ensuring compliance with security best practices.",
  "tools": ["fs_read", "@security-scanner"],
  "allowedTools": ["fs_read"],
  "resources": [
    "file://.amazonq/rules/security-policies.md"
  ]
}
```

### 4. Code Reviewers

```json
{
  "name": "code-reviewer",
  "description": "Code review specialist focused on quality and best practices",
  "prompt": "You are a senior code reviewer. Provide constructive feedback on code quality, maintainability, and adherence to standards.",
  "tools": ["fs_read", "@git"],
  "resources": [
    "file://.amazonq/rules/**/*.md"
  ]
}
```

## Best Practices

### Agent Design

- **Clear purpose**: Each agent should have a specific, well-defined role
- **Appropriate permissions**: Grant only necessary tool access
- **Comprehensive resources**: Provide relevant documentation and rules
- **Meaningful names**: Use descriptive names that reflect the agent's expertise

### Tool Configuration

- **Start restrictive**: Begin with limited tools, expand as needed
- **Use allowedTools**: Pre-approve safe, read-only operations
- **Leverage wildcards**: Simplify tool lists with patterns
- **Tool aliases**: Resolve naming conflicts early

### Resource Management

- **Include project rules**: Always reference `.amazonq/rules/**/*.md`
- **Glob patterns**: Use for dynamic documentation inclusion
- **Relative paths**: Prefer relative paths for portability

### Hook Integration

- **Validate inputs**: Use `preToolUse` for security validation
- **Automate formatting**: Use `postToolUse` for code formatting
- **Gather context**: Use `agentSpawn` for initial context gathering

## Troubleshooting

### Agent Not Found

```bash
# Verify agent file exists
ls ~/.aws/amazonq/cli-agents/

# Check JSON syntax
jq . ~/.aws/amazonq/cli-agents/agent-name.json
```

### Tool Permission Errors

- Verify tool is included in `tools` array
- Check if tool should be in `allowedTools`
- Review `toolsSettings` for path restrictions

### Resource Loading Failures

- Verify file paths are correct
- Check glob patterns match expected files
- Ensure files exist at specified locations

### Hook Execution Errors

- Check hook command syntax
- Verify exit codes (0=success, 2=block, other=warning)
- Review STDERR output for error messages

## Additional Resources

**Official Documentation:**
- Agent Format: https://github.com/aws/amazon-q-developer-cli/blob/main/docs/agent-format.md
- Agent File Locations: https://github.com/aws/amazon-q-developer-cli/blob/main/docs/agent-file-locations.md
- Built-in Tools: https://github.com/aws/amazon-q-developer-cli/blob/main/docs/built-in-tools.md
- Default Agent Behavior: https://github.com/aws/amazon-q-developer-cli/blob/main/docs/default-agent-behavior.md

**Schema:**
- JSON Schema: https://raw.githubusercontent.com/aws/amazon-q-developer-cli/refs/heads/main/schemas/agent-v1.json

**Related Guides:**
- [Hooks Configuration](../hooks/README.md)
- [Rules Configuration](../rules/README.md)
- [MCP Servers Configuration](../mcp/README.md)

---

**Last Updated:** 2025-10-04
