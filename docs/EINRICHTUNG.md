# Einrichtung auf Windows

## Voraussetzungen und Installation

Codex läuft lokal mit Zugriff auf Terminal und Dateien. Vorhandene Installationen zuerst erkennen. Eine entfernte Sitzung kann nicht einfach auf `127.0.0.1` des Windows-PCs zugreifen. Bei fehlender lokaler Ausführung erst in die lokale Desktop-Sitzung wechseln; keine Tunnel oder externen Portfreigaben als Ersatz einrichten.

Fusion über die [offizielle Autodesk-Anleitung](https://help.autodesk.com/view/fusion360/ENU/?caas=caas%2Fsfdcarticles%2Fsfdcarticles%2FHow-to-download-Fusion-360.html) herunterladen. Bei vorhandener Lizenz: Autodesk-Konto → Produkte und Services → Fusion → Download. Ohne Lizenz die [Produktseite](https://www.autodesk.com/products/fusion-360/overview) beziehungsweise [persönliche Nutzung](https://www.autodesk.com/products/fusion-360/personal) verwenden und die passende Berechtigung selbst wählen. Keine Lizenz oder kostenlose Funktion allein aus der installierten Programmdatei ableiten.

Der Agent kann den offiziellen Download und Installer starten, soweit seine Werkzeuge und der Anmeldezustand dies ermöglichen. Der Nutzer erledigt Login, MFA, Lizenzwahl und Zustimmungen selbst. Wird der Installer vom Nutzer heruntergeladen, den konkreten Dateipfad übernehmen. Vor dem Start:

```powershell
Get-AuthenticodeSignature -LiteralPath 'C:\Pfad\zum\heruntergeladenen-Installer.exe' |
    Select-Object Status, StatusMessage, SignerCertificate
```

Nur bei gültiger Signatur und geprüftem Autodesk-Herausgeber ausführen. Keine feste Installer-URL oder undokumentierte Silent-Parameter voraussetzen. Danach erfolgreichen Start von Fusion prüfen; der Start eines Bootstrap-Installers allein belegt keinen Installationserfolg. Auf dem Zielrechner können fehlende Funktionen oder eine ältere Version ein reguläres Autodesk-Update erfordern.

## MCP aktivieren

Fusion öffnen, anmelden und **Voreinstellungen → Allgemein → API → Fusion MCP Server** aktivieren. Den dort angegebenen Port ablesen und Anwenden/OK bestätigen. Die erstmalige Aktivierung ist ein ausdrücklich vorgesehener UI-Schritt. Ein zusätzliches Python-Programm, Add-in oder API-Schlüssel ist für diese native lokale Verbindung nicht nötig. [Autodesk: Verbindung](https://help.autodesk.com/cloudhelp/ENU/ADSKMCP-FusionDesktopMcp/files/ADSKMCP_FusionDesktopMcp_connecting_to_the_fusion_mcp_server_html.html)

Die folgenden Beispiele verwenden **27182 nur als dokumentierten Standard**. Bei abweichender Anzeige überall den tatsächlichen Port einsetzen. Fusion während der Arbeit geöffnet lassen. Ein leeres Dokument kann für die erste Tool-Abfrage erforderlich sein; keine bestehende Arbeit schließen.

## Skill installieren

Im heruntergeladenen Projektordner:

```powershell
.\scripts\Install-Skill.ps1
```

Der Helfer kopiert ausschließlich den mitgelieferten Skill in `%USERPROFILE%\.agents\skills\fusion-360-printing`, den aktuell dokumentierten benutzerweiten Skill-Ordner. Er überschreibt keine abweichende vorhandene Version und erkennt identische Inhalte. Vorher auch ältere Installationen unter `%CODEX_HOME%\skills` bzw. `%USERPROFILE%\.codex\skills` prüfen, um doppelte gleichnamige Skills zu vermeiden. Wenn dort ein Skill existiert, mit `-SkillsRoot` diesen vorhandenen Stammordner gezielt prüfen. Bei Abweichungen beide Versionen vergleichen und vorhandene Anpassungen erhalten. [OpenAI: Skill-Orte](https://learn.chatgpt.com/docs/build-skills)

Falls die Ausführungsrichtlinie eine gelesene und geprüfte Datei blockiert, nur für diesen Aufruf `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Install-Skill.ps1` verwenden, soweit die lokale Richtlinie das zulässt. Keine dauerhafte Änderung der Systemrichtlinie. Der Helfer benötigt keine Administratorrechte.

## Codex konfigurieren

Bestehende Server lesen, sofern die CLI verfügbar ist:

```powershell
codex mcp list
codex mcp get fusion --json
```

Die Meldung, dass `fusion` nicht vorhanden ist, ist beim ersten Setup normal. Vor einer Änderung eine vorhandene Konfiguration lokal sichern. Wenn der Name frei ist:

```powershell
codex mcp add fusion --url http://127.0.0.1:27182/mcp
codex mcp get fusion
```

Bei einem passenden bestehenden Eintrag nichts ändern. Bei einer anders belegten Verbindung einen neuen freien Servernamen verwenden. Ohne CLI: die MCP-Einstellungen der lokalen App nutzen oder nach Sicherung eine neue Tabelle in der tatsächlich verwendeten Codex-Konfiguration ergänzen. Üblicher Ort: `%CODEX_HOME%\config.toml`, falls gesetzt, sonst `%USERPROFILE%\.codex\config.toml`. Keine vorhandene Tabelle duplizieren oder ganze Datei ersetzen.

```toml
[mcp_servers.fusion]
url = "http://127.0.0.1:27182/mcp"
```

Die Verbindung verwendet Streamable HTTP. Falls Codex die neue Verbindung noch nicht anzeigt, die Sitzung/Verbindungen neu laden. Dabei Fusion offen lassen. Die normale ChatGPT-Webseite liest keine lokale Codex-Konfiguration. [OpenAI: MCP](https://learn.chatgpt.com/docs/extend/mcp)

## Verbindung wirklich prüfen

```powershell
.\scripts\Test-FusionMcp.ps1 -Endpoint 'http://127.0.0.1:27182/mcp'
```

Der Test initialisiert MCP, entdeckt die Werkzeuge samt Schema und führt ausschließlich ein lesendes Versionsskript aus. Er speichert keine Modelle und ändert weder Fusion-Einstellungen noch Codex-Konfiguration. Nur bei bestandenem Test wird eine Erfolgsmeldung ausgegeben. Zusätzlich einen lesenden Aufruf über Codex selbst prüfen; ein funktionierender Hilfsclient belegt noch nicht die Tool-Einbindung in der App.

Der enthaltene HTTP-Helfer ist für die JSON-Antworten des geprüften nativen Fusion-Servers vorgesehen. Er erkennt SSE-Antworten, verarbeitet aber keine dauerhaft offenen Event-Streams. Bei SSE einen vollwertigen MCP-Client nutzen, nicht den Server umkonfigurieren. Alle Aufrufe haben ein Zeitlimit und werden nicht automatisch wiederholt. Nach einem CAD-Timeout kann Fusion noch arbeiten; keine weiteren CAD-Aufrufe aufstauen.

## Vorlage und vollständiger Einrichtungstest

Eine F2T ist eine native Fusion-Zeichnungsvorlage. Der Download enthält bewusst keine kontogebundene Vorlage. Im eigenen Cloud-Konto zunächst Projektwurzeln und Unterordner nach einer vorhandenen passenden F2T durchsuchen. Fehlt sie, eine eigene Vorlage einrichten: ISO, mm, A4 quer, orthogonale Ansichten und Isometrie, automatische Maße, **Auto-Select / auto**. Je nach Version/Lizenz können diese Funktionen fehlen; das ist ein konkret zu meldender offener Einrichtungsschritt.

MCP/API zuerst verwenden. Falls eine notwendige Vorlageneinstellung nachweislich nur in der UI gespeichert werden kann, ausschließlich diesen Schritt dort erledigen. **Als neue Zeichnungsvorlage speichern** bzw. **Ausgewählte Vorlage aktualisieren** verwenden; **OK** allein speichert nur Einstellungen für die aktuelle Erstellung. [Autodesk: Vorlageneinstellungen](https://help.autodesk.com/cloudhelp/ENU/Fusion-Drawing/files/DWG-AUTO-SETTINGS.htm)

Die gespeicherte Vorlage erneut öffnen und am [Testplatten-Auftrag](ERSTER-AUFTRAG.md) prüfen. Modell und verknüpfte native Zeichnung im selben geeigneten Cloud-Ordner speichern, Versionen und `DataFile.isComplete` kontrollieren. Lokale F3D, STEP und bemaßte PDF ablegen. Alle PDF-Seiten ansehen und die dargestellten Zahlen gegen die gemessene Geometrie prüfen. Nach erfolgreicher automatischer Erstzeichnung keine manuellen Detailmaße ergänzen.

Status lokal in `docs/SETUP-STATUS.local.md` festhalten. Mindestens:

| Bereich | Nachweis |
| --- | --- |
| Installation | Fusion-Version und erfolgreicher Start |
| Verbindung | tatsächlicher Endpunkt, MCP-Name, Werkzeuge, lesender Aufruf |
| Skill | installierter Pfad und Erkennung oder direkte Verwendung |
| Modell | Istmaße, Körper/Bohrungen, Parameteränderung und Wiederherstellung |
| Vorlage | eigene F2T, gespeichert, erneut geöffnet, Testzeichnung geprüft |
| Zeichnung | Quelle/Version, Ansichten, automatische Maße, sichtbare PDF-Prüfung |
| Cloud | Modell und Zeichnung: Zielordner, Version, vollständige Synchronisierung |
| Übergabe | Dateien und private Ansichtslinks, offene Schritte |

## Häufige Blocker

- **Verbindung abgelehnt:** Fusion geöffnet? MCP aktiviert? Angezeigter Port korrekt? Gleicher Rechner? Zuerst diese Punkte klären.
- **Werkzeuge fehlen in Codex:** Eintrag/Client-Neuladen prüfen; `tools/list` mit dem Helfer am selben Endpunkt verwenden. Keine zweite Bridge installieren.
- **Interaktiver Befehl aktiv:** Nutzerarbeit erhalten. Nur eigenen belegten Blocker gezielt beenden. Keine schreibende Operation als `readOnly` tarnen.
- **Timeout:** Ausführung kann weiterlaufen. Keine automatischen Wiederholungen, keine Neustartschleife. Teilzustand und letzte gespeicherte Version sichern, sobald wieder lesbar.
- **Zeichnungsfunktion fehlt:** Verfügbarkeit der installierten API und eigenen Lizenz prüfen. Modell/Verbindung und Zeichnungsstatus getrennt melden.
- **Cloud-Speicherung unvollständig:** Anmeldung/Zielordner/Synchronisierung prüfen; lokale Dateien nicht als abgeschlossene Online-Übergabe ausgeben.
