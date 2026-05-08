#SingleInstance Force

WinGet, AllWindows, List

Gui, Add, Text,, Select the window to which Left/Right Arrow will be redirected
Gui, Add, CheckBox, vFocusWindow, Keep focus on selected window after keypress
Gui, Add, Button, gReloadBtnHandler, &Refresh

Loop %AllWindows%
{
    LoopWindowId := AllWindows%A_Index%
    WinGetTitle, LoopWindowTitle, ahk_id %LoopWindowId%   ; Fix: comma after WinGetTitle
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
    global SelectedWindowIndex          ; Fix: on its own line
    id := AllWindows%SelectedWindowIndex%
    return id                           ; Fix: was return %id% (double-deref bug)
}

SendToWindow(key) {
    Gui, Submit, NoHide
    global FocusWindow
    targetId := GetSelectedWindowId()

    ; Save currently active window so we can restore focus afterwards
    WinGet, prevId, ID, A

    ; Activate target and wait up to 1 second for it to become active
    WinActivate % "ahk_id " . targetId
    WinWaitActive % "ahk_id " . targetId,, 1

    ; Send the key — this works reliably for PowerPoint slideshow/reading view
    Send % key

    ; Restore focus to previous window unless "keep focus" is checked
    if (!FocusWindow && prevId)
        WinActivate % "ahk_id " . prevId
}

*PgUp::
    SendToWindow("{Left}")
    return

*PgDn::
    SendToWindow("{Right}")
    return