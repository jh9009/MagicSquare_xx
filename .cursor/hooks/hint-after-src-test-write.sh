#!/usr/bin/env bash
# postToolUse (Write) — src/ or tests/ 편집 후 pytest 힌트 + flag 터치

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
STATE_DIR="${SCRIPT_DIR}/state"
FLAG_FILE="${STATE_DIR}/touched_src_tests.flag"

input="$(cat)"

export ROOT_DIR="${ROOT_DIR}"
export STATE_DIR="${STATE_DIR}"
export FLAG_FILE="${FLAG_FILE}"
export HOOK_INPUT="${input}"

HINT="$(
  python3 <<'PY'
import json
import os
import sys
from pathlib import Path

raw = os.environ.get("HOOK_INPUT", "")
if not raw.strip():
    sys.exit(0)

try:
    data = json.loads(raw)
except json.JSONDecodeError:
    sys.exit(0)

if data.get("tool_name") != "Write":
    sys.exit(0)

ti = data.get("tool_input") or {}
path = (
    ti.get("path")
    or ti.get("file_path")
    or ti.get("target_path")
    or ""
)
path = str(path).replace("\\", "/").lstrip("./")


def under(prefix: str) -> bool:
    return path.startswith(prefix) or f"/{prefix}" in f"/{path}/"


if not (under("src/") or under("tests/")):
    sys.exit(0)

state_dir = Path(os.environ["STATE_DIR"])
flag = Path(os.environ["FLAG_FILE"])
state_dir.mkdir(parents=True, exist_ok=True)
flag.touch()

if under("tests/control") or under("src/control"):
    scope, cmd = "control", "pytest tests/control -q --tb=short -x"
elif under("tests/entity") or under("src/entity"):
    scope, cmd = "entity", "pytest tests/entity -q --tb=short -x"
elif under("tests/boundary") or under("src/boundary"):
    scope, cmd = "boundary", "pytest tests/boundary -q --tb=short -x"
elif under("tests/"):
    scope, cmd = "tests", "pytest tests/ -q --tb=short"
else:
    scope, cmd = "src", "pytest tests/ -q --tb=short"

hint = f"""## Hook: src/tests Write 감지

- **파일:** `{path}`
- **scope:** {scope}
- **flag:** `.cursor/hooks/state/touched_src_tests.flag` 갱신됨

### pytest (프로젝트 루트에서)
```bash
cd MagicSquare_xx
pip install -e ".[dev]"
{cmd}
```

RED 단계면 **FAILED/ImportError = 정상**. PASSED인데 구현 없으면 RED 재검토.
"""
print(hint, end="")
PY
)"

if [[ -z "${HINT}" ]]; then
  echo "{}"
  exit 0
fi

export ADDITIONAL_CONTEXT="${HINT}"
exec "${SCRIPT_DIR}/_python.sh"
