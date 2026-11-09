# Konstruktion und 3D-Druck mit Fusion

## Einstieg

Für Fusion-Konstruktionen `fusion-360-printing` verwenden. Falls noch nicht installiert, `skills/fusion-360-printing/SKILL.md` direkt lesen. Einrichtung: `docs/EINRICHTUNG.md`. Die Regeln gelten für CAD-Aufträge; Arbeiten an dieser Dokumentation erfordern keine Fusion-Modelländerungen.

## Arbeitsweise

- Konstruktion, Cloud-Verwaltung, Zeichnungen, Exporte und Prüfung über natives Fusion-MCP ausführen. Fehlende eingeblendete Werkzeuge zunächst am konfigurierten Endpunkt entdecken. Kurze API-Skripte über MCP sind Teil dieses Weges.
- UI nur für eine belegte wesentliche API-Lücke, einen interaktiven Blocker oder ausdrücklichen Nutzerwunsch. Beim ersten Setup ist die Aktivierung des MCP-Servers ein zulässiger UI-Schritt. Anmeldung durch den Nutzer. Danach zu MCP zurückkehren.
- Vor Änderungen Dokument, Komponenten, Einheiten, Speicherzustand und aktive Befehle lesen. Vorhandene Arbeit erhalten; neue Bauteile in eigenen Dokumenten beginnen. Nur ein Auftrag gleichzeitig an einer Fusion-Instanz.
- Anforderungen mit Ursprung, Bezugsebenen, Außenmaßen, Bohrungspositionen, Durchmessern und Tiefen aufschreiben. Funktion oder Passung wesentlich beeinflussende Unklarheiten klären, sonst Annahmen nennen.
- Dokumentierte Längen in mm; numerische Fusion-API-Längen in cm ausdrücklich umrechnen. Änderbare Maße als benannte Parameter mit Einheiten und Kommentaren, abhängige Maße als Ausdrücke. Historie erhalten; Skizzen geometrisch und maßlich bestimmen.
- Messwerte, konstruktives Spiel und Fertigungskompensation getrennt halten. Keine pauschalen Drucktoleranzen als gesichert darstellen.
- Nach Timeout mögliche weiterlaufende Ausführung berücksichtigen, keine CAD-Aufrufe aufstauen. Vor einer Wiederholung Teilzustand prüfen. Höchstens ein kontrollierter autorisierter Neustart pro Fehlerpfad, keine UI-/Neustartschleifen.

## Ablage und Zeichnungen

- Pro Bauteilfamilie einen Ordner unter `Projekte/` anlegen. Anforderungen, CAD-Dateien, Exporte und Prüfprotokoll zusammen ablegen.
- Neue Namen: `<Kennung> <Typ> <Kurzname>`, z. B. `01 MOD Halter`, `01 ZG Halter`, `01 PDF Halter.pdf`. Pro Bauteilfamilie bei `01` beginnen, neue Grundentwürfe fortlaufend; Varianten `01a`, `01b`. Kennungen nicht neu vergeben. Änderungen desselben Entwurfs über Versionshistorie führen. Typen: MOD, ZG, PDF, STEP, STL, 3MF. Bestehende Dateien nicht allein deswegen umbenennen.
- Modell und verknüpfte native Zeichnung zusätzlich im gleichen passenden Ordner des eigenen Fusion-Kontos speichern. Für beide Version, Zielordner und `DataFile.isComplete` prüfen; Ansichtslinks nennen. Bestehende Zugriffsrechte erhalten, keine öffentliche Freigabe erforderlich.
- Eigenständige Modelle als editierbare F3D sichern, verknüpfte Baugruppen im passenden nativen Archiv. STEP und STL/3MF im angefragten Übergabeumfang liefern.
- Erstzeichnung mit eingebauter Zeichnungsautomatik und eigener gespeicherter F2T erzeugen. Strategie `auto`, ISO, mm, lesbare Blattgröße. Ergebnis auf Quellmodellstand, initialisierte Ansichten und automatische Maße prüfen. Bemaßte PDF exportieren, dargestellte Werte mit geprüfter Geometrie vergleichen, alle PDF-Seiten auf Lesbarkeit und Beschnitt prüfen. Danach ist die automatische Erstzeichnung fertig.
- Keine ungefragte manuelle Zusatzbemaßung, Schnitte, Layoutoptimierung oder API-Regressionsprojekte anschließen. Vorlage erst nach dauerhafter Speicherung, erneutem Öffnen und geprüfter Testzeichnung als eingerichtet melden.
- Nach Modelländerungen Zeichnung/PDF nur auf Wunsch oder vor konkretem Druckauftrag aktualisieren. Ein CAD-/Netz-Zwischenexport ist noch kein Druckauftrag. Ältere Zeichnungen mit dargestelltem Modellstand kennzeichnen; vor Druck müssen Zeichnung und PDF zum Druckmodell passen.

## Prüfung und Übergabe

- Sollmaße aus Anforderungen ableiten, unabhängig an echter Geometrie prüfen: Außenmaße, Bohrungen inklusive Lage/Tiefe/Durchgang, Wandstärken, Abstände, Körperanzahl und Gültigkeit. Parametertabelle oder Screenshot genügt nicht.
- Neuberechnung und Historienfehler prüfen. Bei geforderter Parametrik sinnvolle Änderung testen, Geometrie prüfen, Ausgangsausdruck zuverlässig wiederherstellen und erneut prüfen.
- Soll/Ist, Einheit, numerische Prüftoleranz und Status dokumentieren. Numerische CAD-Toleranz ist keine Fertigungstoleranz. Fehlende Prüfungen offen nennen.
- Exporterfolg und nicht leere Dateien prüfen. Bei verlangter Dateiintegrität Exporte in separaten Dokumenten wieder öffnen und relevante Eigenschaften kontrollieren.
- CAD, Slicer und reale Passung getrennt bewerten. Übergabe mit Dateilinks, Einstellparametern und offenen Annahmen; fehlende Cloud-Dateien oder Zeichnungen ausdrücklich nennen.
- Konstruktionen, lokale Prüfberichte und Konfigurationen nicht ohne ausdrücklichen Auftrag auf GitHub veröffentlichen. Kein `git add .` für spätere CAD-Arbeit.
