# Kiro IDE - Hooks Configuration Guide

Event-driven automation using `.kiro.hook` files in Kiro IDE.

## Overview

Kiro IDE hooks enable event-driven automation through JSON configuration files with a `.kiro.hook` extension. Hooks trigger AI agent responses based on specific events like file saves, allowing you to automate code reviews, testing, documentation, and more.

## Configuration Location

**Directory:** `~/.kiro/hooks/`

All files with `.kiro.hook` extension in this directory are automatically loaded by Kiro IDE.

## File Structure

```
~/.kiro/
└── hooks/
    ├── code-review.kiro.hook
    ├── test-generator.kiro.hook
    └── documentation.kiro.hook
```

## Hook File Format

```json
{
  "enabled": true,
  "name": "Hook Name",
  "description": "Description of what this hook does",
  "version": "1",
  "when": {
    "type": "fileEdited",
    "patterns": [
      "src/**/*.ts",
      "src/**/*.tsx"
    ]
  },
  "then": {
    "type": "askAgent",
    "prompt": "Your natural language prompt to the AI agent"
  }
}
```

## Configuration Fields

### Core Fields

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `enabled` | Yes | boolean | Whether the hook is active |
| `name` | Yes | string | Display name for the hook |
| `description` | Yes | string | Explanation of hook purpose |
| `version` | Yes | string | Hook format version (currently "1") |
| `when` | Yes | object | Event trigger configuration |
| `then` | Yes | object | Action to perform |

### When Configuration

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `type` | Yes | string | Event type (currently only "fileEdited") |
| `patterns` | Yes | array | Glob patterns for file matching |

**Supported Event Types:**
- `fileEdited` - Triggered when a file matching the pattern is saved

**Pattern Examples:**
```json
{
  "patterns": [
    "src/**/*.ts",           // All TypeScript files in src/
    "src/**/*.tsx",          // All TSX files in src/
    "**/*.js",               // All JavaScript files anywhere
    "tests/**/*",            // All files in tests/
    "*.md",                  // Markdown files in root
    "src/components/**/*.{ts,tsx}"  // Multiple extensions
  ]
}
```

### Then Configuration

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `type` | Yes | string | Action type (currently only "askAgent") |
| `prompt` | Yes | string | Natural language prompt for AI agent |

**Action Types:**
- `askAgent` - Send prompt to Kiro's AI agent

## Hook Examples

### 1. Code Review on Save

Automatically review code when TypeScript/JavaScript files are saved:

**File:** `~/.kiro/hooks/code-review.kiro.hook`

```json
{
  "enabled": true,
  "name": "Review Code on Save",
  "description": "Automatically review code files when saved for quality and best practices",
  "version": "1",
  "when": {
    "type": "fileEdited",
    "patterns": [
      "src/**/*.ts",
      "src/**/*.tsx",
      "src/**/*.js",
      "src/**/*.jsx"
    ]
  },
  "then": {
    "type": "askAgent",
    "prompt": "Review this code for:\n\n## Code Quality\n- Adherence to best practices\n- Code clarity and readability\n- Proper error handling\n\n## Potential Issues\n- Bugs or logical errors\n- Performance concerns\n- Security vulnerabilities\n\n## Improvements\n- Refactoring opportunities\n- Better patterns or approaches\n- Documentation needs\n\nProvide specific, actionable feedback with examples where helpful."
  }
}
```

### 2. Test Generator

Generate tests for new functions:

**File:** `~/.kiro/hooks/test-generator.kiro.hook`

```json
{
  "enabled": true,
  "name": "Generate Tests",
  "description": "Suggest tests for new code",
  "version": "1",
  "when": {
    "type": "fileEdited",
    "patterns": [
      "src/**/*.ts",
      "src/**/*.js"
    ]
  },
  "then": {
    "type": "askAgent",
    "prompt": "Analyze this code and suggest:\n\n1. Unit tests for new functions\n2. Edge cases to test\n3. Mock requirements\n4. Test file structure\n\nProvide code examples for the suggested tests."
  }
}
```

### 3. Documentation Checker

Check documentation completeness:

**File:** `~/.kiro/hooks/documentation.kiro.hook`

```json
{
  "enabled": true,
  "name": "Documentation Checker",
  "description": "Verify documentation is complete and accurate",
  "version": "1",
  "when": {
    "type": "fileEdited",
    "patterns": [
      "src/**/*.ts",
      "src/**/*.tsx"
    ]
  },
  "then": {
    "type": "askAgent",
    "prompt": "Review documentation for:\n\n- Missing JSDoc/TSDoc comments\n- Incomplete function descriptions\n- Missing parameter documentation\n- Missing return value documentation\n- Missing examples\n- Unclear explanations\n\nSuggest improvements with examples."
  }
}
```

### 4. Security Audit

Audit code for security issues:

**File:** `~/.kiro/hooks/security-audit.kiro.hook`

