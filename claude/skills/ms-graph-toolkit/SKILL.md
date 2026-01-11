---
name: ms-graph-toolkit
description: Microsoft Graph API toolkit for Calendar, Teams, Outlook, OneDrive, and organizational intelligence. Use when asked to schedule meetings, find availability, search emails/files, analyze collaboration patterns, or interact with Microsoft 365 services.
allowed-tools: [Bash, Read, Write, Edit]
---

# Microsoft Graph Toolkit

A self-evolving toolkit for Microsoft Graph API operations. This skill enables you to interact with Microsoft 365 services including Calendar, Teams, Outlook, OneDrive, SharePoint, and organizational data.

## Core Capabilities

This skill can help with:

### 📅 Calendar & Meetings
1. **Pre-meeting intel** - Auto-brief on attendees, past conversations, shared files
2. **Find availability** - Search for mutual free time across participants
3. **Schedule meetings** - Book events with Teams links, travel time, time zones
4. **Meeting hygiene audit** - Find no-agenda meetings, burnout patterns, time waste
5. **Auto-decline focus time** - Protect deep work blocks, suggest alternatives

### 👥 People & Organization
6. **Find the expert** - Who in the company knows most about topic X?
7. **Meeting pattern org chart** - Map real influence vs official hierarchy
8. **Network recommendations** - Who should you meet based on collaboration patterns?

### 📧 Email & Communication
9. **Weekly digest** - Unread emails, @mentions, shared files, missed recordings
10. **Inbox sentiment analysis** - Gauge urgency and tone of communications

### 📁 Files & Knowledge
11. **Smart file search** - Find documents across OneDrive, SharePoint, Teams
12. **Forgotten file finder** - Locate files you created but never shared
13. **Resurrect dead projects** - Timeline of what happened and who was involved

### 🚀 Productivity & Automation
14. **Auto weekly status** - Generate "what I did" reports from calendar/tasks/files
15. **Smart travel mode** - OOO blocks, status updates, local colleague suggestions
16. **Meeting cost calculator** - Calculate time investment across attendees

### 🔧 Custom Operations
The skill builds new scripts on demand - just describe what you want!

---

## Prerequisites

### 1. Install Microsoft Graph SDK

**Python (recommended):**
```bash
pip install msgraph-sdk
pip install azure-identity
```

**JavaScript/TypeScript:**
```bash
npm install @microsoft/microsoft-graph-client
npm install @azure/identity
```

**PowerShell:**
```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

### 2. Get an Access Token

**Simple 3-Step Process:**

1. **Claude opens Graph Explorer** (automatically)
2. **You copy and paste token in chat** (it's fine to paste it)
3. **Claude uses it but NEVER displays it back** (key security rule)

**Token Notes:**
- Tokens are portable - work for whoever's token is used
- The `/me` endpoint automatically resolves to the token owner
- Tokens expire after ~1 hour, just get a new one from Graph Explorer
- Claude will store it in memory for the session

---

## Security & Token Handling

### 🔒 ONE CRITICAL RULE

**Claude MUST NEVER display the token back to you.**

When you paste your token, Claude will:
- ✅ Store it in a Python variable
- ✅ Use it for API calls
- ❌ **NEVER echo or print it back**

That's it. Keep it simple.

### Example: Secure Token Usage

```python
#!/usr/bin/env python3
import requests

# User provides token (pasted in chat)
TOKEN = "user_provided_token_here"  # Claude replaces with actual token

# ✅ CORRECT: Use it silently
headers = {"Authorization": f"Bearer {TOKEN}"}
response = requests.get("https://graph.microsoft.com/v1.0/me", headers=headers)

# ❌ WRONG: NEVER display the token
# print(f"Using token: {TOKEN}")  # DON'T DO THIS
```

---

## Usage Patterns

### Pattern 1: Direct API Calls

For one-off operations, make direct API calls:

```bash
# Get my profile
curl -H "Authorization: Bearer $MS_GRAPH_TOKEN" \
  https://graph.microsoft.com/v1.0/me

# List calendar events
curl -H "Authorization: Bearer $MS_GRAPH_TOKEN" \
  "https://graph.microsoft.com/v1.0/me/events?\$top=10"
