---
name: init
description: Sets up the worklog workflow in the current git repo — worklog/README.md (domain table) and .githooks/pre-push. Use for "set up worklog", "install worklog", "/worklog:init".
---

# worklog init

이 스킬 폴더의 `templates/` 를 현재 레포에 깐다. 이미 있는 파일은 덮어쓰지 않는다.

## 1. 깔아도 되는지 확인

레포 루트(`git rev-parse --show-toplevel`)에서 작업한다. 아래 중 하나라도 걸리면 멈추고 사용자에게 알린다.

- `worklog/README.md` 나 `.githooks/pre-push` 가 이미 있다.
- `git config core.hooksPath` 가 비어 있지 않고 `.githooks` 도 아니다, 또는 `.husky/` 가 있다.
  이 워크플로우는 core.hooksPath 를 `.githooks` 로 바꾸므로 기존 훅이 꺼진다.

## 2. 사용자와 정한다

여기서 정한 값을 사용자가 확정하기 전에는 3 으로 넘어가지 않는다. 파일을 하나도 만들지 않는다.
질문은 AskUserQuestion 도구로 한다. 도구를 쓸 수 없는 환경이면 같은 내용을 글로 묻는다.

**첫 번째 호출 — 팀 구성** (질문 1개)

도메인은 폴더 이름이 아니라 "누가 그 기록을 읽는가" 로 나눈다. 그래서 팀이 일을 어떻게 나눠 맡는지 먼저 묻는다.
레포 구조를 보고 고를 만한 분담 방식 2~4개를 선지로 낸다 (예: 혼자 씀, 프론트·백엔드 분리, 프론트·백엔드·AI).
최상위가 `apps/`, `packages/`, `services/` 같은 묶음 폴더면 한 단계 더 들어가 보고 선지를 만든다.

**두 번째 호출 — 도메인과 문서 언어** (질문 2개)

- **도메인** — 팀 구성 답과 레포 구조를 합쳐 매핑안 1~2개를 선지로 낸다.
  각 선지의 preview 에 매핑 표를 담고, 가장 맞는 안에 `(Recommended)` 를 붙인다.
  도메인은 3~5개다. 한 도메인에 여러 경로가 묶여도 된다 (예: `backend/`, `db/`, `docker/` → `be`).
  이름은 짧은 영문 소문자다 (예: `fe`, `be`, `ai`). 어디에도 안 맞는 변경용으로 `etc` 를 둔다.
  혼자 쓰는 레포면 작업 성격으로 나눈다 (예: 화면, 서버, 데이터).
- **문서 언어** — `English (Recommended)` 와 `한국어`.
  worklog 문서, `worklog/README.md`, push 를 막을 때 나오는 안내가 이 언어로 나온다.

사용자가 Other 로 고치면 반영해 두 번째 호출을 다시 한다. 둘 다 선지로 고르면 그 값으로 3 을 진행한다.

## 3. 파일을 깐다

- `templates/README.en.md` (English) 또는 `templates/README.ko.md` (한국어) → `worklog/README.md`.
  `{{DOMAINS}}` 자리를 도메인 표 행으로 바꾼다. 예: `` | `frontend/` | `fe` | ``
- `templates/pre-push` → `.githooks/pre-push`. `lang=` 값을 `en` 또는 `ko` 로 바꾼다.
- `.gitattributes` 끝에 `.githooks/* text eol=lf` 를 붙인다 (파일이 없으면 만든다).
  CRLF 로 체크아웃되면 Windows 에서 훅이 `bad interpreter` 로 죽는다.
- 실행 권한까지 스테이징한다: `git add --chmod=+x .githooks/pre-push`
- `git config core.hooksPath .githooks`

도메인 폴더는 미리 만들지 않는다. `/worklog:write` 가 첫 문서를 쓸 때 생긴다.

## 4. 마무리

커밋은 하지 않는다. 만든 파일과 다음 할 일을 알린다.

- 위 파일을 커밋해 팀에 올린다. 이 커밋은 `worklog/` 밖 변경이라 push 할 때 문서가 필요하다.
  `/worklog:write` 로 "worklog 도입" 문서를 같이 남기면 된다.
- 플러그인이 없는 팀원은 `git config core.hooksPath .githooks` 를 한 번 직접 실행한다.
