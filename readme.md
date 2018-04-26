#Project: VGA Controller
## Introduction
19.02.2018

*) Bildausgabe eines Bildes aus dem Speicher
*) Synchronisierung des Bildes mit vertikaler und horizontaler Synchronisierung
-) Immer Backups erstellen (können komplexe Fehler entstehen)
*) 60 Hz werden die Bilder aktualisiert (Der Source Multiplexer soll dieses Bild
   zum richtigen Zeitpunkt an den VGA-Controller schicken. Pixeltakt 25,175MHz
   verwenden jedoch 25,000MHz)
*) Tatsächliche Größe des Bilds bei einem 640x480 Bilds im VGA-Controller ist 800x525
