# Kiro CLI Hooks

Hooks are automated triggers that execute agent prompts or shell commands when specific events occur.

## Quickstart

```powershell
# 1. Copy hooks to global config
copy hooks\*.json ~\.kiro\hooks\

# 2. In Kiro CLI, invoke manual hooks by name
# (Hook name comes from the "name" field in JSON)
```

## Structure

```
~/.kiro/
├── hooks/                     # Global hooks
│   └── tech-debt-score.json
└── steering/                  # Related steering files
    └── tech-debt-rules.md
```

**Project-level hooks** (optional):
```
my-project/
└── .kiro/
    └── hooks/
        └── my-hook.json
```

## Hook Configuration Format

```json
{
  "name": "hook-name",
  "description": "What this hook does",
  "trigger": "manual",
  "allowedTools": ["read", "write", "shell"],
  "instructions": "What to do when triggered"
}
```

### Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Hook identifier |
| `description` | No | Human-readable description |
| `trigger` | Yes | When to execute (see Trigger Types) |
| `allowedTools` | No | Tools the hook can use |
| `instructions` | Yes | Agent prompt to execute |

### Trigger Types

| Trigger | When It Fires |
|---------|---------------|
| `manual` | User invokes explicitly |
| `file-save` | File matching pattern saved |
| `file-create` | New file created |
| `file-delete` | File deleted |
| `userPromptSubmit` | Before agent processes prompt |
| `preToolUse` | Before tool executes (can block) |

### File Pattern Triggers

For file-based triggers, add a pattern:

```json
{
  "name": "lint-on-save",
  "trigger": "file-save",
  "pattern": "**/*.py",
  "instructions": "Run linter on the saved file"
}
```

## Included Hooks

### tech-debt-score

Manual hook that scores a project for tech debt.

**Usage:**
```
# In Kiro CLI chat
help me score tech debt
```

The hook guides you through:
1. Identifying the project
2. Selecting available data sources
3. Collecting and categorizing findings
4. Scoring using: (Risk × Exposure × Age) ÷ Effort
5. Producing a ranked report

## References

- [Hooks Overview](https://kiro.dev/docs/cli/hooks/)
- [Hook Types](https://kiro.dev/docs/hooks/types/)
- [Hook Examples](https://kiro.dev/docs/hooks/examples/)
