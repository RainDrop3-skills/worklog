<div align="center">

[Kor](README.ko.md) | [Eng](README.md)

</div>

# worklog

push 마다 작업 기록을 남기게 강제하고, 작업을 시작할 때 최근 기록을 읽게 하는 Claude Code 플러그인.

## 구성

| 구성 | 위치 | 하는 일 |
|---|---|---|
| `/worklog:init` | `skills/init/` | 레포에 `worklog/README.md`, `.githooks/pre-push` 를 깐다 |
| `/worklog:write` | `skills/write/` | 이번 push 분량을 `worklog/<도메인>/` 에 문서로 쓰고 커밋한다 |
| SessionStart 훅 | `scripts/session-start.sh` | `core.hooksPath` 를 켜고, 도메인별 최신 worklog 경로를 대화에 넣는다 |
| PostToolUseFailure 훅 | `scripts/push-nudge.sh` | push 가 막히면 Claude 에게 `/worklog:write` 를 돌리고 다시 push 하라고 알린다 |
| git `pre-push` | 각 레포의 `.githooks/` | push 범위에 코드 변경만 있고 worklog 문서가 없으면 막는다 |

git 훅은 플러그인이 아니라 각 레포에 들어간다. 플러그인이 없는 팀원에게도 걸려야 하기 때문이다.

훅은 `worklog/` 가 있는 레포에서만 동작한다. 다른 레포에서는 아무것도 하지 않는다.

## 설치

Claude Code 에서:

```
/plugin marketplace add RainDrop3-skills/worklog
/plugin install worklog@worklog
```

훅 스크립트를 `sh` 로 돌린다. Windows 에서는 Git for Windows 가 있어야 한다.

## 쓰는 법

1. 레포에서 `/worklog:init` — 기준 브랜치, 도메인, 문서 언어(영어 또는 한국어, 기본 영어)를 정하고 파일을 깐다.
2. 평소처럼 작업하고 push 한다. 막히면 Claude 가 문서를 쓰고 다시 push 한다.

문서 언어는 레포마다 정한다. 팀원 모두가 같은 언어로 기록하게 하기 위해서다.
worklog 문서, `worklog/README.md`, push 를 막을 때 나오는 안내에 적용된다.

## 설정

| 환경변수 | 기본값 | 뜻 |
|---|---|---|
| `WORKLOG_READ_N` | `2` | 세션을 시작할 때 도메인마다 보여 줄 최신 문서 수 |

`.claude/settings.json` 의 `env` 에 넣는다.
