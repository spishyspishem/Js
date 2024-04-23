#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#singleInstance force ; if this script is double clicked and is already running, it will be reloaded
#MaxHotkeysPerInterval 300 ; mostly for the volume scroller

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Get local paths from text file ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FileRead, contents, paths.txt
StringSplit, lines, contents, `n
Jn := StrReplace(lines1, "`r", "")
downloads_path := StrReplace(lines2, "`r", "")
vs_code_path := StrReplace(lines3, "`r", "")
username := StrReplace(lines4, "`r", "")
passwd := StrReplace(lines5, "`r", "")
username2 := StrReplace(lines6, "`r", "")
passwd2 := StrReplace(lines7, "`r", "")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extra Shortcuts for Other Applications ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#IfWinActive ahk_exe notepad.exe
!z::
WinMenuSelectItem,,, Format, Word Wrap
Return
#IfWinActive

;;;;;;;;;;;;;;;;;;;;;;;
;; Move Mouse Cursor ;;
;;;;;;;;;;;;;;;;;;;;;;;

Launch_App2 & 1::
F13 & 1::
sorted_monitors := GetMonitorIndexesSortedByLeftmost()
PerformMove(sorted_monitors[1].ind,-1,-1)
return
 
Launch_App2 & 2::
F13 & 2::
sorted_monitors := GetMonitorIndexesSortedByLeftmost()
PerformMove(sorted_monitors[2].ind,-1,-1)
return

Launch_App2 & 3::
F13 & 3::
sorted_monitors := GetMonitorIndexesSortedByLeftmost()
PerformMove(sorted_monitors[3].ind,-1,-1)
return

Launch_App2 & 4::
F13 & 4::
sorted_monitors := GetMonitorIndexesSortedByLeftmost()
PerformMove(sorted_monitors[4].ind,-1,-1)
return

Launch_App2 & 5::
F13 & 5::
sorted_monitors := GetMonitorIndexesSortedByLeftmost()
PerformMove(sorted_monitors[5].ind,-1,-1)
return

Launch_App2 & 6::
F13 & 6::
sorted_monitors := GetMonitorIndexesSortedByLeftmost()
PerformMove(sorted_monitors[6].ind,-1,-1)
return

Launch_App2 & 7::
F13 & 7::
sorted_monitors := GetMonitorIndexesSortedByLeftmost()
PerformMove(sorted_monitors[7].ind,-1,-1)
return

Launch_App2 & 8::
F13 & 8::
sorted_monitors := GetMonitorIndexesSortedByLeftmost()
PerformMove(sorted_monitors[8].ind,-1,-1)
return

Launch_App2 & 9::
F13 & 9::
sorted_monitors := GetMonitorIndexesSortedByLeftmost()
PerformMove(sorted_monitors[9].ind,-1,-1)
return

Launch_App2 & 0::
F13 & 0::
sorted_monitors := GetMonitorIndexesSortedByLeftmost()
PerformMove(sorted_monitors[10].ind,-1,-1)
return

;;;;;;;;;;;;;;;
;; Activates ;;
;;;;;;;;;;;;;;;

F15 & e::
WinGet, id, list, ahk_class CabinetWClass
Loop, %id%
{
  this_ID := id%A_Index%
  WinActivate, ahk_id %this_ID%
}
return

F15 & x::
WinGet, id, list, ahk_exe Excel.exe
Loop, %id%
{
  this_ID := id%A_Index%
  WinActivate, ahk_id %this_ID%
}
return

F15 & c::
WinGet, id, list, ahk_exe chrome.exe
Loop, %id%
{
  this_ID := id%A_Index%
  WinActivate, ahk_id %this_ID%
}
return

F15 & o::
WinGet, id, list, ahk_exe outlook.exe
Loop, %id%
{
  this_ID := id%A_Index%
  WinActivate, ahk_id %this_ID%
}
return

