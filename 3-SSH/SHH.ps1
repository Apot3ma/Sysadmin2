# Verificar si OpenSSH Server está instalado
$ssh = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'

if ($ssh.State -eq "Installed") {
    Write-Host "OpenSSH Server ya esta instalado" -ForegroundColor Green
}
else {
    Write-Host "Instalando OpenSSH Server..."
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
}

# Iniciar servicio SSH
Start-Service sshd

# Configurar inicio automatico
Set-Service -Name sshd -StartupType Automatic

Write-Host "SSH instalado y servicio iniciado correctamente"