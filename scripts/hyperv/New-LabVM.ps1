#Requires -RunAsAdministrator
<#
.SYNOPSIS
  Cria uma VM Linux Geracao 2 no lab.
.EXAMPLE
  .\New-LabVM.ps1 -Name DOCKER01 -IsoPath 'F:\Instaladores\SOs\ubuntu-24.04.2-live-server-amd64.iso' -MemoryGB 16 -CPU 4 -DiskGB 200
#>
param(
    [Parameter(Mandatory)] [string] $Name,
    [Parameter(Mandatory)] [string] $IsoPath,
    [int]    $MemoryGB   = 4,
    [int]    $CPU        = 2,
    [int]    $DiskGB     = 60,
    [string] $SwitchName = 'LabSwitch-NAT',
    [string] $VMRoot     = 'G:\VMs\Hyper-V'
)

if (Get-VM -Name $Name -ErrorAction SilentlyContinue) {
    Write-Host "[=] VM $Name ja existe - nada a fazer"
    return
}

if (-not (Test-Path $IsoPath)) { throw "ISO nao encontrada: $IsoPath" }

$VhdDir  = Join-Path $VMRoot "$Name\Virtual Hard Disks"
$VhdPath = Join-Path $VhdDir "$Name.vhdx"
New-Item -ItemType Directory -Path $VhdDir -Force | Out-Null

New-VM -Name $Name -Generation 2 -Path $VMRoot `
       -MemoryStartupBytes ($MemoryGB * 1GB) `
       -NewVHDPath $VhdPath -NewVHDSizeBytes ($DiskGB * 1GB) `
       -SwitchName $SwitchName | Out-Null

Set-VM -Name $Name -ProcessorCount $CPU -StaticMemory -AutomaticCheckpointsEnabled $false
Set-VMFirmware -VMName $Name -SecureBootTemplate 'MicrosoftUEFICertificateAuthority'
$Dvd = Add-VMDvdDrive -VMName $Name -Path $IsoPath -Passthru
Set-VMFirmware -VMName $Name -FirstBootDevice $Dvd

Write-Host "[+] VM $Name criada: $MemoryGB GB RAM, $CPU vCPU, disco $DiskGB GB (dinamico), switch $SwitchName"
