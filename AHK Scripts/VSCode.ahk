#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#singleInstance force ; if this script is double clicked and is already running, it will be reloaded
 
; EnvGet, var, Installation
; I_Icon = %var%\3_Include\Dependencies\Icons\Autohotkey\AutoHotkey_Hue_Shifted_39.ico
; ICON [I_Icon]
; if I_Icon <> ; https://www.autohotkey.com/board/topic/121982-how-to-give-your-scripts-unique-icons-in-the-windows-tray/
; IfExist, %I_Icon%
; Menu, Tray, Icon, %I_Icon%
 
; if not A_IsAdmin ; if you don't do this, when you refresh an admin-priveleged-running autohotkey script in vs code (ctrl alt win p), it won't refresh at all
; {
; Run *RunAs "%A_ScriptFullPath%"
; ExitApp
; }
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; open current file in explorer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
^!#o::
ClipSaved := ClipboardAll ; Save the entire clipboard to a variable of your choice.
 
Send +!c ; make sure you set your VS code preference so that this shortcut always works instead of just whenever the editor isn't active (the default)
Sleep, 50 ; gotta give VS code some time to respond you know!
VScodefilepath = %Clipboard%
SplitPath, VScodefilepath,, dir
 
Run, "%dir%"
 
Clipboard := ClipSaved ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
ClipSaved = ; Free the memory in case the clipboard was very large.
Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; open a powershell window & change to the path of the active item in vs code (but don't run it)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
^!#i::
ClipSaved := ClipboardAll ; Save the entire clipboard to a variable of your choice.
 
Send +!c ; make sure you set your VS code preference so that this shortcut always works instead of just whenever the editor isn't active (the default)
Sleep, 50 ; gotta give VS code some time to respond you know!
VScodefilepath = %Clipboard%
SplitPath, VScodefilepath, name, dir, extension, namenoext
 
Run powershell.exe -NoExit -command "& {cd '%dir%'}"
Sleep, 100
IfInString,name,%A_Space% ; https://www.autohotkey.com/boards/viewtopic.php?t=27130
{
 if (extension = "py" OR extension = "pyw") ; using the & instead of ./ to account for spaces in filenames
 {
 Send, cls; & python '.\%name%'
  }
 else
 {
 Send, cls; & '.\%name%'
  }
}
Else
{
 if (extension = "py" OR extension = "pyw") ; using the & instead of ./ to account for spaces in filenames
 {
 Send, cls; python .\%name%
 }
 else
 {
 Send, cls; ./%name%
 }
}
 
Clipboard := ClipSaved ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
ClipSaved = ; Free the memory in case the clipboard was very large.
Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; run the current file, or compile and run if cpp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
^!#p::
ClipSaved := ClipboardAll ; Save the entire clipboard to a variable of your choice.
 
Send +!c ; make sure you set your VS code preference so that this shortcut always works instead of just whenever the editor isn't active (the default)
Sleep, 50 ; gotta give VS code some time to respond you know!
VScodefilepath = %Clipboard%
SplitPath, VScodefilepath, name, dir, extension, namenoext
backslash := "\"
; need to have a special case in case the script is run directly on the c, d, e, etc drives; have to manually add in the colon
if (StrLen(dir) = 2)
{
 dir := dir . backslash
}
 
; commandtext = %name% %dir% %extension% %namenoext%
Send ^s ; save the file before attempting to run it
if (extension = "cpp")
{
 ; msgbox %name%, %dir%, %extension%, %namenoext%
 ; problem detected for certain filepaths with parens: https://i.imgur.com/cgM4Yec.png
 ; looks like you need to escape parentheses in filepaths in the POWERSHELL "cd" command
 executablename = %namenoext%.exe
 executablefullname = %dir%\%executablename%
 compile_command = g++ -std=c++11 '%VScodefilepath%' -o '%executablefullname%'
 ; yeah i know the space escaping is annoying but you gotta do it
 Run powershell.exe -command "& {cd '%dir%'; %compile_command%; & '%executablefullname%'; Start-Sleep -m 50; remove-item '%executablefullname%'; Read-Host 'Press enter to exit'}"
}
else if (extension = "py" OR extension = "pyw") ; using the & instead of ./ to account for spaces in filenames
{
 Run powershell.exe -command "& {cd '%dir%'; python "%VScodefilepath%"; Read-Host 'Press enter to exit'}"
}
else if (extension = "ps1")
{
 Run powershell.exe -command "& {cd '%dir%'; & '%VScodefilepath%'; Read-Host 'Press enter to exit'}"
}
else if (extension = "bat" OR extension = "cmd")
{
 Run powershell.exe -command "& {cd '%dir%'; & '%VScodefilepath%'; Read-Host 'Press enter to exit'}"
}
else if (extension = "jsx")
{
 Send ^r ; uses the Adobe Runner extension to run the extendscript code in After Effects
}
else if (extension = "ahk")
{
 Run %VScodefilepath% ; assuming the AHK script uses "single instance force"
 ; Reload ; this only reloads this script, but it needs to reload the script in vs code by name!
}
 
Clipboard := ClipSaved ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
ClipSaved = ; Free the memory in case the clipboard was very large.
Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; open the file in an external program, such as a python script in spyder
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
^!#e::
ClipSaved := ClipboardAll ; Save the entire clipboard to a variable of your choice.
 
Send +!c ; make sure you set your VS code preference so that this shortcut always works instead of just whenever the editor isn't active (the default)
Sleep, 50 ; gotta give VS code some time to respond you know!
VScodefilepath = %Clipboard%
SplitPath, VScodefilepath, name, dir, extension, namenoext
backslash := "\"
; need to have a special case in case the script is run directly on the c, d, e, etc drives; have to manually add in the colon
if (StrLen(dir) = 2)
{
 dir := dir . backslash
}
 
; commandtext = %name% %dir% %extension% %namenoext%
Send ^s ; save the file before attempting to run it
if (extension = "py" OR extension = "pyw") ; using the & instead of ./ to account for spaces in filenames
{
 Run powershell.exe -command "& {Write-Host Opening in Spyder...; cd 'C:\Program Files\Python\Python37\Scripts'; ./spyder3.exe '%VScodefilepath%'}"
}
 
Clipboard := ClipSaved ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
ClipSaved = ; Free the memory in case the clipboard was very large.
Return
 
 
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 