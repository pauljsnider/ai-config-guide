#!/bin/bash

# Install MCP configuration for Cursor IDE and cursor-agent CLI
# Creates timestamped backups of existing configurations

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MCP_SOURCE="$SCRIPT_DIR/mcp.json"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

if [ ! -f "$MCP_SOURCE" ]; then
  echo -e "${RED}Error: mcp.json not found in $SCRIPT_DIR${NC}" >&2
  exit 1
fi

echo "Cursor MCP Configuration Installer"
echo "=================================="
echo ""

CURSOR_DIR="$HOME/.cursor"
CURSOR_MCP_FILE="$CURSOR_DIR/mcp.json"

mkdir -p "$CURSOR_DIR"

echo -e "${GREEN}✓ Cursor settings directory: $CURSOR_DIR${NC}"

if [ -f "$CURSOR_MCP_FILE" ]; then
  BACKUP_FILE="$CURSOR_DIR/mcp.json.backup.$TIMESTAMP"
  cp "$CURSOR_MCP_FILE" "$BACKUP_FILE"
  echo -e "${YELLOW}  Backup created: $BACKUP_FILE${NC}"
fi

cp "$MCP_SOURCE" "$CURSOR_MCP_FILE"
echo -e "${GREEN}  Installed: $CURSOR_MCP_FILE${NC}"

echo ""
echo "Next steps:"
echo "  1. Edit credentials or paths inside $CURSOR_MCP_FILE"
echo "  2. Restart the Cursor IDE or re-run cursor-agent"
echo "  3. Validate with: jq . $CURSOR_MCP_FILE"
echo ""
