class Kaart
{
  PImage image = null;
  final String imageLocation;
  final int waarde;
  
  Kaart(String imageLocation, int waarde)
  {
    this.imageLocation = imageLocation;
    assert waarde >= 2;
    assert waarde <= 14;
    this.waarde = waarde;
  }

  void tekenen(PGraphics canvas, int xPos, int yPos, int kaartBreedte, int kaartHoogte)
  {
    if (image == null) image = loadImage(imageLocation);
    canvas.beginDraw();
    canvas.image(image, xPos, yPos, kaartBreedte, kaartHoogte);
    canvas.endDraw();
    
  }
}
