# Fusion mit Codex – Startpaket für Windows

Autodesk Fusion per natürlicher Sprache bedienen: parametrische Bauteile, geprüfte Maße, native Modelle, automatische Zeichnungen und Exporte für den 3D-Druck.

## Starten

1. **Codex auf dem Windows-PC öffnen und anmelden.** Benötigt wird eine lokale Codex-Sitzung mit Datei- und Terminalzugriff. Eine reine Browser-Unterhaltung lädt dieses Projekt nicht auf deinen PC und erreicht dessen lokalen Fusion-Server nicht.
2. Den Text aus **[INIT-PROMPT.md](INIT-PROMPT.md)** in Codex einfügen. Codex lädt das Projekt herunter, führt durch die Fusion-Installation und richtet die Verbindung ein.
3. Autodesk-Anmeldung, Lizenzwahl und gegebenenfalls Windows-Installationsdialoge selbst erledigen. Codex sagt dir, wann das nötig ist, und setzt danach fort.

Du musst das Repository vorher nicht herunterladen. Alternativ: **Code → Download ZIP**, entpacken und den Ordner in Codex öffnen.

**Zum Weiterleiten:** https://github.com/Abrahamz29/fusion-codex-starter/blob/main/INIT-PROMPT.md

## Was du bekommst

- Einen vollständigen Einrichtungs-Prompt einschließlich Download, Installation, MCP und Funktionstest.
- Den übertragbaren Skill `fusion-360-printing` mit Geometrieprüfung und Zeichnungsablauf.
- Projektregeln in [AGENTS.md](AGENTS.md), damit spätere Konstruktionen nach demselben Vorgehen entstehen.
- PowerShell-Helfer für Skill-Installation und einen lesenden MCP-Test.
- [Einrichtung und Fehlerhilfe](docs/EINRICHTUNG.md), [Beispielauftrag](docs/ERSTER-AUFTRAG.md) und einen ehrlichen [Prüfstand](docs/PRUEFSTAND.md).

Fusion enthält den lokalen MCP-Server bereits. Er wird in **Voreinstellungen → Allgemein → API → Fusion MCP Server** eingeschaltet. Verwende den dort angezeigten Port; Autodesk dokumentiert derzeit `27182` als Standard. Fusion muss geöffnet bleiben. [Autodesk-Anleitung](https://help.autodesk.com/cloudhelp/ENU/ADSKMCP-FusionDesktopMcp/files/ADSKMCP_FusionDesktopMcp_connecting_to_the_fusion_mcp_server_html.html)

Das Paket installiert keine zweite Fusion-Bridge, öffnet keine Router-Ports und enthält keine persönlichen CAD-Dateien, Zugangsdaten oder fremden Cloud-Verweise. Fusion, eine passende Autodesk-Lizenz und Codex sind separate Produkte. Verfügbarkeit von Zeichnungsautomatik und Exporten wird im jeweiligen Konto geprüft; es wird keine bestimmte Lizenzfunktion versprochen.

## Arbeitsweise

Konstruktionen entstehen über den nativen Fusion-MCP. Maße werden als Parameter angelegt und an der echten Geometrie geprüft. Für neue Bauteile gehören ein editierbares Modell, eine automatische Erstzeichnung, lokale Dateien und die Speicherung beider nativen Dokumente im eigenen Fusion-Konto zum vorgesehenen Ablauf. Die erste Zeichnung nutzt eine eigene gespeicherte F2T-Vorlage. Diese wird bei der Einrichtung erstellt oder aus dem eigenen Konto wiederverwendet; eine fremde Cloud-Vorlage ist nicht Teil des Downloads.

Nach Modelländerungen werden Zeichnungen erst auf Anfrage oder vor einem konkreten Druckauftrag aktualisiert. Eine bestandene CAD-Prüfung belegt keine reale Druckpassung.

## Quellen und Herkunft

- [Autodesk: Fusion herunterladen und installieren](https://help.autodesk.com/view/fusion360/ENU/?caas=caas%2Fsfdcarticles%2Fsfdcarticles%2FHow-to-download-Fusion-360.html)
- [Autodesk: Fusion für persönliche Nutzung](https://www.autodesk.com/products/fusion-360/personal)
- [OpenAI: MCP konfigurieren](https://learn.chatgpt.com/docs/extend/mcp)
- [OpenAI: Skills](https://learn.chatgpt.com/docs/build-skills)
- [Autodesk: Zeichnungsautomatik](https://help.autodesk.com/cloudhelp/ENU/Fusion-Drawing/files/DWG-AUTO-DRAWING.htm)

Stand der Einrichtungshinweise: 9. November 2026. Der Skill basiert auf einer angepassten MIT-Version von [HazAT/codex-fusion-360](https://github.com/HazAT/codex-fusion-360), Commit `9f7f54f4b63f28d29f4801c86fdabbcffc02a8bc`. Dessen Lizenz liegt im Skill-Ordner. Autodesk Fusion und Codex sind nicht Bestandteil dieser Software-Lizenz.
