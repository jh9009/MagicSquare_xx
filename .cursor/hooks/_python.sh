#!/usr/bin/env bash
# Emit valid JSON hook stdout from environment variables.
# Usage:
#   ADDITIONAL_CONTEXT="..." .cursor/hooks/_python.sh
#   HOOK_ENV_JSON='{"KEY":"value"}' ADDITIONAL_CONTEXT="..." .cursor/hooks/_python.sh

set -euo pipefail

python3 -c '
import json
import os
import sys

out = {}

ctx = os.environ.get("ADDITIONAL_CONTEXT", "").strip()
if ctx:
    out["additional_context"] = ctx

env_json = os.environ.get("HOOK_ENV_JSON", "").strip()
if env_json:
    try:
        env = json.loads(env_json)
        if isinstance(env, dict) and env:
            out["env"] = env
    except json.JSONDecodeError:
        print("Invalid HOOK_ENV_JSON", file=sys.stderr)
        sys.exit(1)

print(json.dumps(out, ensure_ascii=False))
'
