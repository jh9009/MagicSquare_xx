"""공용 fixture — G1 격자 (로직 없음)."""

from __future__ import annotations

import sys
from pathlib import Path

import pytest

# tests/entity/ 와 src/entity/ 패키지 이름 충돌 방지
_SRC = Path(__file__).resolve().parent.parent / "src"
_src_str = str(_SRC)
if _src_str in sys.path:
    sys.path.remove(_src_str)
sys.path.insert(0, _src_str)
if "entity" in sys.modules:
    del sys.modules["entity"]

from entity.constants import BLANK

# G1: 0 × 2, 1-index (2,2)·(3,3), row-major
G1_GRID: list[list[int]] = [
    [16, 3, 2, 13],
    [5, BLANK, 11, 8],
    [9, 6, BLANK, 12],
    [4, 15, 14, 1],
]


@pytest.fixture
def grid_g1() -> list[list[int]]:
    return [row[:] for row in G1_GRID]
