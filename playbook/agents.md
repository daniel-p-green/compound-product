# Agents Playbook

This defines how we use AI agents without getting stuck in "idea mode".

## Agent Modes

### 1) Capture Agent (low effort)
Goal: convert messy thoughts into a single Issue.
Output:
- Issue title + 5–10 bullet context
- links to source thread
- tags: `inbox`, `needs:brief`

### 2) Shaping Agent (product thinking)
Goal: turn an Issue into a Brief that can be executed.
Output:
- Brief pasted into the Issue (or attached doc)
- success metric
- clear definition of done
- tags: `brief:ready`

### 3) Decomposition Agent (execution thinking)
Goal: convert Brief → small tasks with pass/fail criteria.
Output:
- checklist tasks in the Issue (or `tasks/*.md`)
- tags: `agent:ok`

### 4) Implementation Agent (coding)
Goal: complete tasks, run checks, open PR.
Output:
- commits + PR
- PR links Issue and states what changed

## WIP Rules

- Only **one** Issue can be `In Progress` at a time.
- If new ideas appear, they go to `Inbox` (no context switching).

## Definition of Done (DoD)

Every execution Issue should have:
- measurable acceptance criteria
- tests/quality checks
- rollback/escape hatch if relevant
- documentation updates if behavior changed

## Anti-ADHD Guardrails

- If the task can’t be described with pass/fail checks, it’s not ready.
- If it feels exciting but vague: it goes back to Shaping.
- If it’s big: split until each task is ~30–90 minutes for an agent.