```

### Pattern 2: Generate Scripts On-Demand

For complex or repeated operations, create Python scripts:

**User Request:**
> "Find my availability for meetings next week with alice@company.com"

**Claude Response:**
1. Creates `scripts/calendar/find_availability.py`
2. Runs the script with proper token handling
3. Presents results to user
4. Saves script for future use

### Pattern 3: Build Composite Workflows

Chain multiple operations:

**User Request:**
> "Schedule a meeting with the Azure expert for a 1:1 next week"

**Claude Workflow:**
1. Search org directory for "Azure" expertise
2. Find mutual availability
3. Present options to user
4. Book meeting with Teams link
5. Send confirmation

---

## Common Graph API Endpoints

### User & Organization

| Endpoint | Purpose |
|----------|---------|
| `/me` | Current user profile |
| `/me/manager` | User's manager |
| `/me/directReports` | User's direct reports |
| `/users` | Search organization directory |
| `/users/{id}/people` | Relevant people for a user |

### Calendar

| Endpoint | Purpose |
|----------|---------|
| `/me/events` | List calendar events |
| `/me/calendar/events` | Create/update events |
| `/me/findMeetingTimes` | Find availability |
| `/me/calendar/calendarView` | Events in date range |
| `/me/calendars` | List all calendars |

### Mail

| Endpoint | Purpose |
|----------|---------|
| `/me/messages` | List emails |
| `/me/mailFolders` | Mail folders (Inbox, Sent, etc.) |
| `/me/messages/{id}` | Get specific email |
| `/me/sendMail` | Send email |
| `/me/messages?$search="query"` | Search emails |

### OneDrive & Files

| Endpoint | Purpose |
|----------|---------|
| `/me/drive/root/children` | List files in root |
| `/me/drive/root/search(q='query')` | Search files |
| `/me/drive/recent` | Recently accessed files |
| `/me/drive/sharedWithMe` | Files shared with user |
| `/me/drive/items/{id}` | Get file metadata |

### Teams

| Endpoint | Purpose |
|----------|---------|
| `/me/joinedTeams` | Teams user is member of |
| `/teams/{id}/channels` | Channels in a team |
| `/teams/{id}/channels/{id}/messages` | Channel messages |
| `/me/chats` | User's chats |
| `/chats/{id}/messages` | Messages in a chat |

### OneNote

| Endpoint | Purpose |
|----------|---------|
| `/me/onenote/notebooks` | List notebooks |
| `/me/onenote/sections` | List sections |
| `/me/onenote/pages` | List pages |
| `/me/onenote/pages/{id}/content` | Page content |
| `/me/onenote/pages?$search="query"` | Search notes |

---

## Script Development Guidelines

### When to Create Scripts

Create a new script when:
- A task is requested 2+ times
- The operation is complex (multiple API calls)
- The user wants to save the capability for later
- Error handling or data processing is needed

### Script Structure

```python
#!/usr/bin/env python3
"""
Script description and usage examples.

Usage:
    python script.py --arg1 value1 --arg2 value2

Environment Variables:
    MS_GRAPH_TOKEN - Microsoft Graph access token (required)
"""

import os
import sys
import argparse
import json
import requests

def main():
    # 1. Read token from environment
    token = os.getenv('MS_GRAPH_TOKEN')
    if not token:
        print("Error: MS_GRAPH_TOKEN not set", file=sys.stderr)
        print("Get token from: https://developer.microsoft.com/en-us/graph/graph-explorer", file=sys.stderr)
        sys.exit(1)

    # 2. Parse arguments
    parser = argparse.ArgumentParser(description='Script description')
    parser.add_argument('--arg1', required=True, help='Description')
    parser.add_argument('--json', action='store_true', help='Output as JSON')
    args = parser.parse_args()

    # 3. Make API request
    headers = {'Authorization': f'Bearer {token}'}
    response = requests.get('https://graph.microsoft.com/v1.0/me', headers=headers)

    # 4. Handle errors
    if response.status_code != 200:
        print(f"Error {response.status_code}: {response.text}", file=sys.stderr)
        sys.exit(1)

    # 5. Process and output results
    data = response.json()

    if args.json:
        print(json.dumps(data, indent=2))
    else:
        # Human-readable output
        print(f"Name: {data.get('displayName')}")
        print(f"Email: {data.get('mail')}")

    sys.exit(0)

if __name__ == '__main__':
    main()
