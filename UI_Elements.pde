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

  boolean getHoger()
  {
    return hoger;
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
    } else
    {
      fill(200, 0, 0);
    }
    rect(xPos, yPos, plaatsBreedte, plaatsHoogte);
  }
}


class knop implements Hitbox
{
  String name;
  String text;
  int x1;
  int y1;
  int x2;
  int y2;

  knop(String name, String text)
  {
    this.name = name;
    this.text = text;
  }

  String getNaam() //getName mag ook al niet
  {
    return name;
  }

  void tekenen(int xPos, int yPos, int knopBreedte, int knopHoogte)
  {
    x1 = xPos;
    y1 = yPos;
    x2 = (xPos + knopBreedte);
    y2 = (yPos + knopHoogte);
    fill(100, 255, 100);
    rect(xPos, yPos, knopBreedte, knopHoogte);
  }

  boolean Match()
  {
    return (mouseX>=x1 && mouseX<=x2 && mouseY>=y1 && mouseY<=y2);
  }
}

class strafvenster implements Hitbox
{
  int sips;
  int x1;
  int y1;
  int x2;
  int y2;

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
    text(sips + " SLOK" + (sips != 1 ? "KEN" : ""),(breedte/2), (hoogte/2));
  }

  boolean Match()
  {
    return (mouseX>=x1 && mouseX<=x2 && mouseY>=y1 && mouseY<=y2);
  }
}
