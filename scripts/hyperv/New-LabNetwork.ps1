#Requires -RunAsAdministrator
<#
.SYNOPSIS
  Cria a rede do lab: switch interno + gateway no host + NAT.
.NOTES
  Idempotente: pode ser executado varias vezes sem duplicar nada.
#>

$SwitchName = 'LabSwitch-NAT'
$NatName    = 'LabNAT'
$GatewayIP  = '10.10.10.1'
$Prefix     = 24
$Subnet     = '10.10.10.0/24'

# 1. Switch virtual interno
if (-not (Get-VMSwitch -Name $SwitchName -ErrorAction SilentlyContinue)) {
    New-VMSwitch -Name $SwitchName -SwitchType Internal | Out-Null
    Write-Host "[+] Switch $SwitchName criado"
} else {
    Write-Host "[=] Switch $SwitchName ja existe"
}

# 2. IP do host na placa virtual do switch (gateway das VMs)
$Alias = "vEthernet ($SwitchName)"
if (-not (Get-NetIPAddress -InterfaceAlias $Alias -IPAddress $GatewayIP -ErrorAction SilentlyContinue)) {
    New-NetIPAddress -InterfaceAlias $Alias -IPAddress $GatewayIP -PrefixLength $Prefix | Out-Null
    Write-Host "[+] Gateway $GatewayIP configurado em $Alias"
} else {
    Write-Host "[=] Gateway $GatewayIP ja configurado"
}

# 3. NAT: traduz o trafego da rede do lab para sair pelo Wi-Fi
if (-not (Get-NetNat -Name $NatName -ErrorAction SilentlyContinue)) {
    New-NetNat -Name $NatName -InternalIPInterfaceAddressPrefix $Subnet | Out-Null
    Write-Host "[+] NAT $NatName criado para $Subnet"
} else {
    Write-Host "[=] NAT $NatName ja existe"
}
