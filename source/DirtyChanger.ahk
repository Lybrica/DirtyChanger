;#notrayicon

indexHelper = 0
ranImg = error
FileRead, folder, %A_ScriptDir%\bin\path.txt
folder = %folder%\ShooterGame\Content\WebAssets\images\merc-backgrounds
config = %A_ScriptDir%\bin\config.txt
FileRead, vRadio, %A_ScriptDir%\bin\radio.txt
FileRead, current, %config%
FileRead, confBackup, %config%
FileRead, from, %A_ScriptDir%\bin\from.txt
FileRead, check, %A_ScriptDir%\bin\check.txt
img = %folder%\%current%.webp
soliders = % list_files(folder)
IfExist %A_ScriptDir%\bin\time.txt
	FileRead, time, %A_ScriptDir%\bin\time.txt
IfNotExist %A_ScriptDir%\bin\time.txt
	time = every
FileRead, preCustom, %A_ScriptDir%\bin\custom.txt

Gui, 2: Color, FFFFFF
Gui, 2: add, Pic, x0, %A_ScriptDir%\bin\banner.png

Gui, 2: add, radio, x50 y100 vRadioManual gManual, Pick Manually
Gui, 2: Font, S11
Gui, 2: add, text, x25 y+20 vTextManual, Pick an image: 
Gui, 2: Font, S8
Gui, 2: add, button, x25 y+10 vBrowse gOnBrowse, Browse

Gui, 2: add, radio, x+80 y100 vRadioRandom gRandom, Randomly pick from folder
Gui, 2: Font, S11
Gui, 2: add, text, x25 y+20 vTextRandom, Choose folder: 
Gui, 2: Font, S8
Gui, 2: add, button, x25 y+10 vSelectFolder gOnFolder, Browse
Gui, 2: add, edit, x+10 w233 r1 vEditFolder, %from%
Gui, 2: add, Checkbox, x25  y+20 vCheckGame gCheckmate, Change with game launch
Gui, 2: add, DropDownList, w100 x+10 y+-17 vDrop gOnDropSelect, every time|every other time|custom..
Gui, 2: add, edit, w40 x+10 vEditCustom
Gui, 2: add, UpDown, vTimeUpDown Range3-99, %preCustom%

Gui, 2: Font, S11
Gui, 2: add, text, x25 y+40 vChangeText, Or change right now:
;Gui, 2: Font, S8
Gui, 2: Add, Button, vChangeButton gOnChangeClick x+15 y+-22, Randomize and change

Gui, 2: Add, Picture, vTick x100 y+30, %A_ScriptDir%\bin\tick.png
Gui, 2: Add, Text, vTickText x+15 y+-20, Image changed
;Gui, 2: Add, Picture, vTickImage x130 y+20, %folder%\%current%.webp
Gui, 2: Add, pic, gOnImageClick vTickImage x100 y+20 w160 h90, %ranImg%

Gui, 2: add, button, y+20 x25 w75 h23 gMainRestore, Restore
Gui, 2: add, button, y+-23 x+90 w75 h23 gMainOk, OK
Gui, 2: add, button, x+5 y+-23 w75 h23 gMainCancel, Cancel

GuiControl, 2: Hide, Tick
GuiControl, 2: Hide, TickText
GuiControl, 2: Hide, TickImage

