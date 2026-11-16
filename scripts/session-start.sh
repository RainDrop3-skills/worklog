#!/bin/sh
# worklog/ 가 있는 레포에서만 동작한다. 없으면 아무것도 하지 않는다.
#   1. git pre-push 훅이 켜져 있게 한다 (core.hooksPath).
#   2. 도메인별 최신 worklog 경로를 대화에 넣는다. 개수는 WORKLOG_READ_N (기본 2).

root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$root" || exit 0
[ -d worklog ] || exit 0

if [ -f .githooks/pre-push ] && [ "$(git config core.hooksPath)" != .githooks ]; then
	git config core.hooksPath .githooks
fi

n=${WORKLOG_READ_N:-2}
list=$(for d in worklog/*/; do
	ls "$d"*.md 2>/dev/null | sort -r | head -n "$n"
done)
[ -n "$list" ] || exit 0

cat <<EOF
이 레포는 worklog 를 쓴다. 작업을 시작하기 전에, 건드릴 도메인의 최신 문서를 아래에서 골라 읽는다.
직전에 무엇을 왜 했는지 모르면 이미 내린 결정을 다시 뒤집게 된다.
worklog 는 "그때 이랬다" 는 기록이라 지금도 맞다는 보장이 없다. 현재 사실은 코드와 스펙 문서로 확인한다.

$list
EOF
