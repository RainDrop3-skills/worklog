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

- **기준 브랜치** — 새 브랜치를 처음 push 할 때 어디서 갈라졌는지 비교할 원격 브랜치.
  `git symbolic-ref --short refs/remotes/origin/HEAD` 를 기본값으로 제안한다.
  PR 을 `develop` 같은 통합 브랜치로 모은다면 그쪽이다.
- **도메인** — 폴더 이름이 아니라 "누가 그 기록을 읽는가" 로 나눈다.
  1. 팀이 일을 어떻게 나눠 맡는지 먼저 묻는다 (예: 프론트·백엔드·AI 담당).
     혼자 쓰는 레포면 작업 성격으로 나눈다 (예: 화면, 서버, 데이터).
  2. 레포 구조를 본다. 최상위가 `apps/`, `packages/`, `services/` 같은 묶음 폴더면 한 단계 더 들어가 본다.
  3. 둘을 합쳐 도메인 3~5개와 경로 매핑을 제안한다. 한 도메인에 여러 경로가 묶여도 된다
     (예: `backend/`, `db/`, `docker/` → `be`). 이름은 짧은 영문 소문자다 (예: `fe`, `be`, `ai`).
     어디에도 안 맞는 변경용으로 `etc` 를 둔다.
- **문서 언어** — `English` 또는 `한국어`. 기본은 `English` 다.
  worklog 문서, `worklog/README.md`, push 를 막을 때 나오는 안내가 이 언어로 나온다.

기준 브랜치, 도메인 매핑 표, 문서 언어를 한 번에 보여 준다. 사용자가 고치면 반영해 다시 보여 주고,
승인하면 그 값으로 3 을 진행한다.

## 3. 파일을 깐다

- `templates/README.en.md` (English) 또는 `templates/README.ko.md` (한국어) → `worklog/README.md`.
  `{{DOMAINS}}` 자리를 도메인 표 행으로 바꾼다. 예: `` | `frontend/` | `fe` | ``
- `templates/pre-push` → `.githooks/pre-push`. `base_branch=` 값을 2 에서 정한 브랜치로,
  `lang=` 값을 `en` 또는 `ko` 로 바꾼다.
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
