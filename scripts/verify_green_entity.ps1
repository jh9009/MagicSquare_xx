# Entity Logic Track — GREEN PASS + Golden Master 검증
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)

if (-not (Test-Path ".venv\Scripts\python.exe")) {
    Write-Host "Creating .venv ..."
    python -m venv .venv
}
& .\.venv\Scripts\python.exe -m pip install -q -e ".[dev]"

Write-Host "`n=== D-LOC-01 GREEN ===" 
& .\.venv\Scripts\python.exe -m pytest tests/entity/test_d_loc_01.py::test_d_loc_01_blank_coords_row_major -v

Write-Host "`n=== D-SOL-01 GREEN + Golden (no UPDATE_GOLDEN) ===" 
& .\.venv\Scripts\python.exe -m pytest tests/entity/test_d_sol_01.py::test_d_sol_01_step_a_success -v -s

Write-Host "`n=== Entity track full ===" 
& .\.venv\Scripts\python.exe -m pytest tests/entity/ -v

Write-Host "`nGREEN PASS gate: OK"