```

### Script Standards

- **Shebang line**: `#!/usr/bin/env python3` or `#!/bin/bash`
- **Docstring**: Include usage examples
- **Token handling**: Always from `MS_GRAPH_TOKEN` env var
- **Error messages**: Print to stderr
- **Exit codes**: 0 = success, non-zero = failure
- **JSON output**: Support `--json` flag for programmatic use
- **Help text**: Use argparse with clear descriptions
- **Never log tokens**: No token in logs, stdout, or stderr

### Directory Organization

```
scripts/
├── calendar/           # Calendar and scheduling
│   ├── find_availability.py
│   ├── book_meeting.py
│   └── list_events.py
├── people/             # User and org directory
│   ├── find_expert.py
│   ├── search_users.py
│   └── org_chart.py
├── mail/               # Email operations
│   ├── search_emails.py
│   ├── send_email.py
│   └── weekly_digest.py
├── files/              # OneDrive and SharePoint
│   ├── search_files.py
│   ├── list_files.py
│   └── recent_files.py
├── teams/              # Teams operations
│   ├── list_teams.py
│   ├── send_message.py
│   └── channel_activity.py
└── analytics/          # Advanced analytics
    ├── collaboration_graph.py
    ├── meeting_patterns.py
    └── time_analysis.py
```

---

## Example Workflows

### Schedule a Meeting

**User:** "Schedule a 30-minute meeting with alice@company.com and bob@company.com next Tuesday"

**Claude Workflow:**
1. Find user emails if needed (search directory)
2. Find availability for all participants
3. Present 3-5 time options to user
4. User selects preferred time
5. Book meeting with Teams link
6. Confirm booking with event details

### Weekly Status Report

**User:** "Generate my weekly status report"

**Claude Workflow:**
1. Get calendar events from past week
2. List sent emails and Teams messages
3. Retrieve modified OneDrive files
4. Summarize completed tasks
5. Format as status update
6. Present to user for review

### Find the Expert

**User:** "Who knows the most about Kubernetes in our company?"

**Claude Workflow:**
1. Search emails for "Kubernetes" mentions
2. Analyze Teams channel participation
3. Find OneNote pages with Kubernetes content
4. Check calendar for related meetings
5. Rank users by engagement signals
6. Present top experts with context

### Pre-Meeting Intel

**User:** "Brief me on my 2pm meeting"

**Claude Workflow:**
1. Get upcoming meeting details
2. Find attendee profiles and roles
3. Search past emails with attendees
4. Find shared documents
5. Identify previous meeting notes
6. Summarize key context

---

## Advanced Features

### Query Parameters

Common OData query parameters:

- `$select` - Choose specific fields: `?$select=displayName,mail`
- `$filter` - Filter results: `?$filter=startsWith(displayName,'A')`
- `$orderby` - Sort results: `?$orderby=displayName`
- `$top` - Limit results: `?$top=10`
- `$skip` - Skip results: `?$skip=20`
- `$search` - Full-text search: `?$search="project alpha"`
- `$expand` - Include related data: `?$expand=manager`
- `$count` - Include total count: `?$count=true`

### Batch Requests

Combine multiple requests:

```json
{
  "requests": [
    {
      "id": "1",
      "method": "GET",
      "url": "/me"
    },
    {
      "id": "2",
      "method": "GET",
      "url": "/me/events?$top=5"
    }
  ]
}
```

POST to: `https://graph.microsoft.com/v1.0/$batch`

### Pagination

Handle large result sets:

```python
url = "https://graph.microsoft.com/v1.0/me/messages"
all_messages = []

while url:
    response = requests.get(url, headers=headers).json()
    all_messages.extend(response.get('value', []))
    url = response.get('@odata.nextLink')  # Next page URL
```

---

## Troubleshooting

### Token Expired

```
Error 401: InvalidAuthenticationToken
```

**Solution:** Get a new token from Graph Explorer and update `MS_GRAPH_TOKEN`

### Insufficient Permissions

```
Error 403: Forbidden
```

