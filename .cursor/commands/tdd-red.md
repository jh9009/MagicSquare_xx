# TDD RED — 실패 테스트 먼저

**MagicSquare_xx** (4×4 부분 마방진) Dual-Track TDD — **RED 단계만**.  
구현(`src/`)은 건드리지 않는다. `.cursorrules` · 테스트 ID: `.cursor/skills/magic-square-tdd/reference.md`

---

## 필수 선언

응답 **첫 줄** (그대로 출력):

```
Phase: red | Layer: <entity|control|boundary> | Track: <Logic|UI>
```

| Track | Layer | 테스트 파일 |
|-------|-------|-------------|
| Logic | entity, control | `tests/entity/test_d_*.py`, `tests/control/test_d_*.py` |
| UI | boundary | `tests/boundary/test_u_*.py` |

---

## 절차

1. **테스트 ID 확인** — `reference.md`의 `D-*`(Logic) 또는 `U-*`(UI) 선택·없으면 제안
2. **실패 이유** — docstring에 “왜 FAIL이어야 하는지” 한 문장 (예: PRD T1, ↘ 합 36)
3. **AAA 테스트 작성** — Arrange(fixture 4×4) · Act(호출 대상 import) · Assert(기대 FAIL 조건)
4. **파일 위치** — Layer에 맞는 `tests/<layer>/test_d_*.py` 또는 `test_u_*.py`
5. **마커** — `@pytest.mark.entity` / `control` / `boundary` (Track와 일치)
6. **pytest 실행** — 아래 bash; **의도적 FAIL** 확인 (통과 = RED 실패)
7. **보고** — § 보고 형식

---

## pytest 예시 (bash)

```bash
cd MagicSquare_xx
pip install -e ".[dev]"

# 방금 만든 RED 테스트 1파일
pytest tests/control/test_d_val_01_wrong_diagonal.py -v

# Logic Track RED (entity + control)
pytest tests/entity tests/control -v --tb=short

# UI Track RED (boundary만)
pytest tests/boundary/test_u_*.py -v
```

**RED 성공 기준:** `FAILED` 또는 `ImportError`/`ModuleNotFoundError`(아직 `src/` 없음).  
**RED 실패(잘못됨):** `PASSED` → assert·fixture 수정, 구현 추가 금지.

---

## 보고

| 항목 | 내용 |
|------|------|
| 테스트 ID | 예: `D-VAL-01` |
| FAIL 요약 | pytest 마지막 1~3줄 (AssertionError / ImportError) |
| 변경 파일 | `tests/` 아래 경로만 나열 |

**한국어**로 짧게. GREEN·REFACTOR·`src/` 변경은 다음 단계로 넘김.

---

## 금지

| 금지 | 이유 |
|------|------|
| `src/` 수정 | RED = 테스트만 |
| Logic Track에서 Domain Mock | `.cursorrules` — 실제 타입·fixture 격자 |
| assert 완화·`skip`·`xfail`·빈 `pass` | 우회 GREEN |
| `34`/`16` 리터럴 산재 | RED에서도 fixture는 MagicConstant 또는 상수 모듈 import |
| entity가 E001~E005 처리 테스트 | boundary 책임 |
| git commit / push | 사용자 요청 시만 |
