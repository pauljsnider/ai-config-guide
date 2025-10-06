# Coding Standards

## General Principles
- Write clear, maintainable code
- Follow language-specific conventions
- Prioritize readability over cleverness
- Document complex logic

## Python Standards

### Code Formatting
- Use Black for code formatting
- Maximum line length: 88 characters
- Use type hints for all function parameters and return values
- Follow PEP 8 naming conventions

### Imports
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

### Error Handling
```python
# Good - Specific exception
try:
    process_data(data)
except ValueError as e:
    logger.error(f"Invalid data: {e}")
    raise

# Bad - Catching everything
try:
    process_data(data)
except:
    pass
```

## TypeScript/JavaScript Standards

### Configuration
- Use ESLint with recommended rules
- Enable strict mode
- Prefer interfaces over type aliases for object shapes
- Use async/await over raw Promises

### Naming Conventions
- Classes: `PascalCase`
- Functions/Variables: `camelCase`
- Constants: `UPPER_SNAKE_CASE`
- Private fields: `#privateField` or `_privateField`

### Type Safety
```typescript
// Good - Explicit types
function processUser(user: User): Promise<UserResult> {
  return api.updateUser(user);
}

// Bad - Any types
function processUser(user: any): any {
  return api.updateUser(user);
}
```

## Testing Standards

### Test Coverage
- Maintain test coverage above 80%
- Write tests for new features before merging
- Include edge cases and error conditions

### Test Structure
```python
def test_user_creation():
    # Arrange
    user_data = {"name": "Test User", "email": "test@example.com"}

    # Act
    user = create_user(user_data)

    # Assert
    assert user.name == "Test User"
    assert user.email == "test@example.com"
```

### Test Naming
- Use descriptive names: `test_should_create_user_with_valid_data`
- Follow pattern: `test_should_<expected_behavior>_when_<condition>`

## Code Review Checklist

- [ ] Code follows language-specific style guide
- [ ] Tests are included and pass
- [ ] No security vulnerabilities introduced
- [ ] Error handling is appropriate
- [ ] Documentation is updated
- [ ] Performance considerations addressed
