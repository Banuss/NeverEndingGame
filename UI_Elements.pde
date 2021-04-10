abstract class Hitbox
{
  protected int x1;
  protected int y1;
  protected int x2;
  protected int y2;

  Hitbox()
  {
    hitboxes.add(this);
  }

  boolean Match()
  {
    return mouseX>=x1 && mouseX<=x2 && mouseY>=y1 && mouseY<=y2;
  }

  abstract void onClick();

  void destroy()
  {
    hitboxes.remove(this);
  }
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
    if (geselecteerd != null)
    {
      runGameLogic(geselecteerd.rij, geselecteerd.getLinks(), hoger);
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
  PGraphics pg;
  PVector loc, dim;

  strafvenster(int sips)
  {
    pg = createGraphics(width, height);
    pg.beginDraw();
    pg.textFont(uiFont);
    pg.textAlign(CENTER, CENTER);
    pg.endDraw();
    
    dim = new PVector(pg.width * 0.8, pg.height * 0.8);
    loc = new PVector(pg.width/2, pg.height/2);
    
    x1 = int(loc.x - dim.x/2);
    x2 = int(loc.x + dim.x/2);
    y1 = int(loc.y - dim.y/2);
    y2 = int(loc.y + dim.y/2);
    
    this.sips = sips;
  }

  void tekenen()
  {
    pg.beginDraw();
    pg.fill(255, 200, 0, 200);
    pg.rect(loc.x, loc.y, dim.x, dim.y);
    pg.fill(0, 0, 0);
    pg.text(sips + " SLOK" + (sips != 1 ? "KEN" : ""), (dim.x/2), (dim.y/2));
    pg.endDraw();
  }

  public void onClick() {
  assert false : 
    "Wordt elders geregeld";
  }
}
