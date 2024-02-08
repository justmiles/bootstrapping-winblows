# chocolatey is a better-than-nothing package manager for windows. Install it with the following
# Requires admin priv
# --------------

# If your PowerShell Execution policy is restrictive, you may
# not be able to get around that. Try setting your session to
# Bypass.
Set-ExecutionPolicy Bypass -Scope Process -Force;

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

$env:Path += ";C:\ProgramData\chocolatey\bin"
[System.Environment]::SetEnvironmentVariable("PATH", $env:Path + ";C:\ProgramData\chocolatey\bin", "Machine")

# Install some packages
choco install -y `
  7zip `
  barrier `
  chocolateygui `
  citrix-workspace `
  git `
  googlechrome `
  nano  `
  notepadplusplus `
  powertoys `
  slack `
  tabby `
  zoom
