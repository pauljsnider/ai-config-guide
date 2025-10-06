# Cursor Agents

Cursor supports background agents defined in `.cursor/agents/*.mdc`. These files use YAML front matter to declare metadata (for example `alwaysApply`, `triggers`, or environment hints) followed by markdown instructions that drive the agent’s behaviour.

Real-world examples include:

- [jukangpark/Code_King_Builder](https://github.com/jukangpark/Code_King_Builder/blob/27ad40386a6c9a140f7225e1635ee667c75ed518/.cursor/agents/readme-agent.mdc) – README maintenance agent.
- [luanralid/specere](https://github.com/luanralid/specere/blob/cba004582d9b702dd343fe2ec59b80f5d9914fe1/.cursor/agents/AGENTS.md) – WhatsApp automation instructions.

## File Structure

```md
---
name: build-maintainer
alwaysApply: false
triggers:
  - onFileChange
---
# Build Maintainer Agent

Describe goals, monitoring rules, and response templates here.
```

Front matter keys are optional but commonly include:

- `name`: Unique identifier for the agent.
- `alwaysApply`: Whether the instructions should be loaded automatically.
- `triggers`: Event hints for background execution (e.g. file changes).

## Locations

- **Global:** `~/.cursor/agents/`
- **Project:** `./.cursor/agents/`

Project-level agents are typically committed to source control so the entire team benefits from shared automation.

## Usage Tips

- Keep instructions concise; agents run in the background while you work.
- Include checklists to enforce verification steps.
- Reference companion commands or rules to keep guidance consistent.
- Document any required environment variables in `.cursor/settings.json` or project documentation.

See [example-agent.mdc](./example-agent.mdc) for a starter file.
