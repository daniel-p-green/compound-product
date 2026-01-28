# Collaboration Playbook (Daniel + Rex)

This repo is our **operating system** for turning ideas/threads into shipped artifacts using AI agents.

## Principles

- **Capture fast, shape deliberately, execute ruthlessly.**
- **One source of execution truth:** GitHub Issues (+ Project board).
- **One source of durable knowledge:** this repo (playbook/templates/decisions/reviews).
- **WIP limit:** 1 in-progress item at a time (default). If we break this rule, we name why.
- **Agents only run on shaped work** (clear acceptance criteria + safety boundaries).

## The Funnel (Thread → Shipped)

1) **Capture** → create an Issue in **Inbox**
   - minimal: what it is, why it matters, links to context

2) **Shape** → convert to a **Brief**
   - problem, success metric, non-goals, risks/unknowns, definition of done
   - output: label `brief:ready`

3) **Decompose** → generate an **Agent Task Pack**
   - 8–15 small, boolean pass/fail tasks
   - output: label `agent:ok`

4) **Execute** → agent loop produces commits/PRs
   - PR references the Issue (e.g., `Closes #123`)

5) **Compound** → weekly review + system improvements
   - update templates/checklists so next time is easier

## GitHub Project (recommended columns)

- Inbox
- Shaping
- Ready
- In Progress
- Review
- Done
- Parked

## Labels (recommended)

State:
- `inbox`
- `needs:brief`
- `brief:ready`
- `agent:ok`
- `blocked`

Type:
- `type:feature` `type:bug` `type:chore` `type:research`

Priority/impact (pick one):
- `impact:high` `impact:med` `impact:low`

## What Rex does by default

- Turns chat threads into Issues (Inbox)
- Drafts Briefs using `templates/brief.md`
- Converts Brief → task pack (machine-checkable)
- Maintains `decisions/` (ADR-lite)
- Drafts weekly reviews in `reviews/weekly/`

## Safety / Control

Agents only run when:
- Issue has `brief:ready` AND `agent:ok`
- Scope is bounded (clear DoD)
- Quality checks are configured and passing

If we’re uncertain about risk, we switch to “human-in-the-loop” mode:
- smaller tasks
- no network side effects
- no credential access
- no deploys
