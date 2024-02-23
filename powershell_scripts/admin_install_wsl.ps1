

# enable WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Enable virtualization
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Init WSL
wsl --install --no-distribution

# Allow Traffic to WSL
New-NetFirewallHyperVRule -Name HTTP -DisplayName "HTTP" -Direction Inbound -VMCreatorId '{40E0AC32-46A5-438A-A0B2-2B479E8F2E90}' -Protocol TCP -LocalPorts 3000
