#SingleInstance Force

WinGet, AllWindows, List

Gui, Add, Text,, Clicker input - select the keys your clicker sends:
Gui, Add, Radio, vCaptureChoice checked gUpdateHotkeys, Page Up / Page Down (most clickers, e.g. Logitech Spotlight)
Gui, Add, Radio, gUpdateHotkeys, Left / Right Arrow (some older or alternative clickers)
Gui, Add, Text,, Output - keys to send to the target window:
Gui, Add, Radio, vKeyChoice checked, Page Up / Page Down
Gui, Add, Radio,, Left / Right Arrow
Gui, Add, CheckBox, vFocusWindow, Keep focus on selected window after keypress
Gui, Add, Button, gReloadBtnHandler, &Refresh
Gui, Add, Text,, Target window - select which window receives the keystrokes:

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

Gui, Show

; Register all four hotkeys pointing to shared labels
; then enable only the default pair (PgUp/PgDn)
Hotkey, *PgUp, HotkeyBack
Hotkey, *PgDn, HotkeyFwd
Hotkey, *Left, HotkeyBack
Hotkey, *Right, HotkeyFwd
Hotkey, *Left, Off
Hotkey, *Right, Off
return

GuiClose:
    ExitApp
    return

ReloadBtnHandler:
    Reload
    return

UpdateHotkeys:
    Gui, Submit, NoHide
    global CaptureChoice
    if (CaptureChoice = 1) {
        Hotkey, *PgUp, On
        Hotkey, *PgDn, On
        Hotkey, *Left, Off
        Hotkey, *Right, Off
    } else {
        Hotkey, *PgUp, Off
        Hotkey, *PgDn, Off
        Hotkey, *Left, On
        Hotkey, *Right, On
    }
    return

HotkeyFwd:
    SendToWindow("fwd")
    return

HotkeyBack:
    SendToWindow("back")
    return

GetSelectedWindowId() {
    Gui, Submit, NoHide
    global AllWindows
    global SelectedWindowIndex
    id := AllWindows%SelectedWindowIndex%
    return id
}

SendToWindow(direction) {
    Gui, Submit, NoHide
    global FocusWindow
    global KeyChoice

    if (KeyChoice = 1)
        key := (direction = "fwd") ? "{PgDn}" : "{PgUp}"
    else
        key := (direction = "fwd") ? "{Right}" : "{Left}"

    targetId := GetSelectedWindowId()
    WinGet, prevId, ID, A
    WinActivate % "ahk_id " . targetId
    WinWaitActive % "ahk_id " . targetId,, 1
    Send % key
    if (!FocusWindow && prevId)
        WinActivate % "ahk_id " . prevId
}