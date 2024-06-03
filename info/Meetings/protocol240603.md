# Meeting 2024-06-03

- Testdaten:
  - WICHTIG!
  - Über ORM einpflegen
  - Für alle verfügbar machen
  - Laut Louis fertig
  - PR ausstehend
- Anpassungen:
  - Liste von Locations in DB ablegen? -> Nein
- Player brauchen Rolle
- Action braucht required_role
- Rollen als set von Werten, nicht als DB Tabelle
- Konfiguration von Rollen:
  - ORGL nicht als Rolle benötigt -> rausnehmen
  - Andere Rollen: In DB, neue Tabelle
  - Totale Ordnung beibehalten
- IDs: Primärschlüssel inkrementell
- Neue Attribute für DB: activation_delay, alerted
- Patient.Classification: Neue Flag für pre-classified

YANNICK:

- Lobby fertig
- OpenAPI Dokumentation weiter bearbeitet
- TODO: Aktives/Passives leaven
- snake_case in API und json sollte Standard sein
- performAction: Wie werden Quantities abgezogen?
- Benötigt: Benötigte Resourcen in Anfrage? Sollte in Spezifikation stehen
  - In Anfrage: Resource ID, Anzahl
- "Unverbrauchbare" Ressourcen: Hohe Zahl setzen
- Server bestimmt Verfügbarkeit
- Wenn Ressource n mal benötigt wird sollte sie n mal in der Liste stehen

PETER:

- Respo public
- Actives Pollen
- run.py anschauen und verwenden als API
- Kommunikation mit Server über Polling

LUKAS:

- crossorigin aktivieren
- Verwendung von OpenAPI Generator
- Dockerfile für Backend jetzt verfügbar

JON:

- API-Spezifikation ausgearbeitet
- Review von Yannick
- Bei json: kein null sondern Feld weglassen

ALLE:

- Sollen komplette Anwendung starten können
- KiWo Projekt vorstellen?
