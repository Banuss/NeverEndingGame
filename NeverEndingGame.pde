import java.util.ArrayDeque;
import java.util.HashSet;
import java.util.concurrent.Semaphore;

final int SPACE = 8;
PFont uiFont;

// hoort bij een UI class ofzo
PGraphics pgStraf;
UI ui;

final Semaphore mutex = new Semaphore(1, true);
ArrayDeque<Kaart> Deck;
Row[] Speelveld;
Plaats geselecteerd = null;
HashSet<Hitbox> hitboxes = new HashSet<Hitbox>();
HashSet<Render> changed = new HashSet<Render>();

int kaartTellerDezeBeurt;
int kaartHoogte, kaartBreedte;
int uiHeight, uiWidth;
int maxRijBreedte;
boolean langsteDezeBeurt;
boolean geefVolgendeWeer;
boolean geefStrafWeer;
strafvenster straf;
ArrayList<Row> langsteRijenBegin = new ArrayList<Row>();

void settings() {
  loadSettings();
  fullScreen();
}

void setup() {
  background(0);

  surface.setTitle("Never Ending Game...");
  uiFont = createFont("fonts/keed.ttf", 72);

  stelUIin();

  if (!cardfacesAreIntegrous()) generateCardfaces();

  Deck = createDeck();
  Speelveld = generateSpeelveld();
  ui.KnoppenHoogLaag = generateHogerLager();
  ui.KnoppenVolgende = generateVolgende();
  
  resetTellers();

  textAlign(CENTER, CENTER);
  fill(255);
  textFont(uiFont);
  textSize(200);
  text("Vul alle glazen...", width/2, height/2);
  //noLoop();
}

void draw()
{
  if (changed.isEmpty()) {
    render();
  } else
  {
    println("Rerendering " + changed.size() + " elements");
    for (Render r : changed) {
      r.render();
    }
    changed.clear();
  }
}

void mousePressed() {
  //println("Geklikt op: "+mouseX + ":" + mouseY);

  if (geefStrafWeer)
  {
    if (straf != null )
    {
      geefStrafWeer = false;
      straf.destroy();
      geselecteerd = null;
    }
    redraw();
    return;
  }

  for (Hitbox hb : hitboxes)
  {
    if (hb.Match())
    {
      hb.onClick();
      redraw();
      return;
    }
  }
}
