---
name: ms-graph-search
description: Search OneDrive, Teams, and Outlook using Microsoft Graph API. Use when asked to find files, emails, messages, or documents in Microsoft 365 services.
allowed-tools: [Bash, WebFetch]
---

# Microsoft Graph Search Skill

When asked to search OneDrive, Teams, Outlook, or other Microsoft 365 services, use curl commands to interact with Microsoft Graph API.

## 🔒 Security-First Design

**ONE CRITICAL RULE: Claude NEVER displays your token back to you.**

Simple workflow:
1. Claude opens Graph Explorer for you
2. You paste token in chat (it's fine)
3. Claude uses it in curl commands but **never echoes it back**

---

## Step 1: Get Access Token

**Simple 3-Step Process:**

1. **Claude opens Graph Explorer** (automatically)
   ```bash
   # macOS: open "https://developer.microsoft.com/en-us/graph/graph-explorer"
   # Linux: xdg-open "https://developer.microsoft.com/en-us/graph/graph-explorer"
   # Windows: start "https://developer.microsoft.com/en-us/graph/graph-explorer"
   ```

2. **You get token from browser:**
   - Sign in with your Microsoft account
   - Click "Access token" tab (or profile icon)
   - Copy the access token
   - **Paste it in chat** (it's fine to paste)

3. **Claude uses it silently:**
   - Replaces `TOKEN` in curl commands
   - Makes API calls
   - **Never displays it back**

**Token Notes:**
- Expires in ~1 hour, just get a new one when needed
- Claude will store it for the session

---

## Step 2: Search Using Graph API

Once you have the token, use these endpoints with curl:

### Unified Search (Recommended)

Search across multiple services at once:

```bash
curl -X POST 'https://graph.microsoft.com/v1.0/search/query' \
  -H 'Authorization: Bearer TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "requests": [
      {
        "entityTypes": ["driveItem", "message", "chatMessage"],
        "query": {
          "queryString": "search terms here"
        },
        "from": 0,
        "size": 25
      }
    ]
  }'
```

**Entity Types:**
- `driveItem` - OneDrive and SharePoint files
- `message` - Outlook emails
- `chatMessage` - Teams messages
- `event` - Calendar events
- `person` - People/contacts
- `list` - SharePoint lists
- `listItem` - SharePoint list items
- `site` - SharePoint sites

### OneDrive & SharePoint Files

**Search files:**
```bash
curl 'https://graph.microsoft.com/v1.0/me/drive/root/search(q='"'"'search terms'"'"')' \
  -H 'Authorization: Bearer TOKEN'
```

**List files in OneDrive root:**
```bash
curl 'https://graph.microsoft.com/v1.0/me/drive/root/children' \
  -H 'Authorization: Bearer TOKEN'
```

**Files shared with me:**
```bash
curl 'https://graph.microsoft.com/v1.0/me/drive/sharedWithMe' \
  -H 'Authorization: Bearer TOKEN'
```

**Recent files:**
```bash
curl 'https://graph.microsoft.com/v1.0/me/drive/recent' \
  -H 'Authorization: Bearer TOKEN'
```

### Outlook Emails

**Search emails:**
```bash
curl 'https://graph.microsoft.com/v1.0/me/messages?$search="search terms"' \
  -H 'Authorization: Bearer TOKEN'
```

**List inbox emails (top 10):**
```bash
curl 'https://graph.microsoft.com/v1.0/me/messages?$top=10&$select=subject,from,receivedDateTime' \
  -H 'Authorization: Bearer TOKEN'
```

**Filter by sender:**
```bash
curl 'https://graph.microsoft.com/v1.0/me/messages?$filter=from/emailAddress/address eq '"'"'sender@example.com'"'"'' \
  -H 'Authorization: Bearer TOKEN'
```

### Microsoft Teams

**List my teams:**
```bash
curl 'https://graph.microsoft.com/v1.0/me/joinedTeams' \
  -H 'Authorization: Bearer TOKEN'
```

**Get team channels:**
```bash
curl 'https://graph.microsoft.com/v1.0/teams/TEAM_ID/channels' \
  -H 'Authorization: Bearer TOKEN'
```

**Get channel messages:**
```bash
curl 'https://graph.microsoft.com/v1.0/teams/TEAM_ID/channels/CHANNEL_ID/messages' \
  -H 'Authorization: Bearer TOKEN'
```

**My recent chats:**
```bash
curl 'https://graph.microsoft.com/v1.0/me/chats' \
  -H 'Authorization: Bearer TOKEN'
```

### Calendar

**List calendar events:**
```bash
curl 'https://graph.microsoft.com/v1.0/me/calendar/events' \
  -H 'Authorization: Bearer TOKEN'
```

**Search events:**
```bash
curl 'https://graph.microsoft.com/v1.0/me/events?$search="meeting topic"' \
  -H 'Authorization: Bearer TOKEN'
```

---

## Query Parameters

**Common query parameters:**
- `$search="keywords"` - Search with keywords
- `$filter=property eq 'value'` - Filter results
- `$select=field1,field2` - Select specific fields
- `$top=N` - Limit to N results
- `$orderby=field desc` - Sort results
- `$skip=N` - Skip N results (pagination)

---

## Example Searches

### "Find my recent Excel files"
```bash
curl 'https://graph.microsoft.com/v1.0/me/drive/root/search(q='"'"'.xlsx'"'"')' \
  -H 'Authorization: Bearer TOKEN'
```

### "Search emails from John about budget"
```bash
curl 'https://graph.microsoft.com/v1.0/me/messages?$search="from:john budget"' \
  -H 'Authorization: Bearer TOKEN'
```

### "Find files shared with me containing 'proposal'"
```bash
curl -X POST 'https://graph.microsoft.com/v1.0/search/query' \
  -H 'Authorization: Bearer TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "requests": [{
      "entityTypes": ["driveItem"],
      "query": {"queryString": "proposal"},
      "from": 0,
      "size": 25
    }]
  }'
```

### "Show my Teams messages mentioning 'release'"
```bash
curl -X POST 'https://graph.microsoft.com/v1.0/search/query' \
  -H 'Authorization: Bearer TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "requests": [{
      "entityTypes": ["chatMessage"],
      "query": {"queryString": "release"},
      "from": 0,
      "size": 25
    }]
  }'
```

---

## Response Handling

Graph API returns JSON. Use `jq` to parse if needed:

```bash
curl '...' | jq '.value[] | {name: .name, createdDateTime: .createdDateTime}'
```

---

## Error Handling

Common errors:
- **401 Unauthorized**: Token expired or invalid - get a new token
- **403 Forbidden**: Missing permissions - user needs to grant consent in Graph Explorer
- **429 Too Many Requests**: Rate limited - wait and retry
- **404 Not Found**: Resource doesn't exist
- **400 Bad Request**: Invalid query syntax - check the API docs

### When to Consult Documentation

Use WebFetch to look up documentation when:
1. **Error occurs** - Check error codes reference
2. **Unsure about endpoint** - Look up service-specific API docs
3. **Query not working** - Review query parameters guide
4. **Permission denied** - Check permissions reference
5. **New requirement** - Search for the specific API endpoint

**Example:**
```bash
# If you get a 403 error and aren't sure what permission is needed:
WebFetch "https://learn.microsoft.com/en-us/graph/permissions-reference"
  "What permissions are needed for searching OneDrive files?"

# If you need to find a specific endpoint:
WebFetch "https://learn.microsoft.com/en-us/graph/api/resources/driveitem"
  "How do I filter files by file type in OneDrive?"
```

---

## Documentation & Reference

**Use WebFetch to consult these docs when needed:**

### Core Documentation
- **Graph API Overview**: https://learn.microsoft.com/en-us/graph/api/overview
- **Graph Explorer**: https://developer.microsoft.com/en-us/graph/graph-explorer (Interactive testing)
- **API Reference**: https://learn.microsoft.com/en-us/graph/api/overview?view=graph-rest-1.0

### Search API
- **Search Overview**: https://learn.microsoft.com/en-us/graph/search-concept-overview
- **Search Query API**: https://learn.microsoft.com/en-us/graph/api/search-query

### Service-Specific APIs
- **OneDrive/Files API**: https://learn.microsoft.com/en-us/graph/api/resources/onedrive
- **Drive Item (files)**: https://learn.microsoft.com/en-us/graph/api/resources/driveitem
- **Outlook/Mail API**: https://learn.microsoft.com/en-us/graph/api/resources/message
- **Teams/Chat API**: https://learn.microsoft.com/en-us/graph/api/resources/teams-api-overview
- **Calendar/Events API**: https://learn.microsoft.com/en-us/graph/api/resources/event

### Troubleshooting
- **Error Codes**: https://learn.microsoft.com/en-us/graph/errors
- **Permissions Reference**: https://learn.microsoft.com/en-us/graph/permissions-reference
- **Throttling/Rate Limits**: https://learn.microsoft.com/en-us/graph/throttling
- **Best Practices**: https://learn.microsoft.com/en-us/graph/best-practices-concept

### Query Parameters
- **Query Parameters Guide**: https://learn.microsoft.com/en-us/graph/query-parameters
- **OData Query Options**: https://learn.microsoft.com/en-us/graph/filter-query-parameter

---

## Permissions Required

The Graph Explorer token typically includes:
- `Files.Read.All` - Read OneDrive files
- `Mail.Read` - Read emails
- `Chat.Read` - Read Teams chats
- `ChannelMessage.Read.All` - Read Teams channels
- `Calendars.Read` - Read calendar

If a request fails with 403, the user needs to consent to additional permissions in Graph Explorer.

---

## Best Practices

1. **Start with unified search** (`/search/query`) for cross-service searches
2. **Use specific endpoints** for better performance when you know the service
3. **Limit results** with `$top` parameter (default is often 10)
4. **Select only needed fields** with `$select` to reduce response size
5. **Handle pagination** for large result sets using `$skip` and `@odata.nextLink`
6. **Token security**: Never echo or print the token - it grants access to user's data

---

## Output Format

Present results clearly:

```
📁 OneDrive Search Results for "quarterly report"

Found 3 files:

1. Q4-2024-Report.xlsx
   Modified: 2024-12-15
   Path: /Documents/Reports
   🔗 [View in OneDrive]

2. Quarterly-Summary-Final.docx
   Modified: 2024-12-10
   Path: /Documents/Reports
   🔗 [View in OneDrive]

3. Q4-Presentation.pptx
   Modified: 2024-12-05
   Path: /Shared/Team Reports
   🔗 [View in OneDrive]
```

---

## Common Queries

### "Find my files in OneDrive"
→ Open Graph Explorer, get token, use `/me/drive/root/children` or search endpoint

### "Search my emails for X"
→ Open Graph Explorer, get token, use `/me/messages?$search="X"`

### "Show files shared with me"
→ Open Graph Explorer, get token, use `/me/drive/sharedWithMe`

### "Find Teams messages about X"
→ Open Graph Explorer, get token, use unified search with `chatMessage` entity type

### "What meetings do I have?"
→ Open Graph Explorer, get token, use `/me/calendar/events`

---

## Workflow Summary

When user asks to search Microsoft 365:
1. **Open browser** automatically to Graph Explorer
2. **Wait for token** from user (they paste it in chat)
3. **Run curl commands** replacing TOKEN with user's token
4. **Parse and present** results in readable format
5. **Handle errors** (expired token = open browser again)
6. **Use WebFetch** to consult docs if you encounter issues

---

## Important Notes

- **Token flow** - You paste token in chat (it's fine), Claude never displays it back
- **Token expires in ~1 hour** - User will need to refresh if searches stop working
- **Rate limits apply** - Microsoft Graph has throttling limits
- **Permissions vary** - Some operations require admin consent
- **Beta endpoints** exist but use `/v1.0/` for stability
- **Search syntax** varies by entity type - Some support KQL (Keyword Query Language)
- **Graph Explorer is great for testing** - Users can try queries there first
- **Use WebFetch for docs** - When stuck or encountering errors, look up relevant documentation
- **Documentation is comprehensive** - Most issues can be resolved by checking the official Microsoft Learn docs

---

**Last Updated:** 2026-01-11

**Security Notice:** The ONE rule: Claude never displays your token back to you. Paste it in chat, Claude uses it silently in curl commands.
