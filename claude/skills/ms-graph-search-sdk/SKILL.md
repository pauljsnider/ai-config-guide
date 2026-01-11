---
name: ms-graph-search-sdk
description: Search OneDrive, Teams, and Outlook using Microsoft Graph API with Python. Use when asked to find files, emails, messages, or documents in Microsoft 365 services. This is the preferred method for quick searches.
allowed-tools: [Bash]
---

# Microsoft Graph Search SDK Skill

When asked to search OneDrive, Teams, Outlook, or other Microsoft 365 services, use Python with the requests library for clean, simple API calls.

## 🔒 Security-First Design

**ONE CRITICAL RULE: Claude NEVER displays your token back to you.**

Simple workflow:
1. Claude opens Graph Explorer for you
2. You paste token in chat (it's fine)
3. Claude uses it but **never echoes it back**

---

## Step 1: Install Dependencies (Auto)

Check and install if needed:
```bash
pip3 install -q requests
```

---

## Step 2: Get Access Token

**Simple 3-Step Process:**

1. **Claude opens Graph Explorer** (automatically)
   ```bash
   # macOS: open "https://developer.microsoft.com/en-us/graph/graph-explorer"
   # Linux: xdg-open "https://developer.microsoft.com/en-us/graph/graph-explorer"
   # Windows: start "https://developer.microsoft.com/en-us/graph/graph-explorer"
   ```

2. **You get token from browser:**
   - Sign in with Microsoft account
   - Click "Access token" tab
   - Copy the token
   - **Paste it in chat** (it's fine to paste)

3. **Claude uses it silently:**
   - Stores in Python variable
   - Makes API calls
   - **Never displays it back**

**Token Notes:**
- Expires in 69-90 minutes, just get a new one when needed
- Claude will store it for the session

---

## Step 3: Search Using Python

### Simple Token Usage

```python
#!/usr/bin/env python3
import requests

# User pastes token in chat, Claude uses it
TOKEN = "user_provided_token_here"  # Claude replaces with actual token

# ✅ CORRECT: Use it silently
headers = {"Authorization": f"Bearer {TOKEN}"}
response = requests.get("https://graph.microsoft.com/v1.0/me", headers=headers)

# ❌ WRONG: NEVER display the token
# print(f"Using token: {TOKEN}")  # DON'T DO THIS
```

---

## Timezone Handling (Central Time)

**IMPORTANT:** Always convert dates/times to Central Time Zone for display.

```python
from datetime import datetime
from zoneinfo import ZoneInfo

def to_central_time(iso_datetime_str):
    """Convert ISO datetime string to Central Time"""
    if not iso_datetime_str or iso_datetime_str == 'Unknown':
        return 'Unknown'

    # Remove trailing zeros and parse
    dt_str = iso_datetime_str.rstrip('0').rstrip('.')

    # Parse the datetime (assume UTC if no timezone)
    if 'Z' in dt_str or '+' in dt_str or dt_str.endswith('-'):
        dt = datetime.fromisoformat(dt_str.replace('Z', '+00:00'))
    else:
        dt = datetime.fromisoformat(dt_str).replace(tzinfo=ZoneInfo('UTC'))

    # Convert to Central Time
    central = dt.astimezone(ZoneInfo('America/Chicago'))

    # Format nicely
    return central.strftime('%Y-%m-%d %I:%M %p CST')

# Example usage:
# start_time = to_central_time("2026-01-06T15:00:00.0000000")
# print(start_time)  # "2026-01-06 09:00 AM CST"
```

---

## Common Operations

All examples below assume:
```python
import os
import requests
from datetime import datetime
from zoneinfo import ZoneInfo

TOKEN = os.getenv('MS_GRAPH_TOKEN')
if not TOKEN:
    print("Error: MS_GRAPH_TOKEN not set", file=sys.stderr)
    sys.exit(1)

HEADERS = {"Authorization": f"Bearer {TOKEN}"}
```

### Get Current User

```python
response = requests.get("https://graph.microsoft.com/v1.0/me", headers=HEADERS)
user = response.json()
print(f"Name: {user.get('displayName')}")
print(f"Email: {user.get('userPrincipalName')}")
```

### Search OneDrive Files

```python
query = "report"
url = f"https://graph.microsoft.com/v1.0/me/drive/root/search(q='{query}')"
response = requests.get(url, headers=HEADERS)
files = response.json().get('value', [])

for file in files[:10]:
    print(f"📄 {file['name']}")
    print(f"   Modified: {to_central_time(file.get('lastModifiedDateTime', 'Unknown'))}")
    print(f"   Size: {file.get('size', 0):,} bytes")
```

### List OneDrive Files

```python
response = requests.get("https://graph.microsoft.com/v1.0/me/drive/root/children", headers=HEADERS)
files = response.json().get('value', [])

for file in files[:10]:
    print(f"📁 {file['name']}")
    print(f"   Type: {file.get('@microsoft.graph.downloadUrl', 'Folder' if 'folder' in file else 'File')}")
```

### Files Shared With Me

```python
response = requests.get("https://graph.microsoft.com/v1.0/me/drive/sharedWithMe", headers=HEADERS)
files = response.json().get('value', [])

for item in files[:10]:
    remote_item = item.get('remoteItem', {})
    shared_by = item.get('shared', {}).get('sharedBy', {}).get('user', {}).get('displayName', 'Unknown')
    print(f"📤 {remote_item.get('name', 'Unknown')}")
    print(f"   Shared by: {shared_by}")
```

### Search Emails

```python
query = "budget"
url = f"https://graph.microsoft.com/v1.0/me/messages?$search=\"{query}\"&$top=10"
response = requests.get(url, headers=HEADERS)
messages = response.json().get('value', [])

for msg in messages:
    print(f"✉️  {msg.get('subject', 'No subject')}")
    sender = msg.get('from', {}).get('emailAddress', {}).get('address', 'Unknown')
    print(f"   From: {sender}")
    print(f"   Date: {to_central_time(msg.get('receivedDateTime', 'Unknown'))}")
```

### List Inbox Messages

```python
url = "https://graph.microsoft.com/v1.0/me/messages?$top=10&$select=subject,from,receivedDateTime"
response = requests.get(url, headers=HEADERS)
messages = response.json().get('value', [])

for msg in messages:
    sender = msg.get('from', {}).get('emailAddress', {}).get('name', 'Unknown')
    print(f"📧 {msg.get('subject', 'No subject')}")
    print(f"   From: {sender}")
    print(f"   Date: {to_central_time(msg.get('receivedDateTime', 'Unknown'))}")
```

### List Teams

```python
response = requests.get("https://graph.microsoft.com/v1.0/me/joinedTeams", headers=HEADERS)
teams = response.json().get('value', [])

for team in teams:
    print(f"👥 {team.get('displayName', 'Unknown')}")
    print(f"   Description: {team.get('description', 'No description')}")
```

### List Calendar Events

```python
response = requests.get("https://graph.microsoft.com/v1.0/me/calendar/events?$top=10", headers=HEADERS)
events = response.json().get('value', [])

for event in events:
    # Get start/end times and convert to Central Time
    start = event.get('start', {}).get('dateTime', 'Unknown')
    end = event.get('end', {}).get('dateTime', 'Unknown')

    print(f"📅 {event.get('subject', 'No subject')}")
    print(f"   Start: {to_central_time(start)}")
    print(f"   End: {to_central_time(end)}")
    print(f"   Location: {event.get('location', {}).get('displayName', 'No location')}")
```

### Unified Search (Multiple Services)

```python
search_body = {
    "requests": [{
        "entityTypes": ["driveItem", "message"],
        "query": {"queryString": "quarterly report"},
        "from": 0,
        "size": 25
    }]
}

response = requests.post(
    "https://graph.microsoft.com/v1.0/search/query",
    headers={**HEADERS, "Content-Type": "application/json"},
    json=search_body
)
results = response.json()

# Parse results
for request_result in results.get('value', []):
    for hit_container in request_result.get('hitsContainers', []):
        for hit in hit_container.get('hits', []):
            resource = hit.get('resource', {})
            print(f"🔍 {resource.get('name') or resource.get('subject', 'Unknown')}")
            print(f"   Type: {resource.get('@odata.type', 'Unknown')}")
```

---

## Error Handling Template

```python
def handle_response(response, reopen_browser=False):
    """Handle API response with proper error messages"""
    if response.status_code == 401:
        print("❌ Token expired or invalid", file=sys.stderr)
        print("", file=sys.stderr)
        print("To get a new token:", file=sys.stderr)
        print("1. Open https://developer.microsoft.com/en-us/graph/graph-explorer", file=sys.stderr)
        print("2. Sign in and click 'Access token' tab", file=sys.stderr)
        print("3. Run: export MS_GRAPH_TOKEN=\"<your-token>\"", file=sys.stderr)

        if reopen_browser:
            import platform
            import subprocess
            system = platform.system()
            url = "https://developer.microsoft.com/en-us/graph/graph-explorer"

            try:
                if system == "Darwin":
                    subprocess.run(["open", url])
                elif system == "Linux":
                    subprocess.run(["xdg-open", url])
                elif system == "Windows":
                    subprocess.run(["start", url], shell=True)
                print("\n✅ Opened Graph Explorer in browser", file=sys.stderr)
            except Exception as e:
                print(f"\n⚠️  Could not open browser: {e}", file=sys.stderr)

        return None

    elif response.status_code == 403:
        print("❌ Permission denied. Grant consent in Graph Explorer.", file=sys.stderr)
        return None

    elif response.status_code == 429:
        print("❌ Rate limited. Wait a moment and try again.", file=sys.stderr)
        return None

    elif response.status_code == 200:
        return response.json()

    else:
        print(f"❌ Error {response.status_code}: {response.text}", file=sys.stderr)
        return None

# Usage:
# data = handle_response(response, reopen_browser=True)
# if data:
#     # Process data
```

---

## Complete Example Script Template

```python
#!/usr/bin/env python3
"""
Microsoft Graph Search - Simple & Secure

Searches OneDrive and Outlook using Microsoft Graph API.

Security:
    - User pastes token in chat (it's fine)
    - Claude uses it but never displays it back
"""

import requests
from datetime import datetime
from zoneinfo import ZoneInfo

# User pastes token in chat, Claude replaces this
TOKEN = "user_provided_token_here"

def to_central_time(iso_datetime_str):
    """Convert ISO datetime string to Central Time"""
    if not iso_datetime_str or iso_datetime_str == 'Unknown':
        return 'Unknown'

    dt_str = iso_datetime_str.rstrip('0').rstrip('.')

    if 'Z' in dt_str or '+' in dt_str or dt_str.endswith('-'):
        dt = datetime.fromisoformat(dt_str.replace('Z', '+00:00'))
    else:
        dt = datetime.fromisoformat(dt_str).replace(tzinfo=ZoneInfo('UTC'))

    central = dt.astimezone(ZoneInfo('America/Chicago'))
    return central.strftime('%Y-%m-%d %I:%M %p CST')

def handle_response(response):
    """Handle API response with error checking"""
    if response.status_code == 401:
        print("❌ Token expired. Get new token from Graph Explorer.")
        return None
    elif response.status_code == 403:
        print("❌ Permission denied.")
        return None
    elif response.status_code == 429:
        print("❌ Rate limited. Wait and retry.")
        return None
    elif response.status_code == 200:
        return response.json()
    else:
        print(f"❌ Error {response.status_code}: {response.text}")
        return None

def search_onedrive(query):
    """Search OneDrive files"""
    headers = {"Authorization": f"Bearer {TOKEN}"}
    url = f"https://graph.microsoft.com/v1.0/me/drive/root/search(q='{query}')"
    response = requests.get(url, headers=headers)
    data = handle_response(response)

    if data:
        files = data.get('value', [])
        print(f"\n📁 Found {len(files)} files matching '{query}':\n")
        for i, file in enumerate(files[:10], 1):
            print(f"{i}. {file['name']}")
            print(f"   Modified: {to_central_time(file.get('lastModifiedDateTime', 'Unknown'))}")
            print(f"   Size: {file.get('size', 0):,} bytes\n")

def search_emails(query):
    """Search Outlook emails"""
    headers = {"Authorization": f"Bearer {TOKEN}"}
    url = f"https://graph.microsoft.com/v1.0/me/messages?$search=\"{query}\"&$top=10"
    response = requests.get(url, headers=headers)
    data = handle_response(response)

    if data:
        messages = data.get('value', [])
        print(f"\n✉️  Found {len(messages)} emails matching '{query}':\n")
        for i, msg in enumerate(messages, 1):
            sender = msg.get('from', {}).get('emailAddress', {}).get('address', 'Unknown')
            print(f"{i}. {msg.get('subject', 'No subject')}")
            print(f"   From: {sender}")
            print(f"   Date: {to_central_time(msg.get('receivedDateTime', 'Unknown'))}\n")

# Run searches
search_onedrive("report")
search_emails("budget")
```

---

## Output Format

Present results clearly with dates/times in Central Time:

```
📁 OneDrive Search Results for "quarterly report"

Found 3 files:

1. Q4-2024-Report.xlsx
   Modified: 2024-12-15 04:30 AM CST
   Size: 45,231 bytes
   Path: /Documents/Reports

2. Quarterly-Summary.docx
   Modified: 2024-12-10 08:22 AM CST
   Size: 23,450 bytes
   Path: /Documents/Reports

3. Q4-Presentation.pptx
   Modified: 2024-12-05 03:15 AM CST
   Size: 1,234,567 bytes
   Path: /Shared/Team
```

---

## Common Queries & Workflows

### "Find my Excel files in OneDrive"

1. Check if `MS_GRAPH_TOKEN` is set
2. If not, open Graph Explorer and instruct user
3. Run search: `q='.xlsx'`
4. Display results with file names, dates, sizes

### "Search my emails for X"

1. Check token (reuse if already set)
2. Use `$search="X"` parameter
3. Display subject, sender, date in Central Time

### "Show files shared with me"

1. Use `/me/drive/sharedWithMe` endpoint
2. Parse remoteItem for file details
3. Show who shared each file

### "What meetings do I have today?"

1. Use `/me/calendar/events`
2. Filter by date
3. Convert times to Central Time using `to_central_time()`
4. Display subject, time, location

---

## Best Practices

### Security
- **Always** read token from `MS_GRAPH_TOKEN` environment variable
- **Never** pass token as command-line argument
- **Never** print token to stdout or stderr
- **Never** log token to files
- Store token in memory only during script execution

### API Usage
- Use `$top` parameter to limit results (avoid large responses)
- Use `$select` to request only needed fields
- Handle pagination for large result sets
- Implement exponential backoff for rate limits

### Time Handling
- **Always** convert dates/times to Central Time for display
- Use the `to_central_time()` function consistently
- Handle missing or invalid datetime strings gracefully

### Error Handling
- Check response status codes before parsing JSON
- Provide helpful error messages to stderr
- Re-open browser on 401 errors (expired token)
- Exit with non-zero code on errors

### Code Quality
- Use descriptive function names
- Add docstrings to functions
- Pretty-print JSON with `json.dumps(data, indent=2)` when debugging
- Use f-strings for formatting

---

## Platform Detection for Browser Opening

```python
import platform
import subprocess

def open_graph_explorer():
    """Open Graph Explorer in default browser"""
    system = platform.system()
    url = "https://developer.microsoft.com/en-us/graph/graph-explorer"

    try:
        if system == "Darwin":  # macOS
            subprocess.run(["open", url])
        elif system == "Linux":
            subprocess.run(["xdg-open", url])
        elif system == "Windows":
            subprocess.run(["start", url], shell=True)
        print("✅ Opened Graph Explorer in browser")
    except Exception as e:
        print(f"⚠️  Could not open browser: {e}", file=sys.stderr)
        print(f"Please open manually: {url}", file=sys.stderr)
```

---

## Advantages Over curl

- **Cleaner code** - No complex escaping or quoting
- **Better error handling** - Native Python exceptions
- **Easier parsing** - Direct dict access vs JSON strings
- **Token security** - Claude never displays it back
- **Type safety** - Python type hints and linting
- **Maintainability** - Easier to read and modify

---

## Troubleshooting

### Token Expired

```
❌ Token expired or invalid
```

**Solution:**
- Get new token from Graph Explorer (token expires after 69-90 minutes)
- Paste new token in chat

### Permission Denied

```
❌ Permission denied
```

**Solution:**
- In Graph Explorer, grant consent for required scopes
- Check [Permissions Reference](https://learn.microsoft.com/en-us/graph/permissions-reference)

### Module Not Found

```
ModuleNotFoundError: No module named 'requests'
```

**Solution:**
```bash
pip3 install requests
```

### Timezone Issues

```
ZoneInfoNotFoundError: 'America/Chicago'
```

**Solution:**
```bash
# Install tzdata
pip3 install tzdata
```

---

## Resources

### Microsoft Graph

| Resource | Link |
|----------|------|
| Graph Explorer | https://developer.microsoft.com/en-us/graph/graph-explorer |
| API Reference | https://learn.microsoft.com/en-us/graph/api/overview |
| Permissions Reference | https://learn.microsoft.com/en-us/graph/permissions-reference |
| Quick Start Guide | https://learn.microsoft.com/en-us/graph/tutorials |

### Python Libraries

- **requests**: https://requests.readthedocs.io/
- **datetime**: https://docs.python.org/3/library/datetime.html
- **zoneinfo**: https://docs.python.org/3/library/zoneinfo.html

---

## Important Notes

- **Simple approach** - Uses requests library for direct API calls
- **Token flow** - You paste token in chat (it's fine), Claude never displays it back
- **Screen protection** - Token never echoed or printed
- **Token reuse** - Claude stores it in memory for the session
- **Auto-install** - Claude Code can install requests automatically
- **Graph Explorer** - Uses Graph Explorer for token generation
- **Central Time** - All dates/times converted to America/Chicago timezone

---

**Last Updated:** 2026-01-11

**Security Notice:** The ONE rule: Claude never displays your token back to you. Paste it in chat, Claude uses it silently.
