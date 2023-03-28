# Musikliste um Wünsche einzutagen und um über diese Abzustimmen
Für den privaten gebrauch gebaut und um mit rust, diesel, rocket, docker, alpine und compose herumzuspielen.

## Installation
Eigentlich nur:

```docker-compose up --build```

Aber: vorher sollten der Ordner `db-data` erstellt und mit entsprechenden Rechten gesegnet worden sein. Wenn SELinux genutzt wird auch 

```chcon -Rt svirt_sandbox_file_t db-data server/migrations/2023-02-17-180640_wish_entry/up.sql```

nicht vergessen, sonst haut SELinux die Ersteinrichtung kaputt.

Der Server läuft anschließend auf Port 8000 auf localhost. Um das zu ändern, einfach in der docker-compose.yml den nach außen gereichten port ändern. So oder so muss danach noch ein Reverse-Proxy drauf, sonst gibt's kein TLS.

Der default Webclient wird auch gebaut und fällt auf localhost:8001 raus.

## To do
- Code refactoring
- Mehr saubere error messages im client
- Config Files

