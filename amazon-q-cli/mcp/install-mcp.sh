#!/bin/bash

# Install MCP configuration for Amazon Q CLI and Kiro IDE
# Creates timestamped backups of existing configurations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MCP_SOURCE="$SCRIPT_DIR/mcp.json"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if source mcp.json exists
if [ ! -f "$MCP_SOURCE" ]; then
    echo -e "${RED}Error: mcp.json not found in $SCRIPT_DIR${NC}"
    exit 1
fi

echo "MCP Configuration Installer"
echo "============================"
echo ""

# Amazon Q CLI installation
Q_CONFIG_DIR="$HOME/.aws/amazonq"
Q_MCP_FILE="$Q_CONFIG_DIR/mcp.json"

if [ -d "$Q_CONFIG_DIR" ]; then
    echo -e "${GREEN}✓ Amazon Q CLI detected${NC}"

    # Create backup if mcp.json exists
    if [ -f "$Q_MCP_FILE" ]; then
        BACKUP_FILE="$Q_CONFIG_DIR/mcp.json.backup.$TIMESTAMP"
        cp "$Q_MCP_FILE" "$BACKUP_FILE"
        echo -e "${YELLOW}  Backup created: $BACKUP_FILE${NC}"
    fi

    # Copy new mcp.json
    cp "$MCP_SOURCE" "$Q_MCP_FILE"
    echo -e "${GREEN}  MCP configuration installed to: $Q_MCP_FILE${NC}"
    echo ""
else
    echo -e "${YELLOW}⊘ Amazon Q CLI not found at $Q_CONFIG_DIR${NC}"
    echo ""
fi

# Kiro IDE installation
KIRO_CONFIG_DIR="$HOME/.kiro/settings"
KIRO_MCP_FILE="$KIRO_CONFIG_DIR/mcp.json"

if [ -d "$HOME/.kiro" ]; then
    echo -e "${GREEN}✓ Kiro IDE detected${NC}"

    # Create settings directory if it doesn't exist
    mkdir -p "$KIRO_CONFIG_DIR"

    # Create backup if mcp.json exists
    if [ -f "$KIRO_MCP_FILE" ]; then
        BACKUP_FILE="$KIRO_CONFIG_DIR/mcp.json.backup.$TIMESTAMP"
        cp "$KIRO_MCP_FILE" "$BACKUP_FILE"
        echo -e "${YELLOW}  Backup created: $BACKUP_FILE${NC}"
    fi

    # Copy new mcp.json
    cp "$MCP_SOURCE" "$KIRO_MCP_FILE"
    echo -e "${GREEN}  MCP configuration installed to: $KIRO_MCP_FILE${NC}"
    echo ""
else
    echo -e "${YELLOW}⊘ Kiro IDE not found at $HOME/.kiro${NC}"
    echo ""
fi

echo "============================"
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Review the installed mcp.json files"
echo "  2. Update any placeholder values (credentials, paths, etc.)"
echo "  3. Restart Amazon Q CLI or Kiro IDE"
echo ""
