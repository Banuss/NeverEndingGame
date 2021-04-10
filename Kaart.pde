class Kaart
{
  final PImage image;
  final int waarde;
  
  Kaart(PImage image, int waarde)
  {
    this.image = image;
    assert waarde >= 2;
    assert waarde <= 14;
    this.waarde = waarde;
  }

  PImage getImage()
  {
    return image;
  }

  void tekenen(PGraphics canvas, int xPos, int yPos, int kaartBreedte, int kaartHoogte)
  {
    canvas.beginDraw();
    canvas.image(image, xPos, yPos, kaartBreedte, kaartHoogte);
    canvas.endDraw();
    
  }
}
