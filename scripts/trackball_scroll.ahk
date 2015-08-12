$*XButton1::
Hotkey, $*XButton1 Up, XButton1up, off
;KeyWait, XButton1, T0.4
;If ErrorLevel = 1
;{
   Hotkey, $*XButton1 Up, XButton1up, on
   MouseGetPos, ox, oy
   SetTimer, WatchTheMouse, 5
   movedx := 0
   movedy := 0
   pixelsMoved := 0
;   TrayTip, Scrolling started, Emulating scroll wheel
;}
;Else
;   Send {XButton1}
return

XButton1up:
Hotkey, $*XButton1 Up, XButton1up, off
SetTimer, WatchTheMouse, off
;TrayTip
If (pixelsMoved = 0)
{
    ;The mouse was not moved, send the click event
    ; (May want to make it PGUP or something)
    Send {XButton1}
    Send {XButton1Up}
}
return

WatchTheMouse:
MouseGetPos, nx, ny
movedx := movedx+nx-ox
movedy := movedy+ny-oy

pixelsMoved := pixelsMoved + Abs(nx-ox) + Abs(ny-oy)

scaleX := 4
scaleY:= 3

timesX := Abs(movedx) / scaleX
ControlGetFocus, control, A
Loop, %timesX%
{
    If (movedx > 0)
    {
        SendMessage, 0x114, 1, 0, %control%, A ; 0x114 is WM_HSCROLL
        movedx := movedx - scaleX
    }
    Else
    {
        SendMessage, 0x114, 0, 0, %control%, A ; 0x114 is WM_HSCROLL
        movedx := movedx + scaleX
    }
}

timesY := Abs(movedy) / scaleY
Loop, %timesY%
{
    If (movedy > 0)
    {
        Click WheelDown
        movedy := movedy - scaleY
    }
    Else
    {
        Click WheelUp
        movedy := movedy + scaleY
    }
}   

MouseMove ox, oy
return