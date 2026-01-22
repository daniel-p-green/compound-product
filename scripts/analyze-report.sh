#!/bin/bash
# Analyze a report and pick #1 actionable priority
# Uses Anthropic API directly (no dependencies beyond curl and jq)
#
# Usage: ./analyze-report.sh <report-path>
# Output: JSON to stdout
#
# Requires: ANTHROPIC_API_KEY environment variable

set -e

REPORT_PATH="$1"

if [ -z "$REPORT_PATH" ]; then
  echo "Usage: ./analyze-report.sh <report-path>" >&2
  exit 1
fi

if [ ! -f "$REPORT_PATH" ]; then
  echo "Error: Report file not found: $REPORT_PATH" >&2
  exit 1
fi

if [ -z "$ANTHROPIC_API_KEY" ]; then
  echo "Error: ANTHROPIC_API_KEY environment variable not set" >&2
  exit 1
fi

REPORT_CONTENT=$(cat "$REPORT_PATH")

# Escape for JSON
REPORT_ESCAPED=$(echo "$REPORT_CONTENT" | jq -Rs .)

PROMPT="You are analyzing a daily report for a software product.

Read this report and identify the #1 most actionable item that should be worked on TODAY.

CONSTRAINTS:
- Must NOT require database migrations (no schema changes)
- Must be completable in a few hours of focused work
- Must be a clear, specific task (not vague like 'improve conversion')
- Prefer fixes over new features
- Prefer high-impact, low-effort items
- Focus on UI/UX improvements, copy changes, bug fixes, or configuration changes

REPORT:
$REPORT_CONTENT

Respond with ONLY a JSON object (no markdown, no code fences, no explanation):
{
  \"priority_item\": \"Brief title of the item\",
  \"description\": \"2-3 sentence description of what needs to be done\",
  \"rationale\": \"Why this is the #1 priority based on the report\",
  \"acceptance_criteria\": [\"List of 3-5 specific, verifiable criteria\"],
  \"estimated_tasks\": 3,
  \"branch_name\": \"compound/kebab-case-feature-name\"
}"

PROMPT_ESCAPED=$(echo "$PROMPT" | jq -Rs .)

RESPONSE=$(curl -s https://api.anthropic.com/v1/messages \
  -H "Content-Type: application/json" \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -d "{
    \"model\": \"claude-sonnet-4-20250514\",
    \"max_tokens\": 1024,
    \"messages\": [{\"role\": \"user\", \"content\": $PROMPT_ESCAPED}]
  }")

# Extract the text content
TEXT=$(echo "$RESPONSE" | jq -r '.content[0].text // empty')

if [ -z "$TEXT" ]; then
  echo "Error: Failed to get response from Anthropic API" >&2
  echo "Response: $RESPONSE" >&2
  exit 1
fi

# Try to parse as JSON, handle potential markdown wrapping
if echo "$TEXT" | jq . >/dev/null 2>&1; then
  echo "$TEXT" | jq .
else
  # Try to extract JSON from markdown code block
  JSON_EXTRACTED=$(echo "$TEXT" | sed -n '/^{/,/^}/p' | head -20)
  if echo "$JSON_EXTRACTED" | jq . >/dev/null 2>&1; then
    echo "$JSON_EXTRACTED" | jq .
  else
    echo "Error: Could not parse response as JSON" >&2
    echo "Response text: $TEXT" >&2
    exit 1
  fi
fi