**Solution:**
- In Graph Explorer, grant consent for required scopes
- Check [Permissions Reference](https://learn.microsoft.com/en-us/graph/permissions-reference)
- For app registration, add required API permissions in Azure Portal

### Rate Limiting

```
Error 429: Too Many Requests
```

**Solution:**
- Implement exponential backoff
- Use batch requests to reduce calls
- Cache results when appropriate

### No Results Found

```
{
  "value": []
}
```

**Solutions:**
- Verify query syntax
- Check user has access to requested data
- Try broader search terms
- Confirm data exists (e.g., user has calendar events)

---

## Self-Evolution Guidelines

**Claude: You are encouraged to evolve this toolkit.**

### When to Modify Scripts

- **Fix bugs** discovered during use
- **Add options** when use cases need new functionality
- **Improve output** to be more useful or parseable
- **Handle edge cases** found during real usage
- **Optimize performance** for slow operations

### When to Create New Scripts

- User requests functionality not yet covered
- A task is repeated 2+ times
- A workflow would benefit from automation
- New Microsoft Graph endpoint is needed

### How to Evolve

1. **Read existing patterns** - Follow established conventions
2. **Maintain compatibility** - Don't break existing scripts
3. **Document changes** - Update this SKILL.md with new capabilities
4. **Test thoroughly** - Verify scripts work before confirming
5. **Commit improvements** - Save useful scripts for future use

---

## Resources

### Microsoft Graph

| Resource | Link |
|----------|------|
| Graph Explorer | https://developer.microsoft.com/en-us/graph/graph-explorer |
| API Reference | https://learn.microsoft.com/en-us/graph/api/overview |
| Permissions Reference | https://learn.microsoft.com/en-us/graph/permissions-reference |
| Quick Start Guide | https://learn.microsoft.com/en-us/graph/tutorials |

### Authentication & Security

- **OAuth 2.0 Flow**: https://learn.microsoft.com/en-us/graph/auth/
- **App Registration**: https://learn.microsoft.com/en-us/graph/auth-register-app-v2
- **Permissions**: https://learn.microsoft.com/en-us/graph/permissions-reference
- **Best Practices**: https://learn.microsoft.com/en-us/graph/best-practices-concept

### SDKs

- **Python SDK**: https://github.com/microsoftgraph/msgraph-sdk-python
- **JavaScript SDK**: https://github.com/microsoftgraph/msgraph-sdk-javascript
- **PowerShell SDK**: https://learn.microsoft.com/en-us/powershell/microsoftgraph/

### Examples & Community

- **Graph Samples**: https://github.com/microsoftgraph/msgraph-samples
- **Community Calls**: https://aka.ms/m365pnp
- **Stack Overflow**: [microsoft-graph] tag

---

## Quick Reference

### Common Operations

```bash
# Get user profile
curl -H "Authorization: Bearer $MS_GRAPH_TOKEN" \
  https://graph.microsoft.com/v1.0/me

# List calendar events (next 7 days)
curl -H "Authorization: Bearer $MS_GRAPH_TOKEN" \
  "https://graph.microsoft.com/v1.0/me/calendarView?startDateTime=$(date -u +%Y-%m-%dT%H:%M:%S)&endDateTime=$(date -u -d '+7 days' +%Y-%m-%dT%H:%M:%S)"

# Search emails
curl -H "Authorization: Bearer $MS_GRAPH_TOKEN" \
  "https://graph.microsoft.com/v1.0/me/messages?\$search=\"project alpha\""

# Find availability
curl -H "Authorization: Bearer $MS_GRAPH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"attendees":[{"emailAddress":{"address":"alice@company.com"}}],"timeConstraint":{"timeslots":[{"start":{"dateTime":"2026-01-13T09:00:00","timeZone":"UTC"},"end":{"dateTime":"2026-01-17T17:00:00","timeZone":"UTC"}}]}}' \
  https://graph.microsoft.com/v1.0/me/findMeetingTimes

# Search users
curl -H "Authorization: Bearer $MS_GRAPH_TOKEN" \
  "https://graph.microsoft.com/v1.0/users?\$filter=startsWith(displayName,'Alice')"

# List Teams
curl -H "Authorization: Bearer $MS_GRAPH_TOKEN" \
  https://graph.microsoft.com/v1.0/me/joinedTeams
```

### HTTP Methods

- **GET** - Retrieve data
- **POST** - Create new resource
- **PATCH** - Update existing resource (partial)
- **PUT** - Replace existing resource (full)
- **DELETE** - Remove resource

### Common Headers

```bash
Authorization: Bearer {token}
Content-Type: application/json
Prefer: outlook.timezone="America/Chicago"
ConsistencyLevel: eventual  # For advanced queries
```

---

**Last Updated:** 2026-01-11

**Note:** This skill evolves based on usage. Scripts and capabilities are created on-demand. Always verify token security and permissions before running operations.
