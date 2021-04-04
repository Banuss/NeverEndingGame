class Kaart implements Hitbox
{
  final PImage image;
  final int waarde;
  
  int x1=0;
  int y1=0;
  int x2=0;
  int y2=0;
  
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
  
  boolean Match()
  {
   return (mouseX>=x1 && mouseX<=x2 && mouseY>=y1 && mouseY<=y2);
  }
  
  void tekenen(int xPos, int yPos, int kaartBreedte, int kaartHoogte)
  {
      image(image, xPos, yPos, kaartBreedte, kaartHoogte);
      this.x1 = xPos;
      this.y1 = yPos;
      this.x2 = xPos + kaartBreedte;
      this.y2 = yPos + kaartHoogte;
  }
  
}
