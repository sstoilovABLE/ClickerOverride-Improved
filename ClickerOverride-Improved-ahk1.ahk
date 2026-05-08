; ============================================================
;  ClickerOverride-Improved
;  Version      :   ahk1-v1
;  Tested with  :   AutoHotkey v1.1 (ANSI/Unicode)
;  Repo         :   https://github.com/sstoilovABLE/ClickerOverride-Improved
;  License      :   Refer to the GitHub repositories for license information
;
;  Intercepts clicker button presses (Page Up/Down or Left/Right
;  Arrow) and redirects them as configurable keystrokes to a
;  user-selected target window, without requiring that window
;  to be in focus.
;
; ============================================================

#SingleInstance Force  ; Allow only one running instance; silently replace if relaunched


; ============================================================
;  INITIALISATION — Enumerate all open windows for the GUI list
; ============================================================

WinGet, AllWindows, List  ; Populate AllWindows with IDs of all visible windows;
                          ; AllWindows = count, AllWindows1..N = individual IDs


; ============================================================
;  GUI CONSTRUCTION
; ============================================================

; --- Header link ---
Gui, Add, Link,, Visit <a href="https://github.com/sstoilovABLE/ClickerOverride-Improved">ClickerOverride-Improved on GitHub</a> for the latest version and docs.

; --- Section: Clicker Input ---
; Choose which physical keys your clicker device sends to the PC
Gui, Font, Bold
Gui, Add, Text,, Clicker Input
Gui, Font, Norm
Gui, Add, Text, yp+16, What keys does your clicker send?
; vCaptureChoice: 1 = PgUp/PgDn (default), 2 = Left/Right
; gUpdateHotkeys fires immediately on selection change to swap active hotkeys
Gui, Add, Radio, vCaptureChoice checked gUpdateHotkeys, Page Up / Page Down (most clickers)
Gui, Add, Radio, gUpdateHotkeys, Left / Right Arrow (some older or alternative clickers)

