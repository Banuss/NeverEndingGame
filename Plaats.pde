class Plaats implements Hitbox
{
  int rij;
  boolean links;
  boolean geselecteerd;
  
  int x1;
  int y1;
  int x2;
  int y2;
  
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
  
  boolean Match()
  {
   if (mouseX>=x1 && mouseX<=x2 && mouseY>=y1 && mouseY<=y2)
   {
     geselecteerd = true;
     return true;
   }
   geselecteerd = false;
   return false;
  }
  
  void tekenen(int xPos, int yPos, int plaatsBreedte, int plaatsHoogte)
  {
      x1 = xPos; //<>// //<>//
      y1 = yPos;
      x2 = (xPos + plaatsBreedte);
      y2 = (yPos + plaatsHoogte);
      if(geselecteerd)fill(0,100,0);
      else fill(0,20,0);
      rect(xPos, yPos, plaatsBreedte, plaatsHoogte);
      
  }
}
