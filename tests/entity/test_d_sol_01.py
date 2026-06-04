"""D-SOL-01: G1 step A — int[6] Golden Master."""

import pytest

from entity.solver import solve_step_a
from tests._approval import assert_matches_golden
from tests.golden_format import format_solve_step_ok

pytestmark = pytest.mark.entity

_GOLDEN_REL = "d_sol_01_g1_step_a.approved.txt"


def test_d_sol_01_step_a_success(grid_g1: list[list[int]]) -> None:
    result = solve_step_a(grid_g1)
    assert len(result) == 6
    assert result == [2, 2, 10, 3, 3, 7]
    actual = format_solve_step_ok(result)
    assert_matches_golden(actual, _GOLDEN_REL)
