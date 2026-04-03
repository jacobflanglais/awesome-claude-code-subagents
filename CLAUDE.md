# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a curated collection of Claude Code subagent definitions - specialized AI assistants for specific development tasks. Subagents are markdown files with YAML frontmatter that Claude Code can load and use.

## Repository Structure

```
categories/
  01-core-development/     # Backend, frontend, fullstack, mobile, etc.
  02-language-specialists/ # Language/framework experts (TypeScript, Python, etc.)
  03-infrastructure/       # DevOps, cloud, Kubernetes, etc.
  04-quality-security/     # Testing, security auditing, code review
  05-data-ai/              # ML, data engineering, AI specialists
  06-developer-experience/ # Tooling, documentation, DX optimization
  07-specialized-domains/  # Blockchain, IoT, fintech, gaming
  08-business-product/     # Product management, business analysis
  09-meta-orchestration/   # Multi-agent coordination
  10-research-analysis/    # Research and analysis specialists
```

## Subagent File Format

Each subagent follows this template:

```yaml
---
name: agent-name
description: When this agent should be invoked (used by Claude Code for auto-selection)
tools: Read, Write, Edit, Bash, Glob, Grep  # Comma-separated tool permissions
---

You are a [role description]...

[Agent-specific checklists, patterns, guidelines]

## Communication Protocol
[Inter-agent communication specs]

## Development Workflow
[Structured implementation phases]
```

### Tool Assignment by Role Type

- **Read-only** (reviewers, auditors): `Read, Grep, Glob`
- **Research** (analysts): `Read, Grep, Glob, WebFetch, WebSearch`
- **Code writers** (developers): `Read, Write, Edit, Bash, Glob, Grep`
- **Documentation**: `Read, Write, Edit, Glob, Grep, WebFetch, WebSearch`

## Contributing a New Subagent

When adding a new agent, update these files:

1. **Main README.md** - Add link in appropriate category (alphabetical order)
2. **Category README.md** - Add detailed description, update Quick Selection Guide table
3. **Agent .md file** - Create the actual agent definition

Format for main README: `- [**agent-name**](path/to/agent.md) - Brief description`

## Subagent Storage in Claude Code

| Type | Path | Scope |
|------|------|-------|
| Project | `.claude/agents/` | Current project only |
| Global | `~/.claude/agents/` | All projects |

Project subagents take precedence over global ones with the same name.

## Post-Change Validation Workflow

After completing any code change (feature, bugfix, refactor), you MUST follow this validation loop:

1. **Validate with QA agent:** Dispatch the `feature-dev:code-reviewer` subagent (via the Task tool) to review the changes. If the project has a project-specific reviewer agent (e.g., `reqbase-reviewer`), prefer that over the generic one.

2. **Fix identified issues:** If the QA agent identifies bugs, logic errors, security vulnerabilities, or convention violations, fix them immediately. For multi-file fixes, use an appropriate engineering subagent (e.g., `reqbase-frontend`, `reqbase-functions`, `reqbase-database` if project-specific agents exist, or handle directly).

3. **Re-validate after fixes:** After applying fixes, run the QA agent again to confirm all issues are resolved. Repeat until the QA agent reports no high-priority issues.

This loop is mandatory for all non-trivial changes. Skip only for single-line typo fixes or comment-only edits.

# Obsidian Vault

Jacob's Obsidian vault ("Jacob Second Brain") is at `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Jacob Second Brain`. Claude Code has read/write access. Synced via iCloud.

## Vault Structure

```
Jacob Second Brain/
  Daily Notes/       # Daily journal entries
  Work/              # Work projects (PayPal BNPL, DVC, UCM2)
  Reqbase/           # Reqbase product notes
  Personal/          # Personal (Golf, Finance, Travel)
  Family/            # Family notes
  Edge Vault/        # Research & Bets
  Watches/           # Watch collection/interests
  Archive/           # Archived notes
  Templates/         # Note templates
```

## Conventions

