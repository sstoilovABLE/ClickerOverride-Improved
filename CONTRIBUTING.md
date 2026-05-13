# Contributing to ClickerOverride-Improved

Thank you for your interest in contributing! This document explains how to work
with the project, submit changes, and publish a release. It is also so I don't forget how to do releases...


## Table of Contents

- [Ways to Contribute](#ways-to-contribute)
- [Outstanding Tasks](#outstanding-tasks)
- [Version Naming Convention](#version-naming-convention)
- [Development Setup](#development-setup)
- [Submitting Changes](#submitting-changes)
- [Creating a Git Tag](#creating-a-git-tag)
- [Naming Files for Release](#naming-files-for-release)
- [Compiling the EXE](#compiling-the-exe)
- [Publishing a GitHub Release](#publishing-a-github-release)


## Ways to Contribute

- Report bugs or unexpected behavior via [GitHub Issues](https://github.com/sstoilovABLE/ClickerOverride-Improved/issues)
- Suggest features or improvements via Issues
- Submit bug fixes or new features via Pull Requests
- Improve documentation via Pull Requests


## Outstanding Tasks

The following tasks are open and contributions are welcome:

- **AHK v2 rewrite**: 
  - **End-to-end testing:** Run the draft AHKv2 script through all use
  cases covered by the v1 script and verify behavioral parity. Document any discrepancies found.
  - **Bug hunting and optimization:** Review the v2 script for bugs, edge cases, and performance or code-quality improvements.
  - **Release `ahk2-v1`:** Once the v2 script passes parity testing, prepare and publish the first AHK v2 release following the [Naming Files for Release](#naming-files-for-release) and [Publishing a GitHub
  Release](#publishing-a-github-release) conventions.
  - **Update docs**: Update README, llms.txt and CONTRIBUTING after ahk2 script is published.


## Version Naming Convention

Versions follow the pattern `<runtime>-<version>`, for example: `ahk1-v1`.

| Segment | Meaning |
|---|---|
| `ahk1` | Script targets AutoHotkey v1 |
| `ahk2` | Script targets AutoHotkey v2 |
| `-v1`, `-v2`, `-v3` … | Sequential script version number |

Examples: `ahk1-v1`, `ahk1-v2`, `ahk2-v1`


## Development Setup

1. Install [AutoHotkey v1](https://www.autohotkey.com/download/ahk-install.exe) (1.1.x).
2. Clone the repository:
   ```
   git clone https://github.com/sstoilovABLE/ClickerOverride-Improved.git
   ```
3. Open `ClickerOverride-Improved-ahk1.ahk` in your editor of choice and work on the script.
4. Run the script directly with AutoHotkey to test changes.


## Submitting Changes

1. Fork the repository and create a new branch for your change.
2. Make your changes and test them thoroughly.
3. Open a Pull Request against `main` with a clear description of what you changed and why.


## Creating a Git Tag

After committing all changes to `main`, create an annotated tag that matches the
version string:

```bash
git tag -a ahk1-v2 -m "ahk1-v2"
git push origin ahk1-v2
```

Replace `ahk1-v2` with the correct version. The tag must be pushed to GitHub
before creating the release.


## Naming Files for Release

Append the full version string to the base filename before compiling and before
uploading to the release.

**Pattern:**
```
ClickerOverride-Improved-<version>.ahk
ClickerOverride-Improved-<version>.exe
```

**Example for `ahk1-v2`:**
```
ClickerOverride-Improved-ahk1-v2.ahk
ClickerOverride-Improved-ahk1-v2.exe
```

Copy (do not rename) the working `.ahk` file, rename the copy as described above, and use the versioned copy for compiling, so the source file in the repo root always reflects the
latest working state.


## Compiling the EXE

Use **Ahk2Exe** (bundled with AutoHotkey) with the following settings:

| Setting | Value |
|---|---|
| Source (script) | The versioned `.ahk` file (see [Naming Files for Release](#naming-files-for-release)) |
| Destination (exe) | The versioned `.exe` file (see [Naming Files for Release](#naming-files-for-release)) |
| Base file | `AutoHotkey32.exe` from AutoHotkey **v1.1.37.02 U32** |
| Icon | `assets/iconmonstr-mouse-9.ico` |
| All other settings | Leave at defaults |

> **Note:** The base file version must be exactly **v1.1.37.02 U32** to ensure
> compatibility. Do not use a Unicode 64-bit or any other variant.


## Publishing a GitHub Release

1. Go to the repository on GitHub and click **Releases > Draft a new release**.
2. Under **Choose a tag**, select the tag you just pushed (e.g. `ahk1-v2`).
3. Set the release title to the version string (e.g. `ahk1-v2`).
4. Write release notes / change log according to [best practices](https://keepachangelog.com/en/1.1.0/).
5. Upload the two versioned files as release assets:
   - `ClickerOverride-Improved-ahk1-v2.ahk`
   - `ClickerOverride-Improved-ahk1-v2.exe`
6. Click **Publish release**.