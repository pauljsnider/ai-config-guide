# Kiro IDE - Steering Configuration Guide

Persistent project knowledge through markdown files that guide AI behavior.

## Overview

Steering gives Kiro persistent knowledge about your project through markdown files in `.kiro/steering/`. Instead of explaining your conventions in every chat, steering files ensure Kiro consistently follows your established patterns, libraries, and standards.

## What is Steering?

Steering files are markdown documents that provide Kiro with:
- **Project context** - Product purpose, structure, and tech stack
- **Coding standards** - Naming conventions, patterns, and styles
- **Team guidelines** - Security policies, testing practices, deployment procedures
- **Persistent memory** - No need to repeat instructions in every conversation

**Benefits:**
- Consistent code generation across all interactions
- Reduced repetition and faster development
- Team alignment on standards and practices
- Scalable project knowledge that grows with your codebase

## Configuration Location

**Directory:** `.kiro/steering/`

All `.md` files in this directory become available to Kiro based on their inclusion mode.

## File Structure

```
project/
└── .kiro/
    └── steering/
        ├── product.md          # Product purpose & features (foundational)
        ├── structure.md        # Project organization (foundational)
        ├── tech.md             # Tech stack & dependencies (foundational)
        ├── code-style.md       # Custom coding standards
        ├── security.md         # Security guidelines
        ├── api-design.md       # API conventions
        └── testing.md          # Testing methodologies
```

## Foundational Steering Files

Kiro provides a **Setup Project Steering** command that creates three foundational files:

### 1. product.md

Captures your product's purpose, core features, and user needs.

**Example:**
```markdown
# Product Overview

## Purpose
A task management application for distributed teams that emphasizes async collaboration.

## Core Features
- Task creation and assignment
- Real-time collaboration
- Integration with Slack and Teams
- Advanced reporting and analytics

## Target Users
- Remote software development teams
- Project managers
- Team leads

## Key Differentiators
- Async-first design
- Deep integration with developer tools
- AI-powered task estimation
```

### 2. structure.md

Explains how your project is organized—file structure, naming patterns, and architectural norms.

**Example:**
```markdown
# Project Structure

## Directory Organization
```
src/
├── components/     # React components
├── hooks/          # Custom React hooks
├── services/       # API and business logic
├── utils/          # Utility functions
├── types/          # TypeScript type definitions
└── styles/         # Global styles and themes
```

## Naming Conventions
- Components: PascalCase (e.g., `TaskList.tsx`)
- Hooks: camelCase with 'use' prefix (e.g., `useTaskManager.ts`)
- Services: camelCase (e.g., `taskService.ts`)
- Utils: camelCase (e.g., `formatDate.ts`)

## Import Patterns
- Use absolute imports from `@/` alias
- Group imports: React → Third-party → Local
- Sort alphabetically within groups

## Architecture
- Feature-based organization for large components
- Shared components in `components/common/`
- One component per file
```

### 3. tech.md

Describes your tech stack, constraints, and dependencies.

**Example:**
```markdown
# Technology Stack

## Frontend
- React 18 with TypeScript
- Vite for build tooling
- TailwindCSS for styling
- React Query for data fetching
- Zustand for state management

## Backend
- Node.js with Express
- PostgreSQL database
- Prisma ORM
- Redis for caching

## Development Tools
- ESLint + Prettier
- Vitest for testing
- Docker for local development

## Constraints
- Must support Node.js 18+
- Browser support: Chrome, Firefox, Safari (last 2 versions)
- Mobile-responsive design required

## Preferred Libraries
- Date handling: date-fns (not moment.js)
- HTTP client: axios
- Form validation: zod
- UI components: shadcn/ui
```

## Inclusion Modes

Configure when steering files are loaded using YAML front matter at the top of each file.

### Always Mode

Files loaded into every Kiro interaction automatically. Use for core standards.

**Example:**
```markdown
---
include: always
---

# Code Style Guide

## Naming Conventions
- Use descriptive variable names
- Boolean variables start with 'is', 'has', 'should'
- Constants in UPPER_SNAKE_CASE
- Private methods start with underscore

## Code Organization
- Maximum function length: 50 lines
- Extract complex logic into helper functions
- Keep files under 300 lines
```

### File Match Mode

Automatically included only when working with files matching the specified pattern.

**Example:**
```markdown
---
include: file-match
pattern: "**/*.test.ts"
---

# Testing Guidelines

## Test Structure
- Use Arrange-Act-Assert pattern
- One assertion per test when possible
- Descriptive test names: `should_<expected>_when_<condition>`

## Mocking
- Mock external dependencies
- Use test fixtures for complex data
- Reset mocks between tests

## Coverage
- Minimum 80% code coverage
- 100% coverage for critical paths
- Test edge cases and error conditions
```

