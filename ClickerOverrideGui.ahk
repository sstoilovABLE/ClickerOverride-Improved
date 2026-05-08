#SingleInstance Force

WinGet, AllWindows, List

Gui, Add, Text,, Select the window to redirect clicker input to:
Gui, Add, CheckBox, vFocusWindow, Keep focus on selected window after keypress
Gui, Add, Text,, Keys to send to the target window:
Gui, Add, Radio, vKeyChoice checked, Page Up / Page Down
Gui, Add, Radio,, Left Arrow / Right Arrow
Gui, Add, Button, gReloadBtnHandler, &Refresh

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
return

GuiClose:
    ExitApp
    return

ReloadBtnHandler:
    Reload
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

*PgUp::
    SendToWindow("back")
    return

*PgDn::
    SendToWindow("fwd")
    return