# Amazon Q CLI - Hooks Configuration Guide

Event-driven automation that executes commands at specific trigger points in Amazon Q CLI.

## Overview

Hooks allow you to execute custom commands at specific points during agent lifecycle and tool execution. This enables security validation, logging, formatting, context gathering, and other custom behaviors for Amazon Q CLI.

## Configuration Location

Hooks are defined in agent JSON files under the `hooks` field.

**File:** `~/.aws/amazonq/cli-agents/agent-name.json`

## Hook Types

| Hook Type | Trigger | Can Block | Input | Use Cases |
|-----------|---------|-----------|-------|-----------|
| `agentSpawn` | Agent initialization | No | None | Context gathering, setup |
| `userPromptSubmit` | User submits message | No | User prompt | Pre-processing, logging |
| `preToolUse` | Before tool execution | Yes (exit 2) | Tool name & input | Validation, security |
| `postToolUse` | After tool execution | No | Tool name, input & response | Formatting, cleanup |
| `stop` | Assistant finishes response | No | None | Post-processing, tasks |

## Configuration Format

```json
{
  "hooks": {
    "agentSpawn": [
      {
        "command": "shell command here"
      }
    ],
    "userPromptSubmit": [
      {
        "command": "shell command here"
      }
    ],
    "preToolUse": [
      {
        "matcher": "tool-pattern",
        "command": "shell command here"
      }
    ],
    "postToolUse": [
      {
        "matcher": "tool-pattern",
        "command": "shell command here"
      }
    ],
    "stop": [
      {
        "command": "shell command here"
      }
    ]
  }
}
```

## Hook Event Input

Hooks receive JSON input via STDIN:

**agentSpawn:**
```json
{
  "hook_event_name": "agentSpawn",
  "cwd": "/current/working/directory"
}
```

**userPromptSubmit:**
```json
{
  "hook_event_name": "userPromptSubmit",
  "cwd": "/current/working/directory",
  "prompt": "user's input prompt"
}
```

**preToolUse / postToolUse:**
```json
{
  "hook_event_name": "preToolUse",
  "cwd": "/current/working/directory",
  "tool_name": "fs_read",
  "tool_input": {
    "operations": [
      {
        "mode": "Line",
        "path": "/path/to/file.md"
      }
    ]
  },
  "tool_response": {
    "success": true,
    "result": ["file content..."]
  }
}
```

**stop:**
```json
{
  "hook_event_name": "stop",
  "cwd": "/current/working/directory"
}
```

## Exit Codes

| Exit Code | Behavior | Use Cases |
|-----------|----------|-----------|
| `0` | Success - Continue | Normal completion |
| `2` | Block (preToolUse only) | Security violation, validation failure |
| Other | Warning | Log error but continue |

**Example - Blocking Tool Use:**
```bash
#!/bin/bash
# Block dangerous operations
if echo "$input" | grep -q "rm -rf /"; then
  echo "Dangerous operation blocked!" >&2
  exit 2
fi
exit 0
```

## Tool Matchers

Matchers filter which tools trigger the hook:

**Exact Match:**
```json
{
  "matcher": "fs_read",
  "command": "echo 'Reading file'"
}
```

**Wildcard Patterns:**
```json
{
  "matcher": "fs_*",
  "command": "echo 'Filesystem operation'"
}
```

**MCP Server Tools:**
```json
{
  "matcher": "@memory/*",
  "command": "echo 'Memory operation'"
}
```

**Multiple Matchers:**
```json
{
  "hooks": {
    "preToolUse": [
      {
        "matcher": "execute_bash",
        "command": "audit_bash_command.sh"
      },
      {
        "matcher": "use_aws",
        "command": "audit_aws_command.sh"
      }
    ]
  }
}
```

## Hook Examples

### 1. Context Gathering (agentSpawn)

Provide git context when agent starts:

```json
{
  "hooks": {
    "agentSpawn": [
      {
        "command": "git status && git log -1 --oneline"
      }
    ]
  }
}
```

### 2. User Prompt Logging (userPromptSubmit)

Log all user prompts for audit:

```json
{
  "hooks": {
    "userPromptSubmit": [
      {
        "command": "{ echo \"$(date) - User:\"; cat; echo; } >> /tmp/prompt_audit.log"
      }
    ]
  }
}
```

### 3. Security Validation (preToolUse)

Audit and log bash commands:

