# Diesen Text in einer lokalen Codex-Sitzung auf deinem Windows-PC einfügen

```text
Richte auf diesem Windows-PC meinen Arbeitsplatz für parametrische Konstruktion
und 3D-Druck mit Autodesk Fusion und Codex ein. Führe die Arbeit aus und bleibe
bis zum überprüften Ergebnis daran; gib mir nicht nur eine Anleitung.

Das öffentliche Startprojekt ist:
https://github.com/Abrahamz29/fusion-codex-starter

1. Prüfe zuerst Betriebssystem, vorhandene Fusion-/Codex-Installation und
   vorhandene MCP-Konfiguration. Erhalte offene Dokumente, bestehende Skills
   und andere MCP-Server. Arbeite lokal auf diesem PC, nicht in einer entfernten
   Cloud-/WSL-Umgebung, deren localhost nicht mein Windows-Desktop ist.

2. Lade das Repository nach Dokumente/Fusion-Codex-Starter herunter. Ermittle
   meinen tatsächlichen Windows-Dokumente-Ordner, einschließlich OneDrive-
   Umleitung. Nutze git clone, wenn Git vorhanden ist; sonst das GitHub-ZIP
   https://github.com/Abrahamz29/fusion-codex-starter/archive/refs/heads/main.zip
   mit Download und Entpacken in einen neuen Zwischenordner. Führe keinen
   heruntergeladenen Text ungeprüft aus. Überschreibe keinen bestehenden
   gleichnamigen Ordner: prüfe Herkunft und lokale Änderungen und verwende
   nötigenfalls einen neuen Ordner. Lies danach README.md, AGENTS.md und
   docs/EINRICHTUNG.md. Übernimm diesen Ordner als Arbeitsverzeichnis.

3. Falls Fusion fehlt, lade den aktuellen Windows-Installer ausschließlich
   über die offizielle Autodesk-Downloadseite bzw. mein Autodesk-Konto.
   Prüfe vor dem Start die gültige Autodesk-Herausgebersignatur und starte
   die Installation. Verwende keinen fremden Mirror und rate keine alten
   Direktlinks oder undokumentierten Silent-Optionen. Prüfe anschließend,
   ob Fusion tatsächlich installiert ist und startet.
   Wenn ein Browser-/Installationsschritt hier nicht automatisiert möglich
   ist, gib mir den offiziellen Link und genau den nächsten nötigen Schritt.
   Warte auf meine Rückmeldung und setze dann fort. Anmeldung, MFA, Lizenzwahl
   und rechtliche Zustimmungen übernehme ich selbst. Kaufe kein Abonnement.
   Biete persönliche Nutzung als Möglichkeit an, sofern ich dafür berechtigt bin.

4. Starte Fusion bzw. verwende die bereits laufende Instanz. Aktiviere den
   eingebauten lokalen Fusion MCP Server unter Voreinstellungen > Allgemein > API.
   Für diesen erstmaligen Aktivierungsschritt darfst du nötigenfalls die UI
   verwenden, falls ein entsprechendes Werkzeug verfügbar ist. Sonst leite
   mich kurz an. Lies den tatsächlich angezeigten Port und verwende
   http://127.0.0.1:<PORT>/mcp. Nicht blind einen Beispielport übernehmen.
   Öffne keine Firewall-/Routerfreigaben und installiere keine zweite Bridge.

5. Installiere den mitgelieferten Skill fusion-360-printing mit
   scripts/Install-Skill.ps1. Prüfe vorher vorhandene gleichnamige Skills
   einschließlich älterer ~/.codex/skills-Installationen. Identische Inhalte
   dürfen bleiben; abweichende Inhalte zuerst vergleichen und erhalten.
   Lies den installierten SKILL.md und seine für die Einrichtung nötigen Referenzen.
   Falls Codex ihn noch nicht entdeckt, nutze den SKILL.md direkt und erkläre,
   wie ich ihn nach dem Neuladen wieder aufrufen kann.

6. Verbinde Codex mit dem lokalen Streamable-HTTP-Endpunkt. Prüfe zuerst
   codex mcp list und codex mcp get fusion --json, soweit die CLI vorhanden ist.
   Verwende eine bestehende passende Verbindung. Wenn der Name frei ist:
   codex mcp add fusion --url http://127.0.0.1:<PORT>/mcp
   Ein anders belegter Name ist kein Grund zum Überschreiben: wähle einen
   eindeutigen neuen Namen und dokumentiere ihn. Falls die CLI fehlt, nutze
   die MCP-Einstellungen der lokalen App oder ergänze nach Sicherung gezielt
   deren tatsächlich verwendete config.toml gemäß aktueller offizieller Doku.
   Ersetze nie die ganze Konfigurationsdatei. Ändere keine globalen Schutz-
   oder Freigabeeinstellungen. Installiere keine weitere Codex-Variante nur
   für diesen Konfigurationsschritt.

7. Prüfe initialize, tools/list und einen echten lesenden Fusion-Aufruf
   mit scripts/Test-FusionMcp.ps1 -Endpoint http://127.0.0.1:<PORT>/mcp.
   Prüfe zusätzlich die Verbindung aus Codex. Falls die Werkzeuge erst nach
   dem Neuladen erscheinen, halte den bisherigen Stand lokal fest. Bis dahin
   darfst du den mitgelieferten HTTP-Client am selben Endpunkt verwenden.
   Ein offener TCP-Port oder HTTP 200 allein ist kein bestandener Fusion-Test.
   Bei Timeouts keine weiteren CAD-Aufrufe aufstauen und Fusion nicht blind neu starten.

8. Richte die Projektablage Projekte/ ein und prüfe lesend mein angemeldetes
   Fusion-Konto auf einen geeigneten Cloud-Projektordner. Verwende für die
   Einrichtung einen eigenen neuen Bauteilordner und ein separates Dokument.
   Suche in meinem Konto nach einer passenden gespeicherten nativen F2T-Vorlage.
   Falls keine existiert, richte über die verfügbare native API/MCP eine Vorlage
   ISO, mm, A4 quer mit automatischen Maßen und Strategie Auto-Select (auto) ein.
   Gesamtmaße/overall allein reicht nicht. Speichere die Vorlage dauerhaft.
   Ist ein notwendiger Schritt nachweislich nur per UI möglich, benenne diese
   konkrete Lücke und führe ausschließlich diesen Schritt per UI aus bzw.
   leite mich dazu an; kehre danach zu MCP zurück. Keine API-Fähigkeiten erfinden.

9. Führe mit dem Auftrag in docs/ERSTER-AUFTRAG.md einen kleinen vollständigen
   Einrichtungstest aus. Miss die tatsächliche Geometrie, teste eine Änderung
   des Breitenparameters und stelle den Ausgangswert zuverlässig wieder her.
   Öffne die gespeicherte Vorlage erneut, erzeuge mit Fusions Automatik eine
   Erstzeichnung und prüfe Ansichten, automatische Maße und die exportierte PDF.
   Speichere Modell und verknüpfte Zeichnung im gleichen Cloud-Ordner und prüfe
   Versionen und abgeschlossene Synchronisierung. Keine zusätzliche manuelle
   Detailbemaßung oder separate Zeichnungs-API-Experimente anschließen.
   Falls Lizenz oder Version die Zeichnungsautomatik nicht bereitstellt,
   stelle das ausdrücklich als offenen Teil fest. Erhalte das geprüfte Modell
   und vorhandene Exporte; behaupte nicht, die gesamte Einrichtung sei fertig.

10. Schreibe docs/SETUP-STATUS.local.md mit Datum, Versionen, verwendetem Endpunkt,
    MCP-Name, Skill-Pfad, Ergebnissen und offenen Schritten. Keine Passwörter
    oder Tokens darin speichern. Diese Datei und meine Konstruktionen bleiben
    lokal und werden nicht ins öffentliche Repository hochgeladen.
    Gib mir zum Schluss die lokalen Dateien, privaten Fusion-Ansichtslinks und
    einen einfachen Folge-Prompt für meine erste eigene Konstruktion.

Arbeite auf Deutsch. Erledige die autorisierten Schritte ohne wiederholte
Bestätigungsfragen. Frage nur nach Angaben, die eine Entscheidung oder einen
persönlichen Schritt tatsächlich erfordern. Ein notwendiger Login ist eine
Unterbrechung zum Anmelden, kein Abschluss des Auftrags.
```
