# ClickerOverride-Improved

**Redirect your presentation clicker's buttons to any window without requiring that window to be in focus.**

ClickerOverride-Improved is an AutoHotkey v1 script that intercepts the Page Up/Page Down (or Left/Right Arrow) key presses sent by a wireless presentation clickers/remote controls and silently forwards configurable keystrokes to a target window of your choice. The target window does not need to be active or even visible on the primary screen. This script is especially useful when you need to work on the presentation PC while someone else is presenting a slide show. 

This is a fork and complete rewrite of [ClickerOverride by 4000degrees](https://github.com/4000degrees/ClickerOverride), with substantially expanded functionality, a restructured GUI, and multiple operating modes.

## Use Cases

### Setup Scenarios

| Setup | Recommended Mode | Target Window |
|---|---|---|
| **In-person, dual screen**, with **Presenter View** or **Pympress** <br> Presentation PC connected to an external monitor or projector. PowerPoint is full-screen presenting on the second screen with Presenter View enabled; or Pympress is full-screen presenting a PDF on the second screen. You work on the primary screen. | **Mode 1** allows you to keep the Presenter View in the background out of focus while you work in other windows. Clicks are relayed to PowerPoint seamlessly. | PowerPoint: Presenter View window<br> Pympress: any window |
| **In-person, dual screen, without Presenter View** <br> Presentation PC connected to an external monitor or projector. PowerPoint without Presenter View or another app is full-screen presenting on the second screen. | Try **Mode 1** (works with Pympress)<br> **Mode 2** for PowerPoint windowed mode and apps incompatible with Mode 1 | The full-screen slide show window |
| **In-person, dual screen, via OBS Studio** <br> Presentation PC connected to a second screen. OBS Studio (or similar) uses a windowed slide show as input and outputs it to the second screen or projector. The slide show runs in windowed mode as an OBS source. | Try **Mode 1** (works with Pympress)<br> **Mode 2** for PowerPoint windowed mode and apps incompatible with Mode 1 | The windowed slide show window (not OBS) |
| **Online presentation, screen shared** <br> Presentation PC with or without a second screen. The slide show runs in windowed mode and is screen-shared directly into an online meeting (Zoom, Teams, Meet, etc.). | Try **Mode 1** (works with Pympress)<br> **Mode 2** for PowerPoint windowed mode and apps incompatible with Mode 1 | The windowed slide show window |
| **Live streaming via OBS Studio** <br> Presentation PC with or without a second screen. The slide show runs in windowed mode and is captured by OBS Studio (or similar) as a source for a live stream. | Try **Mode 1** (works with Pympress)<br> **Mode 2** for PowerPoint windowed mode and apps incompatible with Mode 1 | The windowed slide show window (not OBS) |

### Software Scenarios

| Presentation Software | Recommended Mode |
|---|---|
| **PowerPoint (full-screen with Presenter View)** | **Mode 1**. Select Presenter View as the Target Window; Presenter View works with Mode 1 |
| **PowerPoint (full-screen without Presenter View)** | **Mode 2**. Select the PowerPoint full-screen slide show as the Target Window (doesn't work with Mode 1) |
| **PowerPoint (windowed mode)** | **Mode 2**. Select the PowerPoint windowed slide show as the Target Window ([windowed PowerPoint slide shows don't support Presenter View](https://techcommunity.microsoft.com/discussions/microsoft-365/powerpoint-presentation-in-windowed-mode-but-with-presenter-screen-also-visible/2046883)) |
|  [**Pympress**](https://github.com/Cimbali/pympress) PDF presentation | **Mode 1**. Pympress responds to background key messages |
| **Any application** that accepts Page Up/Down or Left/Right Arrow for navigation | Any mode, depending on whether the app must be focused |

## Installing

### Download the script [![github version badge][github_version]][github_release]

Download the latest release of **ClickerOverride-Improved** from the [Releases](../../releases/latest) page. Under **Assets**, choose the file that matches how you want to run the script:

| File | When to use |
|---|---|
| `ClickerOverride-Improved-ahk1.exe` | You do not have AutoHotkey installed and do not want to install it |
| `ClickerOverride-Improved-ahk1.ahk` | You have AutoHotkey v1.1 installed (or plan to install it) |

Alternatively, you can download the raw script directly from the repository's source code.

### Installing AutoHotkey v1 (to run the script)

This script requires **AutoHotkey v1.1** (also called AutoHotkey Classic). AutoHotkey v2 is *not* compatible. Note that AutoHotkey is only available for Windows.

1. Go to [autohotkey.com/download](https://www.autohotkey.com/download/) and under *AutoHotkey v1.1*, download the installer (`.exe`). Or install using your favorite package manager.
2. Run the installer and follow the prompts. The default options are fine.
3. Once installed, double-click `ClickerOverride-Improved-ahk1.ahk` to run it. The `.ahk` extension should be associated with AutoHotkey v1 automatically.

> **Note:** If you have AutoHotkey v2 already installed, you may need to right-click the `.ahk` file and choose *Run with* → *AutoHotkey v1.1* or set the file association manually.

### Pympress (for PDF slides)

[Pympress](https://github.com/Cimbali/pympress) is a feature-rich PDF presentation viewer designed for dual-screen setups, with a Presenter View similar to PowerPoint. It is a popular open-source alternative to PowerPoint for presenting PDF-based slide decks.

ClickerOverride-Improved works well with Pympress in **Mode 1**. Pympress responds to background key messages, so the target window does not need to be focused to receive navigation keystrokes, allowing you to seamlessly use the presentation PC without clicker clicks interfering with your work.

## How to Use

1. Open your presentation (in PowerPoint, Pympress, etc.) and enter slide show mode.
2. Launch `ClickerOverride-Improved-ahk1.ahk`. If you've associated `.ahk` files with AutoHotkey during installation, you can just double-click the script. The main configuration window will appear.
3. **Clicker Input** - select which keys your clicker sends to the PC (Page Up/Page Down is correct for most modern clickers).
4. **Output Keystrokes** - select which keys should be forwarded to the target window. Start with Page Up/Page Down; switch to Left/Right Arrow if the application does not respond.
5. **Mode** - choose how the script handles window focus:
   - *Mode 1* - recommended for Presenter View on a second screen and for Pympress. (default)
   - *Mode 2* - recommended for windowed or full-screen slide shows where the target window must be briefly focused to receive input.
   - *Mode 3* - focus the target window and stay there.
6. **Target Window** - select the window that should receive the forwarded keystrokes. For Presenter View use cases, select the Presenter View window; for Pympress, select the Pympress window.
7. Click your clicker. The script intercepts the button press and forwards the configured keystroke to the selected window. You can minimise the ClickerOverride-Improved window, but it must remain running. 

> **Tip:** If you open a new application after starting the script, click **Refresh Window List** to reload the script so the new window appears in the list.

## Features

- **Configurable clicker input** - works with clickers that send Page Up/Page Down (e.g. Logitech Spotlight, most modern clickers) *or* Left/Right Arrow (some older or alternative devices).
- **Configurable output keystrokes** - forward either Page Up/Down or Left/Right Arrow to the target window, independently of the input, ensuring compatibility with most software.
- **Three modes** - allows you to choose whether focus is switched to the target window. Works best with PowerPoint Presenter View or Pympress PDFs, where you focus doesn't need to be switched at all! 
- **Window selector** - all open windows are listed in the GUI at startup; pick the target with a radio button.
- **Modifier-key passthrough** - hotkeys are registered with `*`, so they fire even if modifier keys happen to be held down (common with some clickers).
- **Single-instance enforcement** - only one copy of the script runs at a time; launching it again silently replaces the previous instance.

## Improvements Over the Original

ClickerOverride-Improved is a complete rewrite of [ClickerOverride by 4000degrees](https://github.com/4000degrees/ClickerOverride). The original script provided a window selector and hardcoded redirection via `ControlSend`. The following improvements have been made:

### Configurable Input and Output
The original script assumed Page Up/Page Down input and output. ClickerOverride-Improved adds separate radio groups for clicker input (Page Up/Down or Left/Right Arrow) and output keystrokes (Page Up/Down or Left/Right Arrow), covering the full range of common clicker hardware and application requirements.

### Three Focus Modes
The original script by default sent keystrokes in the background (equivalent to Mode 1 in ClickerOverride-Improved), which only works with PowerPoint Presenter Mode and Pympress. The script also offered an optional checkbox to activate the target window and stay there (equivalent to Mode 3 in Improved). ClickerOverride-Improved builds on this by allowing the user to select from three distinct modes, each suited to a different use case:

- **Mode 1** - `ControlSend` with no focus change (ideal for PowerPoint Presenter View or Pympress).
- **Mode 2** - save the currently active window, activate the target, send the key, then restore the previous window. On a fast system this happens almost seamlessly and still allows one to work on the presentation PC without interfering with the slide show too much. 
- **Mode 3** - activate the target and remain there.

### Dynamic Hotkey Switching
Rather than registering a fixed hotkey pair, the script registers all four candidate hotkeys at startup and uses the `Hotkey` command to enable or disable each pair in real time when the user changes the Clicker Input selection. This prevents double-firing if both input types were somehow active.

### Bug Fixes
Several bugs present in the modified version of the original script have been corrected:

- Missing commas in `WinGetTitle` calls (AHK v1 requires comma-separated command/parameter syntax).
- Multi-statement `global` declarations that prevented `GetSelectedWindowId()` from returning a value.
- Missing explicit string concatenation (`.` operator) in `WinActivate` and `ControlSend` expression-mode calls.

### Improved `ControlSend` Call
The original script passed `ahk_parent` as the control parameter to `ControlSend`. ClickerOverride-Improved leaves the control parameter empty, which directs the keystroke to the window's focused or default control - more reliable across a wider range of applications.

### Structured and Commented Code
The rewrite is fully commented with section headers, parameter descriptions, and per-mode behavior documentation, making the script easier to read, modify, and maintain.

## Screenshots
### ClickerOverride-Improved's GUI
![ClickerOverride-Improved Screenshot](assets\screenshot-gui.png)

### PowerPoint target windows
![Screenshot of PowerPoint target windows](assets\screenshot-gui-powerpoint.png)

### Pympress target windows
![Screenshot of Pympress target windows](assets\screenshot-gui-pympress.png)

## AI Assistance Disclaimer

This script and its documentation were developed largely by directing AI coding
agents. While the code has been reviewed and tested by the repository author,
you are encouraged to read and understand the script before running it, and to
review any modifications carefully before use. The repository author assumes no
liability for unintended behavior.

## Copyright and License

**ClickerOverride-Improved** is a fork of [ClickerOverride](https://github.com/4000degrees/ClickerOverride) by [4000degrees](https://github.com/4000degrees). The original code is under copyright by 4000degrees. At the time of publication of this fork, the original repository does not carry an open-source license. I've opened an issue on the original repository requesting that a license be added: [ClickerOverride issue #3](https://github.com/4000degrees/ClickerOverride/issues/3).

This fork does not currently carry a license. Until a license is established - either on this repository or on the upstream repository - the standard copyright rules apply: the code in this repository may be viewed and forked on GitHub, but may not be redistributed, sublicensed, or used in other projects without explicit permission from the respective copyright holders.

[github_version]: https://img.shields.io/github/v/release/sstoilovABLE/ClickerOverride-Improved?label=Latest%20GitHub%20release&logo=github
[github_release]: https://github.com/sstoilovABLE/ClickerOverride-Improved/releases/latest