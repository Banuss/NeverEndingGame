interface Render {
  void render();
}

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
    println("removed hitbox.");
    hitboxes.remove(this);
  }
}

class knophogerlager extends Hitbox
{
  boolean hoger = false;
  PVector pos, dim;
  color fillColor;

  knophogerlager(boolean hoger, int xPos, int yPos, int plaatsBreedte, int plaatsHoogte)
  {
    this.hoger = hoger;
    fillColor = (hoger) ? color(0, 255, 0) : color(255, 0, 0);
    pos = new PVector( xPos, yPos );
    dim = new PVector( plaatsBreedte, plaatsHoogte );
    x1 = getXpos(int(pos.x - dim.x/2));
    x2 = getXpos(int(pos.x + dim.x/2));
    y1 = getYpos(int(pos.y - dim.y/2));
    y2 = getYpos(int(pos.y + dim.y/2));
  }

  void render()
  {
    ui.pgUI.beginDraw();
    ui.pgUI.strokeWeight(10);
    ui.pgUI.stroke(255,255,255);
    ui.pgUI.fill(fillColor);
    ui.pgUI.rect(pos.x, pos.y, dim.x, dim.y);
    ui.pgUI.fill(255,255,255);
    ui.pgUI.endDraw();
  }

  public void onClick()
  {
    if (geselecteerd != null) runGameLogic(geselecteerd.rij, geselecteerd.getLinks(), hoger);
  }
}


class volgendeKnop extends Hitbox implements Render
{
  PVector pos, dim;
  volgendeKnop(int xPos, int yPos, int knopBreedte, int knopHoogte)
  {
    pos = new PVector( xPos, yPos );
    dim = new PVector( knopBreedte, knopHoogte );
    x1 = getXpos(int(pos.x - dim.x/2));
    x2 = getXpos(int(pos.x + dim.x/2));
    y1 = getYpos(int(pos.y - dim.y/2));
    y2 = getYpos(int(pos.y + dim.y/2));
  }
  
  void render()
  {
    ui.pgUI.beginDraw(); 
    if (geefVolgendeWeer) {
      ui.pgUI.strokeWeight(10);
      ui.pgUI.stroke(255,255,255);
      ui.pgUI.fill(0, 0, 255);
    } else {
      ui.pgUI.fill(0);
      ui.pgUI.stroke(0,0,0);
      ui.pgUI.strokeWeight(0);
    }
    ui.pgUI.rect(pos.x, pos.y, dim.x, dim.y);
    ui.pgUI.endDraw();
  }
  
  public void onClick()
  {
    if (geselecteerd != null) changed.add(geselecteerd.rij);
    volgendeSpeler();
    changed.add(ui);
  }
}

class UI implements Render
{
  PGraphics pgUI;
  knophogerlager[] KnoppenHoogLaag;
  volgendeKnop[] KnoppenVolgende;
  
  UI() {
    pgUI = createGraphics(getNewWidth(), getNewHeight()); //Hiuer stond renderer
    pgUI.beginDraw();
    pgUI.rectMode(CENTER);
    pgUI.noStroke();
    pgUI.endDraw();
  }
  
  void render() {
    // Knoppen
    pgUI.beginDraw();
    pgUI.clear();
    pgUI.endDraw();
    for (volgendeKnop knop : KnoppenVolgende) {
      knop.render();
    }
    for (knophogerlager knop : KnoppenHoogLaag)
    {
      knop.render();
    }
    image(pgUI, getXpos(0), getYpos(0));
  }
}

class strafvenster extends Hitbox
{
  int sips;
  PVector pos, dim;
  Kaart getrokken, opTafel;


  strafvenster(Kaart getrokken, Kaart opTafel, int sips)
  {
    this.getrokken = getrokken;
    this.opTafel = opTafel;
    pos = new PVector(pgStraf.width/2, pgStraf.height/2);
    dim = new PVector(pgStraf.width/2, pgStraf.height/2);

    x1 = getXpos(int(pos.x - dim.x/2));
    x2 = getXpos(int(pos.x + dim.x/2));
    y1 = getYpos(int(pos.y - dim.y/2));
    y2 = getYpos(int(pos.y + dim.y/2));

    this.sips = sips;
  }

  void render()
  {
    pgStraf.beginDraw();
    pgStraf.clear();
    pgStraf.fill(0, 0, 0);
    pgStraf.stroke(255,255,255);
    pgStraf.strokeWeight(10);
    pgStraf.rect(pos.x, pos.y, dim.x, dim.y);
    pgStraf.fill(255, 255, 255);
    pgStraf.textAlign(CENTER, CENTER);
    pgStraf.text(sips + " SLOK" + (sips != 1 ? "KEN" : ""), pos.x+80, pos.y+80);
    pgStraf.text(">", pos.x+10, pos.y-170);
    getrokken.tekenen(pgStraf,int(pos.x)-(kaartBreedte/2)-150,int(pos.y)-230, kaartBreedte, kaartHoogte);
    opTafel.tekenen(pgStraf, int(pos.x)-(kaartBreedte/2)+150, int(pos.y)-230, kaartBreedte, kaartHoogte);
    pgStraf.endDraw();
    image(pgStraf, getXpos(0), getYpos(0));
  }

  public void onClick() {
  assert false : 
    "Strafvenster wordt elders geregeld";
  }
}
