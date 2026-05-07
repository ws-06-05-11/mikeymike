# Get-IisApplicationVersion.ps1

PowerShell script om versie-informatie op te halen van applicaties die draaien onder IIS, lokaal of op remote servers, met optionele CSV export.

---

## Vereisten

- Windows PowerShell 5.1 of hoger
- IIS Management Tools op de doelserver (`WebAdministration` module)
- Voor remote uitvoering: PowerShell Remoting (WinRM) actief

**IIS Management Tools installeren:**
```powershell
Install-WindowsFeature -Name Web-Mgmt-Tools
```

**WinRM inschakelen op een remote server:**
```powershell
Enable-PSRemoting -Force
```

---

## Gebruik

### Lokaal

```powershell
.\Get-IisApplicationVersion.ps1
```

### Remote server

```powershell
.\Get-IisApplicationVersion.ps1 -ComputerName "webserver01"
```

### Meerdere servers

```powershell
.\Get-IisApplicationVersion.ps1 -ComputerName "webserver01","webserver02","webserver03" `
    -Credential (Get-Credential)
```

### Filteren op sitenaam

```powershell
.\Get-IisApplicationVersion.ps1 -ComputerName "webserver01" `
    -SiteFilter "MijnApplicatie"
```

### Met CSV export

```powershell
.\Get-IisApplicationVersion.ps1 -ComputerName "webserver01","webserver02" `
    -Credential (Get-Credential) `
    -OutputPath "C:\Rapporten"
```

### Resultaat in een variabele

```powershell
$resultaat = .\Get-IisApplicationVersion.ps1 -ComputerName "webserver01"
$resultaat | Where-Object Versie -ne "Niet gevonden"
```

---

## Parameters

| Parameter | Verplicht | Standaard | Omschrijving |
|---|---|---|---|
| `-ComputerName` | Nee | Lokale machine | Één of meerdere servers |
| `-SiteFilter` | Nee | Alle sites | Filter op (deel van) sitenaam |
| `-OutputPath` | Nee | — | Map voor CSV export |
| `-Credential` | Nee | — | Inloggegevens voor remote servers |

---

## Inhoud CSV-bestand

| Kolom | Omschrijving |
|---|---|
| `Server` | Naam van de server |
| `Site` | Naam van de IIS-site |
| `Applicatie` | Naam van de applicatie (`(root)` voor de hoofdapplicatie) |
| `Versie` | Gevonden versienummer |
| `IIS_Versie` | Versie van IIS op de server |
| `Site_Status` | Status van de site (`Started` / `Stopped`) |
| `AppPool` | Naam van de application pool |
| `AppPool_Status` | Status van de app pool (`Started` / `Stopped`) |
| `DotNet_Versie` | .NET versie van de app pool |
| `Fysiek_Pad` | Fysiek pad van de applicatie op de server |
| `Poort` | Poort waarop de site luistert |

---

## Hoe de versie wordt bepaald

Het script zoekt in deze volgorde naar een versienummer:

| Prioriteit | Bron | Toelichting |
|---|---|---|
| 1 | `web.config` — appSetting | Key `Version`, `AppVersion` of `version` |
| 2 | DLL / EXE in `bin`-map | `FileVersionInfo` van de grootste assembly (Microsoft en System libraries worden overgeslagen) |
| 3 | Niet gevonden | Geen versie-informatie aanwezig |

**Versie toevoegen via web.config:**
```xml
<appSettings>
    <add key="Version" value="2.4.1" />
</appSettings>
```

---

## Voorbeelduitvoer

```
──────────────────────────────────────────────────────────
  IIS applicaties ophalen — webserver01
──────────────────────────────────────────────────────────

Site               Applicatie     Versie   Site_Status  AppPool_Status  DotNet_Versie
----               ----------     ------   -----------  --------------  -------------
Default Web Site   (root)         1.0.0    Started      Started         v4.0
Default Web Site   api            2.3.1    Started      Started         Geen (.NET Core/5+)
MijnApplicatie     (root)         4.1.0    Started      Started         v4.0

  CSV opgeslagen: C:\Rapporten\IIS_Applicaties_20250507_060000.csv
```

---

## Problemen oplossen

| Foutmelding | Oorzaak | Oplossing |
|---|---|---|
| `WebAdministration module niet beschikbaar` | IIS Management Tools niet geïnstalleerd | `Install-WindowsFeature -Name Web-Mgmt-Tools` |
| `Toegang geweigerd` | Onvoldoende rechten | Voer uit als Administrator of gebruik `-Credential` |
| `WinRM verbinding mislukt` | Remoting niet actief op doelserver | `Enable-PSRemoting -Force` op de doelserver |
| `Versie: Niet gevonden` | Geen versie-info in binaries of web.config | Voeg een `Version` key toe aan `web.config` |