; --- Section: Output Keystrokes ---
; Choose which keys are forwarded to the target window
Gui, Font, Bold
Gui, Add, Text, yp+28, Output Keystrokes
Gui, Font, Norm
Gui, Add, Text, yp+16, What keys should be sent to the target window?
; vKeyChoice: 1 = PgUp/PgDn (default), 2 = Left/Right
Gui, Add, Radio, vKeyChoice checked, Page Up / Page Down (default)
Gui, Add, Radio,, Left / Right Arrow (if PgUp/Dn doesn't work)

; --- Section: Mode ---
; Controls whether and how the target window is brought into focus
Gui, Font, Bold
Gui, Add, Text, yp+28, Mode
Gui, Font, Norm
Gui, Add, Text, yp+16, What should happen on clicker button press?
; vFocusMode: 1 = no focus change (ControlSend), 2 = focus+restore, 3 = focus+stay
Gui, Add, Radio, vFocusMode checked, Mode 1: Don't focus target window`n(works well with PowerPoint Presenter View and Pympress PDF)
Gui, Add, Radio,, Mode 2: Focus target window for the click and immediately switch back`n(works with windowed PowerPoint, full-screen PPT without Presenter View, or other apps)
Gui, Add, Radio,, Mode 3: Focus target window and stay there

; --- Section: Target Window ---
; The window list is populated dynamically from the snapshot taken at startup/refresh
Gui, Font, Bold
Gui, Add, Text, yp+28, Target Window
Gui, Font, Norm
Gui, Add, Text, yp+16, Which window should receive the keystrokes?`nIn Mode 1, select Presenter View as target`nIn Mode 2 or 3, select the slide show window as target
; Refresh button re-runs the script so the window list reflects current open windows
Gui, Add, Button, gReloadBtnHandler, &Refresh Window List

; Populate window list as a radio group; vSelectedWindowIndex stores the 1-based
; index of the selected radio, used later to look up the corresponding window ID
Loop %AllWindows%
{
    LoopWindowId := AllWindows%A_Index%
    WinGetTitle, LoopWindowTitle, ahk_id %LoopWindowId%
    WinGet, LoopWindowExe, ProcessName, ahk_id %LoopWindowId%
    if (A_Index = 1) {
        Gui, Add, Radio, vSelectedWindowIndex checked, %LoopWindowTitle% - %LoopWindowExe%
    } else {
        Gui, Add, Radio,, %LoopWindowTitle% - %LoopWindowExe%
    }
}

Gui, Show, Center, ClickerOverride-Improved ahk1-v1


; ============================================================
;  HOTKEY REGISTRATION
;  All four candidate hotkeys are registered upfront pointing
;  to shared labels. Only the default pair (PgUp/PgDn) is
;  enabled; the other pair is disabled. UpdateHotkeys swaps
;  which pair is active when the user changes CaptureChoice.
; ============================================================

Hotkey, *PgUp, HotkeyBack   ; * = fire even if modifier keys are held (clickers may send these)
Hotkey, *PgDn, HotkeyFwd
Hotkey, *Left, HotkeyBack
Hotkey, *Right, HotkeyFwd
Hotkey, *Left, Off           ; Disabled by default; enabled if CaptureChoice = 2
Hotkey, *Right, Off
return                        ; End of auto-execute section


; ============================================================
;  EVENT HANDLERS
; ============================================================

; Fired when the GUI window is closed — terminate the script
GuiClose:
    ExitApp
    return

; Fired by the Refresh button — reload the script to rebuild the window list
ReloadBtnHandler:
    Reload
    return

; Fired when either CaptureChoice radio is clicked.
; Enables the selected capture pair and disables the other,
; ensuring only one pair of hotkeys is active at a time.
UpdateHotkeys:
    Gui, Submit, NoHide
    global CaptureChoice
    if (CaptureChoice = 1) {        ; PgUp/PgDn selected
        Hotkey, *PgUp, On
        Hotkey, *PgDn, On
        Hotkey, *Left, Off
        Hotkey, *Right, Off
    } else {                        ; Left/Right selected
        Hotkey, *PgUp, Off
        Hotkey, *PgDn, Off
        Hotkey, *Left, On
        Hotkey, *Right, On
    }
    return

; Hotkey label for forward navigation (PgDn or Right Arrow pressed on clicker)
HotkeyFwd:
    SendToWindow("fwd")
    return

; Hotkey label for backward navigation (PgUp or Left Arrow pressed on clicker)
HotkeyBack:
    SendToWindow("back")
    return


; ============================================================
;  FUNCTIONS
; ============================================================

; Returns the HWND of the window currently selected in the GUI.
; SelectedWindowIndex is the 1-based index of the chosen radio button,
; which maps directly to the AllWindows array populated at startup.
GetSelectedWindowId() {
    Gui, Submit, NoHide
    global AllWindows
    global SelectedWindowIndex
    id := AllWindows%SelectedWindowIndex%
    return id
}

; Resolves the output key from KeyChoice and direction, then delivers
; it to the target window using the method determined by FocusMode.
;
; Parameters:
;   direction  "fwd"  = forward (next slide)
;              "back" = backward (previous slide)
;
; FocusMode behaviour:
;   1 = ControlSend — no focus change; relies on target already being
;       active (e.g. Presenter View on a second screen) or responding
;       to background key messages (e.g. Pympress)
;   2 = WinActivate → Send → restore previous window focus
;   3 = WinActivate → Send → remain on target window
SendToWindow(direction) {
    Gui, Submit, NoHide
    global FocusMode
    global KeyChoice

    ; Resolve the output key from KeyChoice and direction
    if (KeyChoice = 1)
        key := (direction = "fwd") ? "{PgDn}" : "{PgUp}"
    else
        key := (direction = "fwd") ? "{Right}" : "{Left}"

    targetId := GetSelectedWindowId()

    if (FocusMode = 1) {
        ; Send directly to target window message queue without activating it.
        ; Empty control parameter sends to the window's focused/default control.
        ControlSend,, %key%, % "ahk_id " . targetId

    } else if (FocusMode = 2) {
        ; Save current foreground window, activate target, send key, restore focus
        WinGet, prevId, ID, A
        WinActivate % "ahk_id " . targetId
        WinWaitActive % "ahk_id " . targetId,, 1  ; Wait up to 1 second for activation
        Send % key
        if (prevId)
            WinActivate % "ahk_id " . prevId       ; Restore previously active window

    } else {
        ; Activate target, send key, leave target window in focus
        WinActivate % "ahk_id " . targetId
        WinWaitActive % "ahk_id " . targetId,, 1
        Send % key
    }
}