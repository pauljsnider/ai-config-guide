# Cursor Commands

Cursor recognises command definitions stored under `.cursor/commands/*.md`. Each markdown file describes a repeatable workflow that the agent can execute from the command palette (`Cmd/Ctrl + K`) or via slash commands.

## Format

Community templates such as [github/spec-kit](https://github.com/github/spec-kit/blob/23e0c5c83cecc129d3679522499b9df8b3f377c1/AGENTS.md) and real-world repositories like [wisarootl/leetcode-py](https://github.com/wisarootl/leetcode-py/blob/85bbb073e16c2344042071838875d46b75d8f427/.cursor/commands/batch-problem-creation.md) show that each file contains:

- A top-level heading describing the command
- Step-by-step sections outlining the workflow
- Shell snippets or tool invocations the assistant should run
- Explicit instructions for validation and reporting

Commands are plain markdown and can include fenced code blocks, checklists, or reference links. Cursor displays the content to the agent when the command is triggered, ensuring deterministic behaviour.

## Locations

- **Global:** `~/.cursor/commands/` (shared across workspaces)
- **Project:** `./.cursor/commands/` (checked into source control)

When both exist, project commands take precedence for that repository.

## Usage

1. Create `.cursor/commands/` in your project.
2. Add markdown files summarising the workflow your agent should follow.
3. Open the command palette in Cursor and search for the command title.
4. Cursor injects the file content into the agent’s context before execution.

## Recommended Practices

- Keep commands idempotent wherever possible.
- Reference supporting files (tests, scripts) with relative paths.
- Document critical steps (quality checks, approvals) explicitly.
- Break large automations into focused commands to aid discoverability.

See [example-command.md](./example-command.md) for a starter template.
