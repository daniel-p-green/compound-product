---
name: tasks
description: "Convert a PRD markdown file to prd.json for execution. Triggers on: convert prd, create tasks, prd to json, generate tasks from prd."
---

# Tasks - Convert PRD to JSON Format

Converts a PRD markdown document into the prd.json format for the execution loop.

---

## The Job

1. Read the PRD markdown file
2. Extract tasks (from Tasks section or User Stories)
3. Order by dependencies (schema → backend → UI → tests)
4. Output to the specified prd.json location

---

## Input

A PRD file created by the `prd` skill, typically at `tasks/prd-[feature-name].md`.

---

## Output Format

Create `prd.json`:

```json
{
  "project": "Project Name",
  "branchName": "compound/[feature-name]",
  "description": "[One-line description from PRD]",
  "tasks": [
    {
      "id": "T-001",
      "title": "[Task title]",
      "description": "[What to implement]",
      "acceptanceCriteria": [
        "Specific verifiable criterion",
        "Another criterion",
        "Quality checks pass"
      ],
      "priority": 1,
      "passes": false,
      "notes": ""
    }
  ]
}
```

---

## Conversion Rules

### Task Sizing

Each task must be completable in ONE iteration (~one context window).

**Right-sized tasks:**
- Add a database column + migration
- Create a single UI component
- Implement one server action
- Add a filter to an existing list
- Write tests for one module

**Too big (split these):**
- "Build the entire dashboard" → Split into: schema, queries, components, filters
- "Add authentication" → Split into: schema, middleware, login UI, session handling

**Rule of thumb:** If you can't describe the change in 2-3 sentences, it's too big.

### Priority Ordering

Set priority based on dependencies:

1. Schema/database changes (migrations) - priority 1
2. Server actions / backend logic - priority 2-3
3. UI components that use the backend - priority 4-5
4. Integration / E2E tests - highest priority numbers

Lower priority number = executed first.

### Acceptance Criteria

Always include:
- Quality check verification (e.g., "npm run typecheck passes")
- Browser verification for UI tasks

Criteria must be **verifiable**, not vague:
- ❌ "Works correctly"
- ✅ "Button shows confirmation dialog before deleting"

### Branch Naming

Use `compound/[feature-name]` format (or whatever prefix is in config):
- `compound/task-priority`
- `compound/email-notifications`
- `compound/user-settings`

---

## Process

### Step 1: Read the PRD

```
Read the PRD file the user specified
```

### Step 2: Extract Tasks

Look for:
- Tasks (T-001, T-002, etc.)
- User Stories (US-001, US-002, etc.)
- Functional Requirements (FR-1, FR-2, etc.)
- Any numbered/bulleted work items

### Step 3: Order by Dependencies

Determine logical order:
1. What needs to exist first? (database schema)
2. What depends on that? (backend logic)
3. What depends on that? (UI components)
4. What verifies everything? (tests)

### Step 4: Generate prd.json

Create the JSON file with all tasks having `passes: false`.

### Step 5: Confirm

Show the user:
- Number of tasks created
- Task order with dependencies
- Branch name

---

## Example Conversion

**From PRD:**
```markdown
### T-001: Add priority field to database
**Acceptance Criteria:**
- [ ] Add priority column to tasks table
- [ ] Generate and run migration
- [ ] Quality checks pass

### T-002: Display priority indicator
**Acceptance Criteria:**
- [ ] Task card shows colored badge
- [ ] Quality checks pass
- [ ] Verify in browser
```

**To prd.json:**
```json
{
  "project": "MyProject",
  "branchName": "compound/task-priority",
  "description": "Add priority levels to tasks",
  "tasks": [
    {
      "id": "T-001",
      "title": "Add priority field to database",
      "description": "Add priority column to tasks table for persistence.",
      "acceptanceCriteria": [
        "Add priority column to tasks table: 'high' | 'medium' | 'low' (default 'medium')",
        "Generate and run migration successfully",
        "Quality checks pass"
      ],
      "priority": 1,
      "passes": false,
      "notes": ""
    },
    {
      "id": "T-002",
      "title": "Display priority indicator on task cards",
      "description": "Show colored priority badge on each task card.",
      "acceptanceCriteria": [
        "Each task card shows colored priority badge (red=high, yellow=medium, gray=low)",
        "Priority visible without hovering or clicking",
        "Quality checks pass",
        "Verify in browser"
      ],
      "priority": 2,
      "passes": false,
      "notes": ""
    }
  ]
}
```

---

## Checklist

Before saving prd.json:

- [ ] All tasks are small enough for one iteration
- [ ] Priority order reflects dependencies
- [ ] Every task has quality check verification
- [ ] UI tasks have browser verification
- [ ] Branch name follows correct format
- [ ] All tasks have `passes: false`
