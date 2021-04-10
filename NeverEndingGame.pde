import java.util.ArrayDeque;
import java.util.HashSet;

final int SPACE = 8;
PFont uiFont;

// hoort bij een UI class ofzo
PGraphics pgUI, pgStraf;
knophogerlager[] KnoppenHoogLaag;
volgendeKnop[] KnoppenVolgende;

ArrayDeque<Kaart> Deck;
Row[] Speelveld;
Plaats geselecteerd = null;
HashSet<Hitbox> hitboxes = new HashSet<Hitbox>();

int kaartTellerDezeBeurt;
int kaartHoogte, kaartBreedte;
int uiHeight, uiWidth;
int maxRijBreedte;
boolean langsteDezeBeurt;
boolean geefVolgendeWeer;
boolean geefStrafWeer;
strafvenster straf;
ArrayList<Row> langsteRijenBegin = new ArrayList<Row>();

void setup() {
  fullScreen(P2D);
  background(0);

  surface.setTitle("Never Ending Game...");
  uiFont = createFont("fonts/keed.ttf", 72);

  loadSettings();
  stelUIin();

  if (!cardfacesAreIntegrous()) generateCardfaces();

  Deck = createDeck();
  Speelveld = generateSpeelveld();
  KnoppenHoogLaag = generateHogerLager();
  KnoppenVolgende = generateVolgende();

  resetTellers();
  
  textAlign(CENTER,CENTER);
  fill(255);
  textFont(uiFont);
  textSize(200);
  text("Loading...", width/2,height/2);
  
  noLoop();
}

void draw()
{
  render();
}

void mousePressed() {
  //println("Geklikt op: "+mouseX + ":" + mouseY);

  if (geefStrafWeer)
  {
    if (straf != null && straf.Match())
    {
      geefStrafWeer = false;
      straf.destroy();
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
