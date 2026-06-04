"""부분 격자 1스텝 채움 — D-SOL-01 (row 단일 빈칸 가정)."""

from __future__ import annotations

from entity.constants import BLANK, MAGIC_SUM, SIZE
from entity.locator import find_blank_coords

Grid = list[list[int]]
SolveStep = list[int]


def solve_step_a(grid: Grid) -> SolveStep:
    """G1 등: 빈칸별 행 합 34로 값 결정 → [r1,c1,n1,r2,c2,n2] 1-index."""
    coords = find_blank_coords(grid)
    work = [row[:] for row in grid]
    out: SolveStep = []
    for row_1, col_1 in coords:
        row_index = row_1 - 1
        col_index = col_1 - 1
        row_total = sum(work[row_index])
        value = MAGIC_SUM - row_total + work[row_index][col_index]
        work[row_index][col_index] = value
        out.extend([row_1, col_1, value])
    if len(out) != 6:
        raise ValueError(f"expected int[6], got {len(out)} values")
    return out
