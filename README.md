# RehydratedDownpatcher
A simple tool to make downpatching BFBB Rehydrated easy for speedrunners who need an earlier patch to run on.  
  
Tutorial video - https://youtu.be/ta_u8uisCjM  
The video also shows you how to preserve/transfer your steam controller mappings once you've downpatched.  
  
## Installation Instructions:  
(Prerequisite - You must own the game on steam and be using an OS that my tool supports. More OS support coming in later releases)  
* 1 - Download the latest release for your OS (Currently only working for Windows x64) (The file named RehydratedDownpatcher-<version>.zip  
* 2 - Extract the zip folder anywhere  
* 3 - Start the program (it will ask for admin privileges so it can install to restricted folders such as "C:/Program Files/...")  
* 4 - Press the first button to install the required DOTNet SDK and complete installation.  
* 5 - Return to the program and select your desired game revision and type your steam username/id (not Steam display name) and steam password  
* 6 - Click the second button labeled "Downpatch"  
* 7 - Navigate to your desired game installation folder. You can create new folders in this dialog if you need to (Be sure to remember where you installed this)  
* 8 - Carefully read the notice message that appears before hitting "Okay"   
* 9 (Conditional) - Enter your steamguard authentication code from your app or email into the cmd window that appears when prompted then hit enter (if you do not use 2FA you can disregard this step)  
* 10 - Wait very patiently for the game to download and copy to your selected install location. This will take a long time and will often seem to freeze, but wait it out, if it fails, it will time out and close, not hang.   
* 11 - When this is completed, it will pop up with a prompt saying "Installation Completed". You may now close the tool and Navigate to the installation folder you selected and it will be installed there.  
  
Note: To preserve steam controller mappings and steam FPS display, you need to add the .exe file in this new install to steam as a "non-steam game". You will also need to apply or create any custom controller mappings in steam big picture after adding it.  
  
## Compiling Instructions:  
If you want to compile the script for yourself I've also left instructions below.

* 1 - Download and install AutoHotKey - https://www.autohotkey.com/  
* 2 - Clone/Download the latest master branch of RehydratedDownpatcher and extract it to any desired location  
* 3 - Right click RehydratedDownloader.ahk and select "Compile Script" (if this option is not there, then you didn't install AutoHotKey or unchecked the box to allow windows shell shortcuts/options)  
  
### Reference Info for the manual use of DepotDownloader with Rehydrated
Steam AppID: 969990  
Steam Depot: 969991  
Revision: 603296 (06-23-20) ManifestID: 1053335632047073742  
Revision: 603442 (06-26-20) ManifestID: 4499864563879474996  
Revision: 603899 (07-17-20) ManifestID: 8029231884565495947  
Revision: 604909 (08-07-20) ManifestID: 5129037688278363502  

DepotDownloader download command format:  
`dotnet DepotDownloader.dll -app 969990 -depot 969991 -manifest ################### -username USER -password PASSWORD`  

### Credit for incorporated assets:  
DepotDownloader 2.3.6 by SteamRE - https://github.com/SteamRE/DepotDownloader/  
DOTNet SDK 3.1.303 by Microsoft - https://dotnet.microsoft.com/download/dotnet-core/3.1
