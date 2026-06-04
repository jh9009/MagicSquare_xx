"""빈칸 좌표 탐색 — FR-LOC-01."""

from __future__ import annotations

from entity.constants import BLANK, BLANK_COUNT, SIZE

Grid = list[list[int]]
Coord = tuple[int, int]


def find_blank_coords(grid: Grid) -> list[Coord]:
    """0인 칸의 (행, 열) 1-index, row-major 스캔 순."""
    coords: list[Coord] = []
    for row_index in range(SIZE):
        for col_index in range(SIZE):
            if grid[row_index][col_index] == BLANK:
                coords.append((row_index + 1, col_index + 1))
    if len(coords) != BLANK_COUNT:
        msg = f"expected {BLANK_COUNT} blanks, found {len(coords)}"
        raise ValueError(msg)
    return coords
