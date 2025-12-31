# Kiro CLI Agents

Custom agents extend Kiro CLI with specialized behaviors, tools, and prompts.

## Quickstart

```powershell
# 1. Copy agent to global config
copy agents\*.json ~\.kiro\agents\

# 2. Copy related steering files
copy steering\tech-debt-rules.md ~\.kiro\steering\

# 3. Start Kiro with the agent
kiro-cli --agent tech-debt-collector

# Or swap to it during a session
/agent swap
```

## Structure

```
~/.kiro/
├── agents/                    # Global agents (available everywhere)
│   └── tech-debt-collector.json
├── hooks/                     # Global hooks
│   └── tech-debt-score.json
└── steering/                  # Global steering files
    └── tech-debt-rules.md
```

**Project-level agents** (optional):
```
my-project/
└── .kiro/
    └── agents/               # Project-specific agents
        └── my-agent.json
```

## Agent Configuration Format

```json
{
  "name": "agent-name",
  "description": "What this agent does",
  "prompt": "System prompt and instructions",
  "tools": ["read", "write", "shell", "grep", "glob"],
  "resources": ["file://~/.kiro/steering/rules.md"]
}
```

### Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | No | Agent name (derived from filename if omitted) |
| `description` | No | Human-readable description |
| `prompt` | No | System prompt with instructions |
| `tools` | No | Array of available tools |
| `resources` | No | Files to include as context (`file://` URIs) |
| `mcpServers` | No | MCP servers specific to this agent |
| `allowedTools` | No | Tools that don't require confirmation |
| `model` | No | Override default model |

### Available Tools

| Tool | Description |
|------|-------------|
| `read` | Read files and directories |
| `write` | Write/create files |
| `shell` | Execute shell commands |
| `grep` | Search file contents |
| `glob` | Find files by pattern |
| `@mcp_server/*` | All tools from an MCP server |
| `@mcp_server/tool` | Specific MCP tool |

## CLI Commands

```bash
# List available agents
/agent list

# Create new agent interactively
/agent create my-agent

# Generate agent with AI assistance
/agent generate

# Swap to different agent
/agent swap

# Start with specific agent
kiro-cli --agent my-agent

# Set default agent
/agent set-default my-agent
```

## Included Agents

### tech-debt-collector

Guides you through collecting and scoring tech debt across multiple sources.

**Sources supported:**
- GitHub (repos, PRs, issues, CODEOWNERS)
- Jira (backlog, aged issues)
- Confluence (architecture docs, ADRs)
- Mend (dependency vulnerabilities)
- Checkmarx (SAST findings)

**Usage:**
```bash
kiro-cli --agent tech-debt-collector
> help me score this project for tech debt
```

The agent will ask you:
1. Which project/repo to analyze
2. Which data sources are available
3. For exports if APIs aren't configured
4. Jira project keys / Confluence spaces

Then produces a scored, prioritized tech debt report.

## References

- [Custom Agents Overview](https://kiro.dev/docs/cli/custom-agents/)
- [Creating Custom Agents](https://kiro.dev/docs/cli/custom-agents/creating/)
- [Agent Configuration Reference](https://kiro.dev/docs/cli/custom-agents/configuration-reference/)
- [Agent Examples](https://kiro.dev/docs/cli/custom-agents/examples/)
