# Standby & Verlof Rooster

Interactief weekrooster voor standby-diensten en verlofregistratie. Werkt volledig in de browser zonder installatie of internetverbinding.

---

## Openen

Dubbelklik op `rooster.html` om het rooster te openen in je browser. Er is geen server of installatie nodig.

---

## Functies

### Teambeheer
- Zes instelbare teamleden met elk een eigen kleur
- Klik op een naam in de linkerzijbalk om deze te bewerken
- Lege namen worden overgeslagen in de rotatie

### Standby rotatie
- Automatische weekrotatie door alle teamleden
- Standby loopt van **maandag 17:00 tot maandag 07:00**
- Klik op de naam in de **Standby**-kolom om handmatig te wisselen (blijft bewaard)
- Rotatie resetten via de knop **Reset rotatie** rechtsboven

### Verlof
- Klik op een cel in de rij van een teamlid om verlof in of uit te stellen
- 🌴 = verlof

### Conflictdetectie
- ⚠️ verschijnt automatisch als de standby-persoon die week ook verlof heeft
- Zowel de Standby-kolom als de verlofcel worden rood gemarkeerd

### Navigatie
- Jaar wisselen via de pijltjes rechtsboven
- Knop **Vandaag** (rechtsonder) springt naar de huidige week
- Maandscheidingen maken het rooster overzichtelijk

### Opslaan & afdrukken
- Alle gegevens worden automatisch opgeslagen in de browser (localStorage)
- Knop **Afdrukken** genereert een printversie zonder zijbalk en knoppen

---

## Schermindeling

```
┌─────────────────────────────────────────────────────────┐
│  ◈ Standby & Verlof         [jaar ‹ 2025 ›] [Afdrukken] │  ← Topbalk
├──────────────┬──────────────────────────────────────────┤
│ Team leden   │ Week │ Periode          │ Standby │ N1..N6│
│  ● Naam 1   ├──────┼──────────────────┼─────────┼───────┤
│  ● Naam 2   │  W01 │ ma 06 jan → ...  │ Naam 1  │ 🌴    │
│  ...         │  W02 │ ma 13 jan → ...  │ Naam 2  │       │
│              │  ... │                  │         │       │
│ Legenda      │                                           │
│ Gebruik      │                              [↓ Vandaag] │
└──────────────┴──────────────────────────────────────────┘
```

---

## Kolommen

| Kolom | Omschrijving |
|---|---|
| **Week** | ISO-weeknummer, huidige week gemarkeerd met **NU** |
| **Periode** | Datumrange van maandag tot maandag (17:00 → 07:00) |
| **Standby** | Wie de standby-dienst heeft; klik om te wisselen |
| **Naam 1 t/m 6** | Verlofstatus per teamlid; klik om verlof in/uit te stellen |

---

## Kleurcodering

| Kleur/Symbool | Betekenis |
|---|---|
| Gekleurde badge in Standby-kolom | Standby-persoon en diens kleur |
| 🌴 groene cel | Teamlid heeft verlof |
| ⚠️ rode cel + rode badge | Conflict: standby-persoon heeft verlof |
| Lichtblauwe rij | Huidige week |

---

## Gegevens bewaren

Alle gegevens (namen, verlof, handmatige standby-overrides) worden automatisch opgeslagen in de **localStorage** van de browser. Ze blijven bewaard na het sluiten van de browser.

> **Let op:** localStorage is gekoppeld aan de browser en het apparaat. Gebruik je het rooster op meerdere computers, kopieer dan het HTML-bestand inclusief de opgeslagen data niet — de data zit in de browser, niet in het bestand zelf.

---

## Technische details

| Kenmerk | Waarde |
|---|---|
| Technologie | HTML5, CSS3, Vanilla JavaScript |
| Afhankelijkheden | Geen (werkt offline na eerste laden van lettertypen) |
| Browseropslag | localStorage |
| Afdrukken | CSS print stylesheet ingebouwd |
| Weeknummering | ISO 8601 (week begint op maandag) |
