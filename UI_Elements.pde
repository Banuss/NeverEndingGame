class knophogerlager implements Hitbox
{
  boolean hoger = false;
  int x1;
  int y1;
  int x2;
  int y2;
  
  knophogerlager(boolean hoger)
  {
    this.hoger = hoger;
  }

  boolean Match()
  {
    return (mouseX>=x1 && mouseX<=x2 && mouseY>=y1 && mouseY<=y2);
  }

  void tekenen(int xPos, int yPos, int plaatsBreedte, int plaatsHoogte)
  {
    x1 = xPos;
    y1 = yPos;
    x2 = (xPos + plaatsBreedte);
    y2 = (yPos + plaatsHoogte);
    if (hoger)
    {
      fill(0, 200, 0);
    }
    else
    {
      fill(200, 0, 0);
    }
    rect(xPos, yPos, plaatsBreedte, plaatsHoogte);
  }
}
