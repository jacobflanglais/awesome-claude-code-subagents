#!/bin/bash
# Stop hook: append session entry to Obsidian vault
# Receives JSON on stdin with transcript_path, cwd, session_id

LOG_FILE="/Users/jacob_langlais/Library/Mobile Documents/iCloud~md~obsidian/Documents/Jacob Second Brain/Reqbase/Claude Code Session Log.md"

# Create file if it doesn't exist
if [ ! -f "$LOG_FILE" ]; then
  mkdir -p "$(dirname "$LOG_FILE")"
  echo "# Claude Code Session Log" > "$LOG_FILE"
  echo "" >> "$LOG_FILE"
fi

# Read hook input from stdin
INPUT=$(cat)

# Extract fields from JSON
CWD=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('cwd','unknown'))" 2>/dev/null || echo "unknown")
TRANSCRIPT=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('transcript_path',''))" 2>/dev/null || echo "")

PROJECT=$(basename "$CWD")
BRANCH=$(cd "$CWD" 2>/dev/null && git branch --show-current 2>/dev/null || echo "unknown")
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")

# Extract summary from transcript: get the first user message and count of assistant turns
SUMMARY="Session completed"
if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
  # Get first user message as the session topic
  FIRST_MSG=$(python3 -c "
import sys, json
msgs = []
with open('$TRANSCRIPT') as f:
    for line in f:
        try:
            obj = json.loads(line)
            if obj.get('type') == 'human' or obj.get('role') == 'user':
                parts = obj.get('message', {}).get('content', [])
                for p in parts:
                    if isinstance(p, dict) and p.get('type') == 'text':
                        text = p['text'].strip()[:200]
                        if text and not text.startswith('<'):
                            print(text)
                            sys.exit(0)
                if isinstance(parts, str):
                    text = parts.strip()[:200]
                    if text and not text.startswith('<'):
                        print(text)
                        sys.exit(0)
        except: pass
print('Session completed')
" 2>/dev/null || echo "Session completed")

  # Count tool uses as a rough activity metric
  TOOL_COUNT=$(python3 -c "
import json
count = 0
with open('$TRANSCRIPT') as f:
    for line in f:
        try:
            obj = json.loads(line)
            if obj.get('type') == 'tool_use' or obj.get('type') == 'tool_result':
                count += 1
        except: pass
print(count // 2)
" 2>/dev/null || echo "0")

  # Get git changes made during session
  CHANGED_FILES=$(cd "$CWD" 2>/dev/null && git diff --name-only HEAD~1 HEAD 2>/dev/null | head -5 | tr '\n' ', ' | sed 's/,$//' || echo "none detected")

  SUMMARY="Task: ${FIRST_MSG}. Tool calls: ~${TOOL_COUNT}."
fi

# Append entry
cat >> "$LOG_FILE" << EOF

## ${TIMESTAMP} — ${PROJECT}
**Project:** ${PROJECT}
**Branch:** ${BRANCH}
**Summary:** ${SUMMARY}
**Files changed:** ${CHANGED_FILES:-none detected}
**Status:** completed

---
EOF
