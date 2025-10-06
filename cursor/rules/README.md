# Cursor Rules Configuration

Project-scoped rules help Cursor tailor AI assistance to your repository. Cursor reads both `.cursorrules` files and Markdown-with-front-matter `.mdc` files stored under `.cursor/rules/`.

## File Locations

| Purpose | Path |
|---------|------|
| Repository instructions | `./.cursorrules` |
| Structured rule bundles | `./.cursor/rules/*.mdc` |

The `.cursorrules` convention is widely documented by community projects such as [patrickjs/awesome-cursorrules](https://github.com/patrickjs/awesome-cursorrules). The `.cursor/rules` directory uses Markdown with YAML front matter (see examples like [phamhung075/cursor-agentic-ai](https://github.com/phamhung075/cursor-agentic-ai/tree/0f9724948af01c637864460c90bef7b026bb225e/.cursor/rules)).

## Getting Started

1. **Create a `.cursorrules` file** in the root of your repository.
2. **Describe project context** (tech stack, architecture decisions, naming conventions, testing strategy).
3. **Add best practices** your team expects Cursor to follow.
4. **Optional:** Organize richer documentation in `.cursor/rules/*.mdc` for reusable prompts. Each `.mdc` file supports YAML front matter fields such as `description`, `globs`, and `alwaysApply`.

## Example `.cursorrules`

See [example.cursorrules](./example.cursorrules) for a starter template. It combines project overview, style guidelines, and testing expectations—mirroring patterns from curated repositories like `awesome-cursorrules`.

## Community Catalogs

- [Cursor Directory](https://cursor.directory/) – Discover community-maintained rules and MCP integrations.
- [patrickjs/awesome-cursorrules](https://github.com/patrickjs/awesome-cursorrules) – Large catalog of `.cursorrules` organized by technology.
- [pontusab/directories](https://github.com/pontusab/directories) – Source for the Cursor Directory with contribution guidelines.

## Best Practices

- Keep instructions actionable and concise.
- Mention file structure so Cursor places new code in the right location.
- Document testing expectations (unit, integration, e2e).
- Update rules whenever you change team conventions or dependencies.
- Store sensitive data (keys, tokens) outside of rules; use environment variables instead.

## Validation

1. **Open the repository in Cursor** – the editor loads `.cursorrules` automatically.
2. **Use “Rules for AI” panel** – confirm your text appears in the IDE sidebar.
3. **Test `.mdc` prompts** by invoking them from the Cursor command palette or the agent sidebar.

Refresh the IDE if you edit rules while Cursor is open.
