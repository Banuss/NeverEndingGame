class Plaats implements Hitbox
{
  int rij;
  boolean links;
  boolean geselecteerd;
  
  int x1=0;
  int y1=0;
  int x2=0;
  int y2=0;
  
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
   println(x1+","+x2+","+y1+","+y2 );
   if (mouseX>=x1 && mouseX<=x2 && mouseY>=y1 && mouseY<=y2)
   {
     println("Match");
     geselecteerd = true;
     return true;
   }
   return false;
  }
  
  void tekenen(int xPos, int yPos, int plaatsBreedte, int plaatsHoogte)
  {
      if(geselecteerd)fill(0,100,0);
      else fill(0,20,0);
      
      rect(xPos, yPos, plaatsBreedte, plaatsHoogte);
      this.x1 = xPos;
      this.y1 = yPos;
      this.x2 = xPos + plaatsBreedte;
      this.y2 = yPos + plaatsHoogte;
  }
}
