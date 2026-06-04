# MagicSquare_xx

4×4 **부분 마방진** 과제에서, 빈칸을 채운 뒤 **제출 전** 행·열·대각선(10줄) 합 **34**를 빠짐없이 검증하는 학습 프로젝트입니다.

Mom Test(STEP 1)로 표면 문제(프로그램 일괄 구현)와 **검증 누락 → 채점 실패 → 장시간 우연 탐색**이라는 진짜 문제를 분리했습니다.  
구현은 **ECB + Dual-Track TDD**로 진행합니다.

---

## 도메인

| 항목 | 값 |
|------|-----|
| 격자 | 4×4 |
| 빈칸 | `0` (**정확히 2개**) |
| 숫자 | 1~16 (완성 시 각 1회) |
| 마법 상수 | **34** (`entity/constants.py` SSOT) |
| 검증 줄 | **10개** — R1–R4, C1–C4, ↘, ↙ |
| 정답 출력 | `int[6]` = `[r1,c1,n1,r2,c2,n2]` — 좌표 **1-index** |

**제출 전 체크리스트:** `R1 R2 R3 R4 | C1 C2 C3 C4 | ↘ ↙`

---

## 프로젝트 구조

```
MagicSquare_xx/
├── src/
│   ├── entity/          # constants, locator, solver
│   ├── control/         # (P1) line_sums, validator
│   └── boundary/        # (P1) E001~E007, input_validator
├── tests/
│   ├── conftest.py      # grid_g1 fixture
│   ├── _approval.py     # Golden Master 비교
│   ├── golden_format.py # int[6] / ERR 직렬화
│   ├── golden/          # *.approved.txt
│   ├── entity/          # D-LOC-01, D-SOL-01
│   ├── control/         # (예정) D-VAL-*
│   └── boundary/        # (예정) U-IN-*
├── scripts/
│   └── verify_green_entity.ps1
├── docs/PRD.md
├── Report/              # 01~07 세션 보고서
├── Prompting/           # 01~03 Transcript Export
└── .cursor/
    ├── skills/magic-square-tdd/
    ├── commands/        # tdd-red, review-ecb
    ├── hooks.json       # 비활성 (hooks: {})
    └── hooks.enabled.json  # Hook 백업 (재활성용)
```

**의존 방향:** `boundary → control → entity` (entity는 상위 레이어 import 금지)

---

## 현재 Phase — entity GREEN + Golden

| Track | Layer | Test ID | 상태 |
|-------|-------|---------|------|
| Logic | entity | **D-LOC-01** | ✅ GREEN — `find_blank_coords` → `[(2,2),(3,3)]` |
| Logic | entity | **D-SOL-01** | ✅ GREEN + **Golden matched** |
| Logic | control | D-VAL-01~03 | ⏳ 미구현 |
| UI | boundary | U-IN-01~03 | ⏳ 미구현 |

테스트 ID: [`.cursor/skills/magic-square-tdd/reference.md`](.cursor/skills/magic-square-tdd/reference.md)

---

## 로컬에서 시작하기

```powershell
git clone https://github.com/jh9009/MagicSquare_xx.git
Set-Location MagicSquare_xx

# 가상환경 (권장)
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
python -m pip install -e ".[dev]"
```

### entity GREEN · Golden 한 번에 검증

```powershell
.\scripts\verify_green_entity.ps1
```

### pytest (개별)

```powershell
# entity 전체 (현재 2건)
python -m pytest tests/entity/ -v

# D-LOC-01
python -m pytest tests/entity/test_d_loc_01.py::test_d_loc_01_blank_coords_row_major -v

# D-SOL-01 + golden matched 메시지
python -m pytest tests/entity/test_d_sol_01.py::test_d_sol_01_step_a_success -v -s
```

Golden 기준 파일 갱신 (포맷·구현 변경 시만):

```powershell
$env:UPDATE_GOLDEN = "1"
python -m pytest tests/entity/test_d_sol_01.py::test_d_sol_01_step_a_success -v
Remove-Item Env:UPDATE_GOLDEN
```

**TDD 규칙:** `skip`·`xfail`·assert 완화 금지. RED 단계는 의도적 `FAILED` / `pytest.fail`.

### Cursor

| 리소스 | 용도 |
|--------|------|
| `.cursorrules` | 도메인·ECB·TDD 헌법 |
| `/tdd-red` | RED 단계 |
| `/review-ecb` | 계약 리뷰 (읽기 전용) |
| `.cursor/hooks.json` | **비활성** (`hooks: {}`) — 콘솔 창 이슈로 Hook 끔 |
| `.cursor/hooks.enabled.json` | Hook 설정 백업 (필요 시 `hooks.json`으로 복원) |

Hook 스크립트(`.cursor/hooks/*.sh`)는 보관만 하며 **자동 실행되지 않습니다.** 상세: [Report/07](Report/07.MagicSquare_Hooks_Disabled_Report.md).

---

## 문서

| 경로 | 설명 |
|------|------|
| [Report/01.MagicSquare_ProblemDefinition_Report.md](Report/01.MagicSquare_ProblemDefinition_Report.md) | Mom Test · 문제 정의 |
| [docs/PRD.md](docs/PRD.md) | FR/AC, T1~T3 |
| [Report/03.MagicSquare_Session3_Cursor_Design_Report.md](Report/03.MagicSquare_Session3_Cursor_Design_Report.md) | Cursor 8계층 |
| [Report/04.MagicSquare_D_LOC01_RED_Skeleton_Report.md](Report/04.MagicSquare_D_LOC01_RED_Skeleton_Report.md) | D-LOC-01 RED |
| [Report/05.MagicSquare_GREEN_PASS_Entity_Report.md](Report/05.MagicSquare_GREEN_PASS_Entity_Report.md) | GREEN PASS 게이트 |
| [Report/06.MagicSquare_Entity_GREEN_Golden_Report.md](Report/06.MagicSquare_Entity_GREEN_Golden_Report.md) | GREEN · Golden 세션 |
| [Report/07.MagicSquare_Hooks_Disabled_Report.md](Report/07.MagicSquare_Hooks_Disabled_Report.md) | Cursor Hooks 비활성화 |
| [Prompting/03.MagicSquare_Session5_Export_Transcript.md](Prompting/03.MagicSquare_Session5_Export_Transcript.md) | 세션 5 Transcript |

---

## 마일스톤

| Phase | 상태 | 내용 |
|-------|------|------|
| **P0** | ✅ | Mom Test · PRD · Harness |
| **P1** | ⏳ | entity D-LOC/D-SOL GREEN · control/boundary RED 대기 |
| **P2** | — | SquareValidator · 10줄 검증 |
| **P3** | — | Boundary UI, Solver 확장 |

**Non-Goals:** GridUI, ECB 일괄 구현 (명시 요청 전)

---

## 저장소

https://github.com/jh9009/MagicSquare_xx

브랜치 예: `main`, `red`, `green` — 최신 entity GREEN은 로컬 `green` 브랜치에 있을 수 있음.

---

## 라이선스

교육용 프로젝트. 라이선스 미정 시 저장소 소유자 정책을 따릅니다.
