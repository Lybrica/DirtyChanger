#NoTrayicon
FileRead, options, %A_ScriptDir%\bin\time.txt
FileRead, ability, %A_ScriptDir%\bin\check.txt
FileRead, current, %A_ScriptDir%\bin\config.txt
FileRead, folder, %A_ScriptDir%\bin\path.txt
If !folder
{
	MsgBox,,Error, Configure Dirty Changer first
	exitapp
}
folder = %folder%\ShooterGame\Content\WebAssets\images\merc-backgrounds
FileRead, from, %A_ScriptDir%\bin\from.txt
img = %folder%\%current%.webp

If ability = 0
	Goto justLaunch

If options = every
	Goto it
If options = everyOther
{
	FileRead, sync, %A_ScriptDir%\bin\sync.txt
	FileDelete %A_ScriptDir%\bin\sync.txt
	If sync = 0
	{
		FileAppend, 1, %A_ScriptDir%\bin\sync.txt
		Goto justLaunch
	}
	If sync = 1
	{
		FileAppend, 0, %A_ScriptDir%\bin\sync.txt
	}
	If !sync
	{
		FileAppend, 1, %A_ScriptDir%\bin\sync.txt
		Goto justLaunch
	}
}
If options = custom
{
	FileRead, sync, %A_ScriptDir%\bin\sync.txt
	FileRead, desire, %A_ScriptDir%\bin\custom.txt
	If !sync
	{
		FileAppend, 2, %A_ScriptDir%\bin\sync.txt
		Goto justLaunch
	}
	If sync != %desire%
	{
		sync++
		FileDelete %A_ScriptDir%\bin\sync.txt
		FileAppend, %sync%, %A_ScriptDir%\bin\sync.txt
		Goto justLaunch
	}
	If sync = %desire%
	{
		FileDelete %A_ScriptDir%\bin\sync.txt
		FileAppend, 1, %A_ScriptDir%\bin\sync.txt
	}
}

it:
Loop, %from%\*
{
	Random, r, 0.0, %A_Index%
	if (r<1)
	{
		ranFile = %A_LoopFileFullPath%
	}
}

IfNotExist, %A_ScriptDir%\backups\%current%.webp
	FileCopy, %img%, %A_ScriptDir%\backups\%current%.webp
FileCopy, %ranFile%, %img%, 1
justLaunch:
Run steam://rungameid/333930
ExitApp