- All notes are markdown (`.md`) — standard Obsidian format
- Use `[[wikilinks]]` for internal links between notes
- Place new notes in the appropriate top-level folder by topic
- Use YAML frontmatter for metadata when relevant (tags, date, status)
- Daily notes go in `Daily Notes/` with format `YYYY-MM-DD.md`
- Never modify `.obsidian/` config files unless explicitly asked
- Keep note titles concise and descriptive

# Ralph
Always use Ralph for project management workflows. Run `ralph --monitor` for integrated monitoring. Follow the .ralph/ directory structure and conventions for all project requirements.

# Context7
Always use Context7 MCP when you need library/API documentation, code generation, setup or configuration steps. Automatically invoke context7 tools to resolve library IDs and fetch docs without me having to explicitly ask.

# Ralph Global Rules
When using Ralph on any project:
- Always write acceptance criteria in Gherkin format (Given/When/Then)
- Break work into small, testable increments
- Write tests before implementation
- Commit after each completed task with descriptive commit messages
- Log progress to .ralph/status.json after each milestone
- Ask for clarification before making architectural assumptions
- Never skip error handling
- Document all API contracts and data models

# Playwright
When building or modifying frontend features, use Playwright to visually verify the output. After creating UI components or pages, launch a browser, take a screenshot, and confirm it renders correctly before marking the task complete. Write end-to-end tests for any new user-facing flows.

# Prompt Advisor

Proactively surface the right prompting technique when it would materially improve output quality. Act like a senior Claude power user riding shotgun — don't lecture, don't over-fire. One crisp suggestion beats five mediocre ones.

## When to trigger

Fire when:
- Task is complex, ambiguous, or high-stakes (architecture decisions, requirements, debugging, exec comms)
- The user's prompt leaves significant quality on the table
- User expresses frustration with output quality
- User asks "how do I get better results"

Do NOT fire for:
- Simple factual questions or casual chat
- Already well-structured prompts
- Tasks covered by an existing slash command or tool (use those instead)

## Technique reference

| Technique | Use when | How |
|---|---|---|
| Chain-of-Thought | Multi-step reasoning, debugging, root cause | "Think step by step" |
| Ultrathink | Hard tradeoffs, architectural decisions | Prepend "Ultrathink:" |
| Self-Critique | High-stakes output (PRDs, ACs, arch docs) | "Now review for errors or gaps" |
| Few-Shot Examples | Format-sensitive output (Gherkin, templates) | Provide 2-3 input/output examples |
| Task Decomposition | Large deliverables, 5+ step tasks | "First outline your plan, then execute" |
| Adversarial | Requirements review, system design, risk | "What could go wrong with this?" |
| XML Tags | Complex multi-part prompts, agentic tasks | Wrap in `<context>`, `<instructions>` |
| Meta-Prompting | Fuzzy goals, user unsure how to ask | "Write a prompt that would get the best answer for..." |
| Constraint Setting | Output keeps drifting, wrong format | "Do NOT include X", "In under N words" |
| Prompt Chaining | Multi-stage pipelines | Break into explicit sequential calls |

## How to surface a suggestion

One to two sentences max. Options:

- **Before responding** (technique changes the whole approach): "Quick note: applying CoT here for better reasoning."
- **After responding** (helps on follow-up): "For next time: prepending 'Ultrathink:' on questions like this gets deeper tradeoff analysis."
- **When prompt leaves quality on the table**: "A few format examples upfront would improve this — want me to show you?"

Never suggest multiple techniques at once. Pick the highest-leverage one and move on.

## Special cases

- **Frustrated user**: Apply the technique directly, fix the response, then briefly note what changed.
- **PM work (ACs, stories, PRDs)**: Self-critique and adversarial prompting are almost always worth flagging — high cost-of-errors.
- **Building agents/pipelines**: Prioritize ReAct, prompt chaining, XML tags over single-turn techniques.

# Reqbase PM

