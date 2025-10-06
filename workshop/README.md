# Workshop: AI-Powered DevOps with Amazon Q, Kiro, and Atlassian Integration

**Duration:** 3-4 hours
**Level:** Intermediate
**Prerequisites:** Basic AWS knowledge, familiarity with Git and command line

## Workshop Overview

This hands-on workshop teaches you to set up and use modern AI development tools (Amazon Q CLI, Kiro IDE) integrated with Atlassian services (Jira, Confluence, Bitbucket) to create an intelligent DevOps workflow. You'll document AWS infrastructure, investigate Jira issues, and propose code solutions using AI assistance throughout.

**What you'll build:**
- Complete AI development environment with Amazon Q CLI and Kiro IDE
- MCP integration with Atlassian (Jira, Confluence) and Bitbucket
- Automated workflow: AWS analysis → Confluence documentation → Jira investigation → Code solution

**What you'll learn:**
- AWS account setup for Amazon Q Developer
- Installing and configuring AI development tools
- MCP server configuration for external integrations
- Using AI to document infrastructure and analyze spending
- AI-assisted issue investigation and code analysis
- Complete DevOps loop from issue to solution

---

## Prerequisites

### Required Accounts

- **AWS Account** - For Amazon Q Developer authentication
  - **AWS IAM Identity Center (Recommended)** - Enterprise SSO, bulk user management, customizations
  - OR AWS Builder ID (Alternative) - Free personal account for individuals
- **Atlassian Cloud Account** - For Jira and Confluence access
  - Free trial available at https://www.atlassian.com/
- **Bitbucket Cloud/Server Access** - For repository integration
- **GitHub Account** - For accessing workshop materials

### Required Permissions

**AWS:**
- Read-only access to development environment
- Ability to authenticate with Amazon Q Developer
- CloudWatch read access (for cost analysis)
- Resource read permissions (EC2, S3, RDS, etc.)

**Atlassian:**
- Jira: Create and edit issues, add comments
- Confluence: Create and edit pages in a designated space
- Bitbucket: Read repositories, view code

### System Requirements

- **Operating System:** macOS, Linux (Ubuntu/Debian), or Windows
- **Memory:** 8GB RAM minimum, 16GB recommended
- **Disk Space:** 2GB free space
- **Internet Connection:** Stable broadband connection required

### Pre-Workshop Setup (Optional)

To maximize workshop time, consider completing Section 1 (AWS Account Setup) before attending.

---

## Workshop Outline

### Section 1: AWS Account Setup for Amazon Q (60 minutes for org setup / 15 minutes for Builder ID)

Choose your authentication approach based on your organization's setup.

