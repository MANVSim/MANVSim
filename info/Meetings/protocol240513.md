# Protokoll 13.05

Author: Yannick Illmann

## Inhalt

**Yannick**: Implementiert erste API Endpunkte für erst Kommunikation

- API Endpoint Sandbox Inhalte
- entity model gemerged

_Aufgabe_: Image Processing

**Simon**: bearbeitet Laufzeit Entity Model (NICHT DB Schema)

- erster ER Runtime Draft fortlaufend gewandelt -> neu: dict auf scenario level; locations halten resources (nicht mehr anders herum)
- weitergehend json methoden implementiert zur serialisierung (Keyword: shallow für Objektreferenzierung)
- aktuell Testobjekterstellung für laufende Entwicklung

_Aufgabe_: Ladeprozess von DB Startzustand zu Game Initialzustand

**Louis**: war letzte Woche verhindert.

- arbeitet an Logging

_Aufgabe_: Logging fertigstellen und DB Modell einpflegen

**Peter**: Bearbeiten der Lobby Page

- Nav Page: für Scenario Bereich und Admin Bereich
- Scenario Breich: Dummy Daten mit Start Button
- Admin Bereich: Django Default Titel renaming

_Aufgabe_: TAN Generierung

**Jon**: arbeitet an Logik

- App könnte Daten abfragen, wenn Endpunkt existiert.
- Actions mit Timer

_Aufgabe_: App-seitige Api Spezifikation erstellen

**Lukas**:

- QR Codes füllen Login Daten aus
- Widget Refactoring

_Aufgabe_: App-seitige Api Spezifikation erstellen

**Sonstiges**:

_Game Master Anfragen der Web Page an das aktuelle Game über API?_

- Django ist Komponenten basiert, dann kann der Webserver Part auch direkt auf die Datenhaltenden Dateien zugreifen.
- Folgegespräch-Ergenbis: Trennung in Game Preparation und Game Management sinnvoll. Anhaltspunkt ist [Scenario Flow](../../doc/server/Scenario%20Flow.svg)

_Disskusion: Main URL auf Nav geroutet -> sinnvoll?_

- nein, evtl will die App auch ins Web-Frontend und da wäre eine einheitliche URL sinnvoll,
- routing auf '/nav', scenario auf '/create' o. ä. und game-lobby au '/lobby'

_Backend soll Endpunkte definieren, App würde sich orientieren?_

- allgemeine Daten werden vom Backend bereitgestellt, ABER
- Patienten-Information sollen zustandsabhängig von der App angefragt werden.
- Dokumentationsanhaltspunkt: [Entity Relation Runtime](../../doc/server/entity_relation_runtime.svg)

_Warum eigentlich Django?_

- Schlankere Alternativen möglich. Django eher Multi Prozess Application
- Präferenz eher Richtung Flask oder Bottle. Noch offen: Wie können diese Optionen den Memory Zustand halten, während Requests einfließen. Entscheidung wünschenswert bis 13.05 Tagesende.
