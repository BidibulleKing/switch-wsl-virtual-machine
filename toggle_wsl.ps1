param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false) {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    }
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

# $action = Read-Host -Prompt "Activer ou desactiver WSL ? Tapez 'enable' ou 'disable' : "

if ((Get-WindowsOptionalFeature -Online -FeatureName '*Hyper-V').State) {
    $action = Read-Host -Prompt "WSL is actually enabled. Do you want to disable it in order to use virtualization? Write 1 to disable it or 2 to exit the program: "

    if ($action -eq "1") {
        Disable-WindowsOptionalFeature -Online -FeatureName $("VirtualMachinePlatform", "Microsoft-Windows-Subsystem-Linux", "Microsoft-Hyper-V-All")
    }
    exit
}
else {
    $action = Read-Host -Prompt "WSL is actually disabled. Do you want to enable it (virtualization will be disabled)? Write 1 to enable it or 2 to exit the program: "

    if ($action -eq "1") {
        Enable-WindowsOptionalFeature -Online -FeatureName $("VirtualMachinePlatform", "Microsoft-Windows-Subsystem-Linux", "Microsoft-Hyper-V-All")
    }
    exit
}

# if ($action -eq "enable") {
#     Enable-WindowsOptionalFeature -Online -FeatureName $("VirtualMachinePlatform", "Microsoft-Windows-Subsystem-Linux", "Microsoft-Hyper-V-All")
# }
# else {
#     Disable-WindowsOptionalFeature -Online -FeatureName $("VirtualMachinePlatform", "Microsoft-Windows-Subsystem-Linux", "Microsoft-Hyper-V-All")
# }