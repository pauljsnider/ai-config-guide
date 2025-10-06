# Amazon Q CLI - Rules Configuration Guide

Project-specific coding standards and guidelines stored as Markdown files.

## Overview

Rules allow you to define project-specific guidelines, coding standards, and behavioral rules for Amazon Q CLI through markdown files. These rules are automatically integrated into agent contexts, ensuring consistent behavior across your development workflow.

## Configuration Location

**Directory:** `.amazonq/rules/**/*.md` (workspace-specific)

All `.md` files in the rules directory and subdirectories are automatically loaded.

## File Structure

```
project/
├── .amazonq/
│   └── rules/
│       ├── coding-standards.md
│       ├── architecture-guidelines.md
│       ├── security-policies.md
│       └── team-conventions.md
└── src/
    └── main.py
```

## Rule Categories

### 1. Coding Standards

**File:** `.amazonq/rules/coding-standards.md`

```markdown
# Coding Standards

## General Principles
- Write clear, maintainable code
- Follow language-specific conventions
- Prioritize readability over cleverness

## Language-Specific

### Python
- Use Black for code formatting
- Maximum line length: 88 characters
- Use type hints for all function parameters and return values
- Follow PEP 8 naming conventions

### TypeScript
- Use ESLint with recommended rules
- Enable strict mode
- Prefer interfaces over type aliases for object shapes
- Use async/await over raw Promises

## Error Handling
- Always use specific exception types
- Include meaningful error messages
- Log errors at appropriate levels
- Never swallow exceptions silently

## Testing
- Write tests for new features
- Maintain test coverage above 80%
- Use descriptive test names
- Follow Arrange-Act-Assert pattern
```

### 2. Architecture Patterns

**File:** `.amazonq/rules/architecture-guidelines.md`

```markdown
# Architecture Guidelines

## Service Architecture
- Use microservices pattern for new features
- Implement circuit breaker pattern for external API calls
- All services must expose health check endpoints at `/health`
- Use API Gateway for external-facing services

## Database Access
- Use repository pattern for data access
- No direct database queries in controllers
- Implement proper connection pooling
- Use migrations for schema changes

## API Design
- Follow RESTful conventions
- Use consistent naming (plural nouns for collections)
- Version APIs using URL path (`/api/v1/`)
- Return appropriate HTTP status codes

## Event-Driven Architecture
- Use message queues for async communication
- Implement idempotent event handlers
- Include correlation IDs in all events
- Use dead letter queues for failed messages

## Caching Strategy
- Cache at multiple levels (CDN, application, database)
- Use Redis for distributed caching
- Implement cache invalidation strategies
- Monitor cache hit rates
```

### 3. Security Policies

**File:** `.amazonq/rules/security-policies.md`

```markdown
# Security Guidelines

## Authentication
- All API endpoints must require authentication
- Use JWT tokens with 1-hour expiration
- Implement proper session management
- Support OAuth 2.0 for third-party integrations

## Authorization
- Use role-based access control (RBAC)
- Implement least privilege principle
- Validate permissions on every request
- Never trust client-side permission checks

## Data Handling
- Never log sensitive information (passwords, tokens, PII)
- Encrypt all PII data at rest
- Use parameterized queries to prevent SQL injection
- Validate and sanitize all user inputs

## API Security
- Implement rate limiting on all endpoints
- Use HTTPS only (no HTTP)
- Validate Content-Type headers
- Implement CORS properly

## Dependency Management
- Keep dependencies up to date
- Use dependency scanning tools
- Review security advisories weekly
- Pin dependency versions in production
```

### 4. Team Conventions

**File:** `.amazonq/rules/team-conventions.md`

```markdown
# Team Conventions

## Code Review Process
- All changes require at least 2 approvals
- Include tests for new functionality
- Update documentation for API changes
- Address all review comments before merging

## Commit Messages
- Use conventional commit format
- Include ticket numbers in commit messages (e.g., [PROJ-123])
- Keep commits focused and atomic
- Write meaningful commit messages

Examples:
- `feat(auth): add OAuth2 support [PROJ-123]`
- `fix(api): handle null user in session [PROJ-456]`
- `docs(readme): update installation steps`

## Branch Strategy
- Create feature branches from `main`
- Use naming: `feature/PROJ-123-description`
- Delete branches after merging
- Keep branches up to date with main

## Pull Request Guidelines
- Include description of changes
- Reference related tickets
- Add screenshots for UI changes
- Update CHANGELOG.md
- Ensure CI passes before requesting review

## Documentation
- Update API documentation with code changes
- Include inline comments for complex logic
- Maintain up-to-date README files
- Document all public APIs
```

### 5. Performance Guidelines

**File:** `.amazonq/rules/performance-guidelines.md`

```markdown
# Performance Guidelines

## Database Optimization
- Use indexes for frequently queried columns
- Avoid N+1 queries (use joins or batch loading)
- Implement pagination for large result sets
- Use database query explain plans for optimization

## API Performance
- Implement response caching where appropriate
- Use compression (gzip) for responses
- Minimize payload sizes
- Implement request timeouts

## Frontend Performance
- Lazy load components and routes
- Optimize images (compression, responsive sizes)
- Minimize bundle sizes
- Implement code splitting

## Monitoring
- Add performance metrics to all critical paths
- Monitor API response times
- Track database query performance
- Set up alerts for performance degradation
```

