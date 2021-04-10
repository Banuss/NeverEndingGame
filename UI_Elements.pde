abstract class Hitbox
{
  protected int x1;
  protected int y1;
  protected int x2;
  protected int y2;

  boolean Match()
  {
    return mouseX>=x1 && mouseX<=x2 && mouseY>=y1 && mouseY<=y2;
  }

  abstract void onClick();
}

class knophogerlager extends Hitbox
{
  boolean hoger = false;

  knophogerlager(boolean hoger)
  {
    this.hoger = hoger;
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
    } else
    {
      fill(200, 0, 0);
    }
    rect(xPos, yPos, plaatsBreedte, plaatsHoogte);
  }

  public void onClick()
  {
    for (Plaats p : Plaatsen)
    {
      if (p.getSelect())
      {
        runGameLogic(Speelveld[p.getRij()], p.getLinks(), hoger);
        return;
      }
    }
  }
}


class volgendeKnop extends Hitbox
{
  void tekenen(int xPos, int yPos, int knopBreedte, int knopHoogte)
  {
    x1 = xPos;
    y1 = yPos;
    x2 = (xPos + knopBreedte);
    y2 = (yPos + knopHoogte);
    fill(100, 255, 100);
    rect(xPos, yPos, knopBreedte, knopHoogte);
  }
  
  public void onClick()
  {
    volgendeSpeler();
  }
}

class strafvenster extends Hitbox
{
  int sips;

  strafvenster(int sips)
  {
    this.sips = sips;
  }

  void tekenen(int xPos, int yPos, int breedte, int hoogte)
  {
    x1 = xPos;
    y1 = yPos;
    x2 = (xPos + breedte);
    y2 = (yPos + hoogte);
    fill(255, 200, 0, 200);
    rect(xPos, yPos, breedte, hoogte);
    fill(0, 0, 0);
    textFont(createFont("fonts/keed.ttf", 72));
    textAlign(CENTER, CENTER);
    text(sips + " SLOK" + (sips != 1 ? "KEN" : ""), (breedte/2), (hoogte/2));
  }

  public void onClick() {
    assert false : "Wordt elders geregeld";
  }
}
