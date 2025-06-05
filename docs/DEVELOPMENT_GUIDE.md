# Development Guide

This guide provides technical guidance for developing and maintaining projects within the 21.000.000 organization.

## Development Environment Setup

### Prerequisites

```bash
# Required tools
node --version    # v18.0.0 or higher
npm --version     # v8.0.0 or higher
git --version     # v2.30.0 or higher
python --version  # v3.9.0 or higher (for some projects)
```

### Quick Setup

```bash
# Clone and setup any repository
git clone https://github.com/21-000-000/REPOSITORY_NAME
cd REPOSITORY_NAME

# Run our universal setup script
./scripts/setup-dev-environment.sh

# Or manually install dependencies
npm install  # for Node.js projects
pip install -r requirements.txt  # for Python projects
```

## Coding Standards

### Git Workflow

#### Branch Naming Convention
```bash
# Feature branches
feature/add-bitcoin-price-api
feature/improve-search-functionality

# Bug fixes
fix/resolve-memory-leak
fix/correct-calculation-error

# Documentation
docs/update-api-documentation
docs/add-tutorial-examples

# Maintenance
chore/update-dependencies
chore/cleanup-unused-code
```

#### Commit Message Format
We use [Conventional Commits](https://www.conventionalcommits.org/):

```bash
# Format: type(scope): description
feat(api): add Bitcoin price endpoint
fix(ui): resolve mobile responsive issues
docs(readme): update installation instructions
chore(deps): bump lodash from 4.17.20 to 4.17.21
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Code Style

#### JavaScript/TypeScript
```javascript
// Use ESLint + Prettier configuration
// .eslintrc.js example
module.exports = {
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended',
    'prettier'
  ],
  rules: {
    'no-console': 'warn',
    'prefer-const': 'error',
    '@typescript-eslint/no-unused-vars': 'error'
  }
};

// Function documentation
/**
 * Calculates Bitcoin value in different currencies
 * @param {number} btcAmount - Amount of Bitcoin
 * @param {string} currency - Target currency (USD, EUR, CZK)
 * @returns {Promise<number>} Converted value
 */
async function calculateBitcoinValue(btcAmount, currency) {
  // Implementation
}
```

#### Python
```python
# Follow PEP 8 standards
# Use Black formatter and pylint

from typing import Optional, Dict, Any
import requests

def fetch_bitcoin_price(currency: str = "USD") -> Optional[float]:
    """
    Fetch current Bitcoin price in specified currency.
    
    Args:
        currency: Target currency code (default: USD)
        
    Returns:
        Current Bitcoin price or None if request fails
        
    Raises:
        ValueError: If currency code is invalid
    """
    # Implementation
    pass
```

#### Markdown
```markdown
# Use consistent formatting

## Headings
- Use sentence case for headings
- Include table of contents for long documents
- Use descriptive anchor links

## Lists
- Use hyphens for unordered lists
- Use numbers for ordered lists
- Keep list items concise

## Code blocks
```bash
# Always specify language for syntax highlighting
echo "Example command"
```

## Links
- Use descriptive link text
- Prefer relative links for internal content
- Test all external links regularly
```

### Testing Standards

#### Unit Tests
```javascript
// Jest example for JavaScript
describe('Bitcoin Price Calculator', () => {
  test('should calculate USD value correctly', async () => {
    const result = await calculateBitcoinValue(1, 'USD');
    expect(result).toBeGreaterThan(0);
    expect(typeof result).toBe('number');
  });

  test('should handle invalid currency', async () => {
    await expect(calculateBitcoinValue(1, 'INVALID'))
      .rejects.toThrow('Invalid currency code');
  });
});
```

#### Integration Tests
```python
# pytest example for Python
import pytest
from unittest.mock import patch

class TestBitcoinAPI:
    @patch('requests.get')
    def test_fetch_price_success(self, mock_get):
        # Mock successful API response
        mock_get.return_value.json.return_value = {'price': 50000}
        
        result = fetch_bitcoin_price('USD')
        assert result == 50000
        
    def test_fetch_price_invalid_currency(self):
        with pytest.raises(ValueError):
            fetch_bitcoin_price('INVALID')
```

#### Test Coverage
```bash
# JavaScript with Jest
npm test -- --coverage

# Python with pytest
pytest --cov=src --cov-report=html

# Minimum coverage requirements:
# - Unit tests: 80%
# - Integration tests: 60%
# - Critical paths: 95%
```

## Documentation Standards

### README Structure
```markdown
# Project Name

Brief description of the project.

## Features
- List key features
- Include screenshots if applicable

## Installation

```bash
# Clear installation steps
npm install
npm start
```

## Usage

```javascript
// Code examples
const result = await someFunction();
```

## API Documentation

### Endpoints

#### GET /api/bitcoin/price
Returns current Bitcoin price.

