---
name: write
description: Writes up the work in this push as a document under worklog/. Use it when the pre-push hook blocks a push, or right before pushing. Use for "worklog", "write a worklog", "leave a work log", "/worklog:write".
---

# worklog write

push 한 번에 기록 한 번. 같은 날 같은 도메인 문서가 이미 있으면 거기 이어 쓰고,
없으면 새로 만든다. 이미 쓰인 줄은 고치지 않고 끝에만 덧붙인다.

레포에 `worklog/README.md` 가 없으면 이 워크플로우가 깔리지 않은 레포다.
문서를 쓰지 말고 `/worklog:init` 을 먼저 하라고 알린다.

## 1. 범위 확인

이번 push 분량은 원격 어디에도 아직 없는 커밋이다. 새 브랜치든 이미 올린 브랜치든 같다.

```
git log --oneline HEAD --not --remotes
git log --format= --name-only HEAD --not --remotes | sort -u
```

## 2. 도메인 하나 고른다

`worklog/README.md` 의 도메인 표를 따른다.
표를 참고하되 절대적이진 않다. 작업 성격에 따라 유연하게 도메인을 고른다.

여러 도메인에 걸치면 변경 파일이 가장 많은 쪽 하나만 고른다. 문서는 한 개다.

## 3. 문서를 쓴다

문서 언어는 `worklog/README.md` 에 적힌 값(`Document language: English` 또는 `문서 언어: 한국어`)을 따른다.
그런 줄이 없으면 README 가 쓰인 언어를 따른다. 제목, 본문, 절 이름을 모두 그 언어로 쓴다.

오늘 날짜 문서가 그 도메인에 이미 있으면 (여러 개면 가장 최근 것) 새로 만들지 않는다.
그 파일 끝에 `## <HH:MM> <한 줄 요약>` 을 붙이고 무엇을 왜 했는지 이어 쓴다.

없으면 새로 만든다. 경로는 `worklog/<도메인>/<YYYY-MM-DD>-<슬러그>.md` 이고
슬러그는 영문 케밥케이스다. 언어에 맞는 틀을 쓴다.

English:

```markdown
# <one-line title>

- Branch: <branch>
- Commits: <short>..<short> (N)
- Key files: <file names> (1–4)

## What was done

## Why this way

## Remaining · known issues
```

한국어:

```markdown
# <한 줄 제목>

- 브랜치: <브랜치명>
- 커밋: <short>..<short> (N개)
- 주요파일: <파일명> (1~4개)

## 한 일

## 왜 이렇게 했나

## 남은 것 · 아는 문제
```

커밋 메시지와 diff 에서 실제로 읽히는 것만 쓴다. 추측으로 채우지 않는다.
"왜" 절(`Why this way` / `왜 이렇게 했나`)에 쓸 게 없으면 그 절은 지운다.

## 4. 커밋

```
git add worklog/
git commit -m "docs: worklog <슬러그>"
```

## 5. push

pre-push 훅에 막혀서 이 스킬을 실행한 경우에만, 막혔던 push 명령을 그대로 다시 실행한다.
문서가 범위에 들어갔으므로 이번엔 통과한다.

사용자가 직접 불러서 실행한 경우에는 커밋까지만 하고 push 하지 않는다.
올릴 생각이 없던 커밋까지 함께 올라가기 때문이다.
