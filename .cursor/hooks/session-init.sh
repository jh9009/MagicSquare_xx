#!/usr/bin/env bash
# MagicSquare_xx — sessionStart hook
# Reads stdin JSON (ignored for static context), outputs hook response via _python.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Consume hook input (session_id, composer_mode, ...)
cat >/dev/null

read -r -d '' ADDITIONAL_CONTEXT <<'CTX' || true
## MagicSquare_xx (MagicSquare_1004) — Session Context

**프로젝트:** 4×4 부분 마방진 · **Dual-Track TDD** · **ECB** (boundary → control → entity)

### SSOT (Rule)
- **헌법:** `.cursorrules` — 도메인·ECB·TDD·Non-Goals의 단일 기준
- 격자 4×4, 빈칸 `0` 정확히 2개, 값 1~16, 마방진 상수 **34**
- 출력 `int[6]` = [r1,c1,n1,r2,c2,n2], 좌표 **1-index**
- 10줄 검증: R1–R4 | C1–C4 | ↘ ↙ (대각선 2개 필수)
- E001~E007 → boundary; entity는 E001~E005 **처리 금지**
- Logic Track: Domain Mock 금지 / UI Track: Mock 허용
- TDD: RED → GREEN → REFACTOR (skip·xfail·assert 완화 금지)
- 작업 시작 선언: `Phase: RED|GREEN|REFACTOR | Layer: entity|control|boundary | Track: Logic|UI`

### 문서
- `docs/PRD.md`, `Report/01.MagicSquare_ProblemDefinition_Report.md`
- Skill: `.cursor/skills/magic-square-tdd/SKILL.md` · D-* ID: `reference.md`

### 슬래시 Command (프로젝트)
| Command | 용도 |
|---------|------|
| `/tdd-red` | RED만 — 실패 테스트 먼저, `tests/`만, `src/` 금지 |

### Harness
- `pytest` — `pip install -e ".[dev]"` 후 `pytest tests/ -v`
- 테스트 파일: `test_d_*` (Logic), `test_u_*` (UI)

### git
- commit / push — **사용자 명시 요청 시만**
CTX

export ADDITIONAL_CONTEXT
export HOOK_ENV_JSON='{"MAGIC_SQUARE_PROJECT":"MagicSquare_xx","MAGIC_SQUARE_ALIAS":"MagicSquare_1004"}'

exec "${SCRIPT_DIR}/_python.sh"
