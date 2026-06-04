"""Golden Master 직렬화 — 포맷 고정 (수동 편집·우회 금지)."""

from __future__ import annotations

SolveStep = list[int]


def format_solve_step_ok(result: SolveStep) -> str:
    """성공: int[6] 1-index — STATUS=OK + RESULT= comma-separated."""
    if len(result) != 6:
        raise ValueError(f"int[6] required, got {len(result)}")
    body = ",".join(str(x) for x in result)
    return f"STATUS=OK\nRESULT={body}\n"


def format_error(code: str) -> str:
    """실패: boundary 스타일 에러 문자열 (golden용)."""
    return f"STATUS=ERR\nCODE={code}\n"