```json
{
  "hooks": {
    "preToolUse": [
      {
        "matcher": "execute_bash",
        "command": "{ echo \"$(date) - Bash command:\"; cat; echo; } >> /tmp/bash_audit.log"
      },
      {
        "matcher": "use_aws",
        "command": "{ echo \"$(date) - AWS CLI call:\"; cat; echo; } >> /tmp/aws_audit.log"
      }
    ]
  }
}
```

### 4. Auto-Formatting (postToolUse)

Format Rust code after file writes:

```json
{
  "hooks": {
    "postToolUse": [
      {
        "matcher": "fs_write",
        "command": "jq -r '.tool_input.operations[].path' | grep '\\.rs$' && cargo fmt --all"
      }
    ]
  }
}
```

### 5. Build Verification (stop)

Run build after agent completes:

```json
{
  "hooks": {
    "stop": [
      {
        "command": "npm run build"
      }
    ]
  }
}
```

## Complete Example

**File:** `~/.aws/amazonq/cli-agents/dev-agent.json`

```json
{
  "name": "dev-agent",
  "description": "Development agent with hooks",
  "tools": ["*"],
  "hooks": {
    "agentSpawn": [
      {
        "command": "git status && git log -1 --oneline"
      }
    ],
    "userPromptSubmit": [
      {
        "command": "{ echo \"$(date) - User:\"; cat; echo; } >> /tmp/prompt_log.txt"
      }
    ],
    "preToolUse": [
      {
        "matcher": "execute_bash",
        "command": "{ echo \"$(date) - Bash:\"; cat; echo; } >> /tmp/bash_audit.log"
      },
      {
        "matcher": "use_aws",
        "command": "{ echo \"$(date) - AWS:\"; cat; echo; } >> /tmp/aws_audit.log"
      }
    ],
    "postToolUse": [
      {
        "matcher": "fs_write",
        "command": "jq -r '.tool_input.operations[].path' | grep '\\.rs$' && cargo fmt --all || true"
      }
    ],
    "stop": [
      {
        "command": "npm run build"
      }
    ]
  }
}
```

## Best Practices

### Security

- **Audit sensitive operations** - Log bash, AWS, and filesystem operations
- **Validate inputs** - Use preToolUse to block dangerous commands
- **Never expose secrets** - Don't log credentials or tokens
- **Use exit code 2** - Block preToolUse when validation fails

### Performance

- **Keep hooks fast** - Slow hooks delay agent response
- **Avoid blocking operations** - Use background tasks when possible
- **Cache results** - Don't repeat expensive operations
- **Limit scope** - Use specific matchers instead of wildcards

### Reliability

- **Handle errors gracefully** - Use `|| true` for non-critical commands
- **Test independently** - Verify hook commands work standalone
- **Log to files** - Don't rely on STDOUT for debugging
- **Version control** - Track hook changes in git

### Organization

- **Group related hooks** - Keep security, formatting, and logging separate
- **Document purpose** - Add comments explaining hook behavior
- **Use descriptive names** - Clear matcher patterns
- **Consistent format** - Follow patterns across agents

## Troubleshooting

### Hook Not Executing

**Verify hook configuration:**
```bash
# Check JSON syntax
jq . ~/.aws/amazonq/cli-agents/agent-name.json

# Verify agent is active
q agent list
```

**Test hook command:**
```bash
# Test command independently
echo '{"hook_event_name":"agentSpawn"}' | your-command-here
```

### Hook Blocking Tool Use

**Check exit codes:**
```bash
# Verify your hook script
bash -x your-hook-script.sh
echo $?  # Should be 0 for success, 2 to block
```

### Matcher Not Working

**Test matcher patterns:**
```json
{
  "matcher": "fs_*",        // Matches fs_read, fs_write
  "matcher": "@memory/*",   // Matches @memory/create_entity
  "matcher": "execute_bash" // Exact match only
}
```

### Performance Issues

**Profile hook execution:**
```bash
# Add timing to hook
time your-command-here
```

## Additional Resources

**Official Documentation:**
- Hooks Documentation: https://github.com/aws/amazon-q-developer-cli/blob/main/docs/hooks.md
- Agent Format: https://github.com/aws/amazon-q-developer-cli/blob/main/docs/agent-format.md

**Related Guides:**
- [Agents Configuration](../agents/README.md)
- [MCP Servers Configuration](../mcp/README.md)
- [Rules Configuration](../rules/README.md)

---

**Last Updated:** 2025-10-04
