# Protokoll 24.06.2024

### Aufgaben:

- Jon:
    - Done: Resourcenanzeige und -abfrage in App, Bugfixes
    - Todo: 
        - Docker zum Laufen bringen
        - Executions in App über API anbinden
- Lukas:
    - Done: CSRF entfernt, Camel- auf Snake-Case in API
    - Todo:
        - Web-Actions auf Server-Branch begrenzen
        - TANs nur mit Großbuchstaben eingeben
        - Namenssetzung angucken
        - Login verfeinern
        - Alte Branches löschen
- Yannick:
    - Done: "Mutationsproblem" gelöst, erste Implementierung Patientenzustände/Acitity Diagram, Doku angepasst
    - Todo: 
        - Notifications implentieren
        - Patientenzustand verfeinern
- Simon:
    - Done: Enity-Doku geupdatet, Entity-Load-Tests, TANs jetzt global unique
    - Todo: 
        - Flag für Spieler ob eingelogt/aktiv + Methode zum einfachen Abfragen
        - Execution-Name hinzufügen (DB + Laufzeit)
- Peter:
    - Done: \*siehe Mattermost\*
    - Todo: 
        - Gamemaster kann Szenario auswählen und neue (leere) Execution erstellen oder bestehende Execution laden
        - leere Execution mit Spielern füllen
        - Login-Status anzeigen, Alarmieren-Button, Angekommen-Status
        - Polling für Playerstatus im Execution-Screen

### Besprochene Themen:

- Beispiel-Bilder integrieren (z.B. EKG)
- Notification Polling Feature in API? $\rightarrow$ Ja
    - App pollt mit ID, Server antwortet mit neueren Nachrichten
    - Notifications in Execution-Objekt und Log integrieren
- Warnung vor doppeltem Login hinzufügen, bei Login auf Player-Flag prüfen, Überschreiben von Namen bei Login verhindern
- Einheitlicher Code-Stil für Python (Beispiel Zeilenlänge)
- Diskussion über Vor-/Nachteile von Branches $\rightarrow$ derzeitiges System beibehalten