```json
{
  "enabled": true,
  "name": "Security Audit",
  "description": "Check for security vulnerabilities",
  "version": "1",
  "when": {
    "type": "fileEdited",
    "patterns": [
      "src/**/*.ts",
      "src/**/*.js",
      "src/**/*.tsx",
      "src/**/*.jsx"
    ]
  },
  "then": {
    "type": "askAgent",
    "prompt": "Perform security audit:\n\n## Check for:\n- SQL injection vulnerabilities\n- XSS vulnerabilities\n- Authentication/authorization issues\n- Sensitive data exposure\n- Insecure dependencies\n- Hardcoded secrets\n- Unsafe user input handling\n\n## Provide:\n- Severity rating for each issue\n- Specific code locations\n- Remediation recommendations"
  }
}
```

### 5. Performance Analysis

Analyze code for performance issues:

**File:** `~/.kiro/hooks/performance.kiro.hook`

```json
{
  "enabled": true,
  "name": "Performance Analysis",
  "description": "Identify performance bottlenecks and optimization opportunities",
  "version": "1",
  "when": {
    "type": "fileEdited",
    "patterns": [
      "src/**/*.ts",
      "src/**/*.tsx"
    ]
  },
  "then": {
    "type": "askAgent",
    "prompt": "Analyze code for performance:\n\n- Inefficient algorithms\n- Unnecessary re-renders (React)\n- Memory leaks\n- Blocking operations\n- Large bundle impacts\n- Database query optimization\n\nSuggest specific optimizations with code examples."
  }
}
```

## Best Practices

### Hook Design

- **Focused prompts** - Each hook should have a clear, specific purpose
- **Actionable requests** - Ask for specific, actionable feedback
- **Provide context** - Include relevant details in prompts
- **Use examples** - Request code examples when applicable

### File Patterns

- **Be specific** - Use precise patterns to avoid unnecessary triggers
- **Group related files** - Combine similar file types
- **Exclude test files** - Avoid triggering on test file saves when not needed
- **Consider scope** - Match files that benefit from the hook

### Performance

- **Disable unused hooks** - Set `enabled: false` for hooks you're not using
- **Limit patterns** - Don't match more files than necessary
- **Keep prompts concise** - Shorter prompts process faster
- **Test incrementally** - Start with one hook, add more gradually

### Organization

- **One hook per file** - Separate concerns into different files
- **Descriptive names** - Use clear, meaningful names
- **Document purpose** - Write detailed descriptions
- **Version control** - Track hooks in git repository

## Workflow Integration

### Development Workflow

1. **Write code** in Kiro IDE
2. **Save file** (⌘+S or Ctrl+S)
3. **Hook triggers** based on file pattern
4. **AI agent analyzes** code with your prompt
5. **Review feedback** in Kiro chat panel
6. **Iterate** based on suggestions

### Team Standardization

Share hooks with your team:

```bash
# Commit hooks to repository
git add .kiro-hooks/
git commit -m "Add team code review hooks"
git push

# Team members install
cp .kiro-hooks/* ~/.kiro/hooks/
```

## Troubleshooting

### Hook Not Triggering

**Check file location:**
```bash
ls ~/.kiro/hooks/
# Verify .kiro.hook files exist
```

**Verify JSON syntax:**
```bash
jq . ~/.kiro/hooks/your-hook.kiro.hook
# Should parse without errors
```

**Check enabled field:**
```json
{
  "enabled": true  // Must be true
}
```

### Pattern Not Matching

**Test pattern:**
```bash
# Use glob tester or manually verify
# Pattern: "src/**/*.ts"
# Should match: src/components/Button.ts
# Should not match: test/Button.test.ts
```

**Common pattern issues:**
- Missing `**/` for recursive matching
- Wrong file extension
- Case sensitivity issues
- Incorrect path separators

### AI Agent Not Responding

**Check Kiro IDE:**
- Verify Kiro IDE is running
- Check AI agent is active
- Review Kiro logs for errors
- Restart Kiro IDE

**Check hook configuration:**
- Verify `then.type` is "askAgent"
- Ensure prompt is not empty
- Test prompt manually in chat

## Advanced Usage

### Conditional Prompts

Use descriptive prompts that guide the AI based on context:

```json
{
  "prompt": "If this is a React component:\n- Review hooks usage\n- Check prop types\n- Verify accessibility\n\nIf this is a utility function:\n- Review error handling\n- Check edge cases\n- Verify type safety"
}
```

### Multi-Stage Reviews

Create separate hooks for different review stages:

1. **Quick review** - Fast feedback on every save
2. **Deep review** - Comprehensive analysis (manual trigger)
3. **Pre-commit** - Final check before committing

### Context-Aware Hooks

Tailor prompts to specific directories:

```json
{
  "patterns": ["src/api/**/*.ts"],
  "prompt": "Review this API endpoint for:\n- RESTful conventions\n- Error handling\n- Authentication\n- Input validation\n- Response format"
}
```

## Additional Resources

**Official Documentation:**
- Kiro Documentation: https://kiro.dev/docs/
- Hooks Guide: https://kiro.dev/docs/hooks/
- Getting Started: https://kiro.dev/docs/getting-started/

**GitHub Resources:**
- Awesome Kiro: https://github.com/friends-of-kiro/awesome-kiro
- TDD Workflow: https://github.com/5capeg0at/kiro-tdd-workflow-files

**Related Guides:**
- [MCP Servers Configuration](../mcp/README.md)
- [Kiro IDE Overview](../README.md)

---

**Last Updated:** 2025-10-04
