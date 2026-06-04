# Review ECB — 계약·아키텍처 리뷰

**MagicSquare_xx** ECB·Dual-Track **계약 위반만** 검사한다.  
**코드 수정 금지** — 읽기·grep·표 보고만. `.cursorrules` · `docs/PRD.md`

---

## 필수 선언

응답 **첫 줄**:

```
Phase: review | Scope: ECB·contract | Track: Logic+UI
```

---

## 절차

1. 범위 확인 — 사용자가 지정한 경로, 없으면 `src/`, `tests/` 전체
2. **읽기만** — 파일 내용·import·테스트 Mock 패턴 수집
3. 아래 **5개 체크** 각각 표로 판정
4. 위반만 **상세 표** (파일·줄·규칙·설명)
5. **요약 표** — 체크별 PASS / FAIL / N/A
6. 수정 제안은 **다음 단계**로 분리 (이 Command에서 구현하지 않음)

---

## 체크 항목 (계약)

| # | 체크 | PASS 기준 |
|---|------|-----------|
| C1 | **import 방향** | `boundary → control → entity` 만. entity가 control/boundary import **없음**. control이 boundary import **없음** |
| C2 | **entity · E001~E005** | entity/tests/entity에 E001~E005 발행·처리·테스트 **없음**. E001~E007은 boundary |
| C3 | **int[6] · 1-index** | 정답 형식 `[r1,c1,n1,r2,c2,n2]`, 좌표 **1~4** (0-index 금지). boundary 출력·문서 일치 |
| C4 | **MagicConstant SSOT** | `34`, `16`, `4`, 빈칸 `2` — MagicConstant(또는 SSOT 모듈) 경유. src/tests에 **산재 리터럴** 없음 |
| C5 | **Logic Track · Domain Mock** | `tests/entity`, `tests/control`에서 MagicSquare/Validator 등 **가짜 Domain Mock** 없음. fixture·실타입만 |

**N/A:** 해당 Layer/파일 없음 → `N/A (미구현)` 표기, FAIL 아님.

---

## 출력 형식 (표만)

### 1) 요약

| 체크 | 결과 | 위반 수 |
|------|------|---------|
| C1 import 방향 | PASS / FAIL / N/A | n |
| C2 entity E001~E005 | PASS / FAIL / N/A | n |
| C3 int[6] 1-index | PASS / FAIL / N/A | n |
| C4 MagicConstant SSOT | PASS / FAIL / N/A | n |
| C5 Logic Domain Mock | PASS / FAIL / N/A | n |

### 2) 위반 상세 (FAIL일 때만)

| ID | 체크 | 파일:줄 | 위반 내용 | 심각도 |
|----|------|---------|-----------|--------|
| V-01 | C1 | `src/entity/foo.py:3` | `from control import ...` | 높음 |

위반 **0건**이면: 「ECB·계약 위반 없음 (범위: …)」

### 3) 보고 (한국어, 3줄 이내)

- 검사 범위
- FAIL 체크 번호 목록
- 다음 권장 (예: RED `D-VAL-01`, boundary E00x 매핑) — **코드 패치 없음**

---

## 검사 힌트 (읽기용)

```bash
# import 방향 (예시)
rg "^(from|import)\s+(control|boundary)" src/entity
rg "^(from|import)\s+boundary" src/control

# E001~E005 in entity
rg "E00[1-5]" src/entity tests/entity

# 산재 리터럴 (MagicConstant 없을 때)
rg "\b34\b|\b16\b" src tests --glob "*.py"

# Logic Mock 흔적
rg "Mock|MagicMock|@patch" tests/entity tests/control
```

---

## 금지

| 금지 | 이유 |
|------|------|
| **모든 코드 수정** | 리뷰 Command |
| `src/`·`tests/` 자동 패치 | 계약 검사만 |
| pytest 실행 필수 아님 | 정적 계약 중심 (요청 시만) |
| Solver/UI 일괄 설계 제안 | Non-Goals |
| git commit / push | 사용자 요청 시만 |