F15 & t::
if(Jn = "i2")
{
  WinGet, id, list, ahk_exe slack.exe
}
else
{
  WinGet, id, list, ahk_exe ms-teams.exe
}
Loop, %id%
{
  this_ID := id%A_Index%
  WinActivate, ahk_id %this_ID%
}
return

;;;;;;;;;;;
;; Snaps ;;
;;;;;;;;;;;

snap_teams_outlook(OUTLOOK_MONITOR_INDEX, TeamsOnRight, Jn) ; snap these programs to the leftmost (farthest right) monitor
{
  SetTitleMatchMode, 2
  ; WinActivate ahk_exe OUTLOOK.EXE
  WinActivate, Inbox -
  WinActivate, Calendar -
  SetTitleMatchMode, 1
  SysGet, MonitorWorkArea, MonitorWorkArea, %OUTLOOK_MONITOR_INDEX%; %mon% 5
  WinMove, A,, MonitorWorkAreaLeft+200, 300
  if (TeamsOnright)
  {
    SendInput {Lwin down}{Left}{Lwin up}
  }
  else
  {
    SendInput {Lwin down}{Right}{Lwin up}
  }
  
  Sleep, 200
  
  ; WinActivate ahk_exe ms-teams.exe
  if(Jn = "i2")
  {
    WinActivate ahk_exe slack.exe
  }
  else
  {
    WinActivate ahk_exe ms-teams.exe
  }
  SysGet, MonitorWorkArea, MonitorWorkArea, %OUTLOOK_MONITOR_INDEX%; %mon% 5
  WinMove, A,, MonitorWorkAreaLeft+200, 300
  Sleep, 200
  ; obj := get_loc()
  if (TeamsOnright)
  {
    SendInput {Lwin down}{Right}{Lwin up}
  }
  else
  {
    SendInput {Lwin down}{Left}{Lwin up}
  }
  ; MouseMove, obj[1], obj[2]
}

snap_onenote_chrome(MONITOR_INDEX) ; snap these programs to the vertical monitor
{  
  WinActivate ahk_exe ONENOTE.EXE
  SysGet, MonitorWorkArea, MonitorWorkArea, %MONITOR_INDEX%; %mon% 5
  WinMove, A,, MonitorWorkAreaLeft+10, 300
  sendlevel 1 ; have to do this to use hotkeys defined in another script
  SendInput {Lwin down}{Alt down}{Up}{Alt up}{Lwin up}
  sendlevel 0
  
  Sleep, 100
  
  WinActivate ahk_exe chrome.exe
  SysGet, MonitorWorkArea, MonitorWorkArea, %MONITOR_INDEX%; %mon% 5
  WinMove, A,, MonitorWorkAreaLeft+10, 300
  sendlevel 1 ; have to do this to use hotkeys defined in another script
  SendInput {Lwin down}{Alt down}{Down}{Alt up}{Lwin up}
  sendlevel 0
}

Launch_App2 & NumpadDot::
F15 & 3::
if(Jn = "i2")
{
  WinActivate ahk_exe slack.exe
}
else
{
  WinActivate ahk_exe ms-teams.exe
}
Sleep, 20
obj := get_loc()
MouseMove, obj[1]-400, obj[2]
return

Launch_App2 & Numpad0:: ; Launch_App2 is the calculator button on the keyboard
OUTLOOK_MONITOR_INDEX := GetRightMostMonitorIndex()
snap_teams_outlook(OUTLOOK_MONITOR_INDEX, false, Jn)
return

Launch_App2 & Numpad1:: ; Launch_App2 is the calculator button on the keyboard
OUTLOOK_MONITOR_INDEX := GetRightMostMonitorIndex()
snap_teams_outlook(OUTLOOK_MONITOR_INDEX, true, Jn)
return

Launch_App2 & Numpad4:: ; Launch_App2 is the calculator button on the keyboard
sorted_monitors := GetMonitorIndexesSortedByLeftmost()
OUTLOOK_MONITOR_INDEX := sorted_monitors[sorted_monitors.Count() - 1].ind
snap_teams_outlook(OUTLOOK_MONITOR_INDEX, false, Jn)
return

