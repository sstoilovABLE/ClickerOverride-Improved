# ClickerOverride-Improved — Claude Code Instructions

## Project type
AutoHotkey Windows GUI script. No build system, no test suite, no package manager.

## Files
- `ClickerOverride-Improved-ahk1.ahk` — AHK v1 production script (released, tag `ahk1-v1`)
- `ClickerOverride-Improved-ahk2.ahk` — AHK v2 port (in progress, unreleased)
- `assets/` — screenshots and icon for the README
- `llms.txt` — condensed reference for LLMs

## Versioning convention
Format: `<runtime>-<version>` — e.g. `ahk1-v1`, `ahk2-v1`.
- `ahk1` / `ahk2` = AutoHotkey runtime target
- `-v1` / `-v2` = sequential release number within that runtime

## Running the script
Cannot be run headlessly. To test, open it in Windows with AutoHotkey installed:
- v1: AutoHotkey v1.1 (`AutoHotkey.exe`)
- v2: AutoHotkey v2.0 (`AutoHotkey64.exe`)
No automated test runner exists — all testing is manual end-to-end.

## Compiling
Use Ahk2Exe (bundled with AutoHotkey installation) to produce the `.exe`.
Only v1 has a compiled release so far; v2 compile process not yet documented.

## AHK v2 port status
In progress. Known issue to investigate: lines 83–86 register `*PgUp`/`*PgDn` then immediately call `"Off"` — verify that `UpdateHotkeys()` or equivalent re-enables them on startup, or the default clicker input mode will silently do nothing.

## Outstanding tasks (from CONTRIBUTING.md)
1. End-to-end test the v2 script across all documented use cases
2. Fix any v2 bugs found
3. Compile and publish `ahk2-v1` release
4. Update README, llms.txt, and CONTRIBUTING for the v2 release

## Style notes
- AHK v1 uses label-based GUI and command syntax (`Gui, Add`, `GuiControl`)
- AHK v2 uses OOP GUI (`MyGui := Gui()`, `.OnEvent()`, `.Add()`)
- Comments use `;` — keep section headers and per-block comments consistent with existing style
