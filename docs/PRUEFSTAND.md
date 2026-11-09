# Prüfstand des Startpakets

Stand: 9. November 2026.

## Geprüft

- Skill-Struktur mit dem Skill-Validator geprüft; Frontmatter und Referenzdateien vorhanden.
- PowerShell-Syntax geprüft. Isolierte Helfertests unter Windows PowerShell 5.1 und PowerShell 7 bestanden.
- Installation in temporären Testordner, identische Wiederholung und Schutz einer abweichenden vorhandenen Skill-Datei geprüft.
- MCP-Tests mit isoliertem lokalem HTTP-Testserver: erfolgreiche Initialisierung/Tool-Discovery/lesender Aufruf; Erkennung von JSON-RPC-Fehler, Toolfehler, innerem `success=false`, fehlendem Versionsnachweis und nicht unterstützter SSE-Antwort. Fehler führen nicht zu automatischen Wiederholungen. Nicht lokale Endpunkte werden abgelehnt.
- Echter lesender MCP-Verbindungstest mit Autodesk Fusion **2706.1.17** bestanden: vier Werkzeuge entdeckt und die Versionsnummer innerhalb Fusion ausgelesen. Auch mit Windows PowerShell 5.1 erfolgreich. Dabei keine Modelle oder Fusion-Einstellungen geändert.
- Paket auf persönliche Pfade, projektbezogene Cloud-IDs und lokale Konfiguration geprüft; diese sind nicht Bestandteil der Veröffentlichung. Lokale Konstruktionen und Setup-Protokolle sind per `.gitignore` ausgeschlossen.

Beim Test wurde ein PowerShell-5.1-Problem gefunden und behoben: `Get-Content` kann Zusatzmetadaten an Zeichenfolgen hängen, die bei tiefer JSON-Serialisierung sehr große Objektbäume erzeugen. Der Helfer liest Skripttext deshalb direkt mit `File.ReadAllText`. Sein lokaler HTTP-Client verwendet keine Proxy-Erkennung und keine Weiterleitungen.

## Noch auf jedem Zielrechner zu prüfen

- Vollständiger Fusion-Download und Neuinstallation auf einem frischen Windows-PC.
- Autodesk-Anmeldung, individuelle Lizenz und verfügbare Zeichnungs-/Exportfunktionen.
- Aktivierung des nativen MCP-Servers, tatsächlicher Port und Einbindung in die dortige Codex-App.
- Eigene Cloud-Ablage, dauerhaft gespeicherte F2T, erneutes Öffnen und vollständiger Testplatten-/Zeichnungs-/PDF-Ablauf.
- Slicer und reale Druckpassung. Das Startpaket selbst ist kein getestetes Druckteil.

Die Verbindung wurde an einer vorhandenen Installation geprüft. Das ist kein Nachweis für eine vollautomatische Neuinstallation oder identische Funktionen in allen Konten. Der Einrichtungs-Prompt führt die noch offenen Prüfungen auf dem Zielrechner aus und hält Teilergebnisse getrennt fest.

## Helfertests wiederholen

Nur für Entwicklung am Startpaket; der normale Nutzer benötigt Python nicht:

```powershell
python .\scripts\test_helpers.py
```

Die Tests verwenden temporäre Ordner und einen lokalen simulierten MCP-Server. Sie installieren nichts benutzerweit und greifen nicht auf echtes Fusion zu. Standardmäßig wird Windows PowerShell verwendet, alternativ:

```powershell
$env:TEST_POWERSHELL = (Get-Command pwsh).Source
python .\scripts\test_helpers.py
```