Launch_App2 & Numpad2:: ; Launch_App2 is the calculator button on the keyboard
sorted_monitors := GetMonitorIndexesSortedByAspectRatio()
MONITOR_INDEX := sorted_monitors[1].ind
snap_onenote_chrome(MONITOR_INDEX)
return

Launch_App2 & F::
WinGet, hWndList, List, ahk_class CabinetWClass ahk_exe explorer.exe
Loop, %hWndList%
{
	hWnd := hWndList%A_Index%
	WinActivate, ahk_id %hWnd%
	Sleep 200
	sorted_monitors := GetMonitorIndexesSortedByLeftmost()
	SendInput {Ctrl down}{Lwin down}{Numpad5}{Lwin up}{Ctrl up} ; ensure window isn't at screen edge; can confuse monitors if it is
	Sleep 200
	PerformMoveWindow(sorted_monitors[2].ind)
	Sleep 200
	Remainder := Mod(A_Index-1, 3)
	if Remainder = 0
		SendInput {Ctrl down}{Lwin down}{Numpad1 down}{Numpad2 down}{Numpad3 down}{Numpad1 up}{Numpad2 up}{Numpad3 up}{Lwin up}{Ctrl up}
	else if Remainder = 1
		SendInput {Ctrl down}{Lwin down}{Numpad4 down}{Numpad5 down}{Numpad6 down}{Numpad4 up}{Numpad5 up}{Numpad6 up}{Lwin up}{Ctrl up}
	else
		SendInput {Ctrl down}{Lwin down}{Numpad7 down}{Numpad8 down}{Numpad9 down}{Numpad7 up}{Numpad8 up}{Numpad9 up}{Lwin up}{Ctrl up} 
	Sleep 200
}

;;;;;;;;;;;;;;;;
;; Timestamps ;;
;;;;;;;;;;;;;;;;

#`::
FormatTime, DateTimeString,, yyyy-MM-dd
Send, %DateTimeString%
return

^#`::
FormatTime, DateTimeString,, yyyy-MM-dd_HH-mm-ss
Send, %DateTimeString%
return

;;;;;;;;;;;;
;; Looper ;;
;;;;;;;;;;;;

Launch_App2 & c::
pth := downloads_path "\AA_Scripts\Python Scripts\circ.py"
Run, %ComSpec% /k python "%pth%"
return

;;;;;;;;;;;;;;;;;;;;
;; Sound Settings ;;
;;;;;;;;;;;;;;;;;;;;

Launch_App2 & s::
F17 & s::
Run, control mmsys.cpl sounds
return

Launch_App2 & m:: ; open up mouse pointer options
F17 & m::
Run, control main.cpl`,@0`,2
return

;;;;;;;;;;;;;
;; Strings ;;
;;;;;;;;;;;;;
Launch_App2 & q::
Send, %username%
return

Launch_App2 & w::
Send, %passwd%
return

Launch_App2 & e::
Send, %username2%
return

Launch_App2 & r::
Send, %passwd2%
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; File & Folder Shortcuts ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
Launch_App2 & a:: ; open this file
F17 & a::
pth := vs_code_path "\Code.exe"
Run "%pth%" "%A_ScriptDir%\%A_ScriptName%"
return

#If GetKeyState("Shift", "P")
Launch_App2 & a:: ; open containing folder
F17 & a::
Run "%A_ScriptDir%"
return
#If

;;;;;;;;;;;;;;;;;;;;;;
;; Outlook Controls ;;
;;;;;;;;;;;;;;;;;;;;;;
F15 & 1::
pause_outlook(1)
return

F15 & 2::
pause_outlook(2)
return

