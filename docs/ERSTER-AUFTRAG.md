# Einrichtungstest: einfache Testplatte

Dieser Auftrag ist Teil des Einrichtungs-Prompts. Er ist ein CAD- und Vorlagentest, kein Druckauftrag. Bestehende Dokumente erhalten; neue Dateien unter `Projekte/Einrichtungstest/` und im eigenen Fusion-Konto anlegen.

> Erzeuge `01 MOD Testplatte` als parametrischen Körper. Die Platte liegt mit der Unterseite in XY, Ursprung an der linken unteren Ecke, positive X/Y-Richtung entlang der Kanten, Dicke in +Z. Länge X = 60 mm, Breite Y = 40 mm, Dicke = 5 mm. Vier durchgehende Bohrungen Ø 4 mm mit je 8 mm Abstand zu den benachbarten Außenkanten: Mittelpunkte (8,8), (52,8), (8,32), (52,32) mm. Keine Radien, Senkungen oder Fertigungskompensation. Benenne Parameter `laenge`, `breite`, `dicke`, `randabstand`, `bohrung_d`; Bohrungspositionen hängen von den Plattenmaßen und dem Randabstand ab. Skizzen vollständig bestimmen und parametrische Historie erhalten.
>
> Prüfe an der BRep-Geometrie die Außenmaße, einen gültigen Volumenkörper, genau vier Durchgangsbohrungen mit korrektem Durchmesser, Mittelpunkten und Z-Bereich 0 bis 5 mm. Volumensoll: 60 × 40 × 5 − 4 × π × 2² × 5 mm³. Prüfe Historie und Skizzen. Verwende für analytische Längenvergleiche z. B. 0,00001 mm numerische Prüftoleranz; das ist keine Drucktoleranz.
>
> Teste `breite` von 40 auf 45 mm: obere Bohrungsreihe muss von Y=32 auf Y=37 mm wandern, Außenmaß Y auf 45 mm. Stelle den ursprünglichen Ausdruck auch bei Fehlern zuverlässig wieder her, berechne neu und prüfe erneut Y=40 mm sowie obere Reihe Y=32 mm.
>
> Sichere eine F3D und eine STEP. Erzeuge mit der eigenen gespeicherten und erneut geöffneten F2T die automatische Erstzeichnung `01 ZG Testplatte`, exportiere `01 PDF Testplatte.pdf` und prüfe alle Seiten sowie angezeigte Maße. Verwende die geprüfte automatische Ausgabe ohne zusätzliche manuelle Detailbemaßung. Modell und verknüpfte Zeichnung müssen im gleichen Cloud-Ordner gespeichert und vollständig synchronisiert sein. Protokolliere Quellmodellversion, Dateiversionen, Vorlage, Soll/Ist-Werte und Links. Ist eine Funktion nicht verfügbar, melde genau diesen offenen Teil.

## Danach: eigenes Bauteil

```text
Verwende fusion-360-printing und die Projektregeln aus AGENTS.md.
Ich möchte folgendes Bauteil konstruieren: [Beschreibung].
Es soll zu diesem vorhandenen Teil passen: [Beschreibung/Messwerte].
Meine Maße in Millimetern: [Maße].
Erstelle ein editierbares parametrisches Fusion-Modell, prüfe die tatsächliche
Geometrie und liefere die automatische Erstzeichnung mit PDF sowie die
vereinbarten Exporte. Speichere Modell und Zeichnung auch in meinem Fusion-Konto.
Kläre fehlende funktions- oder passungsentscheidende Angaben vor der Konstruktion.
```