**Pattern Examples:**
```yaml
pattern: "**/*.test.ts"              # All test files
pattern: "src/api/**/*"              # All files in api directory
pattern: "**/*.{ts,tsx}"             # TypeScript files
pattern: "src/components/**/*.tsx"   # React components
```

### Manual Mode

Available on-demand by referencing with `#filename` in chat.

**Example:**
```markdown
---
include: manual
---

# Performance Optimization Guide

## Database Queries
- Use indexed columns for WHERE clauses
- Implement pagination for large result sets
- Use connection pooling
- Cache frequent queries with Redis

## Frontend Performance
- Lazy load routes and components
- Optimize images (WebP format, responsive sizes)
- Minimize bundle size with code splitting
- Use React.memo for expensive components

## API Optimization
- Implement response caching
- Use compression (gzip/brotli)
- Batch similar requests
- Set appropriate cache headers
```

**Usage in Chat:**
```
Optimize the user dashboard for better performance #performance-optimization
```

## Custom Steering Files

### Code Style

**File:** `.kiro/steering/code-style.md`

```markdown
---
include: always
---

# Code Style Standards

## TypeScript
- Enable strict mode
- No 'any' types (use 'unknown' if needed)
- Explicit return types for functions
- Interface over type for object shapes

## React
- Functional components only (no class components)
- Hooks for state and side effects
- PropTypes deprecated, use TypeScript interfaces
- Destructure props in function signature

## Error Handling
- Use custom error classes
- Always catch and handle async errors
- Log errors with context
- User-friendly error messages in UI

## Comments
- Document why, not what
- JSDoc for public APIs
- TODO comments include ticket numbers
- Remove commented-out code
```

### Security Guidelines

**File:** `.kiro/steering/security.md`

```markdown
---
include: always
---

# Security Guidelines

## Authentication
- JWT tokens with 1-hour expiration
- Refresh tokens for extended sessions
- Require authentication on all API routes
- Use httpOnly cookies for tokens

## Authorization
- Role-based access control (RBAC)
- Check permissions on every request
- Never trust client-side permission checks
- Implement least privilege principle

## Data Validation
- Validate all user inputs
- Use Zod schemas for runtime validation
- Sanitize inputs before database queries
- Parameterized queries only (prevent SQL injection)

## Secrets Management
- Never commit secrets to git
- Use environment variables
- Rotate API keys quarterly
- Use AWS Secrets Manager in production

## API Security
- Rate limiting on all endpoints
- CORS configured for known origins only
- CSRF protection on state-changing operations
- Content Security Policy headers
```

### API Design

**File:** `.kiro/steering/api-design.md`

```markdown
---
include: file-match
pattern: "src/api/**/*"
---

# API Design Standards

## Endpoint Naming
- Use plural nouns: `/api/tasks` not `/api/task`
- Use kebab-case: `/api/user-profiles`
- Avoid verbs in URLs (use HTTP methods)
- Version APIs: `/api/v1/tasks`

## HTTP Methods
- GET: Retrieve resources (idempotent)
- POST: Create new resources
- PUT: Full update (idempotent)
- PATCH: Partial update
- DELETE: Remove resources (idempotent)

## Response Format
```json
{
  "data": { /* response data */ },
  "meta": {
    "timestamp": "2025-10-04T12:00:00Z",
    "requestId": "uuid",
    "pagination": {
      "page": 1,
      "perPage": 20,
      "total": 100
    }
  },
  "errors": []
}
```

## Status Codes
- 200: Success
- 201: Created
- 204: No Content
- 400: Bad Request
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found
- 422: Validation Error
- 500: Server Error

## Error Responses
```json
{
  "errors": [
    {
      "code": "VALIDATION_ERROR",
      "message": "Email is required",
      "field": "email"
    }
  ]
}
```
```

### Testing Methodology

**File:** `.kiro/steering/testing.md`

```markdown
---
include: file-match
pattern: "**/*.test.{ts,tsx}"
---

# Testing Standards

## Test Organization
```
src/
├── components/
│   ├── TaskList.tsx
│   └── TaskList.test.tsx      # Co-located with component
└── services/
    ├── taskService.ts
    └── taskService.test.ts     # Co-located with service
```

## Test Structure
```typescript
describe('TaskService', () => {
  describe('createTask', () => {
    it('should create task with valid data', () => {
      // Arrange
      const taskData = { title: 'Test Task' };

      // Act
      const result = taskService.createTask(taskData);

      // Assert
      expect(result).toMatchObject(taskData);
    });

    it('should throw error when title is missing', () => {
      // Test error case
    });
  });
});
```

## Coverage Requirements
- Unit tests: 80% minimum
- Integration tests for critical flows
- E2E tests for user journeys
- Test edge cases and error conditions

## Mocking
- Mock external APIs and services
- Use MSW for HTTP mocking
- Reset mocks in beforeEach
- Avoid mocking internal modules

## Best Practices
- Fast tests (< 100ms per test)
- Independent tests (no shared state)
- Deterministic (no random data)
- Clear test names
```

