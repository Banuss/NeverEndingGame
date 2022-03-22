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
    
    String tekst = hoger ?  "hoger" : "lager";
    ui.pgUI.beginDraw();
    ui.pgUI.strokeWeight(10);
    ui.pgUI.stroke(255,255,255);
    ui.pgUI.fill(fillColor);
    ui.pgUI.rect(pos.x, pos.y, dim.x, dim.y);
    ui.pgUI.pushMatrix();
      ui.pgUI.fill(255,255,255);
      ui.pgUI.textAlign(CENTER);
      ui.pgUI.textFont(uiFont);
      ui.pgUI.textSize(dim.x);
      if(pos.x > getNewWidth()/2)
      {
        float angle = radians(90);
        ui.pgUI.translate(pos.x - (dim.x/3),pos.y);
        ui.pgUI.rotate(angle);
      }
      else
      {
        float angle = radians(270);
        ui.pgUI.translate(pos.x + (dim.x/3),pos.y);
        ui.pgUI.rotate(angle);
      }
      ui.pgUI.text(tekst, 0,0);
    ui.pgUI.popMatrix();
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
  boolean clicked = false;
  PVector pos, dim;
  Kaart getrokken, opTafel;
  
  strafvenster(Kaart getrokken, Kaart opTafel, int sips)
  {
    this.getrokken = getrokken;
    this.opTafel = opTafel;
    pos = new PVector(pgStraf.width/2, pgStraf.height/2);
    dim = new PVector(pgStraf.width*0.8, pgStraf.height*0.8);

    x1 = 0;
    x2 = width;
    y1 = 0;
    y2 = height;
    
    this.clicked = !STRAF_DUBBEL_KLIK;
    this.sips = sips;
  }

  void render()
  {
    pgStraf.beginDraw();
    pgStraf.clear();
    if (clicked) pgStraf.stroke(0,255,0);
    else pgStraf.stroke(255,0,0);
    pgStraf.strokeWeight(20);
    pgStraf.fill(0);
    pgStraf.rect(pos.x, pos.y, dim.x, dim.y,30);
    pgStraf.textAlign(CENTER, CENTER);
    pgStraf.textFont(uiFont);
    
    pgStraf.fill(255);
    pgStraf.textSize(100);
    pgStraf.text(">", pos.x, pos.y-kaartHoogte/4);
    pgStraf.text("<", pos.x, pos.y+kaartHoogte/4);
    
    pgStraf.translate(0, dim.y/4);
    pgStraf.pushMatrix();
      pgStraf.fill(255);
      pgStraf.textSize(100);
      pgStraf.text(sips + " SLOK" + (sips != 1 ? "KEN" : ""), pos.x, pos.y);
    pgStraf.popMatrix();
    
    pgStraf.translate(0, -dim.y/4);
    pgStraf.translate(dim.x*1.25, dim.y);
    
    pgStraf.pushMatrix();
      pgStraf.fill(255);
      pgStraf.textSize(100);
      pgStraf.rotate(radians(180));
      pgStraf.text(sips + " SLOK" + (sips != 1 ? "KEN" : ""), pos.x, pos.y);
    pgStraf.popMatrix();
    
    pgStraf.endDraw();
    getrokken.tekenen(pgStraf,int(pos.x)-(kaartBreedte/2)-150,int(pos.y)-(kaartHoogte/2), kaartBreedte, kaartHoogte);
    opTafel.tekenen(pgStraf, int(pos.x)-(kaartBreedte/2)+150, int(pos.y)-(kaartHoogte/2), kaartBreedte, kaartHoogte);
    image(pgStraf, getXpos(0), getYpos(0));
    
  }

  public void onClick() {
  assert false : 
    "Strafvenster wordt elders geregeld";
  }
}
