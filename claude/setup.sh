#!/bin/bash
# Setup Claude Code plugins and MCP servers

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SETTINGS_FILE="$SCRIPT_DIR/settings.json"
MCP_FILE="$SCRIPT_DIR/mcp-servers.json"

# Install plugins
echo "=== Installing Plugins ==="

if [[ ! -f "$SETTINGS_FILE" ]]; then
  echo "Warning: settings.json not found"
else
  plugins=$(jq -r '.enabledPlugins | keys[]' "$SETTINGS_FILE")
  if [[ -n "$plugins" ]]; then
    echo "$plugins" | while read -r plugin; do
      echo "Installing $plugin..."
      claude plugin install "$plugin"
    done
  fi
fi

# Setup MCP servers
echo ""
echo "=== Setting up MCP Servers ==="

if [[ ! -f "$MCP_FILE" ]]; then
  echo "Warning: mcp-servers.json not found"
else
  jq -r 'keys[]' "$MCP_FILE" | while read -r name; do
    command=$(jq -r --arg n "$name" '.[$n].command' "$MCP_FILE")
    args=$(jq -r --arg n "$name" '.[$n].args | join(" ")' "$MCP_FILE")
    echo "Adding MCP server: $name"
    claude mcp add "$name" --scope user -- $command $args
  done
fi

echo ""
echo "Done!"
