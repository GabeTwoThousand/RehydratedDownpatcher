#SingleInstance, force
PARAM1 = %1%
DllCall("shell32\ShellExecuteA", uint, 0, str, "RunAs", str, A_ScriptFullPath, str, """" . PARAM1 . """", str, A_WorkingDir, int, 1)
;------------------------
; GUI Layout
;------------------------
Gui, Color, 514E58, cWhite
Gui, Font, s15 cRed Bold
Gui, Add, Text, x210, STEP 1
Gui, Font, s13 cWhite 
Gui, Add, Text, x14, Before downpatching, you must install the DOTNet SDK
Gui, Font, s10, Norm
Gui, Add, Button, y+10 x100 w300 gInstall_DOTNet, Click Here to Install DOTNet SDK 3.1.302
Gui, Font, s15 cRed Bold
Gui, Add, Text, y+40 x210, STEP 2
Gui, Font, s13 cWhite Bold 
Gui, Add, Text, x150, Desired Game Revision
Gui, Font, s12 Norm
Gui, Add, Radio,vVersion603296 gVersion603296Checked x170 y+10, 603296 (06-23-20)
Gui, Add, Radio,vVersion603442 gVersion603442Checked y+10, 603442 (06-26-20)
Gui, Add, Radio,vVersion603899 gVersion603899Checked y+10, 603899 (07-17-20)
Gui, Font, s13 Bold 
Gui, Add, Text, x76 y+30, Steam Username
Gui, Font, s12 Norm
Gui, Add, Edit, -WantTab r1 vSteamUser x+5 w200,
Gui, Font, s13 Bold 
Gui, Add, Text, x78 y+30, Steam Password
Gui, Font, s11 Norm
Gui, Add, Edit, -WantTab r1 Password* r1 vSteamPass x+5 w200,
Gui, Font, s13 Bold 
Gui, Add, Button, y+40 x175 w120 gDownpatch, Downpatch
Gui, Show, w500 h500, RehydratedDownpatcher
return
;------------------------
; Labels
;------------------------

Install_DOTNet:
    StartDOTNetInstall()
return

Downpatch:
    GuiControlGet, SteamUser
    GuiControlGet, SteamPass
    StringLen, userLen, SteamUser
    StringLen, passLen, SteamPass

    ;error checking
    if Version not between 1 and 3 
    {
        MsgBox, Error: Please Select a Game Revision
    }
    else if userLen < 1
    {
        MsgBox, Error: Please Enter Your Steam Username
    }
    else if passLen < 1
    {
        MsgBox, Error: Please Enter Your Steam Password
    }
    else
    {
        StartDownpatch(Version, SteamUser, SteamPass)
    }
return

GuiClose:
    ExitApp
return

Version603296Checked:
    Version := 1
return
Version603442Checked:
    Version := 2
return
Version603899Checked:
    Version := 3
return

;------------------------
; Functions
;------------------------

StartDOTNetInstall()
{
    Run, dotnet-sdk-3.1.302-win-x64.exe, %A_ScriptDir%\Assets\ThirdParty
    return
}

StartDownpatch(Version, SteamUser, SteamPass)
{
    ;Set game manifest and other variables
    if Version = 1
    {
        ManifestID := 1053335632047073742
    }
    else if Version = 2
    {
        ManifestID := 4499864563879474996
    }
    else if Version = 3
    {
        ManifestID := 8029231884565495947
    }

    ;Get install location
    FileSelectFolder, InstallLocation,,,Please enter the address of the folder you'd like the downpatched version to be installed. `n(E.g. C:\Steam\steamapps\common\Rehydrated Downpatched)

    ;Give important info
    MsgBox, 48, Please Read, If you use SteamGuard authentication, you will be prompted for an authentication code.`nThis installation will take around 5-20 minutes depending on your internet speed. Please be patient.`nIf you see any InternalServerError messages, this is expected. Don't panic, just wait for it to finish    
    
    ;Setup for downloader
    DetectHiddenText, On
    VarSetCapacity(cmdText, 100000000)
    FinishedString := "100.00% depots\"
    Finished := 0
    SetKeyDelay, 0

    ;Run depotdownloader
    Run, cmd.exe, %A_ScriptDir%\Assets\ThirdParty\depotdownloader-2.3.6,, procID
    WinWaitActive, % "ahk_pid" procID
    SendEvent {Raw}dotnet DepotDownloader.dll -app 969990 -depot 969991 -manifest %ManifestID% -username %SteamUser% -password %SteamPass%
    Send {Enter}

    ;loop and check until download is finished
    While Finished = 0
    {
        Sleep 300
        VarSetCapacity(cmdText, (size:=1000000)*(A_IsUnicode ? 2:1))
        cmdText := GetTextFromCmd(procID)
        If InStr(cmdText, FinishedString)
        {
            Finished := 1
        }
    }

    ;Move downloaded files
    MoveInstall(InstallLocation)

    ;Show installation complete message
    MsgBox, Installation Complete

    ;Close cmd
    WinClose, % "ahk_pid" procID
    return
}

GetTextFromCmd(procID)
{
    ptr:=A_PtrSize ? "Ptr":"UInt", suffix:=A_IsUnicode ? "W":"A", numRead:=data:="", STD_INPUT_HANDLE:=-10, STD_OUTPUT_HANDLE:=-11
    VarSetCapacity(buffer, (size:=1000000)*(A_IsUnicode ? 2:1))
    DllCall("AttachConsole", "UInt", procID, A_PtrSize ? "UInt":"")
    hConsole:=DllCall("GetStdHandle", "Int", STD_OUTPUT_HANDLE, A_PtrSize ? "Ptr":"")
    DllCall("ReadConsoleOutputCharacter"suffix, ptr, hConsole, ptr, &buffer, "UInt", size, "UInt", 0, "UInt*", numRead, A_PtrSize ? "UInt":"")
    Loop, % numRead
    Mod(A_Index, 320) ? data.=Chr(NumGet(buffer, (A_Index-1)*(A_IsUnicode ? 2:1), A_IsUnicode ? "UShort":"UChar"))
                    . "" : data:=RTrim(data)"`r"
    Return RTrim(data)
    DllCall("FreeConsole")
}

MoveInstall(InstallLocation)
{
    FileMoveDir, %A_ScriptDir%\Assets\ThirdParty\depotdownloader-2.3.6\depots\969991\5347749, %InstallLocation%, 2
    FileRemoveDir,  %InstallLocation%\.DepotDownloader, 1
    FileCopy, E:\Documents\RehydratedDownpatcher\Assets\steam_appid.txt, %InstallLocation%, 1
    return
}