**Parameters:**
- `currency` (string, optional): Target currency (default: USD)

**Response:**
```json
{
  "price": 50000,
  "currency": "USD",
  "timestamp": "2024-01-01T00:00:00Z"
}
```

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md)

## License
MIT License
```

### API Documentation
Use OpenAPI/Swagger for REST APIs:

```yaml
# openapi.yaml
openapi: 3.0.0
info:
  title: Bitcoin Price API
  version: 1.0.0
  description: API for fetching Bitcoin prices

paths:
  /api/bitcoin/price:
    get:
      summary: Get Bitcoin price
      parameters:
        - name: currency
          in: query
          schema:
            type: string
            default: USD
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                type: object
                properties:
                  price:
                    type: number
                  currency:
                    type: string
                  timestamp:
                    type: string
                    format: date-time
```

## CI/CD Pipeline

### GitHub Actions Workflow
```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run linting
      run: npm run lint
    
    - name: Run tests
      run: npm test -- --coverage
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
    
    - name: Build project
      run: npm run build

  security:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Run security audit
      run: npm audit --audit-level=moderate
    
    - name: Run CodeQL analysis
      uses: github/codeql-action/analyze@v2
```

### Deployment
```yaml
# Deploy job (only on main branch)
deploy:
  needs: [test, security]
  runs-on: ubuntu-latest
  if: github.ref == 'refs/heads/main'
  
  steps:
  - uses: actions/checkout@v3
  
  - name: Deploy to production
    run: |
      # Deployment commands
      npm run build
      npm run deploy
```

## Security Guidelines

### Dependency Management
```bash
# Regular security updates
npm audit fix

# Check for outdated packages
npm outdated

# Update dependencies
npm update

# Use exact versions for critical dependencies
{
  "dependencies": {
    "express": "4.18.2",  // exact version
    "lodash": "^4.17.21" // allow patch updates
  }
}
```

### Environment Variables
```bash
# .env.example
API_KEY=your_api_key_here
DATABASE_URL=postgresql://localhost:5432/dbname
JWT_SECRET=your_secret_here

# Never commit actual .env files
# Use GitHub Secrets for CI/CD
```

### Input Validation
```javascript
// Express.js with validation
const { body, validationResult } = require('express-validator');

app.post('/api/bitcoin/alert',
  body('price').isNumeric().custom(value => {
    if (value <= 0) {
      throw new Error('Price must be positive');
    }
    return true;
  }),
  body('email').isEmail().normalizeEmail(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    // Process valid input
  }
);
```

## Performance Guidelines

### Frontend Optimization
```javascript
// Code splitting with React
const BitcoinChart = lazy(() => import('./components/BitcoinChart'));

// Memoization for expensive calculations
const expensiveCalculation = useMemo(() => {
  return calculateComplexBitcoinMetrics(data);
}, [data]);

// Image optimization
<img 
  src="/images/bitcoin-logo.webp" 
  alt="Bitcoin Logo"
  loading="lazy"
  width="100" 
  height="100"
/>
```

### Backend Optimization
```python
# Caching with Redis
import redis
from functools import wraps

def cache_result(expire_time=300):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            cache_key = f"{func.__name__}:{hash(str(args) + str(kwargs))}"
            cached = redis_client.get(cache_key)
            
            if cached:
                return json.loads(cached)
            
            result = func(*args, **kwargs)
            redis_client.setex(cache_key, expire_time, json.dumps(result))
            return result
        return wrapper
    return decorator

@cache_result(expire_time=60)  # Cache for 1 minute
def get_bitcoin_price(currency):
    # Expensive API call
    pass
```

## Troubleshooting

### Common Issues

#### Build Failures
```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules and reinstall
rm -rf node_modules package-lock.json
npm install

# Check Node.js version
node --version
nvm use 18  # if using nvm
```

#### Test Failures
```bash
# Run tests in verbose mode
npm test -- --verbose

# Run specific test file
npm test -- bitcoin.test.js

# Debug test with Node debugger
node --inspect-brk node_modules/.bin/jest --runInBand
```

#### Git Issues
```bash
# Reset local changes
git reset --hard HEAD
git clean -fd

# Sync with upstream
git fetch upstream
git checkout main
git merge upstream/main

# Fix merge conflicts
git status
# Edit conflicted files
git add .
git commit
```

## Resources

### Internal Documentation
- [Architecture Overview](ARCHITECTURE.md)
- [Onboarding Guide](ONBOARDING.md)
- [Contributing Guidelines](../CONTRIBUTING.md)
- [Security Policy](../SECURITY.md)

### External Resources
- [Bitcoin Developer Documentation](https://developer.bitcoin.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Open Source Guides](https://opensource.guide/)

---

This development guide ensures consistent, high-quality code across all 21.000.000 projects. For project-specific guidelines, check the individual repository documentation.

