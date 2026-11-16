# worklog

A running log of work, in time order. **Append-only** — never edit lines that are already written; only add to the end.

- Document language: English
- One log entry per push. If a document for the same day and domain already exists, add to it.
  `.githooks/pre-push` enforces this.
- Documents are written with `/worklog:write` in Claude Code.
- Path: `worklog/<domain>/<YYYY-MM-DD>-<slug>.md`

These documents record "how things were at the time" and may no longer be accurate.
For the current state, read the code and the spec documents.

## Domains

Pick one domain from the paths of the changed files. If a push spans several domains, pick the one with the most changed files.

| Changed path | Domain |
|---|---|
{{DOMAINS}}

## Setup

With the worklog plugin, a SessionStart hook sets this up when Claude Code starts.
To set it up by hand without the plugin:

```
git config core.hooksPath .githooks
```