if vRadio = manual
{
	GuiControl, 2: , RadioManual, 1
	GuiControl, 2: Hide, TextRandom
	GuiControl, 2: Hide, EditFolder
	GuiControl, 2: Hide, TimeUpDown
	GuiControl, 2: Hide, SelectFolder
	GuiControl, 2: Hide, EditCustom
	GuiControl, 2: Hide, CheckGame
	GuiControl, 2: Hide, Drop
	GuiControl, 2: Hide, ChangeText
	GuiControl, 2: Hide, ChangeButton
}
if vRadio = random
{
	GuiControl, 2: , RadioRandom, 1
	GuiControl, 2: Hide, TextManual
	GuiControl, 2: Hide, Browse
	
	GuiControl, 2: Hide, EditCustom
	GuiControl, 2: Hide, TimeUpDown
	
	If time = every
		GuiControl, 2: Choose, Drop, 1
	If time = everyOther
		GuiControl, 2: Choose, Drop, 2
	If time = custom
		GuiControl, 2: Choose, Drop, 3
		
	If check = 1
	{
		GuiControl, 2: , CheckGame, 1
		if time = custom
		{
			GuiControl, 2: Show, EditCustom
			GuiControl, 2: Show, TimeUpDown
		}
	}
	If check = 0
	{
		GuiControl, 2: Disable, Drop
		GuiControl, 2: Disable, EditCustom
		GuiControl, 2: Disable, TimeUpDown
		
		if time = custom
		{
			GuiControl, 2: Show, EditCustom
			GuiControl, 2: Show, TimeUpDown
		}
	}
	


}

Gui 2: Show,w350, Dirty Changer

IfExist %A_ScriptDir%\bin\first
{
	Gui, 3: Color, FFFFFF
	Gui, 3: Font, S13
	Gui, 3: Add, Text, y20, Please confirm Dirty Bomb directory:
	Gui, 3: Font, S8
	Gui, 3: Add, Edit, r1 w450 vEditConfirm, C:\Program Files (x86)\Steam\steamapps\common\Dirty Bomb
	Gui, 3: Add, Button, gConfirmBrowse x+10, Browse
	Gui, 3: Add, Button, gConfirmOk x360 w40 Default, Ok
	Gui, 3: Add, Button, w50 gConfirmQuit x410 y+-23, Quit
	Gui, 3: Show, ,Dirty Changer: confirm
	return
}

IfNotExist %A_ScriptDir%\bin\mercs.txt ; if running 4 the first time
{
	indexHelper = 1
	FileAppend, %soliders%, %A_ScriptDir%\bin\mercs.txt
}
IfExist %A_ScriptDir%\bin\mercs.txt
{
	FileRead, prevSoliders, %A_ScriptDir%\bin\mercs.txt
	
	If soliders != %prevSoliders%
	{
		FileDelete %A_ScriptDir%\bin\mercs.txt
		FileAppend, %soliders%, %A_ScriptDir%\bin\mercs.txt
		FileDelete %config%
		StringSplit, arraySoliders, soliders,|
		StringSplit, arrayPrevSoliders, prevSoliders,|
		loop, %arraySoliders0%
		{
			  if (arraySoliders%A_Index% != arrayPrevSoliders%A_Index%) {
				current = % arraySoliders%A_Index%
				If indexHelper != 1
					index = %A_Index%
				break
			  }
		}
		Goto  new
	}
}
return

new:
Gui, Color, FFFFFF
Gui, Font, s15
Gui, add, Text, Center y20, New merc realease or first time launching.
Gui, Font, s12
Gui, add, Text, Center w350, Select the new merc:
Gui, Font, s10
Gui, add, Text, Center w350,(should already be highlighted)
Gui, Font, s10
Gui, add, ListBox, x70 y+20 h300 w250 vList gListBox, %soliders%
Gui, Add, Edit, xm y+10 x70 w250 hwndHED1 vCustom 
SetEditCueBanner(HED1, "Or type the name here")
Gui, add, button, gSave, Submit
Gui, add, button, x+20 gCancel, Cancel
Gui, add, Text, y+3 x80 cGray, Enter
Gui, add, Text, y+-16 x160 cGray, Esc

GuiControl, Choose, List, %index%

Gui, Show, , Dirty Bomb Image Changer
return


continue:
img = %folder%\%current%.webp
FileSelectFile, SelectedFile, 3, , Pick an image,Images(*.jpg;*.png)
WinWaitClose Pick an image

IfNotExist, %A_ScriptDir%\backups\%current%.webp
	FileCopy, %img%, %A_ScriptDir%\backups\%current%.webp

FileCopy, %SelectedFile%, %img%, 1
return

ListBox:
if A_GuiEvent =  DoubleClick 
{
	GuiControlGet, List
	current = %List%
	Goto save
}
Return

