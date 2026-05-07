# Get-RegistryValue.ps1

PowerShell script om registerwaarden op te vragen, lokaal of op remote machines, met optionele CSV export.

---

## Vereisten

- Windows PowerShell 5.1 of hoger
- Voor remote machines: PowerShell Remoting (WinRM) actief op de doelmachine

**WinRM inschakelen op een remote machine:**
```powershell
Enable-PSRemoting -Force
```

---

## Gebruik

### Alle waarden in een sleutel opvragen (lokaal)

```powershell
.\Get-RegistryValue.ps1 -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
```

### Één specifieke waarde opvragen

```powershell
.\Get-RegistryValue.ps1 -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" `
    -ValueName "CurrentBuild"
```

### Remote machine

```powershell
.\Get-RegistryValue.ps1 -ComputerName "server01" `
    -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" `
    -ValueName "DisplayVersion"
```

### Meerdere remote machines

```powershell
.\Get-RegistryValue.ps1 -ComputerName "server01","server02","server03" `
    -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" `
    -ValueName "DisplayVersion"
```

### Met CSV export

```powershell
.\Get-RegistryValue.ps1 -ComputerName "server01","server02" `
    -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" `
    -OutputPath "C:\Rapporten"
```

### Resultaat in een variabele (voor gebruik in ander script)

```powershell
$resultaat = .\Get-RegistryValue.ps1 -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$resultaat | Where-Object Naam -eq "CurrentBuild"
```

---

## Parameters

| Parameter | Verplicht | Standaard | Omschrijving |
|---|---|---|---|
| `-Path` | Ja | — | Volledig registerpad, bijv. `HKLM:\SOFTWARE\...` |
| `-ComputerName` | Nee | Lokale machine | Één of meerdere machines |
| `-ValueName` | Nee | Alle waarden | Naam van een specifieke registerwaarde |
| `-OutputPath` | Nee | — | Map voor CSV export (wordt aangemaakt indien nodig) |

**Ondersteunde hives:**

| Afkorting | Volledige naam |
|---|---|
| `HKLM` | HKEY_LOCAL_MACHINE |
| `HKCU` | HKEY_CURRENT_USER |
| `HKCR` | HKEY_CLASSES_ROOT |
| `HKU` | HKEY_USERS |
| `HKCC` | HKEY_CURRENT_CONFIG |

---

## Voorbeelduitvoer

```
Machine: server01
  Pad   : HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion
  Naam  : CurrentBuild

  CurrentBuild                        [String]     22621
```

CSV export bevat de kolommen: `Computer`, `Pad`, `Naam`, `Waarde`, `Type`.

---

## Veelgebruikte registerpaden

| Doel | Pad |
|---|---|
| Windows versie | `HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion` |
| Geïnstalleerde software (32-bit) | `HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall` |
| Geïnstalleerde software (64-bit) | `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall` |
| Opstartprogramma's | `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run` |
| Tijdzone | `HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation` |
