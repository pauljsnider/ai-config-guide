# Claude Code Skills

Skills extend Claude Code with specialized capabilities, custom workflows, and API integrations. Each skill is a self-contained package that Claude can automatically invoke when relevant.

## What Are Skills?

Skills are markdown-based configurations (SKILL.md) that:
- Define custom AI capabilities with specific knowledge and tools
- Declare which tools Claude can use (Bash, Read, Write, Edit, etc.)
- Include scripts, documentation, and resources
- Are automatically invoked by Claude when the task matches the skill's description

Think of skills as "expert modes" that give Claude specialized knowledge and permissions for specific domains.

## Available Skills

### [ms-graph-toolkit](./ms-graph-toolkit/)

Microsoft Graph API integration for Microsoft 365 services with comprehensive capabilities.

**Capabilities:**
- Calendar management (find availability, book meetings, list events)
- OneDrive file operations (search, list, share)
- Outlook email integration (search, send, manage inbox)
- Teams messaging (channels, chats, notifications)
- User directory search
- OneNote operations
- Organizational intelligence (find experts, collaboration patterns)
- Productivity automation (status reports, meeting analysis)

**Use Cases:**
- Schedule meetings automatically
- Search across all Microsoft 365 data
- Automate calendar and email workflows
- Generate weekly status reports from calendar/tasks
- Find organizational experts by topic
- Analyze meeting patterns and collaboration

### [ms-graph-search-sdk](./ms-graph-search-sdk/)

Quick and simple Microsoft 365 search using Python and the Graph API.

**Capabilities:**
- OneDrive file search
- Outlook email search
- Calendar event queries
- Teams exploration
- Unified search across services

**Use Cases:**
- Quick file lookups in OneDrive
- Search emails by keyword
- Find documents shared with you
- List upcoming meetings

**Differences from ms-graph-toolkit:**
- Simpler, lightweight Python scripts
- Focused on search and retrieval
- No on-demand script generation
- Direct API calls with requests library
- Preferred for quick queries

## Installation

### 1. Create Skills Directory

```bash
mkdir -p ~/.claude/skills
```

### 2. Install Skills from This Repository

```bash
# Install all skills
cp -r claude/skills/* ~/.claude/skills/

# Or install specific skills
cp -r claude/skills/ms-graph-toolkit ~/.claude/skills/
cp -r claude/skills/ms-graph-search-sdk ~/.claude/skills/
```

### 3. Verify Installation

```bash
ls ~/.claude/skills/
# Should show: ms-graph-toolkit ms-graph-search-sdk
```

Skills are automatically discovered by Claude Code when placed in `~/.claude/skills/`.

## Using Skills

### Automatic Invocation

Claude automatically uses skills when your request matches the skill's description:

```bash
claude "Find my calendar availability next week"
# Automatically uses ms-graph-toolkit

claude "Search my OneDrive for project reports"
# Automatically uses ms-graph-search-sdk (simpler search)

claude "Find the Kubernetes expert in my company"
# Automatically uses ms-graph-toolkit (advanced analysis)
```

### Manual Invocation

You can also explicitly reference a skill:

```bash
claude "Using ms-graph-toolkit, schedule a meeting with Alice tomorrow at 2pm"
```

## Skill Structure

Each skill follows this structure:

```
skill-name/
├── SKILL.md           # Skill configuration (required)
├── scripts/           # Executable scripts (optional)
│   ├── category1/
│   │   └── script1.py
│   └── category2/
│       └── script2.sh
├── resources/         # Data files, templates (optional)
└── README.md          # User documentation (optional)
```

### SKILL.md Format

The SKILL.md file contains YAML front matter and markdown documentation:

```markdown
---
name: skill-name
description: Brief description used by Claude to determine when to invoke this skill
allowed-tools: [Bash, Read, Write, Edit]
---

# Skill Name

Detailed documentation goes here...

## Setup

Installation instructions...

## Usage

Examples and API reference...
```

**Front Matter Fields:**
- `name` - Skill identifier (must match directory name)
- `description` - When Claude should use this skill (keep concise)
- `allowed-tools` - Array of tools the skill can use

**Allowed Tools:**
- `Bash` - Execute shell commands
- `Read` - Read files
- `Write` - Create/overwrite files
- `Edit` - Modify existing files
- `Glob` - Find files by pattern
- `Grep` - Search file contents
- `WebFetch` - Fetch web content
- `WebSearch` - Search the web

## Creating Custom Skills

### Step 1: Plan Your Skill

Identify:
- What problem does it solve?
- What APIs or tools does it need?
- What information should Claude know?

### Step 2: Create Skill Structure

```bash
cd ~/.claude/skills
mkdir my-skill
cd my-skill
```

### Step 3: Write SKILL.md

```markdown
---
name: my-skill
description: Description of when to use this skill
allowed-tools: [Bash, Read, Write]
---

# My Skill

## Overview

What this skill does...

## Setup

### Prerequisites

- Tool X installed
- API key for service Y

### Configuration

1. Install dependencies...
2. Set environment variables...

## Usage

### Common Tasks

#### Task 1
Description and examples...

#### Task 2
Description and examples...

## Reference

API endpoints, commands, etc...
```

