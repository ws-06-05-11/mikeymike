# Get-OrchestratorRunbooks.ps1

PowerShell script om runbook-informatie op te vragen van een System Center Orchestrator server via de ingebouwde Web Service API en het resultaat te exporteren naar een CSV-bestand.

---

## Vereisten

- Windows PowerShell 5.1 of hoger
- Orchestrator Web Service actief op de doelserver (standaard poort 81)
- Een account met leesrechten op de Orchestrator Web Service

**Controleer of de Web Service bereikbaar is:**
```
http://<server>:81/orchestrator2012/orchestrator.svc/
```

---

## Gebruik

### Alle runbooks ophalen

```powershell
.\Get-OrchestratorRunbooks.ps1 -OrchestratorServer "orch01.bedrijf.local"
```

Het script vraagt automatisch om inloggegevens.

### Met opgeslagen credentials

```powershell
$cred = Get-Credential
.\Get-OrchestratorRunbooks.ps1 -OrchestratorServer "orch01.bedrijf.local" `
    -Credential $cred
```

### Filteren op map

```powershell
.\Get-OrchestratorRunbooks.ps1 -OrchestratorServer "orch01.bedrijf.local" `
    -FolderFilter "Productie"
```

### Met CSV export naar specifieke map

```powershell
.\Get-OrchestratorRunbooks.ps1 -OrchestratorServer "orch01.bedrijf.local" `
    -OutputPath "C:\Rapporten"
```

### Alles gecombineerd

```powershell
.\Get-OrchestratorRunbooks.ps1 `
    -OrchestratorServer "orch01.bedrijf.local" `
    -Credential (Get-Credential) `
    -FolderFilter "Productie\Servers" `
    -OutputPath "C:\Rapporten"
```

---

## Parameters

| Parameter | Verplicht | Standaard | Omschrijving |
|---|---|---|---|
| `-OrchestratorServer` | Ja | — | Hostname of IP van de Orchestrator server |
| `-Port` | Nee | `81` | Poort van de Orchestrator Web Service |
| `-Credential` | Nee | Prompt | Inloggegevens voor de Web Service |
| `-OutputPath` | Nee | Huidige map | Map voor het CSV-bestand |
| `-FolderFilter` | Nee | Alle mappen | Filter op mapnaam in Orchestrator |

---

## Inhoud CSV-bestand

| Kolom | Omschrijving |
|---|---|
| `Naam` | Naam van het runbook |
| `Pad` | Map in Orchestrator |
| `ID` | Unieke GUID van het runbook |
| `Aangemaakt` | Aanmaakdatum |
| `Gewijzigd` | Datum laatste wijziging |
| `Uitgecheckt_Door` | Wie het runbook uitgecheckt heeft |
| `Beschrijving` | Omschrijving (indien ingevuld) |

---

## Voorbeelduitvoer

```
──────────────────────────────────────────────────────────
  Samenvatting
──────────────────────────────────────────────────────────
  Totaal runbooks  : 24

Naam                    Pad                 Gewijzigd          Uitgecheckt_Door
----                    ---                 ---------          ----------------
Backup controle         Productie\Servers   12-04-2025 08:30   -
Disk cleanup            Productie\Servers   03-03-2025 14:15   beheerder
Gebruiker aanmaken      Productie\AD        01-05-2025 09:00   -

  CSV opgeslagen: C:\Rapporten\Orchestrator_Runbooks_20250507_060000.csv
```

---

## Versienummers

Orchestrator slaat geen traditioneel versienummer op per runbook. De kolom `Gewijzigd` is de meest betrouwbare indicator voor de laatste versie. Wil je formeel versiebeheer bijhouden, gebruik dan de `Beschrijving` van een runbook, bijv.:

```
v2.1.0 — Aangepast voor nieuwe AD-structuur
```

---

## Problemen oplossen

| Foutmelding | Oorzaak | Oplossing |
|---|---|---|
| Verbinding geweigerd | Web Service niet actief of verkeerde poort | Controleer de Orchestrator Web Service in IIS |
| 401 Unauthorized | Verkeerde inloggegevens | Controleer gebruikersnaam en wachtwoord |
| 0 runbooks gevonden | Mapfilter te strikt | Controleer de mapnaam of laat `-FolderFilter` weg |
