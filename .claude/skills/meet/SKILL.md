---
name: meet
description: "Extract actions, decisions, and context from meeting notes or transcripts. Use when the user pastes meeting notes and wants structured output. SKIP when: the input is not meeting-related."
argument-hint: "[meeting notes or transcript]"
---

# Meeting Notes Processor

Turn raw meeting notes into structured, actionable output.

## Process

1. Read the provided notes/transcript
2. Extract and organize into:

### Decisions Made
- What was decided, by whom, with what rationale
- Record to `docs/decisions/` if project-affecting

### Action Items
- Who does what by when
- Each action gets a clear owner + deadline

### Open Questions
- What's unresolved, who's responsible for resolving

### Key Context
- Background info that future readers need

## Output Format

```markdown
## Meeting: [topic] — [date]

### Decisions
- [Decision]: [rationale]

### Actions
- [ ] [Owner]: [action] by [deadline]

### Open Questions
- [Question] → [owner]

### Context
- [Relevant background]
```

If the notes mention work that should enter the harness, suggest running through `/harness` intake.
