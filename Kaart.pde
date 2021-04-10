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
  
  void render(PGraphics canvas, PVector position, PVector dimensions) {
    canvas.beginDraw();
    canvas.imageMode(CENTER);
    canvas.image(image, position.x, position.y, dimensions.x, dimensions.y);
    canvas.endDraw();
  }
  
  PImage getImage()
  {
    return image;
  }
  
  void tekenen(int xPos, int yPos, int kaartBreedte, int kaartHoogte)
  {
      image(image, xPos, yPos, kaartBreedte, kaartHoogte);
  }
}
