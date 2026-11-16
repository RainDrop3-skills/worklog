<div align="center">

[Kor](README.ko.md) | [Eng](README.md)

</div>

# worklog

A Claude Code plugin that requires a work log for every push and has Claude read recent logs before starting work.

## What's inside

| Component | Location | What it does |
|---|---|---|
| `/worklog:init` | `skills/init/` | Sets up `worklog/README.md` and `.githooks/pre-push` in a repo |
| `/worklog:write` | `skills/write/` | Writes up this push's work under `worklog/<domain>/` and commits it |
| SessionStart hook | `scripts/session-start.sh` | Turns on `core.hooksPath` and adds the latest worklog paths per domain to the conversation |
| PostToolUseFailure hook | `scripts/push-nudge.sh` | When a push is blocked, tells Claude to run `/worklog:write` and push again |
| git `pre-push` | each repo's `.githooks/` | Blocks a push that has code changes but no worklog document |

The git hook lives in each repo, not in the plugin, so it also applies to teammates who don't have the plugin.

The hooks only act in repos that have a `worklog/` folder. Everywhere else they do nothing.

## Install

In a terminal (bash):

```bash
claude plugin marketplace add RainDrop3-skills/worklog
claude plugin install worklog@worklog
```

The hook scripts run with `sh`. On Windows, Git for Windows is required.

### Install scope

Both commands take `--scope` (default `user`).
`project` and `local` apply to the folder you run the command in, so `cd` there first.

| `--scope` | Applies to |
|---|---|
| `user` | All your projects |
| `project` | This project. Commit `.claude/settings.json` to share it with the team |
| `local` | This project, only you |

```bash
cd <project>
claude plugin marketplace add RainDrop3-skills/worklog --scope local
claude plugin install worklog@worklog --scope local
```

To turn it off in one project only: `claude plugin disable worklog@worklog --scope local`

## Usage

1. In a repo, run `/worklog:init`. Pick the domains and the document language
   (English or Korean, English by default), then it sets up the files.
2. Work and push as usual. If a push is blocked, Claude writes the log and pushes again.

The document language is set per repo, so everyone on a team writes logs in the same language.
It applies to the worklog documents, `worklog/README.md` and the message shown when a push is blocked.

## Settings

| Environment variable | Default | Meaning |
|---|---|---|
| `WORKLOG_READ_N` | `2` | Number of latest documents per domain shown at session start |

Set it under `env` in `.claude/settings.json`.
