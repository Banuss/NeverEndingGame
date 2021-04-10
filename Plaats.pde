class Plaats extends Hitbox
{
  Row rij;
  boolean links;

  Plaats(Row rij, boolean links)
  {
    this.rij = rij;
    this.links = links;
  }

  boolean getLinks()
  {
    return links;
  }

  public void onClick()
  {
    geselecteerd = this;
  }

  void tekenen(PGraphics canvas, int xPos, int yPos, int plaatsBreedte, int plaatsHoogte)
  {
    x1 = int( xPos + rij.pos.x - plaatsBreedte / 2 );
    y1 = int( yPos + rij.pos.y - plaatsHoogte / 2);
    x2 = int( xPos + plaatsBreedte/2 + rij.pos.x );
    y2 = int( yPos + plaatsHoogte/2 + rij.pos.y );


    canvas.beginDraw();
    if (this.equals(geselecteerd))
      canvas.fill(0, 100, 0);
    else
      canvas.fill(100, 0, 0);
    canvas.rect(xPos, yPos, plaatsBreedte, plaatsHoogte);
    canvas.endDraw();
  }
}
