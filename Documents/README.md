# WSUS Update Rapport Scripts

PowerShell scripts om automatisch een Windows Update compliance-rapport te genereren vanuit een WSUS server, met optionele e-mailversturing en wekelijkse automatisering via een Scheduled Task.

---

## Bestanden

| Bestand | Doel |
|---|---|
| `Get-WsusUpdateReport.ps1` | Hoofdscript — haalt updatestatus op en genereert CSV + HTML rapport |
| `Register-WsusReportTask.ps1` | Registreert een wekelijkse Scheduled Task |
| `Save-WsusSmtpCredential.ps1` | Slaat SMTP-wachtwoord veilig op via Windows DPAPI |

---

## Vereisten

- Windows PowerShell 5.1 of hoger
- WSUS Administration Tools (RSAT) op de machine waarop de scripts draaien

**Installeren op Windows Server:**
```powershell
Install-WindowsFeature -Name UpdateServices-UI
```

**Installeren op Windows 10/11:**
```powershell
Add-WindowsCapability -Online -Name Rsat.WSUS.Tools~~~~0.0.1.0
```

---

## Snel starten

### 1. Rapport eenmalig draaien

```powershell
.\Get-WsusUpdateReport.ps1 -WsusServer "wsus01.bedrijf.local"
```

Het script genereert een CSV en HTML rapport in de huidige map en toont een samenvatting in de console.

### 2. Wekelijkse taak instellen

```powershell
.\Register-WsusReportTask.ps1 `
    -WsusServer "wsus01.bedrijf.local" `
    -ScriptPath "C:\Scripts\Get-WsusUpdateReport.ps1" `
    -OutputPath "C:\Rapporten\WSUS"
```

De taak draait standaard elke **maandag om 06:00**. Taak verwijderen:

```powershell
.\Register-WsusReportTask.ps1 -Unregister
```

---

## E-mail instellen

### Stap 1 — Credentials veilig opslaan

Voer dit éénmalig uit **als het account dat de Scheduled Task uitvoert**:

```powershell
.\Save-WsusSmtpCredential.ps1 `
    -SmtpUser "wsus@bedrijf.nl" `
    -OutputFile "C:\Scripts\wsus_smtp.cred"
```

Het wachtwoord wordt gevraagd via een beveiligde prompt en opgeslagen als DPAPI-versleuteld bestand. Het bestand werkt alleen op dezelfde machine en onder hetzelfde Windows-account.

### Stap 2 — Rapport met e-mail draaien

```powershell
.\Get-WsusUpdateReport.ps1 `
    -WsusServer "wsus01.bedrijf.local" `
    -SmtpServer "smtp.office365.com" -SmtpPort 587 -SmtpUseTLS `
    -SmtpFrom "wsus@bedrijf.nl" `
    -SmtpTo "beheer@bedrijf.nl","manager@bedrijf.nl" `
    -SmtpCredentialFile "C:\Scripts\wsus_smtp.cred" `
    -SendOnlyIfIssues
```

### Stap 3 — Wekelijkse taak met e-mail

```powershell
.\Register-WsusReportTask.ps1 `
    -WsusServer "wsus01.bedrijf.local" `
    -ScriptPath "C:\Scripts\Get-WsusUpdateReport.ps1" `
    -OutputPath "C:\Rapporten\WSUS" `
    -RunAsUser "BEDRIJF\svc-wsusreport" -RunAsPassword "P@ssw0rd" `
    -SmtpServer "smtp.office365.com" -SmtpPort 587 -SmtpUseTLS `
    -SmtpFrom "wsus@bedrijf.nl" -SmtpTo "beheer@bedrijf.nl" `
    -SmtpCredentialFile "C:\Scripts\wsus_smtp.cred" `
    -SendOnlyIfIssues `
    -RunDay Monday -RunTime "06:00"
```

---

## Parameters

### Get-WsusUpdateReport.ps1

