#SingleInstance Force

WinGet, AllWindows, List

Gui, Add, Text,, Clicker input - select the keys your clicker sends:
Gui, Add, Radio, vCaptureChoice checked gUpdateHotkeys, Page Up / Page Down (most clickers, e.g. Logitech Spotlight)
Gui, Add, Radio, gUpdateHotkeys, Left / Right Arrow (some older or alternative clickers)
Gui, Add, Text,, Output - keys to send to the target window:
Gui, Add, Radio, vKeyChoice checked, Page Up / Page Down
Gui, Add, Radio,, Left / Right Arrow
Gui, Add, Text,, What happens on clicker button press:
Gui, Add, Radio, vFocusMode checked, Don't focus target window (works well with PowerPoint full-screen slide show)
Gui, Add, Radio,, Focus target window for the click and immediately switch back (for PowerPoint windowed slide show)
Gui, Add, Radio,, Focus target window and stay there
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

; Register all four hotkeys, enable only the default pair (PgUp/PgDn)
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
    global FocusMode
    global KeyChoice

    if (KeyChoice = 1)
        key := (direction = "fwd") ? "{PgDn}" : "{PgUp}"
    else
        key := (direction = "fwd") ? "{Right}" : "{Left}"

    targetId := GetSelectedWindowId()

    if (FocusMode = 1) {
        ; Don't activate — send directly via ControlSend
        ; Works when the target is already the active window (e.g. full-screen slide show)
        ControlSend,, %key%, % "ahk_id " . targetId
    } else if (FocusMode = 2) {
        ; Activate target, send key, then restore focus to the previous window
        WinGet, prevId, ID, A
        WinActivate % "ahk_id " . targetId
        WinWaitActive % "ahk_id " . targetId,, 1
        Send % key
        if (prevId)
            WinActivate % "ahk_id " . prevId
    } else {
        ; Activate target, send key, stay there
        WinActivate % "ahk_id " . targetId
        WinWaitActive % "ahk_id " . targetId,, 1
        Send % key
    }
}