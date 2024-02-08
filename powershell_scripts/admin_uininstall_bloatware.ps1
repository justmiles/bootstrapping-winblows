# Disables/removes unncessary software
# Requires admin priv
# --------------

#  Disable Windows Copilot
reg add HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot /f /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1

# Disable Bing Bullshit
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Search /f /v BingSearchEnabled /t REG_DWORD /d 0

# Disable Cortanal; This is not Halo
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Search /f /v CortanaConsent /t REG_DWORD /d 0

# Disable unncessary scheduled jobs
Get-ScheduledTask | Where-Object { $_.TaskName -like "*XblGameSaveTask*" } | Unregister-ScheduledTask -Confirm:$false
Get-ScheduledTask | Where-Object { $_.TaskName -like "*OneDrive*" } | Unregister-ScheduledTask -Confirm:$false

# Remove unwanted desktop icons
Get-ChildItem -Path "C:\Users\Public\Desktop" -Filter "*Edge*" | Remove-Item -Force
