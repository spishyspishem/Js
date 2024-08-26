#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

num_keys := A_Args[1]
hotkey1 := A_Args[2] ; https://superuser.com/a/1401837
hotkey2 := A_Args[3]

if(num_keys = 1)
{
  SendLevel 1 ; https://www.autohotkey.com/docs/v1/lib/SendLevel.htm#ExBasic
  SendInput {%hotkey1% down}
  Sleep, 100
  SendInput {%hotkey1% up}
  SendLevel 0
}
else if(num_keys = 2)
{
  SendLevel 1 ; https://www.autohotkey.com/docs/v1/lib/SendLevel.htm#ExBasic
  SendInput {%hotkey1% down}{%hotkey2% down}{%hotkey2% up}{%hotkey1% up}
  SendLevel 0
}
