Simon berichtet, dass er umfangreiche Methoden definiert hat, aber leider keine Daten in der Datenbank vorliegen, so dass er leider nicht viel zeigen kann.

Louis hat nach Flask migriert, das scheint recht übersichtlich. Allerdings liegt derzeit nur eine leere Datenbank vor. Wir benötigen Testdatensätze. 

Yannick hat sich ein Workflow für Images überlegt, aber wegen Datenbankumstellung dies noch zurück gestellt. Darüber hinaus hat er mit einer Patientensimulation begonnen. Basis hier gelegt. Darüber hinaus hat eine Diskussion mit Luaks und Jon begonnen bzgl. Der API-Schnittstellen.

Lukas berichtet über Weiterentwicklungen der App. Übersetzungsdatei hinzugefügt, welche es ermöglicht unterschiedliche Sprachen vorzuhalten. Hauptanwendung sollte vermutlich auf Deutsch laufen. 

Lukas präsentuiert Datei de.arb. en.arb kann bei bedarf hinzugenommen werden. Diese soll auch für Web-Seiten verwendet werden.

Beschränkungen, die sich durch den pivate-Status des Repositories ergeben, behindern. Deshalb möchten alle es möglichst bald auf public setzen.

Notificationservice ist bereit, aber ohne Daten noch nichts sichtbar.

Lukas und Jon präsentiert die API-Spezifikation.

Wir diskutieren:
- wie das Alarmieren der Kräfte erfolgt. Kräfte sollen auch zu unterschiedlichen Zeiten einsteigen (Alarmiert werden). Diese Alarmierungen erfolgen manuell durch den Szenario-Manager.
- wie die gameID in den Anfragen übermittelt wird. Die gameID identifiziert die laufende Execution.
- Aufbau der Routen. Feste Routen. Dynamische Teile als Parameter (GET oder POST).
- Maßnahme: liefern als Ergebnis auch veränderte Ressourcen des Spielers. Hierbei können durch die Anwesenheit andere Spieler, die Ressourcen erweitert werden.
Hierzu muss ggf. gepollt werden. Es reicht aber vermutlich, dass Spieler ihre möglichen Maßnahmen aktiv selber refreshen, wenn z.B. ein weiteret Spieler physisch hinzu kommt.

Jon präsentiert die Weiterentwicklung der App.
Maßnahmen können durchgeführt werden, wenn benötigten Ressourcen vorher ausgewählt wurden. 

Locations sind: Patient, RTW, Verletzenablage, etc.
Spieler können Locations wechseln und ggf. weitere Ressourcen "nehmen".

Das Verlasen einer Location wird dem Server angezeigt, aber in der App muss der Spieler eine Location nicht aktiv verlassen, sondern "geht" zu einer anderen Location und wird automatisch abgemeldet. Wechseln einer Location benötigt ggf. auch Zeit. 

Lukas fragt zum Login:
- TAN eindeutig für gesamten Server => Ja.
- Soll TAN im Klartext verschickt werden. Zunäcsht ja, später ggf. Sicherheitskonzept.

## ToDo:

Peter: Repository public machen. Falls möglich an MAnager weiterarbeiten.
Louis: Datenbank füllen mit Testdatensätzen.
Lukas: Login, Anfahrt auf API anpassen und Kommunikation mit Server bauen.
Jon: Änderungen in API-Spezifikation einbauen, prototypischen Server bauen, der MOC-Daten zurück gibt. Antwortformat spezifizieren (Texte, Bilder, ect.). Patientensicht implementieren, Beginn von Maßnahmen. 
Simon: Laufzeitobjekte weiterentwickeln (Spielerrolle, Sichtungsfarbe). Schnittstelle an Datanbank anpassen
Yannick: Serverseitige Realisierung der API anfangen. Zunächst Login.