Manual:
FileDelete %A_ScriptDir%\bin\radio.txt
FileAppend, manual, %A_ScriptDir%\bin\radio.txt
GuiControl, 2: , RadioRandom, 0
GuiControl, 2: Show, TextManual
GuiControl, 2: Hide, TextRandom
GuiControl, 2: Show, Browse
GuiControl, 2: Hide, EditFolder
GuiControl, 2: Hide, TimeUpDown
GuiControl, 2: Hide, EditCustom
GuiControl, 2: Hide, CheckGame
GuiControl, 2: Hide, Drop
GuiControl, 2: Hide, ChangeText
GuiControl, 2: Hide, ChangeButton
return

Random:
Gui, 2: Submit, NoHide
FileDelete %A_ScriptDir%\bin\radio.txt
FileAppend, random, %A_ScriptDir%\bin\radio.txt
GuiControl, 2: , RadioManual, 0
GuiControl, 2: Hide, TextManual
GuiControl, 2: Hide, Browse
GuiControl, 2: Show, TextRandom
GuiControl, 2: Show, SelectFolder
GuiControl, 2: Show, EditFolder
GuiControl, 2: Show, CheckGame
GuiControl, 2: Show, Drop
GuiControl, 2: Show, ChangeText
GuiControl, 2: Show, ChangeButton
If Drop = custom..
{
	GuiControl, 2: Show, EditCustom
	GuiControl, 2: Show, TimeUpDown
}
return

OnBrowse:
goto continue
return

OnFolder:
FileSelectFolder, from,,,Select folder
FileDelete, %A_ScriptDir%\bin\from.txt
FileAppend, %from%, %A_ScriptDir%\bin\from.txt
WinWaitClose Select folder
GuiControl, 2: , EditFolder, %from%
return

OnDropSelect:
Gui, 2: Submit, NoHide
FileDelete %A_ScriptDir%\bin\sync.txt
If Drop = custom..
{
	time = custom
	GuiControl, 2: Show, EditCustom
	GuiControl, 2: Show, TimeUpDown
	GuiControl, 2: Enable, TimeUpDown
	GuiControl, 2: Enable, EditCustom
}
else if Drop = every time
{
	time = every
	GuiControl, 2: Hide, EditCustom
	GuiControl, 2: Hide, TimeUpDown
}
else If Drop = every other time
{
	time = everyOther
	GuiControl, 2: Hide, EditCustom
	GuiControl, 2: Hide, TimeUpDown
}
FileDelete, %A_ScriptDir%\bin\time.txt
FileAppend, %time%, %A_ScriptDir%\bin\time.txt
return

Checkmate:
Gui, 2: Submit, nohide
if CheckGame = 1
{
	IfExist %A_ScriptDir%\bin\firstCheck
	{
		;FileCopy, "%A_ScriptDir%\bin\Dirty Bomb Launcher", "%A_Desktop%\Dirty Bomb Launcher"
		;MsgBox,,Please note, From now on please run Dirty Bomb via the shortcut placed on your desktop "Dirty Bomb Launcher". This allows the image to be changed according to your setting
		MsgBox,,Alert, From now on please run Dirty Bomb via "Dirty Bomb Launcher.exe". This allows the image to be changed according to your settings.`n`nYou can easily create a shortcut to it by right clicking and then selecting 'Send to: Desktop'
		FileDelete %A_ScriptDir%\bin\firstCheck
	}
	
	FileDelete %A_ScriptDir%\bin\sync.txt
	FileDelete %A_ScriptDir%\bin\check.txt
	FileAppend, 1, %A_ScriptDir%\bin\check.txt
	GuiControl, 2: Enable, Drop
	GuiControl, 2: Enable, EditCustom
	GuiControl, 2: Enable, TimeUpDown
	If Drop = custom..
	{
		GuiControl, 2: Show, EditCustom
		GuiControl, 2: Show, TimeUpDown
	}
}
if CheckGame = 0
{
	FileDelete %A_ScriptDir%\bin\check.txt
	FileAppend, 0, %A_ScriptDir%\bin\check.txt
	GuiControl, 2: Disable, Drop
	GuiControl, 2: Disable, EditCustom
	GuiControl, 2: Disable, TimeUpDown
	
	if Drop != custom..
	{
		GuiControl, 2: Hide, EditCustom
		GuiControl, 2: Hide, TimeUpDown
	}
}
return

