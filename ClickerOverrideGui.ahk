#SingleInstance Force

WinGet, AllWindows, List

Gui, Add, Link,, Visit <a href="https://github.com/sstoilovABLE/ClickerOverride-Improved">ClickerOverride-Improved on GitHub</a> for the latest version and docs.
Gui, Font, Bold
Gui, Add, Text,, Clicker Input
Gui, Font, Norm
Gui, Add, Text, yp+16, What keys does your clicker send?
Gui, Add, Radio, vCaptureChoice checked gUpdateHotkeys, Page Up / Page Down (most clickers, e.g. Logitech Spotlight)
Gui, Add, Radio, gUpdateHotkeys, Left / Right Arrow (some older or alternative clickers)

Gui, Font, Bold
Gui, Add, Text, yp+28, Output Keystrokes
Gui, Font, Norm
Gui, Add, Text, yp+16, What keys should be sent to the target window?
Gui, Add, Radio, vKeyChoice checked, Page Up / Page Down (default)
Gui, Add, Radio,, Left / Right Arrow (if PgUp/Dn doesn't work)

Gui, Font, Bold
Gui, Add, Text, yp+28, Mode
Gui, Font, Norm
Gui, Add, Text, yp+16, What should happen on clicker button press?
Gui, Add, Radio, vFocusMode checked, Mode 1: Don't focus target window`n(works well with PowerPoint Presenter View and Pympress PDF)
Gui, Add, Radio,, Mode 2: Focus target window for the click and immediately switch back`n(works with windowed PowerPoint, full-screen PPT without Presenter View, or other apps)
Gui, Add, Radio,, Mode 3: Focus target window and stay there

Gui, Font, Bold
Gui, Add, Text, yp+28, Target Window
Gui, Font, Norm
Gui, Add, Text, yp+16, Which window should receive the keystrokes?`nIn Mode 1, select Presenter View as target`nIn Mode 2 or 3, select the slide show window as target
Gui, Add, Button, gReloadBtnHandler, &Refresh Window List

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
        ControlSend,, %key%, % "ahk_id " . targetId
    } else if (FocusMode = 2) {
        WinGet, prevId, ID, A
        WinActivate % "ahk_id " . targetId
        WinWaitActive % "ahk_id " . targetId,, 1
        Send % key
        if (prevId)
            WinActivate % "ahk_id " . prevId
    } else {
        WinActivate % "ahk_id " . targetId
        WinWaitActive % "ahk_id " . targetId,, 1
        Send % key
    }
}