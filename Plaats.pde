class Plaats extends Hitbox
{
  int rij;
  boolean links;
  boolean geselecteerd;
  
  
  Plaats(int rij, boolean links)
  {
    this.rij = rij;
    this.links = links;
    geselecteerd = false;
  }  
  
  boolean getSelect()
  {
    return geselecteerd;
  }
  
  int getRij()
  {
    return rij;
  }
  
  boolean getLinks()
  {
    return links;
  }
  
  
  boolean Match()
  {
    geselecteerd = super.Match();
    return geselecteerd;
  }
  
  void tekenen(int xPos, int yPos, int plaatsBreedte, int plaatsHoogte)
  {
      x1 = xPos;
      y1 = yPos;
      x2 = (xPos + plaatsBreedte);
      y2 = (yPos + plaatsHoogte);
      if(geselecteerd)fill(0,100,0);
      else fill(0,20,0);
      rect(xPos, yPos, plaatsBreedte, plaatsHoogte);
  }
}
