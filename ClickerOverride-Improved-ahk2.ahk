; ============================================================
;  ClickerOverride-Improved
;  Version      :   ahk2-v1 (draft, unreleased)
;  Tested with  :   AutoHotkey v2.0+
;  Repo         :   https://github.com/sstoilovABLE/ClickerOverride-Improved
;  License      :   Refer to the GitHub repositories for license information
;
;  Intercepts clicker button presses (Page Up/Down or Left/Right
;  Arrow) and redirects them as configurable keystrokes to a
;  user-selected target window, without requiring that window
;  to be in focus.
;
; ============================================================

#Requires AutoHotkey v2.0
#SingleInstance Force


; ============================================================
;  INITIALISATION — Enumerate all open windows for the GUI list
; ============================================================

AllWindowIds := WinGetList()   ; Returns an array of HWNDs for all visible windows


; ============================================================
;  GUI CONSTRUCTION
; ============================================================

MyGui := Gui(, "ClickerOverride-Improved ahk2-v1")
MyGui.OnEvent("Close", GuiClose)

; --- Header link ---
MyGui.Add("Link",, 'Visit <a href="https://github.com/sstoilovABLE/ClickerOverride-Improved">ClickerOverride-Improved on GitHub</a> for the latest version and docs.')

; --- Section: Clicker Input ---
MyGui.SetFont("Bold")
MyGui.Add("Text",, "Clicker Input")
MyGui.SetFont("Norm")
MyGui.Add("Text", "yp+16", "What keys does your clicker send?")
rbCapture1 := MyGui.Add("Radio", "vCaptureChoice Checked", "Page Up / Page Down (most clickers)")
rbCapture1.OnEvent("Click", UpdateHotkeys)
rbCapture2 := MyGui.Add("Radio",, "Left / Right Arrow (some older or alternative clickers)")
rbCapture2.OnEvent("Click", UpdateHotkeys)

; --- Section: Output Keystrokes ---
MyGui.SetFont("Bold")
MyGui.Add("Text", "yp+28", "Output Keystrokes")
MyGui.SetFont("Norm")
MyGui.Add("Text", "yp+16", "What keys should be sent to the target window?")
MyGui.Add("Radio", "vKeyChoice Checked", "Page Up / Page Down (default)")
MyGui.Add("Radio",, "Left / Right Arrow (if PgUp/Dn doesn't work)")

; --- Section: Mode ---
MyGui.SetFont("Bold")
MyGui.Add("Text", "yp+28", "Mode")
MyGui.SetFont("Norm")
MyGui.Add("Text", "yp+16", "What should happen on clicker button press?")
MyGui.Add("Radio", "vFocusMode Checked", "Mode 1: Don't focus target window`n(works well with PowerPoint Presenter View and Pympress PDF)")
MyGui.Add("Radio",, "Mode 2: Focus target window for the click and immediately switch back`n(works with windowed PowerPoint, full-screen PPT without Presenter View, or other apps)")
MyGui.Add("Radio",, "Mode 3: Focus target window and stay there")

; --- Section: Target Window ---
MyGui.SetFont("Bold")
MyGui.Add("Text", "yp+28", "Target Window")
MyGui.SetFont("Norm")
MyGui.Add("Text", "yp+16", "Which window should receive the keystrokes?`nIn Mode 1, select Presenter View as target`nIn Mode 2 or 3, select the slide show window as target")
MyGui.Add("Button",, "&Refresh Window List").OnEvent("Click", ReloadBtnHandler)

; Populate window list as a radio group; vSelectedWindowIndex stores the 1-based
; index of the selected radio, used later to look up the corresponding window HWND
for Index, WinId in AllWindowIds {
    WinTitle := WinGetTitle("ahk_id " WinId)
    WinExe   := WinGetProcessName("ahk_id " WinId)
    if (Index = 1)
        MyGui.Add("Radio", "vSelectedWindowIndex Checked", WinTitle " - " WinExe)
    else
        MyGui.Add("Radio",, WinTitle " - " WinExe)
}

MyGui.Show("Center")


; ============================================================
;  HOTKEY REGISTRATION
;  All four candidate hotkeys are registered upfront. Only the
;  default pair (PgUp/PgDn) is enabled; Left/Right starts off.
;  UpdateHotkeys swaps which pair is active on radio change.
; ============================================================

HotkeyFunc := ObjBindMethod({}, "Call")  ; placeholder — overridden below

Hotkey "*PgUp", HotkeyBack
Hotkey "*PgDn", HotkeyFwd
Hotkey "*Left", HotkeyBack
Hotkey "*Right", HotkeyFwd
Hotkey "*Left", "Off"
Hotkey "*Right", "Off"


; ============================================================
;  EVENT HANDLERS
; ============================================================

GuiClose(*) {
    ExitApp
}

ReloadBtnHandler(*) {
    Reload
}

; Fired when either CaptureChoice radio is clicked.
; Enables the selected capture pair and disables the other.
UpdateHotkeys(*) {
    Saved := MyGui.Submit("NoHide")
    if (Saved.CaptureChoice = 1) {
        Hotkey "*PgUp", "On"
        Hotkey "*PgDn", "On"
        Hotkey "*Left", "Off"
        Hotkey "*Right", "Off"
    } else {
        Hotkey "*PgUp", "Off"
        Hotkey "*PgDn", "Off"
        Hotkey "*Left", "On"
        Hotkey "*Right", "On"
    }
}

; Hotkey callback for forward navigation (PgDn or Right Arrow)
HotkeyFwd(*) {
    SendToWindow("fwd")
}

; Hotkey callback for backward navigation (PgUp or Left Arrow)
HotkeyBack(*) {
    SendToWindow("back")
}


; ============================================================
;  FUNCTIONS
; ============================================================

; Returns the HWND of the window currently selected in the GUI.
GetSelectedWindowId() {
    global AllWindowIds
    Saved := MyGui.Submit("NoHide")
    return AllWindowIds[Saved.SelectedWindowIndex]
}

; Resolves the output key from KeyChoice and direction, then delivers
; it to the target window using the method determined by FocusMode.
;
; Parameters:
;   direction  "fwd"  = forward (next slide)
;              "back" = backward (previous slide)
;
; FocusMode behaviour:
;   1 = ControlSend — no focus change; relies on target responding
;       to background key messages (e.g. Presenter View, Pympress)
;   2 = WinActivate -> Send -> restore previous window focus
;   3 = WinActivate -> Send -> remain on target window
SendToWindow(direction) {
    Saved    := MyGui.Submit("NoHide")
    FocusMode := Saved.FocusMode
    KeyChoice := Saved.KeyChoice

    ; Resolve output key from KeyChoice and direction
    if (KeyChoice = 1)
        key := (direction = "fwd") ? "{PgDn}" : "{PgUp}"
    else
        key := (direction = "fwd") ? "{Right}" : "{Left}"

    targetId := GetSelectedWindowId()

    if (FocusMode = 1) {
        ; Send to target window without activating it
        ControlSend key, , "ahk_id " targetId

    } else if (FocusMode = 2) {
        ; Save foreground window, activate target, send, restore
        prevId := WinGetID("A")
        WinActivate "ahk_id " targetId
        WinWaitActive "ahk_id " targetId, , 1
        Send key
        if (prevId)
            WinActivate "ahk_id " prevId

    } else {
        ; Activate target, send, remain on it
        WinActivate "ahk_id " targetId
        WinWaitActive "ahk_id " targetId, , 1
        Send key
    }
}