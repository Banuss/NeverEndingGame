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
    if (geselecteerd != null) changed.add(geselecteerd.rij);
    geselecteerd = this;
    changed.add(rij);
  }

  void tekenen(PGraphics canvas, int xPos, int yPos, int plaatsBreedte, int plaatsHoogte)
  {
    x1 = getXpos(int( xPos + rij.pos.x - plaatsBreedte / 2 ));
    y1 = getYpos(int( yPos + rij.pos.y - plaatsHoogte / 2));
    x2 = getXpos(int( xPos + plaatsBreedte/2 + rij.pos.x ));
    y2 = getYpos(int( yPos + plaatsHoogte/2 + rij.pos.y ));
    canvas.beginDraw();
    if (this.equals(geselecteerd))
    {
      canvas.fill(0, 255, 0);
      canvas.strokeWeight(10);
      canvas.stroke(255,255,255);
    }
    
    else
    {
      if(isLangsteRij(rij)) canvas.fill(0, 0, 75);
      else canvas.fill(75, 0, 0);
      canvas.strokeWeight(0);
    }
      
    canvas.rect(xPos, yPos, plaatsBreedte, plaatsHoogte);
    canvas.endDraw();
  }
}
