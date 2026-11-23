<#
.SYNOPSIS
    Automatisierter System-Health-Check fuer Windows-Clients und Server.
.DESCRIPTION
    Prueft Hostname, Betriebssystem, RAM-Auslastung, freien Festplattenspeicher
    sowie die Netzwerkverbindung und speichert einen Bericht als Textdatei.
#>

$Date = Get-Date -Format "yyyy-MM-dd_HH-mm"
$ReportPath = "$PSScriptRoot\HealthReport_$Date.txt"

# 1. Systeminformationen abrufen
$OS = Get-CimInstance Win32_OperatingSystem
$TotalRAM = [math]::Round($OS.TotalVisibleMemorySize / 1MB, 2)
$FreeRAM = [math]::Round($OS.FreePhysicalMemory / 1MB, 2)
$UsedRAMPercent = [math]::Round((($TotalRAM - $FreeRAM) / $TotalRAM) * 100, 1)

# 2. Festplattenspeicher (Laufwerk C:) pruefen
$Disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$TotalDisk = [math]::Round($Disk.Size / 1GB, 2)
$FreeDisk = [math]::Round($Disk.FreeSpace / 1GB, 2)
$FreeDiskPercent = [math]::Round(($FreeDisk / $TotalDisk) * 100, 1)

$DiskStatus = if ($FreeDiskPercent -lt 20) { "WARNUNG: Wenig Speicherplatz!" } else { "OK" }

# 3. Netzwerk- & DNS-Test
$NetTest = Test-Connection -ComputerName 8.8.8.8 -Count 2 -Quiet
$NetStatus = if ($NetTest) { "Online (Erreichbar)" } else { "Offline (Fehler)" }

# 4. Bericht erstellen
$Report = @"
=============================================
      WINDOWS SYSTEM HEALTH REPORT
=============================================
Zeitstempel : $(Get-Date -Format "dd.MM.yyyy HH:mm:ss")
Hostname    : $env:COMPUTERNAME
OS          : $($OS.Caption)
---------------------------------------------
RAM Gesamt  : $TotalRAM GB
RAM Belegt  : $UsedRAMPercent %
---------------------------------------------
Laufwerk C: : $FreeDisk GB frei von $TotalDisk GB ($FreeDiskPercent %)
Disk-Status : $DiskStatus
---------------------------------------------
Internet    : $NetStatus
=============================================
"@

# Ausgabe in der Konsole und Export als Datei
Write-Host $Report -ForegroundColor Cyan
$Report | Out-File -FilePath $ReportPath -Encoding UTF8
Write-Host "Bericht erfolgreich gespeichert unter: $ReportPath" -ForegroundColor Green