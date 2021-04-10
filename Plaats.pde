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

  void tekenen(PGraphics canvas,int xPos, int yPos, int plaatsBreedte, int plaatsHoogte)
  {
    x1 = xPos;
    y1 = yPos;
    x2 = (xPos + plaatsBreedte);
    y2 = (yPos + plaatsHoogte);
    canvas.beginDraw();
    if (this.equals(geselecteerd))
      canvas.fill(0, 100, 0);
    else
      canvas.fill(100, 0, 0);
    canvas.rect(xPos, yPos, plaatsBreedte, plaatsHoogte);
    canvas.endDraw();
  }
}
