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
| 마법 상수 | **34** (`MagicConstant` SSOT) |
| 검증 줄 | **10개** — R1–R4, C1–C4, ↘, ↙ |
| 정답 출력 | `int[6]` = `[r1,c1,n1,r2,c2,n2]` — 좌표 **1-index** |

**제출 전 체크리스트:** `R1 R2 R3 R4 | C1 C2 C3 C4 | ↘ ↙`

---

## 프로젝트 구조

```
MagicSquare_xx/
├── src/
│   ├── entity/          # MagicConstant, locator, 도메인 예외
│   ├── control/         # line_sums, validator, ValidationResult
│   └── boundary/        # ErrorCode E001~E007, input_validator
├── tests/
│   ├── conftest.py      # G1, T1~T3 격자 fixture
│   ├── entity/          # Logic Track D-ENT-*, D-LOC-*
│   ├── control/         # Logic Track D-CTL-*, D-VAL-*
│   └── boundary/        # UI Track U-IN-*
├── docs/PRD.md
├── .cursorrules
└── .cursor/skills/magic-square-tdd/
```

**의존 방향:** `boundary → control → entity` (entity는 상위 레이어 import 금지)

---

## Dual-Track TDD · RED 스켈레톤

| Track | Layer | ID 접두 | 테스트 | Mock |
|-------|-------|---------|--------|------|
| **Logic** | entity, control | `D-*` | `test_d_*.py` | Domain Mock **금지** |
| **UI** | boundary | `U-*` | `test_u_*.py` | control 호출 Mock **허용** |

현재 **Phase: RED** — `src/`는 스켈레톤(의도적 미구현·오답 반환), 대부분 테스트는 **FAIL**이 정상입니다.  
`D-ENT-01`(`MagicConstant`)만 SSOT 상수로 **통과**합니다.

### Logic Track (RED)

| Test ID | 파일 | 기대 (GREEN 후) |
|---------|------|-----------------|
| D-ENT-01 | `test_d_magic_constant.py` | SSOT 상수 ✅ |
| D-LOC-01~03 | `test_d_loc_01.py` | G1 빈칸 좌표 row-major |
| D-CTL-01 | `test_d_line_sums.py` | 10줄 합 |
| D-VAL-01 | `test_d_val_01_wrong_diagonal.py` | T1 ↘36 → FAIL |
| D-VAL-02 | `test_d_val_02_all_lines_pass.py` | T2 → PASS |
| D-VAL-03 | `test_d_val_03_incomplete_blank.py` | T3 → INCOMPLETE |

### Boundary Track (RED)

| Test ID | 파일 | 기대 (GREEN 후) |
|---------|------|-----------------|
| U-IN-01 | `test_u_in_01.py` | `grid=None` → E003 |
| U-IN-02 | 동일 | 3×4 → E001 |
| U-IN-03 | 동일 | 빈칸 0개 → E002 |

테스트 ID 전체: [`.cursor/skills/magic-square-tdd/reference.md`](.cursor/skills/magic-square-tdd/reference.md)

---

## 로컬에서 시작하기

```powershell
git clone https://github.com/jh9009/MagicSquare_xx.git
Set-Location MagicSquare_xx
python -m pip install -e ".[dev]"
```

### pytest

```powershell
# 전체 (RED: 다수 FAILED가 정상)
python -m pytest tests/ -v

# Logic Track만
python -m pytest tests/entity tests/control -v

# Boundary Track만
python -m pytest tests/boundary -v

# 대표 RED 1건 (Mom Test T1)
python -m pytest tests/control/test_d_val_01_wrong_diagonal.py -v

# 빈칸 좌표 RED
python -m pytest tests/entity/test_d_loc_01.py::test_d_loc_01_blank_coords_row_major -v

# boundary 입력 RED
python -m pytest tests/boundary/test_u_in_01.py::test_u_in_01_null_grid_returns_e003 -v
```

**RED 성공 기준:** 의도한 테스트가 `FAILED` / `AssertionError`. `skip`·`xfail`·assert 완화 금지.

### Cursor

| 리소스 | 용도 |
|--------|------|
| `.cursorrules` | 도메인·ECB·TDD 헌법 |
| `/tdd-red` | RED 단계 절차 |
| `/review-ecb` | 계약 리뷰 (읽기 전용) |

---

## 문서

| 경로 | 설명 |
|------|------|
| [Report/01.MagicSquare_ProblemDefinition_Report.md](Report/01.MagicSquare_ProblemDefinition_Report.md) | Mom Test · 문제 정의 |
| [docs/PRD.md](docs/PRD.md) | FR/AC, T1~T3, 마일스톤 |
| [Report/03.MagicSquare_Session3_Cursor_Design_Report.md](Report/03.MagicSquare_Session3_Cursor_Design_Report.md) | Cursor 8계층 설계 |

---

## 마일스톤

| Phase | 상태 | 내용 |
|-------|------|------|
| **P0** | ✅ | Mom Test · PRD · Harness |
| **P1** | ⏳ | RED 스켈레톤 → GREEN `validate` + T1~T3 |
| **P2** | — | SquareValidator · Entity 연동 |
| **P3** | — | Solver, Boundary UI (별도 PRD) |

**Non-Goals:** Solver, GridUI, ECB 일괄 구현 (명시 요청 전)

---

## 저장소

https://github.com/jh9009/MagicSquare_xx

---

## 라이선스

교육용 프로젝트. 라이선스 미정 시 저장소 소유자 정책을 따릅니다.