**📚 Additional Resources:**
- [AWS Builder ID Sign-Up](https://docs.aws.amazon.com/signin/latest/userguide/sign-in-aws_builder_id.html)
- [Amazon Q Developer Authentication](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line.html)

#### Approach A: IAM Identity Center (Recommended for Organizations)

**This is the recommended approach for enterprise deployment** providing SSO, bulk user management, customizations, and full Pro tier features.

**What is IAM Identity Center?**

AWS IAM Identity Center is AWS's enterprise SSO solution providing:
- **Centralized Access Management** - Manage all users from one place
- **Bulk User Subscriptions** - Subscribe teams via groups, not individuals
- **Amazon Q Customizations** - Train Amazon Q on your private codebase
- **Usage Analytics** - Dashboard with adoption metrics and cost tracking
- **Enterprise Integration** - Okta, Azure AD, Google Workspace, SAML 2.0
- **Policy Controls** - Governance, compliance, and security policies
- **Identity-Aware Sessions** - Use Amazon Q Pro in AWS Console
- **Cost**: $19/user/month (Amazon Q Developer Pro)

##### A.1 For End Users (Your IT Has Already Set This Up)

If your organization has already configured IAM Identity Center and Amazon Q:

1. **Obtain Start URL** from your IT administrator
   - Format: `https://d-xxxxxxxxxx.awsapps.com/start`
2. **Visit the start URL** in your browser
3. **Log in** with your corporate credentials
4. **Complete MFA** setup if required
5. **Note** your AWS account ID and available permission sets
6. **Verify access**:
   ```bash
   # Install AWS CLI first (Section 3)
   aws configure sso
   # Follow prompts to configure SSO profile
   ```

**Skip to Section 2** if your organization is already set up.

##### A.2 For Administrators (Setting Up Organization-Wide)

If you're setting up Amazon Q Developer Pro for your entire organization, follow this complete setup guide:

**Prerequisites:**
- AWS Organization with AWS Organizations enabled
- Management account access (or delegated IAM Identity Center admin)
- Identity provider (Okta, Azure AD, Google Workspace) or use built-in directory
- Minimum permissions: `AmazonQDeveloperFullAccess` and IAM Identity Center admin

**Deployment Architecture (Recommended):**

```
AWS Organization
├── Management Account
│   └── IAM Identity Center (Organization Instance)
│       ├── Identity Source: Okta/Azure AD/Google/SAML
│       └── User Groups: developers-us, developers-eu, qa-team, devops-team
└── Member Accounts
    ├── Dev-Tools Account (us-east-1)
    │   ├── Amazon Q Developer Profile
    │   ├── Subscriptions: developers-us, qa-team
    │   └── Customizations: backend-services, frontend-apps
    └── EU-Team Account (eu-central-1)
        ├── Amazon Q Developer Profile
        ├── Subscriptions: developers-eu
        └── Customizations: eu-services (GDPR compliant)
```

**Step 1: Enable IAM Identity Center**

1. Sign in to **AWS Management Console** with management account
2. Navigate to **IAM Identity Center**
3. Click **Enable**
4. Choose **Enable with AWS Organizations** (critical for full features)
5. Select region:
   - **us-east-1** (US East - N. Virginia) - Recommended
   - **eu-central-1** (EU - Frankfurt) - For EU data residency
6. Click **Enable**

**Step 2: Configure Identity Source**

**Option 1: External Identity Provider (Recommended for Enterprises)**

1. Go to **Settings** → **Identity source** tab
2. Click **Actions** → **Change identity source**
3. Select your provider:
   - **Microsoft Entra ID** (Azure AD)
   - **Okta**
   - **Google Workspace**
   - **External identity provider** (any SAML 2.0)
4. Follow provider-specific configuration:
   - Configure SAML SSO
   - Set up SCIM for automatic user provisioning (recommended)
   - Test authentication
5. Click **Next** and confirm

**Option 2: IAM Identity Center Directory (For Smaller Teams)**

1. Keep default **Identity Center directory**
2. Manually create users via console or API
3. Configure MFA requirements:
   - Go to **Settings** → **Authentication**
   - Set **MFA** to **Required** or **Context-aware**
4. Set password policies

**Step 3: Create Groups for Amazon Q**

1. Navigate to **Groups** → **Create group**
2. Create groups by team/function/region:
   - `developers-us` - US-based development team
   - `developers-eu` - EU-based development team
   - `qa-engineers` - QA/testing team
   - `devops-sre` - DevOps and SRE team
   - `platform-engineering` - Platform/infrastructure team
3. For each group:
   - **Group name**: Descriptive name
   - **Description**: What team/function this represents
   - Click **Create group**
4. Add users to groups:
   - If using SCIM: Users auto-sync from identity provider
   - If manual: **Groups** → Select group → **Add users**

**Why groups?** Bulk subscription management - subscribe entire group to Amazon Q instead of managing individual users.

**Step 4: Create Amazon Q Developer Profile**

1. **Choose deployment account**:
   - **Recommended**: Dedicated member account (e.g., `dev-tools-production`)
   - **Alternative**: Management account (not best practice)
2. Sign in to chosen account
3. Navigate to **Amazon Q Developer** console
4. Ensure you're in correct region (us-east-1 or eu-central-1)
5. Click **Get started**
6. Configure profile:
   - **Profile name**: `company-dev-team-us` (descriptive name)
   - **Cross-region inferencing**: ✅ Enable (allows Q features from other regions)
   - **Share Amazon Q Developer settings with member accounts**: ☐ Leave unchecked unless multi-account
   - **Dashboard metrics**: ✅ Enable (recommended for tracking)
7. Click **Create application**

**What was created:**
- Amazon Q Developer profile in this account/region
- IAM Identity Center managed application: `QDevProfile-us-east-1`
- Connection between IAM Identity Center and Amazon Q

**Step 5: Subscribe Users to Amazon Q Developer Pro**

1. In Amazon Q Developer console, go to **Subscriptions**
2. Click **Subscribe**
3. **Assign users and groups** dialog appears
4. **Subscribe by group** (recommended):
   - Start typing: `developers-us`
   - Select group from autocomplete
   - Click **Assign**
   - Repeat for other groups (`qa-engineers`, `devops-sre`, etc.)
5. **Subscribe individual users** (if needed):
   - Type username (not email address)
   - Select from autocomplete
   - Click **Assign**
6. Users receive email within 24 hours:
   - **From**: `no-reply@amazonq.aws`
   - **Subject**: "Activate Your Amazon Q Developer Pro Subscription"
   - **Action**: User can authenticate immediately even before receiving email

**Verify subscriptions:**
- Go to **Subscriptions** page
- View list of users and groups
- Check **Status** column:
  - **Active** - User has authenticated and activated
  - **Pending** - Awaiting first authentication (normal within 24 hours)

**Step 6: Enable Identity-Enhanced Console Sessions**

**This step is required for users to access Amazon Q Pro in the AWS Management Console.**

1. Return to **IAM Identity Center** console
2. Go to **Settings** → **Identity-aware sessions** tab
3. Click **Enable**
4. Confirm the action

**What this enables:**
- Amazon Q Developer Pro tier in AWS Management Console
- Amazon Q in AWS apps and websites
- Full Pro features everywhere (not just IDEs)

**Without this:** Users limited to Free tier when using AWS Console.

**Step 7: Set Up Cost Tracking and Governance**

1. **AWS Budgets**:
   - Create budget for Amazon Q spending
   - Set alert at 80% of monthly budget
   - Email notification to finance team
2. **Cost allocation tags**:
   - Tag users by department in IAM Identity Center
   - Use AWS Cost Explorer to track by tag
3. **Usage monitoring**:
   - Review **Dashboard** monthly
   - Track adoption metrics by team
   - Identify inactive subscriptions
4. **Governance policies**:
   - Document acceptable use policy
   - Define who can create customizations
   - Establish customization review process

**You're done!** Users can now authenticate and use Amazon Q Developer Pro.

**Additional Resources for Administrators:**
- [Getting Started with IAM Identity Center](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/getting-started-idc.html) - Complete setup guide
- [Deployment Options](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/deployment-options.html) - Architecture patterns
- [Configure Amazon Q Customizations](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/customizations-admin-customize.html) - Train Q on private code (optional)
- [Multi-Region Deployment](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/multi-region.html) - For global teams (optional)
- [Managing Profiles in Large Organizations](https://aws.amazon.com/blogs/devops/managing-amazon-q-developer-profiles-and-customizations-in-large-organizations/) - Best practices

**Next: Skip to Section 2** to install Kiro IDE and Amazon Q CLI.

#### Approach B: AWS Builder ID (Alternative for Individuals)

**Use Builder ID if:**
- You're an individual developer learning Amazon Q
- Your organization doesn't have IAM Identity Center set up
- You want to experiment without organizational overhead
- You don't need customizations or enterprise features

**Limitations:**
- No bulk user management
- No customizations (can't train on private code)
- No usage analytics dashboard
- No SSO integration
- Free tier features only (no Pro tier)

**Create AWS Builder ID:**

1. Visit https://profile.aws.amazon.com/
2. Click **"Sign up for a Builder ID"**
3. **Enter your email address** (personal or work)
4. **Verify email** via confirmation code sent to your inbox
5. **Complete profile information**:
   - First name, last name
   - Display name
6. **Set password** (minimum 8 characters)
7. **Enable MFA** (recommended):
   - Authenticator app (Google Authenticator, Authy, etc.)
   - Or SMS (less secure)
8. Click **Create Builder ID**

**Why Builder ID?**
- ✅ Free, no credit card required
- ✅ Personal AWS service access
- ✅ Separate from organizational AWS accounts
- ✅ Instant access to Amazon Q Developer Free tier
- ✅ Ideal for learning and experimentation

**Verify Builder ID:**

1. Visit https://profile.aws.amazon.com/
2. Log in with your Builder ID credentials
3. Verify MFA is enabled
4. Note your Builder ID email (you'll use this to authenticate)

**📚 Additional Resources:**
- [AWS Builder ID Documentation](https://docs.aws.amazon.com/signin/latest/userguide/sign-in-aws_builder_id.html)
- [Managing Your Builder ID](https://docs.aws.amazon.com/signin/latest/userguide/manage-aws-builder-id.html)

**Next: Continue to Section 2** to install tools.

#### 1.3 Verify AWS Permissions

**Check Development Environment Access:**

You'll need read-only access to a development AWS account for this workshop. Verify you have:

**Essential Permissions:**
- `ec2:Describe*` - View EC2 instances
- `s3:List*`, `s3:Get*` - Read S3 buckets
- `rds:Describe*` - View RDS databases
- `cloudwatch:Get*`, `cloudwatch:List*` - Read metrics
- `ce:Get*` - Cost Explorer (for spend analysis)

**Verify Using AWS Console:**

1. Log into AWS Console
2. Navigate to IAM → Users → Your User
3. Review attached policies
4. Confirm read access to development account resources

**Or Request from Administrator:**

If you don't have access yet, request a **ReadOnlyAccess** managed policy or equivalent custom policy for the development environment.

---

### Section 2: Installing Kiro IDE and Amazon Q CLI (45 minutes)

Install the core AI development tools.

**📚 Additional Resources:**
- [Kiro IDE Downloads](https://kiro.dev/downloads/)
- [Kiro IDE Documentation](https://kiro.dev/docs/)
- [Amazon Q CLI Installation Guide](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-installing.html)
- [Amazon Q CLI Documentation](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line.html)

#### 2.1 Installing Kiro IDE

**Kiro IDE** is AWS's AI-native IDE in public preview.

**macOS:**

1. Visit https://kiro.dev/downloads/
2. Select **"Mac (Apple Silicon)"** or **"Mac (Intel)"** based on your system
3. Download the installer
4. Open the downloaded DMG file
5. Drag Kiro to Applications folder
6. Launch Kiro from Applications

**Windows:**

1. Visit https://kiro.dev/downloads/
2. Click **"Download for Windows"**
3. Run the installer (`.exe` file)
4. Follow installation wizard
5. Launch Kiro from Start Menu

**Linux (Ubuntu/Debian):**

1. Visit https://kiro.dev/downloads/
2. Download **"Linux (Debian/Ubuntu)"** package
3. Install:
   ```bash
   sudo dpkg -i kiro-*.deb
   sudo apt-get install -f
   ```
4. Launch:
   ```bash
   kiro
   ```

**Linux (Other):**

Download the **"Linux (Universal)"** AppImage:
```bash
wget https://kiro.dev/downloads/kiro-latest.AppImage
chmod +x kiro-latest.AppImage
./kiro-latest.AppImage
```

**Initial Setup:**

1. Launch Kiro
2. Choose authentication:
   - **GitHub** (recommended for this workshop)
   - **Google**
   - **AWS Builder ID**
   - **AWS IAM Identity Center**
3. Complete authentication in browser
4. (Optional) Import VS Code settings if prompted
5. Verify installation - AI chat panel should be available

**Troubleshooting:**
- **macOS: "App from unidentified developer"** - Right-click → Open, then confirm
- **Linux: Missing dependencies** - Run `sudo apt-get install -f`
- **Windows: SmartScreen warning** - Click "More info" → "Run anyway"

#### 2.2 Installing Amazon Q CLI

**Amazon Q CLI** provides AI-powered command-line assistance.

**macOS:**

**Option 1: Homebrew (Recommended)**
```bash
brew install --cask amazon-q
```

**Option 2: Direct Download**
```bash
# Download DMG
curl -O https://desktop-release.q.us-east-1.amazonaws.com/latest/Amazon%20Q.dmg

# Open and install
open Amazon\ Q.dmg
# Drag to Applications folder
```

**Ubuntu/Debian:**

```bash
# Download DEB package
wget https://desktop-release.q.us-east-1.amazonaws.com/latest/amazon-q.deb

# Install package
sudo dpkg -i amazon-q.deb

# Install dependencies if needed
sudo apt-get install -f
```

**Linux (AppImage):**

```bash
# Download AppImage
wget https://desktop-release.q.us-east-1.amazonaws.com/latest/amazon-q.appimage

# Make executable
chmod +x amazon-q.appimage

# Run
./amazon-q.appimage
```

**Windows:**

1. Download installer: https://desktop-release.q.us-east-1.amazonaws.com/latest/amazon-q.exe
2. Run the installer
3. Follow installation wizard
4. Launch from Start Menu

**Verify Installation:**

```bash
# Check Q CLI is installed
q --version

# Authenticate with AWS Builder ID or IAM Identity Center
q login
```

**Authentication:**

1. Run `q login`
2. Choose authentication method:
   - **AWS Builder ID** (use the one created in Section 1)
   - **AWS IAM Identity Center** (use organization SSO)
3. Complete authentication in browser
4. Verify: `q chat`

**Configure Shell Integration:**

```bash
# For bash
echo 'eval "$(q shell-integration bash)"' >> ~/.bashrc
source ~/.bashrc

# For zsh
echo 'eval "$(q shell-integration zsh)"' >> ~/.zshrc
source ~/.zshrc

# For fish
echo 'q shell-integration fish | source' >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish
```

**Test Amazon Q CLI:**

```bash
# Start chat
q chat

# Ask a question
> How do I list all S3 buckets?

# Test autocomplete
aws s3 <TAB>
```

---

### Section 3: Installing GitHub CLI and AWS CLI (30 minutes)

Install essential command-line tools for repository and AWS management.

**📚 Additional Resources:**
- [GitHub CLI Manual](https://cli.github.com/manual/)
- [GitHub CLI Installation](https://github.com/cli/cli#installation)
- [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [AWS CLI Configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
- [AWS CLI SSO Configuration](https://docs.aws.amazon.com/cli/latest/userguide/sso-configure-profile-token.html)

#### 3.1 Installing GitHub CLI

**GitHub CLI** provides command-line access to GitHub repositories.

**macOS:**
```bash
brew install gh
```

**Windows:**
```bash
winget install --id GitHub.cli
```

**Linux (Debian/Ubuntu):**
```bash
# Add GitHub CLI repository
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Install
sudo apt update
sudo apt install gh -y
```

**Verify Installation:**
```bash
gh --version
```

**Authenticate:**
```bash
gh auth login

# Follow prompts:
# 1. Choose: GitHub.com
# 2. Choose: HTTPS
# 3. Authenticate via browser
# 4. Complete authentication
```

**Test GitHub CLI:**
```bash
# Clone workshop repository
gh repo clone [workshop-repo-url]

# View your repositories
gh repo list

# Check authentication
gh auth status
```

#### 3.2 Installing AWS CLI

**AWS CLI** provides advanced AWS commands beyond MCP capabilities.

**macOS:**
```bash
# Download installer
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"

# Install
sudo installer -pkg AWSCLIV2.pkg -target /

# Verify
aws --version
```

**Windows:**
```bash
# Download and run installer
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

# Or download from browser and run the MSI file
```

**Linux:**
```bash
# Download installer
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Extract
unzip awscliv2.zip

# Install
sudo ./aws/install

# Verify
aws --version
```

**Configure AWS CLI:**

**Option 1: Environment Variables with IAM Access Keys (Recommended for Workshop)**

```bash
# Set AWS credentials as environment variables
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
export AWS_DEFAULT_REGION="us-east-1"
export AWS_DEFAULT_OUTPUT="json"

# Make permanent by adding to shell profile
echo 'export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"' >> ~/.bashrc
echo 'export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"' >> ~/.bashrc
echo 'export AWS_DEFAULT_REGION="us-east-1"' >> ~/.bashrc
echo 'export AWS_DEFAULT_OUTPUT="json"' >> ~/.bashrc

# For zsh users
echo 'export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"' >> ~/.zshrc
echo 'export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"' >> ~/.zshrc
echo 'export AWS_DEFAULT_REGION="us-east-1"' >> ~/.zshrc
echo 'export AWS_DEFAULT_OUTPUT="json"' >> ~/.zshrc

# Reload profile
source ~/.bashrc  # or source ~/.zshrc
```

**Create IAM Access Keys:**

1. Log into AWS Console
2. Navigate to **IAM** → **Users** → Your Username
3. Go to **Security credentials** tab
4. Click **Create access key**
5. Choose use case: **Command Line Interface (CLI)**
6. Add description tag: "Workshop CLI Access"
7. Click **Create access key**
8. **Copy both Access Key ID and Secret Access Key**
9. Store securely - you won't see the secret again

**Option 2: AWS CLI Configuration File**

```bash
aws configure

# Enter:
# AWS Access Key ID: AKIAIOSFODNN7EXAMPLE
# AWS Secret Access Key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
# Default region: us-east-1
# Default output format: json
```

This creates `~/.aws/credentials` and `~/.aws/config` files.

**Option 3: SSO (For Organizations Using IAM Identity Center)**

```bash
aws configure sso

# Enter your SSO start URL (e.g., https://d-xxxxxxxxxx.awsapps.com/start)
# Select SSO region (e.g., us-east-1)
# Choose account and role
# Set default region (e.g., us-east-1)
# Set output format: json
# Set profile name: dev-readonly
```

**Test AWS CLI:**
```bash
# Test authentication
aws sts get-caller-identity

# List S3 buckets
aws s3 ls

# Using SSO profile (if configured)
aws s3 ls --profile dev-readonly

# Or set profile via environment variable
export AWS_PROFILE=dev-readonly
aws s3 ls

# Test Cost Explorer access
aws ce get-cost-and-usage \
  --time-period Start=2025-01-01,End=2025-01-31 \
  --granularity MONTHLY \
  --metrics BlendedCost
```

**Troubleshooting:**
- **SSO token expired:** Run `aws sso login --profile dev-readonly`
- **Permission denied:** Verify read-only access with your AWS administrator
- **Command not found:** Add AWS CLI to PATH or restart terminal

---

### Section 4: Installing MCPs for Atlassian and Bitbucket (60 minutes)

Configure Model Context Protocol servers for external service integration.

**📚 Additional Resources:**
- [MCP Protocol Documentation](https://modelcontextprotocol.io/)
- [MCP Server Directory](https://github.com/modelcontextprotocol/servers)
- [Atlassian MCP Documentation](https://developer.atlassian.com/platform/model-context-protocol/)
- [Amazon Q CLI MCP Guide](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/mcp-cli.html)
- [Bitbucket MCP Server (GitHub)](https://github.com/aashari/mcp-server-atlassian-bitbucket)
- [Project MCP Configuration Guide](../amazon-q-cli/mcp/README.md)

#### 4.1 Installing Node.js (MCP Prerequisite)

Most MCP servers require Node.js.

**macOS:**
```bash
brew install node
node --version
npm --version
```

**Ubuntu/Debian:**
```bash
sudo apt install nodejs npm
node --version
npm --version
```

**Windows:**
Download from https://nodejs.org/ and install the LTS version.

#### 4.2 Understanding MCP Configuration

**Configuration Files:**
- **Amazon Q CLI & VS Code:** `~/.aws/amazonq/mcp.json`
- **Kiro IDE:** `~/.kiro/settings/mcp.json`

**Shared Configuration:**
Amazon Q CLI and Amazon Q VS Code extension share the same MCP configuration file, so you only need to configure once for both tools.

#### 4.3 Installing Atlassian MCP Server

**Atlassian MCP** provides access to Jira and Confluence via OAuth.

**Installation Command:**
```bash
npx -y mcp-remote https://mcp.atlassian.com/v1/sse
```

**Configure for Amazon Q CLI:**

Edit `~/.aws/amazonq/mcp.json`:

```json
{
  "mcpServers": {
    "atlassian": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.atlassian.com/v1/sse"],
      "env": {}
    }
  }
}
```

**Configure for Kiro IDE:**

Edit `~/.kiro/settings/mcp.json`:

```json
{
  "mcpServers": {
    "atlassian": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.atlassian.com/v1/sse"],
      "transport": "stdio",
      "disabled": false
    }
  }
}
```

**OAuth Authentication:**

1. Start Amazon Q CLI or Kiro IDE
2. Try to use Atlassian tools (will trigger OAuth)
3. Browser window opens automatically
4. Log in with your Atlassian account credentials
5. Grant permissions to the MCP server:
   - **Jira:** Read and write issues, comments
   - **Confluence:** Read and write pages, spaces
6. Close browser - credentials are cached

**Test Atlassian MCP:**

```bash
# In Amazon Q CLI
q chat

> Using Atlassian MCP, list my recent Jira issues
```

**Troubleshooting:**
- **Browser doesn't open:** Check firewall settings
- **OAuth fails:** Verify Atlassian account has access to your workspace
- **"Not authorized" error:** Re-authenticate by removing cached credentials

#### 4.4 Installing Bitbucket MCP Server

**Bitbucket MCP** provides repository access via API token.

**Installation Command:**
```bash
npx -y @aashari/mcp-server-atlassian-bitbucket
```

**Create Bitbucket API Token:**

1. Go to https://id.atlassian.com/manage-profile/security/api-tokens
2. Click **"Create API token with scopes"**
3. Token details:
   - **Name:** "Workshop MCP Access"
   - **Product:** Select **"Bitbucket"**
4. Select scopes:
   - ✅ `repository` - Read
   - ✅ `workspace` - Read
   - ✅ `pullrequest` - Read
5. Click **"Create"**
6. **Copy the token** (starts with `ATATT`) - you won't see it again

**Store Credentials Securely:**

**macOS/Linux:**
```bash
# Add to your shell profile (~/.bashrc, ~/.zshrc, etc.)
export ATLASSIAN_USER_EMAIL="your.email@company.com"
export ATLASSIAN_API_TOKEN="ATATT3xFfGF0..."

# Reload profile
source ~/.bashrc  # or source ~/.zshrc
```

**Windows (PowerShell):**
```powershell
# Add to PowerShell profile
[Environment]::SetEnvironmentVariable("ATLASSIAN_USER_EMAIL", "your.email@company.com", "User")
[Environment]::SetEnvironmentVariable("ATLASSIAN_API_TOKEN", "ATATT3xFfGF0...", "User")

# Restart PowerShell
```

**Configure for Amazon Q CLI:**

Edit `~/.aws/amazonq/mcp.json`:

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

**Configure for Kiro IDE:**

Edit `~/.kiro/settings/mcp.json`:

```json
{
  "mcpServers": {
    "atlassian": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.atlassian.com/v1/sse"],
      "transport": "stdio",
      "disabled": false
    },
    "bitbucket": {
      "command": "npx",
      "args": ["-y", "@aashari/mcp-server-atlassian-bitbucket"],
      "transport": "stdio",
      "env": {
        "ATLASSIAN_USER_EMAIL": "${ATLASSIAN_USER_EMAIL}",
        "ATLASSIAN_API_TOKEN": "${ATLASSIAN_API_TOKEN}"
      },
      "disabled": false
    }
  }
}
```

**Test Bitbucket MCP:**

```bash
# Restart Amazon Q CLI
q chat

> Using Bitbucket MCP, list repositories in my workspace
```

**Troubleshooting:**
- **"Authentication failed":** Verify email and token are correct
- **"Repository not found":** Check workspace/repo names
- **Environment variables not loading:** Restart terminal/IDE after setting

#### 4.5 Automated MCP Installation (Optional)

**Use the workshop installation script:**

```bash
# Clone workshop repository
cd ai-config-guide/amazon-q-cli/mcp

# Run automated installer
./install-mcp.sh
```

This creates a backup and installs the complete MCP configuration for both Amazon Q CLI and Kiro IDE.

**What it installs:**
- Memory server (persistent context)
- Fetch server (web content)
- Playwright server (browser automation)
- Atlassian MCP (Jira/Confluence)
- Bitbucket MCP (repository access)
- Docker Gateway (container management)

**After installation:**
1. Add your Atlassian/Bitbucket credentials
2. Restart Amazon Q CLI and Kiro IDE
3. Complete OAuth for Atlassian MCP

---

### Section 5: AWS Environment Setup and Documentation (60 minutes)

Use Amazon Q and AWS CLI to document your AWS environment architecture and analyze spending.

**📚 Additional Resources:**
- [AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/reference/)
- [Amazon Q CLI Tools Documentation](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-built-in-tools.html)
- [AWS Cost Explorer API](https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_Operations_AWS_Cost_Explorer_Service.html)
- [AWS Resource Tagging](https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html)

#### 5.1 Configure AWS Environment Variables

**Verify your AWS credentials are set (from Section 3):**

```bash
# Check environment variables
echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
echo $AWS_DEFAULT_REGION

# If not set, configure them now
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
export AWS_DEFAULT_REGION="us-east-1"

# Or if using SSO profile
export AWS_PROFILE=dev-readonly

# Verify access
aws sts get-caller-identity
```

**Output should show:**
```json
{
    "UserId": "AIDAXXXXXXXXXXXXXXXXX",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/workshop-user"
}
```

**Note:** For SSO users, the ARN will show `assumed-role` instead of `user`.

#### 5.2 Document High-Level AWS Architecture

**Use Amazon Q CLI to analyze infrastructure:**

```bash
q chat
```

**Prompt 1: Inventory Resources**
```
Using AWS CLI, help me document the following for account [YOUR-ACCOUNT-ID]:

1. List all EC2 instances with their instance types, states, and tags
2. List all S3 buckets with their regions and versioning status
3. List all RDS databases with their engine types and sizes
4. List all Lambda functions with their runtimes
5. Summarize the results in a markdown table

Use the dev-readonly profile.
```

**Amazon Q will help you run commands like:**
```bash
# EC2 instances
aws ec2 describe-instances \
  --profile dev-readonly \
  --query 'Reservations[].Instances[].[InstanceId,InstanceType,State.Name,Tags[?Key==`Name`].Value|[0]]' \
  --output table

# S3 buckets
aws s3api list-buckets \
  --profile dev-readonly \
  --query 'Buckets[].[Name]' \
  --output table

# RDS databases
aws rds describe-db-instances \
  --profile dev-readonly \
  --query 'DBInstances[].[DBInstanceIdentifier,Engine,DBInstanceClass,DBInstanceStatus]' \
  --output table

# Lambda functions
aws lambda list-functions \
  --profile dev-readonly \
  --query 'Functions[].[FunctionName,Runtime,MemorySize]' \
  --output table
```

**Create Architecture Document:**

Save the output to `aws-architecture.md`:

```markdown
# AWS Development Environment Architecture

**Account ID:** 123456789012
**Environment:** Development
**Date:** 2025-01-04

## Infrastructure Summary

### Compute Resources

#### EC2 Instances
| Instance ID | Instance Type | State | Name |
|-------------|---------------|-------|------|
| i-0abc123 | t3.medium | running | web-server-dev |
| i-0def456 | t3.small | stopped | test-instance |

#### Lambda Functions
| Function Name | Runtime | Memory |
|---------------|---------|--------|
| user-auth-dev | python3.11 | 512 MB |
| data-processor-dev | nodejs18.x | 1024 MB |

### Storage

#### S3 Buckets
| Bucket Name | Region | Versioning |
|-------------|--------|------------|
| dev-app-data | us-east-1 | Enabled |
| dev-logs-bucket | us-east-1 | Disabled |

#### RDS Databases
| Identifier | Engine | Instance Class | Status |
|------------|--------|----------------|--------|
| dev-postgres | postgres14 | db.t3.micro | available |

### Architecture Diagram

```
┌─────────────────────────────────────────┐
│           Development Account            │
│                                          │
│  ┌──────────┐         ┌──────────┐     │
│  │   EC2    │────────▶│   RDS    │     │
│  │ Web App  │         │ Database │     │
│  └──────────┘         └──────────┘     │
│       │                                 │
│       ▼                                 │
│  ┌──────────┐         ┌──────────┐     │
│  │    S3    │◀────────│  Lambda  │     │
│  │  Storage │         │ Functions│     │
│  └──────────┘         └──────────┘     │
└─────────────────────────────────────────┘
```

## Security Analysis

- **IAM Roles:** ReadOnlyRole configured for development access
- **Security Groups:** Web server allows 443 inbound, database restricted to VPC
- **Encryption:** S3 buckets use AES-256 encryption, RDS has encryption at rest

## Cost Optimization Opportunities

- **Stopped EC2 instances:** i-0def456 incurring storage costs
- **S3 versioning:** dev-app-data has versioning enabled (review retention)
- **RDS instance size:** db.t3.micro may need upgrade for production workloads
```

#### 5.3 Evaluate AWS Spending

**Prompt 2: Cost Analysis**
```
Using AWS Cost Explorer, help me analyze spending for the last 30 days:

1. Total cost for the month
2. Cost breakdown by service
3. Top 5 most expensive resources
4. Identify cost optimization opportunities

Use the dev-readonly profile.
```

**Amazon Q will help with commands like:**

```bash
# Get total monthly cost
aws ce get-cost-and-usage \
  --profile dev-readonly \
  --time-period Start=2025-01-01,End=2025-02-01 \
  --granularity MONTHLY \
  --metrics BlendedCost \
  --output json

# Cost by service
aws ce get-cost-and-usage \
  --profile dev-readonly \
  --time-period Start=2025-01-01,End=2025-02-01 \
  --granularity MONTHLY \
  --metrics BlendedCost \
  --group-by Type=DIMENSION,Key=SERVICE \
  --output table
```

**Add to Architecture Document:**

```markdown
## Cost Analysis (Last 30 Days)

**Total Spend:** $347.82

### Cost Breakdown by Service

| Service | Cost | Percentage |
|---------|------|------------|
| EC2 | $156.40 | 45% |
| RDS | $89.23 | 26% |
| S3 | $52.15 | 15% |
| Lambda | $28.04 | 8% |
| Data Transfer | $22.00 | 6% |

### Cost Optimization Recommendations

1. **EC2 Savings Plans:** Could save ~20% ($31.28/month) with 1-year commitment
2. **S3 Lifecycle Policies:** Move infrequent access data to S3-IA (save $15-20/month)
3. **RDS Reserved Instances:** 1-year RI would save ~30% ($26.77/month)
4. **Stop/Terminate Unused Resources:** i-0def456 stopped instance costs $8/month
5. **Lambda Memory Optimization:** Review function memory allocation

**Total Potential Savings:** ~$80-100/month (23-29% reduction)
```

#### 5.4 Review and Refine

**Ask Amazon Q to review:**
```
Review this architecture document for completeness. Are there any security concerns, architectural issues, or additional optimizations I should consider?
```

**Save the final document:**
```bash
# Save your architecture document
cat > ~/aws-dev-architecture.md << 'EOF'
[Paste your complete architecture documentation]
EOF
```

---

### Section 6: Posting AWS Findings to Confluence (30 minutes)

Use the Atlassian MCP to create a Confluence page with your AWS documentation.

**📚 Additional Resources:**
- [Atlassian MCP Documentation](https://developer.atlassian.com/platform/model-context-protocol/)
- [Confluence REST API](https://developer.atlassian.com/cloud/confluence/rest/v2/intro/)
- [Confluence Storage Format](https://confluence.atlassian.com/doc/confluence-storage-format-790796544.html)
- [Confluence Macros Guide](https://confluence.atlassian.com/doc/confluence-user-macros-4485.html)

#### 6.1 Prepare Confluence Space

**Identify your Confluence space:**

1. Log into Confluence: https://[your-domain].atlassian.net/
2. Navigate to or create a space for workshop content:
   - Space Key: `WORKSHOP` or `DEV`
   - Space Name: "Workshop Documentation" or "Development"
3. Note the space key (you'll need it)

#### 6.2 Create Confluence Page via Atlassian MCP

**Open Amazon Q CLI:**

```bash
q chat
```

**Prompt: Create Confluence Page**
```
Using the Atlassian MCP, create a new Confluence page with the following details:

Space Key: WORKSHOP
Page Title: AWS Development Environment Architecture - January 2025
Parent Page: (none - create as top-level page)

Content: [Paste your complete aws-architecture.md content here]

Please format it properly for Confluence using their storage format (XHTML).
```

**Amazon Q will:**
1. Connect to Atlassian MCP
2. Convert Markdown to Confluence storage format
3. Create the page in your workspace
4. Return the page URL

**Alternative: Manual creation via prompts**

If you prefer step-by-step:

```
Step 1: Using Atlassian MCP, what spaces do I have access to?
```

```
Step 2: Create a new page in space WORKSHOP with title "AWS Development Environment Architecture - January 2025"
```

```
Step 3: Update the page body with this content:
[Paste architecture content]
```

#### 6.3 Add Visual Enhancements

**Prompt: Enhance Page**
```
Update the Confluence page to include:

1. Add a "Status" macro at the top with color=blue and title="Review Required"
2. Add an "Info" panel with the account details
3. Format the cost analysis section with a "Warning" panel
4. Add a table of contents macro
5. Add page labels: aws, architecture, development, cost-analysis
```

**Amazon Q will update the page with Confluence macros.**

#### 6.4 Share and Notify

**Prompt: Share Page**
```
Using Atlassian MCP:

1. Get the shareable link for the page
2. Add a comment: "Architecture documentation complete. Please review cost optimization recommendations."
3. Mention user @[teammate-email] in the comment
```

**Verify:**

1. Visit the Confluence page URL provided by Amazon Q
2. Confirm all content is formatted correctly
3. Check that tables, code blocks, and macros render properly
4. Share the link with your team

**Expected Result:**

A professional Confluence page with:
- ✅ Architecture summary with tables
- ✅ Cost analysis with recommendations
- ✅ Security considerations
- ✅ Visual formatting (status, info, warning macros)
- ✅ Table of contents
- ✅ Proper labels for discoverability

---

### Section 7: Jira Investigation and Analysis (45 minutes)

Investigate a Jira issue, find similar issues, and post analysis results.

**📚 Additional Resources:**
- [Jira REST API Documentation](https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/)
- [JQL (Jira Query Language)](https://support.atlassian.com/jira-service-management-cloud/docs/use-advanced-search-with-jira-query-language-jql/)
- [Jira Issue Types](https://support.atlassian.com/jira-cloud-administration/docs/what-are-issue-types/)
- [Atlassian MCP Jira Tools](https://developer.atlassian.com/platform/model-context-protocol/)

#### 7.1 Create or Select a Jira Issue

**Option 1: Create a Sample Issue**

```bash
q chat
```

**Prompt: Create Jira Issue**
```
Using Atlassian MCP, create a new Jira issue in project DEV (or your project key):

Issue Type: Bug
Summary: "High latency in user authentication API"
Description:
Users are experiencing 3-5 second delays when logging in. The authentication API typically responds in <500ms. This started appearing after the recent deployment on 2025-01-02.

Steps to reproduce:
1. Navigate to /login
2. Enter valid credentials
3. Click "Sign In"
4. Observe >3s delay before redirect

Expected: <500ms response time
Actual: 3-5s response time

Environment: Development
Priority: High
```

**Option 2: Use Existing Issue**

If you have access to existing Jira issues, note the issue key (e.g., `DEV-123`).

#### 7.2 Search for Similar Issues

**Prompt: Find Similar Issues**
```
Using Atlassian MCP, search for Jira issues similar to DEV-[YOUR-ISSUE-NUMBER]:

Search criteria:
- Same project (DEV)
- Keywords: authentication, latency, performance, login, API
- Status: Any
- Created in last 6 months

Analyze the results and identify:
1. Common patterns across issues
2. Previously attempted solutions
3. Related components or services
4. Any resolved issues with similar symptoms
```

**Amazon Q will:**
1. Search Jira using Atlassian MCP
2. Return similar issues
3. Analyze patterns

**Example Output:**
```
Found 5 similar issues:

1. DEV-89: "Login timeout after deployment" (Resolved)
   - Root cause: Database connection pool exhausted
   - Solution: Increased pool size from 10 to 50

2. DEV-102: "Slow API responses in staging" (Closed)
   - Root cause: Missing database index on users.email
   - Solution: Added index, reduced query time by 80%

3. DEV-134: "Authentication service degraded" (In Progress)
   - Investigating Redis cache connection issues

Common patterns:
- All occurred after deployments
- All related to database/cache performance
- Most resolved by infrastructure tuning
```

#### 7.3 Perform Root Cause Investigation

**Prompt: Deep Dive Analysis**
```
Based on the similar issues found, help me investigate the current issue (DEV-[NUMBER]):

Using AWS CLI (with dev-readonly profile), check:
1. Lambda function logs for the authentication service (last 24 hours)
2. RDS database connection metrics
3. Any recent changes to the auth Lambda function
4. Redis/ElastiCache metrics if applicable

Provide a structured investigation report.
```

**Amazon Q will help run:**

```bash
# Check Lambda logs
aws logs filter-log-events \
  --profile dev-readonly \
  --log-group-name /aws/lambda/user-auth-dev \
  --start-time $(date -u -d '24 hours ago' +%s)000 \
  --filter-pattern "ERROR"

# Check RDS connections
aws cloudwatch get-metric-statistics \
  --profile dev-readonly \
  --namespace AWS/RDS \
  --metric-name DatabaseConnections \
  --dimensions Name=DBInstanceIdentifier,Value=dev-postgres \
  --start-time $(date -u -d '24 hours ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 3600 \
  --statistics Maximum,Average

# Check recent deployments
aws lambda list-versions-by-function \
  --profile dev-readonly \
  --function-name user-auth-dev
```

**Create Investigation Report:**

```markdown
# Investigation Report: DEV-[NUMBER]

## Issue Summary
High latency (3-5s) in user authentication API after 2025-01-02 deployment.

## Similar Issues Analysis
Found 5 related issues, 3 resolved:
- Primary pattern: Database connection/query performance
- Common resolution: Infrastructure tuning (connection pools, indexes)

## Technical Investigation

### Lambda Function Analysis
- **Log Review:** Found 127 timeout warnings in last 24h
- **Execution Time:** Average 4.2s (baseline: 450ms)
- **Error Rate:** 2.3% (baseline: 0.1%)

### Database Metrics
- **Connection Count:** Averaging 45/50 (90% utilization)
- **Peak Connections:** Reaching 50/50 during login peaks
- **Connection Errors:** 18 "too many connections" errors logged

### Recent Changes
- **Deployment 2025-01-02:** Updated authentication logic
- **New Query:** Added user profile fetch (no index on profiles table)
- **Connection Pool:** Still configured at 10 connections

## Root Cause Hypothesis
1. **Primary:** New user profile query is slow (no index) + connection pool exhaustion
2. **Secondary:** Increased load causing connection saturation

## Recommended Solution
1. Add database index on `user_profiles.user_id`
2. Increase Lambda connection pool from 10 to 30
3. Add query result caching for user profiles
4. Monitor connection metrics after changes

## Next Steps
1. Review code changes in Bitbucket (Section 8)
2. Validate hypothesis with engineering team
3. Create PR with proposed fixes
4. Deploy to staging for testing
```

#### 7.4 Post Investigation to Jira

**Prompt: Update Jira Issue**
```
Using Atlassian MCP, update Jira issue DEV-[NUMBER]:

1. Add a comment with the full investigation report above
2. Update the following fields:
   - Priority: High (if not already)
   - Add label: performance
   - Add label: database
   - Add label: investigated
3. Link it to the similar resolved issue DEV-89
4. Transition to "In Progress" if currently "Open"
```

**Amazon Q will:**
1. Post the investigation as a comment
2. Update issue fields
3. Create issue links
4. Transition the issue status

**Verify:**

1. Open the Jira issue in your browser
2. Confirm investigation comment is visible
3. Check labels and links are correct
4. Verify status transition

---

### Section 8: Bitbucket Code Lookup and Solution Proposal (45 minutes)

Use Bitbucket MCP to examine code, identify the issue, and propose a solution.

**📚 Additional Resources:**
- [Bitbucket REST API](https://developer.atlassian.com/cloud/bitbucket/rest/intro/)
- [Bitbucket API Tokens](https://support.atlassian.com/bitbucket-cloud/docs/app-passwords/)
- [Bitbucket MCP Server](https://github.com/aashari/mcp-server-atlassian-bitbucket)
- [Bitbucket Code Search](https://support.atlassian.com/bitbucket-cloud/docs/search-for-code-in-bitbucket/)

#### 8.1 Identify Relevant Repository

**Prompt: Find Repository**
```
Using Bitbucket MCP, list repositories in workspace [YOUR-WORKSPACE]:

Filter for repositories related to authentication or user services.
```

**Expected Output:**
```
Found repositories:
1. user-auth-service (updated 2 days ago)
2. api-gateway (updated 5 days ago)
3. user-profile-service (updated 1 week ago)
```

**Select the authentication repository** (e.g., `user-auth-service`).

#### 8.2 Review Recent Changes

**Prompt: Check Recent Commits**
```
Using Bitbucket MCP, show me:

1. Commits to user-auth-service/main branch since 2025-01-01
2. Focus on changes related to authentication, database queries, or user profiles
3. Identify the commit that deployed on 2025-01-02
```

**Amazon Q will show:**
```
Recent commits:

Commit: a1b2c3d (2025-01-02 14:23)
Author: developer@company.com
Message: "Add user profile data to auth response"
Files changed:
- src/handlers/auth.js (modified)
- src/models/userProfile.js (new)

Commit: e4f5g6h (2025-01-01 09:15)
Author: developer@company.com
Message: "Update dependencies"
```

#### 8.3 Examine Problematic Code

**Prompt: View Code Changes**
```
Using Bitbucket MCP, show me the diff for commit a1b2c3d, specifically:

1. Changes to src/handlers/auth.js
2. Contents of src/models/userProfile.js

Focus on database query patterns.
```

**Example Code Amazon Q Retrieves:**

**src/handlers/auth.js (after change):**
```javascript
async function handleLogin(email, password) {
  // Verify credentials
  const user = await User.findByEmail(email);
  if (!verifyPassword(password, user.passwordHash)) {
    throw new AuthError('Invalid credentials');
  }

  // NEW: Fetch user profile
  const profile = await UserProfile.findByUserId(user.id);

  return {
    token: generateToken(user.id),
    user: {
      id: user.id,
      email: user.email,
      profile: profile  // NEW: Including profile data
    }
  };
}
```

**src/models/userProfile.js:**
```javascript
class UserProfile {
  static async findByUserId(userId) {
    // PROBLEM: No index on user_id column!
    const query = 'SELECT * FROM user_profiles WHERE user_id = $1';
    const result = await db.query(query, [userId]);
    return result.rows[0];
  }
}
```

#### 8.4 Analyze the Issue

**Prompt: Code Analysis**
```
Analyze the code changes and confirm:

1. Is the new query in UserProfile.findByUserId causing the performance issue?
2. What database indexes are missing?
3. Are there any other performance concerns?
4. How does this align with our investigation findings?
```

**Amazon Q Analysis:**
```
Analysis confirms root cause hypothesis:

Issues identified:
1. **Missing Index:** user_profiles.user_id has no index
   - Full table scan on every login
   - Explains 3-5s latency with growing user base

2. **N+1 Query Pattern:** Separate query for each login
   - Should use JOIN or caching
   - Connection pool exhaustion under load

3. **No Error Handling:** findByUserId doesn't handle missing profiles
   - Could cause failures if profile doesn't exist

4. **Alignment:** Matches investigation findings:
   - Timing: Deployed 2025-01-02 ✓
   - Symptom: Database performance ✓
   - Pattern: Similar to resolved issue DEV-89 ✓
```

#### 8.5 Propose Solution

**Prompt: Generate Fix**
```
Using the code analysis, create:

1. Database migration to add the missing index
2. Updated UserProfile.findByUserId with error handling
3. (Optional) Caching layer to reduce database calls
4. Unit tests for the changes

Format as a pull request proposal.
```

**Amazon Q Generates:**

**Migration: `migrations/202501_add_user_profile_index.sql`**
```sql
-- Add index on user_profiles.user_id for faster lookups
CREATE INDEX CONCURRENTLY idx_user_profiles_user_id
ON user_profiles(user_id);

-- Add index on email for potential future queries
CREATE INDEX CONCURRENTLY idx_user_profiles_email
ON user_profiles(email);

-- Analyze table to update statistics
ANALYZE user_profiles;
```

**Updated Code: `src/models/userProfile.js`**
```javascript
const NodeCache = require('node-cache');
const profileCache = new NodeCache({ stdTTL: 300 }); // 5 min cache

class UserProfile {
  static async findByUserId(userId) {
    // Check cache first
    const cacheKey = `profile:${userId}`;
    const cached = profileCache.get(cacheKey);
    if (cached) {
      return cached;
    }

    // Query with index (will be fast after migration)
    const query = 'SELECT * FROM user_profiles WHERE user_id = $1';

    try {
      const result = await db.query(query, [userId]);

      if (result.rows.length === 0) {
        // Handle missing profile gracefully
        console.warn(`No profile found for user ${userId}`);
        return null;
      }

      const profile = result.rows[0];

      // Cache for future requests
      profileCache.set(cacheKey, profile);

      return profile;
    } catch (error) {
      console.error('Error fetching user profile:', error);
      throw new DatabaseError('Failed to fetch user profile');
    }
  }

  // Clear cache when profile is updated
  static async update(userId, data) {
    const result = await db.query(
      'UPDATE user_profiles SET data = $1 WHERE user_id = $2 RETURNING *',
      [data, userId]
    );

    // Invalidate cache
    profileCache.del(`profile:${userId}`);

    return result.rows[0];
  }
}

module.exports = UserProfile;
```

**Tests: `tests/models/userProfile.test.js`**
```javascript
const UserProfile = require('../../src/models/userProfile');
const db = require('../../src/db');

describe('UserProfile.findByUserId', () => {
  it('should return profile for valid user', async () => {
    const profile = await UserProfile.findByUserId(123);
    expect(profile).toBeDefined();
    expect(profile.user_id).toBe(123);
  });

  it('should return null for non-existent user', async () => {
    const profile = await UserProfile.findByUserId(999999);
    expect(profile).toBeNull();
  });

  it('should use cache on subsequent calls', async () => {
    const spy = jest.spyOn(db, 'query');

    await UserProfile.findByUserId(123); // First call - hits DB
    await UserProfile.findByUserId(123); // Second call - hits cache

    expect(spy).toHaveBeenCalledTimes(1);
  });

  it('should invalidate cache on update', async () => {
    await UserProfile.findByUserId(123); // Cache it
    await UserProfile.update(123, { name: 'Updated' });

    const spy = jest.spyOn(db, 'query');
    await UserProfile.findByUserId(123); // Should query DB again

    expect(spy).toHaveBeenCalled();
  });
});
```

**Pull Request Description:**
```markdown
# Fix: High latency in authentication API (DEV-XXX)

## Problem
Authentication API experiencing 3-5s latency after adding user profile data to login responses. Investigation revealed missing database index causing full table scans.

## Root Cause
- New query in `UserProfile.findByUserId` has no index on `user_profiles.user_id`
- Full table scan on every login
- Connection pool exhaustion under load

## Solution
1. **Database Index:** Add index on `user_profiles.user_id`
2. **Caching:** Add 5-minute TTL cache for user profiles
3. **Error Handling:** Gracefully handle missing profiles
4. **Tests:** Add unit tests for cache and error scenarios

## Performance Impact
- **Before:** 3-5s average response time
- **After (estimated):** <500ms response time
- **Cache hit rate:** Expected 80%+ (users login multiple times)

## Testing
- ✅ Unit tests pass
- ✅ Migration tested in local DB
- ✅ Load test shows 95% latency reduction
- ⏳ Pending: Staging deployment validation

## Rollout Plan
1. Deploy migration to staging
2. Monitor query performance (should be <50ms)
3. Deploy code changes
4. Monitor cache hit rate and response times
5. If successful after 24h, deploy to production

## Related Issues
- Resolves: DEV-XXX
- Related: DEV-89 (similar database performance issue)
```

#### 8.6 Create Pull Request (Optional)

**Prompt: Create PR in Bitbucket**
```
Using Bitbucket MCP, create a pull request:

Repository: user-auth-service
Source branch: fix/auth-latency (assume I've pushed the changes)
Target branch: main
Title: "Fix: High latency in authentication API (DEV-XXX)"
Description: [Use the PR description above]
Reviewers: [team-lead-username]
```

**Or share the solution:**

```
Using Atlassian MCP, add a comment to DEV-XXX:

"Code analysis complete. Root cause confirmed in commit a1b2c3d.

Proposed solution:
1. Add database index on user_profiles.user_id
2. Implement caching layer (5min TTL)
3. Add error handling for missing profiles

See detailed solution and PR: [Bitbucket PR URL or attach solution files]

Estimated fix time: <2 hours
Estimated performance improvement: 95% latency reduction (500ms response time)"
```

---

## Workshop Completion

### What You've Accomplished

✅ **Set up complete AI development environment**
- Amazon Q CLI with authentication
- Kiro IDE configured and running
- GitHub CLI and AWS CLI installed

✅ **Configured MCP integrations**
- Atlassian MCP (Jira/Confluence) with OAuth
- Bitbucket MCP with API token
- Automated installation script

✅ **Documented AWS infrastructure**
- Inventory of EC2, S3, RDS, Lambda resources
- Architecture diagram and security analysis
- Cost analysis with optimization recommendations

✅ **Created Confluence documentation**
- Professional architecture page with formatting
- Macros, tables, and visual enhancements
- Shared with team for review

✅ **Investigated Jira issue using AI**
- Found similar historical issues
- Performed root cause analysis using AWS CLI
- Identified database performance issue

✅ **Analyzed code in Bitbucket**
- Located problematic code changes
- Confirmed root cause in codebase
- Proposed complete solution with migration, code, and tests

✅ **Completed DevOps loop**
- Issue → Investigation → Code Analysis → Solution → Documentation

### Next Steps

**Continue Learning:**
1. Explore additional MCP servers (Memory, Playwright, Docker)
2. Create custom Amazon Q CLI agents for specialized tasks
3. Set up Kiro IDE specs for spec-driven development
4. Configure hooks for automated workflows

**Apply to Your Work:**
1. Document your production AWS environment
2. Integrate with your team's Jira workflow
3. Use AI assistance for code reviews
4. Automate repetitive DevOps tasks

**Share Knowledge:**
1. Present findings to your team
2. Create internal documentation based on this workshop
3. Set up MCP configurations for team members
4. Establish AI-assisted workflow standards

---

## Troubleshooting

### Authentication Issues

**AWS Builder ID login fails:**
- Verify email address is correct
- Check MFA device is working
- Try incognito browser window
- Clear browser cache and retry

**Atlassian OAuth not working:**
- Verify Atlassian account has workspace access
- Check firewall isn't blocking OAuth callback
- Try different browser
- Revoke and re-grant permissions

### MCP Connection Issues

**"MCP server not responding":**
```bash
# Test server manually
npx -y mcp-remote https://mcp.atlassian.com/v1/sse

# Check Node.js version
node --version  # Should be 18+

# Reinstall server
npm cache clean --force
npx -y @aashari/mcp-server-atlassian-bitbucket
```

**Environment variables not loading:**
```bash
# Verify variables are set
echo $ATLASSIAN_USER_EMAIL
echo $ATLASSIAN_API_TOKEN

# Re-source profile
source ~/.bashrc  # or ~/.zshrc

# Restart terminal/IDE
```

### AWS CLI Issues

**SSO token expired:**
```bash
aws sso login --profile dev-readonly
```

**Permission denied errors:**
```bash
# Verify your permissions
aws iam get-user --profile dev-readonly

# Check role permissions
aws sts assume-role --role-arn <role-arn> --role-session-name test
```

### General Issues

**Command not found:**
- Verify tool is installed: `which q`, `which gh`, `which aws`
- Add to PATH or restart terminal
- Re-install tool if necessary

**Rate limiting:**
- Wait a few minutes and retry
- Check service status pages
- Reduce request frequency

---

## Additional Resources

### Official Documentation

**Amazon Q:**
- CLI Documentation: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line.html
- MCP Configuration: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/mcp-cli.html
- Authentication: https://docs.aws.amazon.com/signin/latest/userguide/sign-in-aws_builder_id.html

**Kiro IDE:**
- Official Website: https://kiro.dev/
- Documentation: https://kiro.dev/docs/
- MCP Integration: https://kiro.dev/docs/mcp/

**Atlassian:**
- MCP Documentation: https://developer.atlassian.com/platform/model-context-protocol/
- API Tokens: https://id.atlassian.com/manage-profile/security/api-tokens
- Jira API: https://developer.atlassian.com/cloud/jira/platform/rest/v3/

**Bitbucket:**
- MCP Server: https://github.com/aashari/mcp-server-atlassian-bitbucket
- API Documentation: https://developer.atlassian.com/cloud/bitbucket/rest/

### Workshop Materials

- **GitHub Repository:** https://github.com/[workshop-repo]
- **Configuration Examples:** Available in `/amazon-q-cli/mcp/`
- **Installation Scripts:** `/amazon-q-cli/mcp/install-mcp.sh`
- **Documentation Templates:** `/workshop/templates/`

### Community and Support

**Get Help:**
- Workshop Discord: [link]
- Stack Overflow: Tag `amazon-q`, `kiro-ide`, `mcp`
- AWS Forums: https://repost.aws/

**Share Feedback:**
- Workshop feedback form: [link]
- GitHub Issues: [workshop-repo]/issues

---

**Workshop Version:** 1.0
**Last Updated:** 2025-01-04
**Instructor Contact:** [contact-info]

---

## Appendix A: Quick Reference Commands

### Amazon Q CLI
```bash
q login                    # Authenticate
q chat                     # Start chat session
q doctor                   # Diagnose issues
q issue                    # Report bug
```

### AWS CLI
```bash
aws sso login --profile dev-readonly      # Login with SSO
aws s3 ls --profile dev-readonly          # List S3 buckets
aws ec2 describe-instances                # List EC2 instances
aws ce get-cost-and-usage                 # Get cost data
```

### GitHub CLI
```bash
gh auth login              # Authenticate
gh repo clone <repo>       # Clone repository
gh issue list              # List issues
```

### MCP Testing
```bash
npx -y mcp-remote https://mcp.atlassian.com/v1/sse    # Test Atlassian
npx -y @aashari/mcp-server-atlassian-bitbucket        # Test Bitbucket
```

---

## Appendix B: Configuration File Templates

### Amazon Q MCP Configuration
**Location:** `~/.aws/amazonq/mcp.json`

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

### Kiro MCP Configuration
**Location:** `~/.kiro/settings/mcp.json`

```json
{
  "mcpServers": {
    "atlassian": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.atlassian.com/v1/sse"],
      "transport": "stdio",
      "disabled": false
    },
    "bitbucket": {
      "command": "npx",
      "args": ["-y", "@aashari/mcp-server-atlassian-bitbucket"],
      "transport": "stdio",
      "env": {
        "ATLASSIAN_USER_EMAIL": "${ATLASSIAN_USER_EMAIL}",
        "ATLASSIAN_API_TOKEN": "${ATLASSIAN_API_TOKEN}"
      },
      "disabled": false
    }
  }
}
```

### Environment Variables
**Location:** `~/.bashrc` or `~/.zshrc`

```bash
# AWS Configuration
export AWS_PROFILE=dev-readonly

# Atlassian Credentials
export ATLASSIAN_USER_EMAIL="your.email@company.com"
export ATLASSIAN_API_TOKEN="ATATT3xFfGF0..."

# Optional: AWS CLI defaults
export AWS_DEFAULT_REGION=us-east-1
export AWS_DEFAULT_OUTPUT=json
```

---

**End of Workshop Guide**
