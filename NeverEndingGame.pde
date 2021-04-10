import java.util.ArrayDeque;
import java.util.HashSet;

final int SPACE = 8;

ArrayDeque<Kaart> Deck;
Row[] Speelveld;
HashSet<Hitbox> hitboxes = new HashSet<Hitbox>();
Plaats geselecteerd = null;

void setup() {
  fullScreen(P2D);
  background(0);

  surface.setTitle("Never Ending Game...");

  loadSettings();
  stelDimensiesIn();

  if (!cardfacesAreIntegrous()) generateCardfaces();

  Deck = createDeck();
  Speelveld = generateSpeelveld();
  resetTellers();
}

int kaartTellerDezeBeurt;
int kaartHoogte, kaartBreedte;
int uiHeight, uiWidth;
int maxRijBreedte;
boolean langsteDezeBeurt;
boolean geefVolgendeWeer;
boolean geefStrafWeer;
strafvenster straf;
ArrayList<Row> langsteRijenBegin = new ArrayList<Row>();

void runGameLogic(Row rij, boolean links, boolean hoger)
{
  kaartTellerDezeBeurt++;
  langsteDezeBeurt = langsteDezeBeurt || isLangsteRij(rij);
  if (kaartTellerDezeBeurt >= MIN_KAARTEN_PER_BEURT && langsteDezeBeurt) geefVolgendeWeer = true;

  if (Deck.isEmpty()) Deck = createDeck();
  Kaart k = Deck.pop();
  if (!rij.addKaart(k, links, hoger))
  {
    println("drink " + rij.getStraf(k, links) + " keer");
    geefStrafWeer = true;
    straf = new strafvenster(rij.getStraf(k, links));
    ArrayList<Kaart> eruit = rij.bijFout(k);
    Deck.addAll(eruit);
    if (RESET_BIJ_FOUT) {
      resetTellers();
    }
  }
}

void volgendeSpeler()
{
  println("De volgende speler is aan de beurt");
  resetTellers();
}

void resetTellers()
{
  if (!REALTIME_LANGSTE_RIJ)
  {
    langsteRijenBegin.clear();
    int langste = 0;
    for (Row row : Speelveld)
    {
      langste = Math.max(langste, row.getSize());
    }
    for (Row row : Speelveld)
    {
      if (row.getSize() == langste)
      {
        langsteRijenBegin.add(row);
      }
    }
  }
  kaartTellerDezeBeurt = 0;
  langsteDezeBeurt = !VEREIS_LANGSTE_RIJ;
  geefVolgendeWeer = false;
}

boolean isLangsteRij(Row teVergelijken)
{
  if (REALTIME_LANGSTE_RIJ)
  {
    int langste = 0;
    for (Row rij : Speelveld)
    {
      langste = Math.max(langste, rij.getSize());
    }
    return langste == teVergelijken.getSize();
  }
  return langsteRijenBegin.contains(teVergelijken);
}

Row[] generateSpeelveld()
{
  Row[] result = new Row[RIJEN];
  for (int i = 0; i < result.length; i++)
  {
    result[i] = new Row(Deck.pop(), new PVector( 0, i * height / RIJEN ) );
  }
  return result;
}

void stelDimensiesIn()
{
  kaartHoogte = ((height-(SPACE*(RIJEN+1)))/RIJEN);
  kaartBreedte = (kaartHoogte*2)/3;
  //Reserveer Links en Rechts Ruimte voor UI elements
  uiHeight = (height-(3*SPACE))/2;
  uiWidth = uiHeight/4;

  maxRijBreedte = (width/2) - SPACE - uiWidth - SPACE - kaartBreedte - SPACE - SPACE - SPACE - (kaartBreedte/2);
}

void draw() {
  clear();
  int xPos = SPACE, yPos = SPACE;
  if (geefStrafWeer && straf!=null)
  {
    xPos = 100;
    yPos = 100;
    straf.tekenen(xPos, yPos, (width-200), (height-200));
    hitboxes.add(straf);
  } else
  {
    // Re-assign hitboxes
    hitboxes.clear();

    //Links
    knophogerlager lagerl = new knophogerlager(false);
    lagerl.tekenen(xPos, yPos, uiWidth, uiHeight);
    hitboxes.add(lagerl);

    yPos += uiHeight + SPACE;
    knophogerlager hogerl = new knophogerlager(true);
    hogerl.tekenen(xPos, yPos, uiWidth, uiHeight);
    hitboxes.add(hogerl);

    yPos = SPACE;

    // Volgende Speler 
    if (geefVolgendeWeer)
    {
      xPos += uiWidth + SPACE;
      volgendeKnop kvolgende = new volgendeKnop();
      kvolgende.tekenen(xPos, yPos, uiWidth, uiWidth);
      hitboxes.add(kvolgende);
    }


    xPos = width - uiWidth - SPACE;

    //Rechts
    knophogerlager hogerr = new knophogerlager(true);
    hogerr.tekenen(xPos, yPos, uiWidth, uiHeight);
    hitboxes.add(hogerr);

    yPos += uiHeight + SPACE;
    knophogerlager lagerr= new knophogerlager(false);
    lagerr.tekenen(xPos, yPos, uiWidth, uiHeight);
    hitboxes.add(lagerr);

    yPos = SPACE;

    for (Row row : Speelveld) 
    {
      row.render();
    }
  }
}

void mousePressed() {
  //println("Geklikt op: "+mouseX + ":" + mouseY);

  if (geefStrafWeer)
  {
    if (straf != null && straf.Match())
    {
      geefStrafWeer = false;
    }
    return;
  }

  for (Hitbox hb : hitboxes)
  {
    if (hb.Match())
    {
      hb.onClick();
      return;
    }
  }
}

public void schud(ArrayList<Kaart> pak)
{
  // Fisher-Yates shuffle
  for (int i = 0; i < pak.size(); i++)
  {
    int nieuwePositie = (int) (Math.random() * pak.size());
    Kaart huidig = pak.get(i);
    pak.set(i, pak.get(nieuwePositie));
    pak.set(nieuwePositie, huidig);
  }
}
