"""Golden Master 비교 — UPDATE_GOLDEN=1 시 기준 파일 갱신."""

from __future__ import annotations

import os
from pathlib import Path

_GOLDEN_ROOT = Path(__file__).resolve().parent / "golden"


def assert_matches_golden(actual: str, relative: str) -> None:
    """relative: golden/ 이하 경로 (예: d_sol_01_g1_step_a.approved.txt)."""
    path = _GOLDEN_ROOT / relative
    if os.environ.get("UPDATE_GOLDEN") == "1":
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(actual, encoding="utf-8", newline="\n")
        return
    if not path.is_file():
        raise AssertionError(f"golden missing: {path}")
    expected = path.read_text(encoding="utf-8")
    if actual == expected:
        print(f"golden matched: {relative}")
        return
    raise AssertionError(
        f"golden mismatch: {relative}\n"
        f"--- expected ---\n{expected}\n"
        f"--- actual ---\n{actual}"
    )
