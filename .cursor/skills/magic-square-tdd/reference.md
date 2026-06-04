# D-* 테스트 ID (Logic Track)

| ID | Layer | 파일(예) | 시나리오 |
|----|-------|----------|----------|
| D-ENT-01 | entity | `tests/entity/test_d_magic_constant.py` | MagicConstant SSOT — 34, 16, 4, blank_count=2 |
| D-LOC-01 | entity | `tests/entity/test_d_loc_01.py` | G1 — 빈칸 (2,2),(3,3) row-major 1-index ✅ GREEN |
| D-SOL-01 | entity | `tests/entity/test_d_sol_01.py` | G1 step A — int[6] + Golden ✅ GREEN |
| D-ENT-02 | entity | `tests/entity/test_d_cell_grid.py` | 4×4 격자, 0×2, 1~16 범위 |
| D-CTL-01 | control | `tests/control/test_d_line_sums.py` | 10줄(행4·열4·↘·↙) 합 계산 |
| D-VAL-01 | control | `tests/control/test_d_val_01_wrong_diagonal.py` | PRD T1 — ↘ 합 36 → FAIL, 줄 식별 |
| D-VAL-02 | control | `tests/control/test_d_val_02_all_lines_pass.py` | PRD T2 — 10줄 합 34 → PASS |
| D-VAL-03 | control | `tests/control/test_d_val_03_incomplete_blank.py` | PRD T3 — 0 포함 → INCOMPLETE |

> UI Track `U-*`는 boundary 구현 시 별도 추가 (`U-CLI-01`, `U-ERR-01` 등).