| Parameter | Verplicht | Standaard | Omschrijving |
|---|---|---|---|
| `-WsusServer` | Ja | — | Hostname of IP van de WSUS server |
| `-WsusPort` | Nee | `8530` | Poort (gebruik `8531` met SSL) |
| `-UseSSL` | Nee | `false` | HTTPS voor WSUS verbinding |
| `-OutputPath` | Nee | Huidige map | Map voor CSV en HTML rapporten |
| `-DaysBeforeStale` | Nee | `30` | Dagen zonder sync → machine als verouderd markeren |
| `-TargetGroup` | Nee | Alle groepen | Filteren op WSUS computergroep |
| `-SmtpServer` | Nee | — | SMTP server (weglaten = geen e-mail) |
| `-SmtpPort` | Nee | `587` | SMTP poort |
| `-SmtpUseTLS` | Nee | `false` | STARTTLS gebruiken |
| `-SmtpFrom` | Nee | — | Afzenderadres |
| `-SmtpTo` | Nee | — | Één of meerdere ontvangers |
| `-SmtpCc` | Nee | — | CC-ontvangers |
| `-SmtpCredentialFile` | Nee | — | Pad naar versleuteld credential-bestand |
| `-EmailSubject` | Nee | Automatisch | Aangepast e-mailonderwerp |
| `-SendOnlyIfIssues` | Nee | `false` | Alleen mailen bij problemen |

### Register-WsusReportTask.ps1

| Parameter | Verplicht | Standaard | Omschrijving |
|---|---|---|---|
| `-WsusServer` | Ja | — | Hostname of IP van de WSUS server |
| `-ScriptPath` | Ja | — | Volledig pad naar `Get-WsusUpdateReport.ps1` |
| `-OutputPath` | Ja | — | Map voor rapporten |
| `-RunDay` | Nee | `Monday` | Dag van de week |
| `-RunTime` | Nee | `06:00` | Tijdstip (HH:mm) |
| `-RunAsUser` | Nee | `SYSTEM` | Windows-account voor de taak |
| `-RunAsPassword` | Nee | — | Wachtwoord bij domein/lokaal account |
| `-TaskName` | Nee | `WSUS_Weekly_Report` | Naam van de taak |
| `-SmtpCredentialFile` | Nee | — | Pad naar versleuteld credential-bestand |
| `-SendOnlyIfIssues` | Nee | `false` | Alleen mailen bij problemen |
| `-Unregister` | Nee | — | Verwijder de taak |

### Save-WsusSmtpCredential.ps1

| Parameter | Verplicht | Standaard | Omschrijving |
|---|---|---|---|
| `-SmtpUser` | Ja | — | SMTP gebruikersnaam / e-mailadres |
| `-OutputFile` | Nee | Naast het script | Pad voor het credential-bestand |

---

## Rapportinhoud

Elk rapport bevat per machine:

- Computernaam en IP-adres
- Besturingssysteem
- **Up to date** (Ja/Nee)
- Status (`Up to date` / `Updates beschikbaar` / `Installatie mislukt` / `Herstart vereist` / `Niet gesynchroniseerd`)
- Aantal updates nodig, mislukt en wachtend op herstart
- Datum en tijd van laatste WSUS-synchronisatie

Het HTML-rapport wordt ook als e-mailbody verstuurd. De CSV en HTML worden als bijlage meegestuurd.

---

## Tips

**Handmatig testen na taakregistratie:**
```powershell
Start-ScheduledTask -TaskName "WSUS_Weekly_Report" -TaskPath "\IT-Beheer\"
```

**Credential-bestand aanmaken als SYSTEM** (indien de taak als SYSTEM draait):
```powershell
psexec.exe -s powershell.exe -File "C:\Scripts\Save-WsusSmtpCredential.ps1" -SmtpUser "wsus@bedrijf.nl"
```

**Aanbeveling:** gebruik een dedicated service-account (bijv. `svc-wsusreport`) in plaats van SYSTEM. Zo kun je eenvoudig inloggen als dat account om credentials op te slaan en is de beveiliging beter afgebakend.