;;;;;;;;;;;;;;;
;; Functions ;;
;;;;;;;;;;;;;;;
pause_outlook(key)
{
  WinGet, id, List,,, Program Manager
  myregex := "(?:.*) - Outlook"
  Loop, %id%
  { ; https://www.the-automator.com/regexmatch-example-with-autohotkey/
    this_id := id%A_Index%
    WinGetClass, this_class, ahk_id %this_id%
    WinGetTitle, this_title, ahk_id %this_id%
    RegExMatch(this_title, myregex, Obj) ; https://regex101.com/r/QlrAkn/1
    if(Obj)
    {
      WinActivate %this_title%
      ControlSend, , {Ctrl Down}%key%{Ctrl Up}, %this_title%
    }
  }
}

objectSort(obj, keyName="", callbackFunc="", reverse=false)
{
  ; https://www.autohotkey.com/boards/viewtopic.php?t=49297
	temp := Object()
	sorted := Object() ;Return value
	for oneKey, oneValue in obj
	{
		;Get the value by which it will be sorted
		if keyname
			value := oneValue[keyName]
		else
			value := oneValue
		;If there is a callback function, call it. The value is the key of the temporary list.
		if (callbackFunc)
			tempKey := %callbackFunc%(value)
		else
			tempKey := value
		;Insert the value in the temporary object.
		;It may happen that some values are equal therefore we put the values in an array.
		if not isObject(temp[tempKey])
			temp[tempKey] := []
		temp[tempKey].push(oneValue)
	}
	;Now loop throuth the temporary list. AutoHotkey sorts them for us.
	for oneTempKey, oneValueList in temp
	{
		for oneValueIndex, oneValue in oneValueList
		{
			;And add the values to the result list
			if (reverse)
				sorted.insertAt(1,oneValue)
			else
				sorted.push(oneValue)
		}
	}
	return sorted
}