ConfirmQuit:
exitapp

ConfirmOk:
Gui, 3: Submit
FileAppend, %EditConfirm%, %A_ScriptDir%\bin\path.txt
FileDelete %A_ScriptDir%\bin\first
folder = %EditConfirm%\ShooterGame\Content\WebAssets\images\merc-backgrounds
return

ConfirmBrowse:
FileSelectFolder, EditConfirm,,,Select Dirty Bomb directory
WinWaitClose Select Dirty Bomb directory
GuiControl, 3:Text, EditConfirm, %EditConfirm%
return

MainRestore:
Loop %A_ScriptDir%\backups\*.*, 0, 1
	Goto truee
MsgBox,, Alert, Nothing changed yet
Return

truee:
MsgBox, 4, Restore,Do you want to restore original images?
IfMsgBox Yes
{
	Loop %A_ScriptDir%\backups\*
	{
		FileMove, %A_LoopFileFullPath%, %folder%\%A_LoopFileName%, 1
	}
	MsgBox,,Restore, All images restored
}
return

MainOk:
Gui,2: Submit
FileDelete %A_ScriptDir%\bin\from.txt
FileDelete %A_ScriptDir%\bin\custom.txt
FileAppend, %EditFolder%, %A_ScriptDir%\bin\from.txt
FileAppend, %EditCustom%, %A_ScriptDir%\bin\custom.txt
exitapp

MainCancel:
exitapp

OnChangeClick:
Gui,2: Submit, NoHide

If !EditFolder
{
	MsgBox,,Error, Please choose a folder first
	Return
}

FileRead, folder, %A_ScriptDir%\bin\path.txt
folder = %folder%\ShooterGame\Content\WebAssets\images\merc-backgrounds
img = %folder%\%current%.webp

IfNotExist, %A_ScriptDir%\backups\%current%.webp
	FileCopy, %img%, %A_ScriptDir%\backups\%current%.webp

Loop, %EditFolder%\*
{
	Random, r, 0.0, %A_Index%
	if (r<1)
	{
		ranFile = %A_LoopFileFullPath%
	}
}
FileCopy, %ranFile%, %img%, 1

SetTimer, here, Off
GuiControl, 2: , TickImage, %ranFile%

GuiControl, 2: Show, Tick
GuiControl, 2: Show, TickText
GuiControl, 2: Show, TickImage
SetTimer, here, 7000,On
Return

here:
GuiControl, 2: Hide, Tick
GuiControl, 2: Hide, TickText
GuiControl, 2: Hide, TickImage
SetTimer,, Off
return

OnImageClick:
Run %ranFile%
Return

MenuHand:
MsgBox
Return

list_files(Directory)
{
	files =
	Loop %Directory%\*.*
	{
		SplitPath, A_LoopFileName,,,,OutNameNoExt
		If A_Index = 1 ; don't write '|' on the first loop
			files = %OutNameNoExt%
		Else
			files = %files%|%OutNameNoExt%
	}
	return files
}

SetEditCueBanner(HWND, Cue) {  ; requires AHL_L
   Static EM_SETCUEBANNER := (0x1500 + 1)
   Return DllCall("User32.dll\SendMessageW", "Ptr", HWND, "Uint", EM_SETCUEBANNER, "Ptr", True, "WStr", Cue)
}

Save:
Gui, Submit
If custom
{
	fileappend, %custom%, %config%
	img = %folder%\%custom%.webp
}
Else
{
	fileappend, %list%, %config%
	img = %folder%\%list%.webp
}
Gui, destroy
return

3GuiClose:
ExitApp

2GuiClose:
exitapp

Cancel:
GuiClose:
FileAppend, %current%, %config%
exitapp

#IfWinActive Dirty Bomb Image Changer
enter::goto Save
esc::
goto GuiClose