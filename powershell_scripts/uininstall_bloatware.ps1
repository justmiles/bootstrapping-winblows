function uninstallMatchingPrograms {
  param(
    [string]$ProgramName
  )
    
  # $matchingPrograms = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*$ProgramName*" }
  $matchingPrograms = Get-AppxPackage | Where-Object { $_.Name -like "*$ProgramName*" } 
    
  foreach ($program in $matchingPrograms) {
    # $program.Uninstall() # WmiObject
    try {
      $program | Remove-AppxPackage -ErrorAction Stop
    }
    catch {
      Write-Host "Error while trying to uninstall $($program): $_"
    }
  }
}

# Remove Bloatware
uninstallMatchingPrograms "XboxIdentityProvider"
uninstallMatchingPrograms "XboxSpeechToTextOverlay"
uninstallMatchingPrograms "XboxGamingOverlay"
uninstallMatchingPrograms "XboxGameOverlay"
uninstallMatchingPrograms "Xbox.TCUI"
uninstallMatchingPrograms "Microsoft.Getstarted"
uninstallMatchingPrograms "MicrosoftWindows.Client.WebExperience"
uninstallMatchingPrograms "Microsoft.MicrosoftEdge.Stable"
uninstallMatchingPrograms "Microsoft.People"
uninstallMatchingPrograms "Microsoft.Paint"
uninstallMatchingPrograms "Microsoft.GamingApp"
uninstallMatchingPrograms "Microsoft.BingWeather"
uninstallMatchingPrograms "Microsoft.BingNews"
uninstallMatchingPrograms "Microsoft.Zune"
uninstallMatchingPrograms "Microsoft.Todos"
uninstallMatchingPrograms "Microsoft.WindowsMaps"
uninstallMatchingPrograms "Microsoft.MicrosoftStickyNotes"
uninstallMatchingPrograms "Clipchamp.Clipchamp"
uninstallMatchingPrograms "SpotifyAB.SpotifyMusic"

# Disable Xbox DVR
reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR /f /t REG_DWORD /v 'AppCaptureEnabled' /d 0
reg add HKEY_CURRENT_USER\System\GameConfigStore /f /t REG_DWORD /v 'GameDVR_Enabled' /d 0

# Remove crap from the taskbar
Get-ChildItem -Path "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" -Filter "*Edge*" | Remove-Item -Force


# Show magic hex data for binary key
# [string]::join(' ',((Get-ItemProperty -Path HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run -Name OneDrive).OneDrive|ForEach{'{0:x2}' -f $_}))

# Disable startup tasks; NOTE: MicrosoftEdgeAutoLaunch_4233AF25CED974BB9C198DFC1DC4FC90 may not be the same on all systems
$magicallyDisabled = '01 00 00 00 76 32 8b a9 1b 5a da 01'.Split(' ') | % { "0x$_" }
Set-ItemProperty -Path HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run -Name OneDrive -Type Binary -Value ([byte[]]$magicallyDisabled)
Set-ItemProperty -Path HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run -Name MicrosoftEdgeAutoLaunch_4233AF25CED974BB9C198DFC1DC4FC90 -Type Binary -Value ([byte[]]$magicallyDisabled)