get_loc()
{
  winHandle := WinExist("A") ; The window to operate on
  
  ; Don't worry about how this part works. Just trust that it gets the 
  ; bounding coordinates of the monitor the window is on.
  ;--------------------------------------------------------------------------
  VarSetCapacity(monitorInfo, 40), NumPut(40, monitorInfo)
  monitorHandle := DllCall("MonitorFromWindow", "Ptr", winHandle, "UInt", 0x2)
  DllCall("GetMonitorInfo", "Ptr", monitorHandle, "Ptr", &monitorInfo)
  ;--------------------------------------------------------------------------
  
  workLeft      := NumGet(monitorInfo, 20, "Int") ; Left
  workTop       := NumGet(monitorInfo, 24, "Int") ; Top
  workRight     := NumGet(monitorInfo, 28, "Int") ; Right
  workBottom    := NumGet(monitorInfo, 32, "Int") ; Bottom
  WinGetPos,,, W, H, A
  WinGet, Style, Style, A
  BORDERSIZE = 100
  nW := abs(workLeft - workRight) - BORDERSIZE*2
  nH := abs(workTop - workBottom) - BORDERSIZE*2
  
  arr := [(workRight - workLeft) // 2, (workBottom - workTop) // 2]
  return arr
}

GetRightMostMonitorIndex()
{
  SysGet, MonitorCount, MonitorCount
  RightIndex := 1
  RightX := -1
  Loop %MonitorCount%
  {
    SysGet, Monitor, Monitor, %A_Index%
    if (MonitorRight > RightX)
    {
      RightX := MonitorRight
      RightIndex := A_Index
    }
  }
  return RightIndex
}

GetMonitorIndexesSortedByLeftmost()
{
  SysGet, MonitorCount, MonitorCount
  Monitors := []
  Loop, %MonitorCount%
  {
    SysGet, Monitor, Monitor, %A_Index%
    Monitors.Push({ind:A_Index, leftx:MonitorLeft})
  }
  Monitors := objectSort(Monitors, "leftx")
  Return Monitors
}

GetMonitorIndexesSortedByAspectRatio()
{
  SysGet, MonitorCount, MonitorCount
  Monitors := []
  Loop, %MonitorCount%
  {
    SysGet, Monitor, Monitor, %A_Index%
    height := MonitorBottom - MonitorTop
    width := MonitorRight - MonitorLeft
    Monitors.Push({ind:A_Index, ar:width/height})
  }
  Monitors := objectSort(Monitors, "ar")
  Return Monitors
}
 
PerformMove(MoveMonNum,OffX,OffY)
{ ; https://www.experts-exchange.com/articles/33932/Keyboard-shortcuts-hotkeys-to-move-mouse-in-multi-monitor-configuration-AutoHotkey-Script.html
  global MoveX,MoveY
  ; Gosub,CheckNumMonsChanged ; before performing move, check if the number of monitors has changed
  RestoreDPI:=DllCall("SetThreadDpiAwarenessContext","ptr",-3,"ptr") ; enable per-monitor DPI awareness and save current value to restore it when done - thanks to lexikos for this
  SysGet,Coordinates%MoveMonNum%,Monitor,%MoveMonNum% ; get coordinates for this monitor
  Left:=Coordinates%MoveMonNum%Left
  Right:=Coordinates%MoveMonNum%Right
  Top:=Coordinates%MoveMonNum%Top
  Bottom:=Coordinates%MoveMonNum%Bottom
  If (OffX=-1)
    MoveX:=Left+(Floor(0.5*(Right-Left))) ; center
  Else
    MoveX:=Left+OffX
  If (OffY=-1)
    MoveY:=Top+(Floor(0.5*(Bottom-Top))) ; center
  Else
    MoveY:=Top+OffY
  DllCall("SetCursorPos","int",MoveX,"int",MoveY) ; first call to move it - usually works but not always
  Sleep,10 ; wait a few milliseconds for first call to settle
  DllCall("SetCursorPos","int",MoveX,"int",MoveY) ; second call sometimes needed
  DllCall("SetThreadDpiAwarenessContext","ptr",RestoreDPI,"ptr") ; restore previous DPI awareness - thanks to lexikos for this
  Return
}

GetCurrentMonitor()
{
	SysGet, numberOfMonitors, MonitorCount
	WinGetPos, winX, winY, winWidth, winHeight, A
	winMidX := winX + winWidth / 2
	winMidY := winY + winHeight / 2
	Loop %numberOfMonitors%
	{
		SysGet, monArea, Monitor, %A_Index%
		; MsgBox, %A_Index% %monAreaLeft% %winX%
	if (winMidX > monAreaLeft && winMidX < monAreaRight && winMidY < monAreaBottom && winMidY > monAreaTop)
		return A_Index
	}
	SysGet, primaryMonitor, MonitorPrimary
	return "No Monitor Found"
}

PerformMoveWindow(MoveMonNum)
{
  SysGet,Coordinates%MoveMonNum%,MonitorWorkArea,%MoveMonNum%
  TMleft:=Coordinates%MoveMonNum%Left
  TMright:=Coordinates%MoveMonNum%Right
  TMtop:=Coordinates%MoveMonNum%Top
  TMbottom:=Coordinates%MoveMonNum%Bottom
  TMw:=TMright-TMleft
  TMh:=TMbottom-TMtop
  WinGetPos, OWleft, OWtop, OWw, OWh, A

  MonitorIndex := GetCurrentMonitor()
  SysGet,Coordinates%MonitorIndex%,MonitorWorkArea,%MonitorIndex%
  OMleft:=Coordinates%MonitorIndex%Left
  OMright:=Coordinates%MonitorIndex%Right
  OMtop:=Coordinates%MonitorIndex%Top
  OMbottom:=Coordinates%MonitorIndex%Bottom
  OMw:=OMright-OMleft
  OMh:=OMbottom-OMtop

  wperc := (OWleft - OMleft)/OMw
  TWleft := TMleft + wperc*TMw
  TWw := OWw*TMw/OMw

  hperc := (OWtop - OMtop)/(OMh)
  TWtop := TMtop + hperc*TMh
  TWh := OWh*TMh/(OMh)

  WinGet, IsMax, MinMax, A
  WinRestore,% ["A"][IsMax] ; if window is maximized
  WinMove, A,, TWleft, TWtop, TWw, TWh
  WinMaximize,% ["A"][IsMax] ; if window was maximized
}
