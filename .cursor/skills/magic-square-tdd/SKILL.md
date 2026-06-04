---
name: magic-square-tdd
description: MagicSquare_xx Dual-Track TDD·ECB 개발 시 Agent가 따를 절차
---

# MagicSquare_xx — Dual-Track TDD Skill

4×4 부분 마방진(빈칸 `0`×2, 1~16, 합 34)을 **ECB + Dual-Track TDD**로 구현할 때 이 Skill을 따른다.  
헌법: `.cursorrules` · 요구사항: `docs/PRD.md` · 테스트 ID: [reference.md](reference.md)

---

## 언제 이 Skill을 켜는지

| 켜기 (적용) | 끄기·보류 |
|-------------|-----------|
| `test_d_*` / `test_u_*` 작성·수정 요청 | Mom Test 인터뷰만 (불편·과거 행동) |
| `src/entity` · `control` · `boundary` 구현·리팩터 | Solver / GridUI / ECB 일괄 생성 (명시 요청 전) |
| RED / GREEN / REFACTOR 단계 명시 또는 TDD 사이클 요청 | git commit·push (사용자 **명시 요청** 전) |
| SquareValidator · MagicConstant · 10줄 검증 | 문서만 편집 (Report/PRD)且无 테스트 |

작업 **시작 시 한 줄 선언** (필수):

`Phase: RED|GREEN|REFACTOR | Layer: entity|control|boundary | Track: Logic|UI`

---

## Logic Track vs UI Track

| | **Logic Track** | **UI Track** |
|---|-----------------|--------------|
| **레이어** | entity, control | boundary |
| **테스트 ID** | `D-*` | `U-*` |
| **파일** | `tests/entity/test_d_*.py`, `tests/control/test_d_*.py` | `tests/boundary/test_u_*.py` |
| **pytest 마커** | `@pytest.mark.entity` / `control` | `@pytest.mark.boundary` |
| **Mock** | **Domain Mock 금지** — 실제 타입·순수 함수·fixture 격자 | **Mock 허용** — stdin/stdout, 표시 스텁 |
| **검증 초점** | 10줄 합 34, MagicConstant SSOT, 도메인 무결성 | E001~E007, `int[6]` 1-index 출력, I/O 형식 |

---

## ECB · Mock · E001~E007

### 의존 방향

```
boundary → control → entity
```

| 규칙 | 내용 |
|------|------|
| entity | `control` / `boundary` **import 금지** (`entity → *` 금지) |
| control | **entity만** 사용; boundary 로직 중복 금지 |
| boundary | control 호출; I/O·에러 매핑 |

### E001~E007

| 코드 | 담당 | entity |
|------|------|--------|
| E001~E007 | **boundary** 정의·발행 | E001~E005 **처리·변환 금지** |
| (도메인 내부) | control / entity | boundary 통과 후 데이터 무결성만 |

### Mock 허용/금지

| 허용 | 금지 |
|------|------|
| boundary: 입출력·CLI 스텁 | Logic Track에서 MagicSquare/Validator **가짜 객체**로 통과 |
| UI Track에서 `pytest` capsys 등 | assert 완화, `skip`, `xfail`, 빈 `pass`로 GREEN |

---

## Phase: RED (5~7단계)

1. **선언** — `Phase: RED | Layer: … | Track: Logic|UI`
2. **테스트 ID** — [reference.md](reference.md)에서 `D-*` / `U-*` 선택 (없으면 추가 제안)
3. **실패 이유 문장화** — docstring에 “무엇이 왜 실패해야 하는지” (예: ↘ 합 36 → FAIL)
4. **파일 생성** — `test_d_*.py` 또는 `test_u_*.py` (구현 **아직 없거나** 스텁)
5. **fixture** — 4×4 격자 fixture; 상수는 **MagicConstant만** (리터럴 34/16 산재 금지)
6. **pytest 실행** — § Test/Review Loop “RED 후” 명령
7. **확인** — **의도적 실패** 확인 (ImportError / AssertionError). 통과하면 RED 아님 → 테스트 수정

---

## Phase: GREEN (5~7단계)

1. **선언** — `Phase: GREEN | Layer: … | Track: …`
2. **최소 구현** — 해당 Layer만 수정 (다른 Layer 선행 구현 금지)
3. **SSOT** — `34`, `16`, `4`, 빈칸 `2` → MagicConstant (또는 합의 SSOT 모듈)
4. **ECB 준수** — import 방향·E001~E005 entity 금지 재확인
5. **Logic Track** — Domain Mock 없이 실제 호출로 통과
6. **pytest** — § “GREEN 후” (해당 파일 → 점진적 확대)
7. **확인** — RED에서 실패하던 테스트 **동일 조건**으로 통과. skip/xfail 추가 금지

---

## Phase: REFACTOR (5~7단계)

1. **선언** — `Phase: REFACTOR | Layer: … | Track: …`
2. **전제** — 현재 RED+GREEN 대상 테스트 **전부 통과** 상태
3. **범위** — 중복 제거, 이름·SSOT·의존 정리 (**동작 변경 없음**)
4. **금지** — assert 완화, 테스트 삭제로 통과, public API 임의 변경
5. **ECB** — entity→상위 import 생기지 않았는지 grep 수준 확인
6. **pytest** — § “REFACTOR 후” (전체 Logic 또는 UI 트랙)
7. **확인** — diff는 구조만; 실패 테스트 0개

---

## Test/Review Loop — pytest 언제 돌리는지

작업 디렉터리: `MagicSquare_xx` 루트. 사전: `pip install -e ".[dev]"`

| 시점 | 명령 | 기대 |
|------|------|------|
| **RED 직후** | `pytest <새 test 파일> -v` | **실패** (RED 성공) |
| **GREEN 직후** | `pytest <해당 Layer tests/> -v` | 해당 테스트 **통과** |
| **REFACTOR 직후** | `pytest tests/entity tests/control -v` (Logic) 또는 `pytest tests/boundary -v` (UI) | 전 트랙 **통과** |
| **세션 마감** | `pytest tests/ -v` | 수집된 테스트 전부 통과 (0 collected면 RED 미작성) |
| **회귀 의심** | `pytest tests/ -v --tb=short` | 실패 시 Layer/Track 선언과 함께 보고 |

**Dual-Track 순서 (권장):** control `D-VAL-*` RED → GREEN → entity SSOT → boundary `U-*` (UI Mock 허용)

**PRD T1~T3 매핑:** T1↘36 → `D-VAL-01` · T2 정답 → `D-VAL-02` · T3 빈칸 → `D-VAL-03`

---

## 완료 보고 항목

세션·Phase 종료 시 **한국어**로 아래를 포함한다.

| # | 항목 |
|---|------|
| 1 | `Phase / Layer / Track` 선언 (실제 수행값) |
| 2 | 변경 파일 목록 (`src/…`, `tests/…`) |
| 3 | 적용 테스트 ID (`D-*` / `U-*`) |
| 4 | pytest 명령 + 결과 (passed / failed / collected N) |
| 5 | RED였다면 **실패 메시지 한 줄** (의도적 실패 증거) |
| 6 | ECB 위반 여부 (import · E001~E005 · Mock) |
| 7 | 미완료·다음 Phase (예: GREEN 대기, `D-VAL-02` 미작성) |

**하지 않음:** git commit/push (사용자 요청 시만) · Solver/UI 일괄 구현 · “행·열만 맞으면 완료” 선언

---

## 참고

- 테스트 ID 목록: [reference.md](reference.md)
- Mom Test 진짜 문제: 제출 전 **10줄(↘↙ 포함)** 검증 누락 방지
