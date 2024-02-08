

# enable WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Enable virtualization
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Init WSL
wsl --install --no-distribution
