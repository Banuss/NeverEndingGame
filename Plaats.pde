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

  void tekenen(int xPos, int yPos, int plaatsBreedte, int plaatsHoogte)
  {
    x1 = xPos;
    y1 = yPos;
    x2 = (xPos + plaatsBreedte);
    y2 = (yPos + plaatsHoogte);
    if (this.equals(geselecteerd.rij))
      fill(0, 100, 0);
    else
      fill(0, 20, 0);
    rect(xPos, yPos, plaatsBreedte, plaatsHoogte);
  }
}
