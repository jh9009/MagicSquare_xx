# MagicSquare_xx

4×4 **부분 마방진** 과제에서, 빈칸을 채운 뒤 **제출 전** 행·열·대각선(10줄) 합 **34**를 빠짐없이 검증하는 학습 프로젝트입니다.

Mom Test(STEP 1)로 “프로그램을 만든다”는 표면 문제와, **검증 누락 → 채점 실패 → 장시간 우연 탐색**이라는 진짜 문제를 분리한 뒤, 검증 규칙·PRD·Test Loop 스코프를 정의합니다.

---

## 도메인

| 항목 | 값 |
|------|-----|
| 격자 | 4×4 |
| 빈칸 | `0` (과제 예: 2개) |
| 숫자 | 1~16 (완성 시 각 1회) |
| 마법 상수 | **34** |
| 검증 줄 | **10개** — R1–R4, C1–C4, ↘, ↙ |

**제출 전 체크리스트:** `R1 R2 R3 R4 | C1 C2 C3 C4 | ↘ ↙`

---

## 진짜 문제 (Mom Test 요약)

> 마방진 조건을 알고 있어도 제출 직전에 검증 항목(특히 대각선)을 빠뜨리고, 채점 실패 후 약 20분을 들여 우연히 누락을 찾아야 하는 불편이 반복된다.

**이번에 하지 않는 것:** Solver, MissingFinder, GridUI, ECB 전체 일괄 구현

---

## 문서

| 경로 | 설명 |
|------|------|
| [Report/01.MagicSquare_ProblemDefinition_Report.md](Report/01.MagicSquare_ProblemDefinition_Report.md) | Mom Test 인터뷰, 질문 뱅크, 세션3 워크북 |
| [docs/PRD.md](docs/PRD.md) | 요구사항, FR/AC, Rule, 마일스톤 |
| [Prompt/01.MagicSquare_ProblemDefinition_Report.prompt](Prompt/01.MagicSquare_ProblemDefinition_Report.prompt) | 에이전트·구현 시 제약 프롬프트 |

---

## 현재 단계

| Phase | 상태 | 내용 |
|-------|------|------|
| **P0** | ✅ | Mom Test · 문제 정의 문서 |
| **P1** | ⏳ | `validate` + Test Loop (T1~T3) |
| **P2** | — | SquareValidator (Control) |
| **P3** | — | Solver, Boundary (별도 PRD) |

---

## 저장소

https://github.com/jh9009/MagicSquare_xx

---

## 로컬에서 시작하기

```powershell
git clone https://github.com/jh9009/MagicSquare_xx.git
Set-Location MagicSquare_xx
```

구현(P1) 이후 예정 명령:

```powershell
# validate <grid>   — 10줄 합 검사
# checklist       — 체크리스트 출력
# test            — 자동 테스트
```

---

## 라이선스

교육용 프로젝트. 라이선스 미정 시 저장소 소유자 정책을 따릅니다.
