# Quick Start Guide - macOS

**Duration:** 90 minutes
**For:** Individual developers on macOS

This streamlined guide gets you up and running with Amazon Q CLI, Kiro IDE, and Atlassian integration. For detailed explanations, see the [full workshop guide](./README.md).

---

## Step 1: AWS Authentication (10 min)

**Create AWS Builder ID:**

```bash
# Visit and create account
open https://profile.aws.amazon.com/
# Follow prompts to create Builder ID
# Enable MFA (recommended)
```

**📚 Details:** [Full AWS Setup Guide](./README.md#section-1-aws-account-setup-for-amazon-q-60-minutes-for-org-setup--15-minutes-for-builder-id)

---

## Step 2: Install Kiro IDE (5 min)

```bash
# Download and install Kiro
open https://kiro.dev/downloads/

# Download for Mac (Apple Silicon or Intel)
# Drag to Applications folder
# Launch and authenticate with AWS Builder ID
```

**📚 Details:** [Kiro Installation Guide](./README.md#21-installing-kiro-ide)

---

## Step 3: Install Amazon Q CLI (5 min)

```bash
# Install via Homebrew
brew install --cask amazon-q

# Verify installation
q --version

# Authenticate
q login
# Choose: AWS Builder ID
# Complete browser authentication

# Test
q chat
```

**📚 Details:** [Amazon Q CLI Installation](./README.md#22-installing-amazon-q-cli)

---

## Step 4: Install GitHub CLI & AWS CLI (10 min)

```bash
# Install GitHub CLI
brew install gh
gh auth login
# Follow prompts: GitHub.com → HTTPS → Browser

# Install AWS CLI
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
aws --version
```

**Configure AWS CLI with Environment Variables:**

```bash
# Set AWS credentials as environment variables
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
export AWS_DEFAULT_REGION="us-east-1"

# Make permanent
echo 'export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"' >> ~/.zshrc
echo 'export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"' >> ~/.zshrc
echo 'export AWS_DEFAULT_REGION="us-east-1"' >> ~/.zshrc
source ~/.zshrc

# Test
aws sts get-caller-identity
```

**Create IAM Access Keys:**
1. AWS Console → IAM → Users → Your User → Security credentials
2. Create access key → CLI → Create
3. Copy Access Key ID and Secret Access Key
4. Use values above

**📚 Details:** [CLI Installation Guide](./README.md#section-3-installing-github-cli-and-aws-cli-30-minutes)

---

## Step 5: Install MCP Servers (15 min)

**Prerequisites:**

```bash
# Install Node.js (if not already installed)
brew install node
node --version  # Should be 18+
```

**Use Automated Installer:**

```bash
# Clone or download the ai-config-guide repository
gh repo clone [repository-url]
cd ai-config-guide

# Run MCP installer for Amazon Q CLI
cd amazon-q-cli/mcp
./install-mcp.sh

# Run MCP installer for Kiro IDE
cd ../../kiro-ide/mcp
./install-mcp.sh
```

**Manual Setup (Alternative):**

Create `~/.aws/amazonq/mcp.json`:

```json
{
  "mcpServers": {
    "atlassian": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.atlassian.com/v1/sse"],
      "env": {}
    },
    "bitbucket": {
      "command": "npx",
      "args": ["-y", "@aashari/mcp-server-atlassian-bitbucket"],
      "env": {
        "ATLASSIAN_USER_EMAIL": "${ATLASSIAN_USER_EMAIL}",
        "ATLASSIAN_API_TOKEN": "${ATLASSIAN_API_TOKEN}"
      }
    }
  }
}
```

**Create Bitbucket API Token:**

```bash
# Open token creation page
open https://id.atlassian.com/manage-profile/security/api-tokens

# Create token:
# - Name: "Workshop MCP Access"
# - Product: Bitbucket
# - Scopes: repository (read), workspace (read), pullrequest (read)
# Copy token (starts with ATATT)
```

**Set environment variables:**

```bash
# Add to ~/.zshrc or ~/.bashrc
echo 'export ATLASSIAN_USER_EMAIL="your.email@company.com"' >> ~/.zshrc
echo 'export ATLASSIAN_API_TOKEN="ATATT3xFfGF0..."' >> ~/.zshrc
source ~/.zshrc
```

**Test MCP Connection:**

```bash
# Start Amazon Q CLI
q chat

# Test Atlassian MCP (triggers OAuth in browser)
> Using Atlassian MCP, list my recent Jira issues

# Complete OAuth in browser
# Verify connection works
```

**📚 Details:** [MCP Installation Guide](./README.md#section-4-installing-mcps-for-atlassian-and-bitbucket-60-minutes)

---

## Step 6: Document AWS Environment (20 min)

```bash
# Verify AWS credentials are set
echo $AWS_ACCESS_KEY_ID
echo $AWS_DEFAULT_REGION

# Start Amazon Q CLI
q chat
```

**Prompt:**

```
Using AWS CLI, help me document my AWS environment:

1. List all EC2 instances with instance types and states
2. List all S3 buckets
3. List all RDS databases
4. Summarize in a markdown document

My credentials are set via environment variables (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY).
```

**Save output to:** `aws-architecture.md`

**📚 Details:** [AWS Documentation Guide](./README.md#section-5-aws-environment-setup-and-documentation-60-minutes)

---

## Step 7: Post to Confluence (10 min)

**Prompt in Amazon Q CLI:**

```
Using Atlassian MCP, create a Confluence page:

Space: WORKSHOP
Title: "AWS Development Environment - [Date]"
Content: [Paste your aws-architecture.md content]

Format with:
- Table of contents macro
- Info panels for key sections
- Status badges (green for running, grey for stopped)
```

**📚 Details:** [Confluence Guide](./README.md#section-6-posting-aws-findings-to-confluence-30-minutes)

---

## Step 8: Investigate Jira & Analyze Code (15 min)

**Create or find a Jira issue:**

```
Using Atlassian MCP:
1. List my recent Jira issues
2. Find issues with label "performance" or "bug"
3. Show me issue DEV-123 (or your issue key)
```

**Investigate similar issues:**

```
Using Atlassian MCP, search for Jira issues similar to DEV-123:
- Same component
- Same labels
- Created in last 90 days

Summarize findings.
```

**Search code in Bitbucket:**

```
Using Bitbucket MCP:
1. List repositories in workspace [YOUR-WORKSPACE]
2. Search for files containing "authentication" in repo "user-service"
3. Show me the file src/auth/login.py
4. Analyze recent commits that modified this file
```

**Propose solution and update Jira:**

```
Using Atlassian MCP, add comment to DEV-123:

"Investigation complete. Root cause identified in src/auth/login.py

Proposed solution:
[Your solution here]

Estimated effort: 2-4 hours"
```

**📚 Details:** [Jira Guide](./README.md#section-7-jira-investigation-and-analysis-45-minutes) | [Bitbucket Guide](./README.md#section-8-bitbucket-code-lookup-and-solution-proposal-45-minutes)

---

## Verification Checklist

- ✅ AWS Builder ID created and authenticated
- ✅ Kiro IDE installed and running
- ✅ Amazon Q CLI installed (`q chat` works)
- ✅ GitHub CLI authenticated (`gh auth status`)
- ✅ AWS CLI configured with environment variables (`aws sts get-caller-identity`)
- ✅ Environment variables set: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION`
- ✅ Atlassian MCP connected (OAuth completed)
- ✅ Bitbucket MCP configured (API token and email set)
- ✅ Environment variables set: `ATLASSIAN_USER_EMAIL`, `ATLASSIAN_API_TOKEN`
- ✅ Created AWS documentation
- ✅ Posted to Confluence
- ✅ Investigated Jira issue
- ✅ Searched Bitbucket code

---

## Troubleshooting

**MCP not loading:**
```bash
# Restart Amazon Q CLI or Kiro IDE
# Check MCP config syntax
jq . ~/.aws/amazonq/mcp.json
```

**Atlassian OAuth fails:**
```bash
# Check firewall/VPN settings
# Try different browser
# Verify Atlassian workspace access
```

**Bitbucket MCP not working:**
```bash
# Verify environment variables
echo $ATLASSIAN_USER_EMAIL
echo $ATLASSIAN_API_TOKEN

# Reload shell profile
source ~/.zshrc
```

**AWS CLI authentication issues:**
```bash
# Verify environment variables are set
echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
echo $AWS_DEFAULT_REGION

# If missing, set them
export AWS_ACCESS_KEY_ID="your-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"

# Test authentication
aws sts get-caller-identity
```

---

## Next Steps

- Explore [Amazon Q CLI Agents](../amazon-q-cli/agents/README.md)
- Configure [Kiro IDE Specs](../kiro-ide/specs/README.md)
- Set up [Hooks for automation](../amazon-q-cli/hooks/README.md)
- Review [full workshop guide](./README.md) for advanced features

---

## Quick Reference Commands

```bash
# Amazon Q CLI
q chat                     # Start chat
q login                    # Re-authenticate
q doctor                   # Diagnose issues

# AWS CLI (with environment variables)
aws sts get-caller-identity   # Test authentication
aws s3 ls                     # List S3 buckets
aws ec2 describe-instances    # List EC2 instances

# Check AWS environment variables
echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
echo $AWS_DEFAULT_REGION

# GitHub CLI
gh auth status
gh repo list

# Check Atlassian environment variables
echo $ATLASSIAN_USER_EMAIL
echo $ATLASSIAN_API_TOKEN

# Test MCP
npx -y mcp-remote https://mcp.atlassian.com/v1/sse
```

---

**📚 Full Workshop:** [README.md](./README.md)
**🔧 MCP Configuration:** [amazon-q-cli/mcp/](../amazon-q-cli/mcp/)
**📖 Documentation:** [AWS Q Developer Docs](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line.html)
