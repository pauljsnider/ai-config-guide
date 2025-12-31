# Tech Debt Collector Rules

Purpose: Define authority, scoring model, and output rules for tech debt collection.

## 1. Purpose & Authority

### Authorized Actions
- Collect read-only data from Mend, Checkmarx, GitHub, Jira, and Confluence
- Normalize findings into a unified Tech Debt Model
- Score and prioritize tech debt
- Create draft Jira issues and draft Confluence pages
- Propose (but not merge) GitHub pull requests

### Prohibited Actions
- Merge code
- Close Jira issues
- Modify production configuration
- Change security policies
- Create tickets without explicit labeling as "kiro-generated"

## 2. Definition of Tech Debt

Tech debt is any condition that:
- Increases future engineering effort
- Increases security, reliability, or compliance risk
- Deviates from documented standards or current best practices
- Has a known remediation path

### Five Categories

| Category | Primary Source |
|----------|----------------|
| Dependency / Supply Chain Debt | Mend |
| Code Security Debt | Checkmarx |
| Engineering Process Debt | GitHub + Jira |
| Documentation / Architecture Drift | Confluence |
| Ownership / Maintainability Debt | GitHub + Jira |

## 3. System-Specific Rules

### 3.1 Mend (Dependency Debt)

**May:**
- Pull vulnerability counts, severities, fix availability
- Identify outdated or EOL dependencies
- Identify license policy violations

**Must:**
- Focus on direct dependencies first
- Prefer findings with fix available
- Ignore vulnerabilities marked "Accepted Risk" or "Ignored"

### 3.2 Checkmarx (Code Security Debt)

**May:**
- Pull SAST findings by severity
- Identify recurring CWEs
- Identify files/modules with repeated findings

**Must:**
- Treat Critical/High as debt automatically
- Treat Medium as debt only if:
  - Repeated across scans
  - In high-risk modules (auth, crypto, input handling)

**Must Not:**
- Create tickets for Low unless explicitly configured

### 3.3 GitHub (Engineering Signals)

**May:**
- Read repo metadata, languages, PR history
- Identify:
  - Long-lived branches (>30 days)
  - High churn files
  - Low test coverage indicators
  - Repos with no recent releases

**Must:**
- Use CODEOWNERS to assign ownership
- Treat "no owner" as ownership debt

### 3.4 Jira (Backlog Reality)

**May:**
- Query issues by label, component, or project
- Analyze aging, reopen rates, SLA breaches

**Must:**
- Treat issues older than 180 days as aged debt
- Prefer linking to existing Jira issues over creating duplicates
- Create new Jira issues only if no equivalent exists

### 3.5 Confluence (Intent vs Reality)

**May:**
- Read architecture standards, ADRs, runbooks
- Identify documented exceptions and expiration dates

**Must:**
- Flag undocumented deviations as architecture drift
- Never overwrite existing Confluence pages
- Publish findings as new pages only

## 4. Scoring Model (Mandatory)

Compute a Debt Priority Score for every item:

```
Debt Score = (Risk × Exposure × Age) ÷ Effort
```

### Scoring Inputs

| Factor | Description | Scale |
|--------|-------------|-------|
| **Risk** | CVSS, severity, exploit maturity | 1-10 |
| **Exposure** | Prod-facing, data sensitivity, blast radius | 1-10 |
| **Age** | Days since first detection | 1-10 (scaled) |
| **Effort** | Remediation complexity | S=1, M=3, L=5 |

### Effort Levels

| Level | Description | Value |
|-------|-------------|-------|
| S | Config change, patch, minor version bump | 1 |
| M | Moderate refactor, multiple files | 3 |
| L | Major upgrade, redesign, breaking changes | 5 |

### Age Scaling

| Days | Score |
|------|-------|
| 0-30 | 1-2 |
| 31-90 | 3-4 |
| 91-180 | 5-6 |
| 181-365 | 7-8 |
| 365+ | 9-10 |

**Normalize all scores to 0-100.**

## 5. Noise Control Rules (Critical)

**Must:**
- Suppress duplicate findings across tools
- Prefer net-new debt over legacy debt
- Never create more than:
  - 1 Epic per solution
  - 5 Stories per repo per run
- Mark all created artifacts with:
  - `label: kiro-generated`
  - `confidence: <high|medium|low>`

### Confidence Levels

| Level | Criteria |
|-------|----------|
| High | Multiple corroborating sources, clear remediation |
| Medium | Single source, clear remediation |
| Low | Inferred from signals, remediation unclear |

## 6. Output Rules

Every run must produce:

1. **Confluence Report Page**
   - Summary with overall debt score
   - Breakdown by category
   - Top 20 ranked items
   - Data sources per finding

2. **Jira Epic**
   - One epic per solution/repo
   - Stories for top priority items (max 5)
   - Links to Confluence report

3. **Ranked Debt List**
   - Top 20 debt items by score
   - Score breakdown (Risk, Exposure, Age, Effort)
   - Remediation recommendations
   - Confidence level per item

4. **Metadata**
   - Timestamp
   - Sources queried
   - Items suppressed (deduped)
   - Items below threshold