## Integration with Agents

### Automatic Inclusion (Default Agent)

The default agent automatically includes all rules:

```json
{
  "resources": [
    "file://.amazonq/rules/**/*.md"
  ]
}
```

### Custom Agent Integration

Custom agents must explicitly include rules:

```json
{
  "name": "my-custom-agent",
  "description": "Custom agent with rules",
  "resources": [
    "file://.amazonq/rules/**/*.md",
    "file://./docs/**/*.md"
  ]
}
```

### Selective Rule Loading

Load specific rule files:

```json
{
  "resources": [
    "file://.amazonq/rules/coding-standards.md",
    "file://.amazonq/rules/security-policies.md"
  ]
}
```

## Best Practices

### Organization

- **Separate files** - Create separate files for different rule types
- **Descriptive filenames** - Use names that reflect content
- **Hierarchical structure** - Organize rules with headers
- **Focused topics** - Keep files focused on specific topics

### Content Guidelines

- **Clear and actionable** - Write guidelines that can be followed
- **Include examples** - Show what good looks like
- **Explain reasoning** - Help developers understand the "why"
- **Stay current** - Update rules as practices evolve

### Markdown Formatting

- **Use headers** - `#`, `##`, `###` for organization
- **Code blocks** - Include examples with syntax highlighting
- **Lists** - Use bullet points or numbered lists
- **Emphasis** - Use `**bold**` or `*italic*` for important points
- **Links** - Reference external documentation when helpful

### Maintenance

- **Regular reviews** - Review rules quarterly for relevance
- **Team input** - Gather feedback from team members
- **Version control** - Track changes to rules over time
- **Remove outdated rules** - Delete or update obsolete guidelines

## Scope and Precedence

### Workspace-Specific

- Rules only apply to the current project directory
- No global rules system
- Each project maintains independent rule sets

### Agent-Dependent

- Rules only apply when using agents that include them
- Default agent automatically includes all rules
- Custom agents must explicitly include rules

### No Inheritance

- Rules don't inherit from parent directories
- Each project has its own independent rule set
- No system-wide or user-wide rules

## Use Cases

### 1. Team Standardization

Ensure all team members follow the same coding standards:

```markdown
# Python Standards

## Import Organization
```python
# Standard library imports
import os
import sys

# Third-party imports
import requests
import pandas as pd

# Local imports
from myapp import utils
from myapp.models import User
```

## Naming Conventions
- Classes: `PascalCase`
- Functions: `snake_case`
- Constants: `UPPER_SNAKE_CASE`
- Private: `_leading_underscore`
```

### 2. Security Compliance

Enforce security requirements across the codebase:

```markdown
# Security Requirements

## Password Handling
- NEVER store passwords in plain text
- Use bcrypt with minimum 12 rounds
- Enforce password complexity (8+ chars, mixed case, numbers, symbols)
- Implement account lockout after 5 failed attempts

## Token Management
- Rotate API keys every 90 days
- Use environment variables for secrets (never commit)
- Implement token expiration
- Use secure token storage
```

### 3. Framework-Specific Guidelines

Provide framework-specific best practices:

```markdown
# React Guidelines

## Component Structure
```tsx
// 1. Imports
import React, { useState, useEffect } from 'react';
import { Button } from '@/components/ui';

// 2. Types/Interfaces
interface Props {
  userId: string;
}

// 3. Component
export function UserProfile({ userId }: Props) {
  // Hooks first
  const [user, setUser] = useState(null);

  // Effects
  useEffect(() => {
    fetchUser(userId);
  }, [userId]);

  // Handlers
  const handleClick = () => { };

  // Render
  return <div>...</div>;
}
```

## Hooks Integration
- Use custom hooks for reusable logic
- Keep components focused and small
- Extract complex state management
```

### 4. API Standards

Define consistent API conventions:

```markdown
# API Conventions

## Endpoint Naming
- Use plural nouns: `/api/v1/users` not `/api/v1/user`
- Use kebab-case: `/api/v1/user-profiles`
- Avoid verbs in URLs (use HTTP methods)

## Response Format
```json
{
  "data": { },
  "meta": {
    "timestamp": "2025-10-04T12:00:00Z",
    "requestId": "uuid"
  },
  "errors": []
}
```

## Status Codes
- 200: Success
- 201: Created
- 400: Bad Request
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found
- 500: Server Error
```

## Troubleshooting

### Rules Not Loading

**Verify file location:**
```bash
ls .amazonq/rules/
```

**Check file extensions:**
- Must be `.md` files
- Check for typos in filenames

**Verify agent configuration:**
```json
{
  "resources": [
    "file://.amazonq/rules/**/*.md"
  ]
}
```

### Rules Not Being Applied

- Confirm agent includes rules in resources
- Restart agent session
- Check markdown formatting is valid
- Verify glob pattern matches files

### Conflicting Rules

- Review all rule files for conflicts
- Prioritize specific over general rules
- Document exceptions explicitly
- Keep rules consistent across files

## Additional Resources

**Official Documentation:**
- Project Rules: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-project-rules.html
- Context Project Rules: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/context-project-rules.html

**Related Guides:**
- [Agents Configuration](../agents/README.md)
- [Hooks Configuration](../hooks/README.md)
- [MCP Servers Configuration](../mcp/README.md)

---

**Last Updated:** 2025-10-04