### Step 4: Add Scripts (Optional)

Create executable scripts in `scripts/`:

```bash
mkdir -p scripts
cat > scripts/example.py <<'EOF'
#!/usr/bin/env python3
import os
import sys

# Read from environment variable, never from arguments
api_key = os.getenv('MY_API_KEY')
if not api_key:
    print("Error: MY_API_KEY not set", file=sys.stderr)
    sys.exit(1)

# Your script logic here...
EOF

chmod +x scripts/example.py
```

### Step 5: Test the Skill

```bash
# Test scripts directly
python3 ~/.claude/skills/my-skill/scripts/example.py

# Test with Claude
claude "Use my-skill to do something"
```

## Best Practices

### Skill Design

- **Single Responsibility** - Each skill should have one clear purpose
- **Clear Description** - Help Claude know when to invoke your skill
- **Self-Documenting** - SKILL.md should be comprehensive
- **Examples First** - Show common use cases before deep reference

### Security

- **Environment Variables** - Never pass secrets as script arguments
- **Token Warnings** - Explicitly warn users not to expose tokens
- **Minimal Permissions** - Only request tools you actually need
- **Input Validation** - Validate all user inputs in scripts
- **No Logging Secrets** - Never log or print sensitive data

### Script Standards

- **Portable** - No hardcoded paths or user-specific values
- **Error Handling** - Clear error messages to stderr
- **Exit Codes** - 0 for success, non-zero for errors
- **JSON Output** - Support `--json` flag for programmatic use
- **Help Text** - Include usage info with `--help`

### Documentation

- **Installation Steps** - Clear prerequisites and setup
- **Quick Examples** - Show 80% use cases upfront
- **API Reference** - Detailed options and parameters
- **Troubleshooting** - Common errors and solutions

## Self-Evolving Skills

Skills can be designed to evolve themselves. For example, the ms-graph-toolkit skill:

- Starts with basic functionality and documentation
- Claude can add new scripts when users need them
- Claude can update documentation as new features are added
- The skill becomes more capable over time

**How to enable self-evolution:**

1. Include guidelines in SKILL.md for when to modify scripts
2. Use clear patterns that Claude can extend
3. Document the script structure and conventions
4. Trust Claude to maintain backward compatibility

## Troubleshooting

### Skill Not Loaded

**Symptom:** Claude doesn't recognize the skill

**Solutions:**
- Verify skill is in `~/.claude/skills/`
- Check SKILL.md exists and has valid YAML front matter
- Ensure `name` in front matter matches directory name
- Restart Claude Code

### Permission Errors

**Symptom:** "Tool X not allowed for this skill"

**Solutions:**
- Add tool to `allowed-tools` in SKILL.md front matter
- Verify tool name is spelled correctly
- Check tool is supported by Claude Code

### Script Execution Errors

**Symptom:** Scripts fail when Claude runs them

**Solutions:**
- Test scripts manually first
- Check file permissions (`chmod +x`)
- Verify dependencies are installed
- Use absolute paths in scripts
- Check environment variables are set

## Example Skills Ideas

### API Integrations
- **github-toolkit** - Issues, PRs, releases, workflows
- **aws-toolkit** - EC2, S3, Lambda, CloudFormation
- **jira-toolkit** - Issue tracking, sprints, reporting
- **slack-toolkit** - Channels, messages, notifications

### Development Tools
- **test-runner** - Run project tests with different frameworks
- **deploy-helper** - Deployment scripts and verification
- **code-reviewer** - Automated code review checks
- **dependency-updater** - Manage package updates

### Productivity
- **meeting-scheduler** - Smart calendar management
- **status-reporter** - Weekly summaries and updates
- **knowledge-base** - Search internal documentation
- **time-tracker** - Track time spent on tasks

### Infrastructure
- **docker-toolkit** - Container management
- **k8s-toolkit** - Kubernetes operations
- **terraform-helper** - IaC management
- **monitoring-alerts** - Query metrics and logs

## Contributing

### Share Your Skills

If you create useful skills, consider:
1. Publishing them to GitHub
2. Submitting a PR to add them to this repository
3. Sharing in the Claude Code community

### Improve Existing Skills

Contributions to existing skills are welcome:
- Bug fixes
- New features
- Better documentation
- Additional examples

## Resources

### Claude Code
- **Documentation**: https://docs.anthropic.com/claude/docs/claude-code
- **Skills Guide**: https://docs.anthropic.com/claude/docs/skills
- **GitHub**: https://github.com/anthropics/claude-code

### Skill Development
- **Agent SDK**: https://docs.anthropic.com/claude/docs/agent-sdk
- **Tool Use Guide**: https://docs.anthropic.com/claude/docs/tool-use
- **Best Practices**: https://docs.anthropic.com/claude/docs/best-practices

---

**Last Updated:** 2026-01-11

**Note:** Skills run with the same permissions as Claude Code. Review skill code before installation, especially for scripts that execute commands or access sensitive data.
