# Get-SccmBuildReport.ps1

PowerShell script om build- en versie-informatie op te halen uit SCCM (System Center Configuration Manager) en te exporteren naar een CSV-bestand op de D-schijf.

---

## Vereisten

- Windows PowerShell 5.1 of hoger
- Leesrechten op de SCCM WMI namespace (`root\SMS\site_<SiteCode>`)
- Het account moet lid zijn van de SCCM-rol **Read-only Analyst** of hoger
- Hardware-inventarisatie moet ingeschakeld zijn in SCCM

---

## Gebruik

### Alle systemen ophalen

```powershell
.\Get-SccmBuildReport.ps1 -SiteServer "sccm01.bedrijf.local"
```

CSV wordt automatisch opgeslagen als `D:\SCCM_BuildReport_<datum>.csv`.

### Filteren op collectie

```powershell
.\Get-SccmBuildReport.ps1 -SiteServer "sccm01.bedrijf.local" `
    -CollectionName "Alle Servers"
```

### Met eigen bestandsnaam

```powershell
.\Get-SccmBuildReport.ps1 -SiteServer "sccm01.bedrijf.local" `
    -OutputFile "D:\Rapporten\SCCM_Builds.csv"
```

### Met sitecode opgeven

```powershell
.\Get-SccmBuildReport.ps1 -SiteServer "sccm01.bedrijf.local" `
    -SiteCode "PS1"
```

### Met afwijkende credentials

```powershell
.\Get-SccmBuildReport.ps1 -SiteServer "sccm01.bedrijf.local" `
    -Credential (Get-Credential) `
    -OutputFile "D:\Rapporten\SCCM_Builds.csv"
```

---

## Parameters

| Parameter | Verplicht | Standaard | Omschrijving |
|---|---|---|---|
| `-SiteServer` | Ja | — | Hostname of IP van de SCCM site server |
| `-SiteCode` | Nee | Automatisch | SCCM sitecode, bijv. `PS1` |
| `-CollectionName` | Nee | Alle systemen | Filter op een SCCM collectienaam |
| `-OutputFile` | Nee | `D:\SCCM_BuildReport_<datum>.csv` | Volledig pad voor het CSV-bestand |
| `-Credential` | Nee | Huidig account | Inloggegevens voor de SCCM site server |

---

## Inhoud CSV-bestand

| Kolom | Omschrijving |
|---|---|
| `Computernaam` | Naam van de machine |
| `Domein` | Domein of werkgroep |
| `Fabrikant` | Hardware fabrikant |
| `Model` | Hardware model |
| `OS_Naam` | Naam van het besturingssysteem |
| `OS_Versie` | Versienummer, bijv. `10.0.19045` |
| `Build_Nummer` | Windows buildnummer, bijv. `19045` |
| `Service_Pack` | Servicepack indien aanwezig |
| `Architectuur` | `64-bit` of `32-bit` |
| `Laatste_Inventaris` | Datum van de laatste hardware-inventarisatie |
| `Actief_Gebruiker` | Laatste ingelogde gebruiker |
| `SCCM_Client_Versie` | Versie van de SCCM client op de machine |

---

## Voorbeelduitvoer

```
──────────────────────────────────────────────────────────
  Samenvatting
──────────────────────────────────────────────────────────
  Totaal verwerkt : 47

  Microsoft Windows Server 2022 Datacenter        : 18
  Microsoft Windows Server 2019 Standard          : 21
  Microsoft Windows 11 Enterprise                 :  8

Computernaam    OS_Naam                          Build_Nummer  OS_Versie    SCCM_Client_Versie
------------    -------                          ------------  ---------    ------------------
SERVER01        Microsoft Windows Server 2022    20348         10.0.20348   5.00.9096.1000
SERVER02        Microsoft Windows Server 2019    17763         10.0.17763   5.00.9096.1000
LAPTOP01        Microsoft Windows 11 Enterprise  22621         10.0.22621   5.00.9096.1000

  CSV opgeslagen : D:\SCCM_BuildReport_20250507_060000.csv
  Aantal regels  : 47
```

---

## Windows buildnummers naslagwerk

| Build | Versie |
|---|---|
| `19041` | Windows 10 2004 |
| `19042` | Windows 10 20H2 |
| `19043` | Windows 10 21H1 |
| `19044` | Windows 10 21H2 |
| `19045` | Windows 10 22H2 |
| `22000` | Windows 11 21H2 |
| `22621` | Windows 11 22H2 |
| `22631` | Windows 11 23H2 |
| `17763` | Windows Server 2019 |
| `20348` | Windows Server 2022 |

---

## Problemen oplossen

| Foutmelding | Oorzaak | Oplossing |
|---|---|---|
| `Kon sitecode niet ophalen` | Geen verbinding met SCCM WMI | Controleer servernaam en firewall (poort 135 + RPC) |
| `Toegang geweigerd` | Onvoldoende SCCM-rechten | Voeg account toe aan rol **Read-only Analyst** |
| `Collectie niet gevonden` | Verkeerde collectienaam | Controleer de naam in de SCCM-console (hoofdlettergevoelig) |
| Lege kolommen in CSV | Hardware-inventarisatie niet uitgevoerd | Forceer inventarisatie via SCCM client op de machine |