When authoring product requirements (epics, user stories, bugs, tasks, ACs, PRDs, backlogs), follow the Reqbase PM methodology. This applies whenever the user asks to create, write, draft, define, or refine any work item — including informal language like "ticket up X" or "write requirements for Y."

## Authoring Flow

Follow this structured process — do not skip or collapse steps:
1. **Intake**: Gather work item type, problem/feature, persona, constraints, parent epic. Confirm understanding before proceeding.
2. **Business Rules Draft**: Write numbered BRs in `# BR.XX - Description` hash-list format. Present for review — BRs are the foundation.
3. **Generate Fields**: Once BRs are confirmed, generate all fields (user story statement, AC, tech reqs, assumptions, design).
4. **Iterative Refinement**: When BRs change, update all downstream AC references. Flag affected fields.
5. **Complexity Scoring**: Score across 5 weighted dimensions (Scope, Integration, Uncertainty, Risk, Testing) → T-shirt size.
6. **Export**: Offer conversation summary, XLSX (Jira import template), or CSV per issue type.

## Acceptance Criteria Format

Always use Gherkin with Jira wiki bold markup and BR traceability:
```
*AC.01 - [BR.01] Descriptive scenario title*
*Given* precondition
*When* user action
*Then* expected observable outcome
```
- Every AC references at least one BR via `[BR.XX]`
- Cover: happy path, validation failures, auth failures, edge cases, error recovery
- One behavior per AC. If testing two things, split it.
- No implementation details in AC — describe observable outcomes only.

## Work Item Types

- **Epic**: Title + description + BRs + success metrics + child stories
- **User Story**: `*As a*` / `*I want*` / `*So that*` + BRs + AC + tech reqs + assumptions + design + complexity
- **Bug**: Component title + environment + steps to reproduce + expected/actual + severity + AC + tech reqs
- **Task**: Action verb title + description + AC + tech reqs + estimate (T-shirt)

## Quality Bar

1. **Testable**: Every AC has clear pass/fail
2. **Unambiguous**: No weasel words — "fast" becomes "responds within 200ms"
3. **Complete**: Happy path + errors + edge cases + boundary conditions
4. **Independent**: Each story deliverable on its own
5. **Sized right**: More than 8-10 AC means split it
6. **Traceable**: Every AC traces to a BR, every BR has at least one AC

# Deploy Recorder

Record screen captures of deployed web application changes using Playwright. Use this whenever asked to record, capture, screen record, or visually verify changes on a live/deployed site after pushing code. Also trigger on phrases like "record what we just shipped," "show me the deployed changes," "capture the updates on prod," "record the last few changes," "verify the deploy visually," or "record the site."

## Workflow

1. **Determine what to record**: User provides explicit URLs/routes (preferred) or infer from recent git changes via `scripts/infer_routes.py` (confirm with user before recording)
2. **Plan interactions**: Visual scan only vs interactive recording (clicking, filling forms, navigating flows)
3. **Record**: Run `scripts/record_session.py` with Playwright (Chromium, 1280x720, video enabled)
4. **Convert**: Run `scripts/convert_to_mp4.py` (always convert WebM to MP4 before sharing)
5. **Assess**: Review frames — working correctly, issues found, improvement opportunities
6. **Deliver**: Copy MP4 to outputs, present with assessment

## Credentials

Retrieve test account credentials from Claude's memory. Never hardcode credentials. If a feature requires global admin access beyond the test account's permissions, inform the user before proceeding.

## Site Config (Reqbase)

- Base URL: `https://www.reqbase.app` (NOT `reqbase.app` — bare domain 307-redirects)
- Auth: Email/password login form at `/login`
- Framework: Vite + React SPA (use `wait_until='commit'`, allow 3-5s for React render)
- Use JS-based scrolling (`window.scrollBy`) instead of `mouse.wheel()` (hangs on font loads)

## Prerequisites

```bash
pip install playwright --break-system-packages
python -m playwright install chromium --with-deps
apt-get update && apt-get install -y ffmpeg 2>/dev/null || true
```