### Deployment Procedures

**File:** `.kiro/steering/deployment.md`

```markdown
---
include: manual
---

# Deployment Procedures

## Pre-Deployment Checklist
- [ ] All tests passing
- [ ] Code review approved
- [ ] Security scan completed
- [ ] Database migrations prepared
- [ ] Environment variables updated
- [ ] Monitoring configured

## Deployment Process

### Staging
1. Merge to `develop` branch
2. Automated deployment to staging
3. Run smoke tests
4. QA verification

### Production
1. Create release branch from `develop`
2. Update version number
3. Merge to `main` with PR
4. Tag release
5. Deploy with blue-green strategy
6. Monitor metrics for 1 hour
7. Rollback if errors > 0.1%

## Database Migrations
- Test migrations on staging first
- Backwards-compatible changes only
- Include rollback scripts
- Run during low-traffic windows

## Rollback Procedure
1. Identify issue
2. Execute rollback command
3. Verify system stability
4. Create incident report
5. Schedule fix deployment
```

## Best Practices

### Organization

- **One topic per file** - Keep steering files focused
- **Descriptive filenames** - Use clear, meaningful names
- **Hierarchical structure** - Use headings for organization
- **Version control** - Track steering files in git

### Content Guidelines

- **Be specific** - Provide concrete examples
- **Explain reasoning** - Help developers understand the "why"
- **Keep current** - Update as practices evolve
- **Include examples** - Show what good looks like

### Inclusion Strategy

- **Always mode** - Core standards that apply everywhere
- **File-match mode** - Specialized guidance for specific file types
- **Manual mode** - Advanced topics or troubleshooting guides
- **Avoid over-inclusion** - Too much context can be counterproductive

### Maintenance

- **Regular reviews** - Review steering files quarterly
- **Team collaboration** - Gather feedback from team members
- **Remove outdated content** - Delete obsolete guidelines
- **Evolve with project** - Update as project grows and changes

## Troubleshooting

### Steering File Not Loading

**Check file location:**
```bash
ls .kiro/steering/
# Verify .md files exist
```

**Verify YAML front matter:**
```markdown
---
include: always
---
# Content starts here
```

**Common issues:**
- Missing triple dashes (---)
- Invalid YAML syntax
- Typo in `include` field
- File not ending in `.md`

### Pattern Not Matching

**Test file-match patterns:**
```yaml
pattern: "**/*.test.ts"        # Matches test files
pattern: "src/api/**/*"        # Matches api directory
pattern: "**/*.{ts,tsx}"       # Multiple extensions
```

**Common pattern issues:**
- Missing `**/` for recursive matching
- Wrong file extension
- Case sensitivity
- Path separators

### Manual Steering Not Working

**Correct syntax:**
```
#filename without extension

Example:
Optimize this code #performance-optimization
```

**Common issues:**
- Including `.md` extension
- Space after `#`
- File not set to `include: manual`
- Typo in filename

## Example: Complete Steering Setup

**Project structure:**
```
.kiro/steering/
├── product.md           # Always included
├── structure.md         # Always included
├── tech.md              # Always included
├── code-style.md        # Always included
├── security.md          # Always included
├── api-design.md        # File-match: src/api/**/*
├── testing.md           # File-match: **/*.test.ts
├── deployment.md        # Manual
└── troubleshooting.md   # Manual
```

**Usage examples:**
```
# Steering automatically applies from always-included files
"Create a new user service"
→ Uses: product, structure, tech, code-style, security

# File-match steering applies based on context
"Add tests for user service"
→ Also uses: testing.md

# Manual steering on-demand
"Help me debug production issue #troubleshooting"
→ Also uses: troubleshooting.md
```

## Additional Resources

**Official Documentation:**
- Steering Guide: https://kiro.dev/docs/steering/
- Getting Started: https://kiro.dev/docs/getting-started/
- Best Practices: https://kiro.dev/docs/specs/best-practices/

**Community Resources:**
- Kiro Steering Guide: https://dev.to/sienna/kiro-steering-guide-ae7
- GitHub: https://github.com/kirodotdev/Kiro

**Related Guides:**
- [Kiro IDE Overview](../README.md)
- [MCP Configuration](../mcp/README.md)
- [Hooks Configuration](../hooks/README.md)
- [Specs Configuration](../specs/README.md)

---

**Last Updated:** 2025-10-04

**Note:** All examples use placeholder values. Customize steering files for your specific project needs.
