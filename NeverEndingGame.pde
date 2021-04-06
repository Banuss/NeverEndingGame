import java.util.ArrayDeque;

int RIJEN;
int MIN_KAARTEN_PER_BEURT;

public static final String GAME_SETTINGS = "game.properties";
final int SPACE = 8;

void loadSettings()
{
  //defaults
  int RIJEN = 5;
  int MIN_KAARTEN_PER_BEURT = 3;

  String gameSettingsLocation = dataPath("settings" + File.separator + GAME_SETTINGS);
  String[] settings = loadStrings(gameSettingsLocation);
  if (settings != null)
  {
    for (String setting : settings)
    {
      int separatorPos = setting.indexOf("=");
      if (separatorPos > 1)
      {
        switch (setting.substring(0, separatorPos))
        {
        case "RIJEN":
          RIJEN = Integer.parseInt(setting.substring(separatorPos+1));
          break;
        case "MIN_KAARTEN_PER_BEURT":
          MIN_KAARTEN_PER_BEURT = Integer.parseInt(setting.substring(separatorPos+1));
          break;
        default:
          println("Unknown setting: \"" + setting + "\"");
          break;
        }
      }
    }
  } else
  {
    saveStrings(gameSettingsLocation, new String[] {"RIJEN="+RIJEN, "MIN_KAARTEN_PER_BEURT="+MIN_KAARTEN_PER_BEURT});
  }

  this.RIJEN = RIJEN;
  this.MIN_KAARTEN_PER_BEURT = MIN_KAARTEN_PER_BEURT;
}

ArrayDeque<Kaart> Deck;
Row[] Speelveld;
Plaats[] Plaatsen;
ArrayList<Hitbox> hitboxes = new ArrayList<Hitbox>();

void setup() {
  loadSettings();
  size(1024, 640);
  surface.setTitle("Never Ending Game...");
  surface.setLocation(100, 100);
  surface.setResizable(true);
  background(0);

  if (!cardfacesAreIntegrous()) generateCardfaces();

  Deck = createDeck();
  Speelveld = generateSpeelveld();
  Plaatsen = generatePlaatsen();
}

int kaartTellerDezeBeurt = 0;
boolean langsteDezeBeurt = false;
boolean geefVolgendeWeer = false;

void runGameLogic(Row rij, boolean links, boolean hoger)
{
  kaartTellerDezeBeurt++;
  langsteDezeBeurt = langsteDezeBeurt || isLangsteRij(rij);
  if (kaartTellerDezeBeurt >= MIN_KAARTEN_PER_BEURT && langsteDezeBeurt) geefVolgendeWeer = true;

  Kaart k = Deck.pop();
  if (!rij.addKaart(k, links, hoger))
  {
    println("drink " + rij.getSize() + " keer");
    ArrayList<Kaart> eruit = rij.bijFout(k);
    Deck.addAll(eruit);
    kaartTellerDezeBeurt = 0;
    langsteDezeBeurt = false;
    geefVolgendeWeer = false;
  }
}

/**
 * Wordt nog niet gebruikt
 */
void volgendeSpeler()
{
  println("De volgende speler is aan de beurt");
  kaartTellerDezeBeurt = 0;
  langsteDezeBeurt = false;
  geefVolgendeWeer = false;
}

boolean isLangsteRij(Row teVergelijken)
{
  int langste = 0;
  for (Row rij : Speelveld)
  {
    langste = Math.max(langste, rij.getSize());
  }
  return langste == teVergelijken.getSize();
}

Row[] generateSpeelveld()
{
  Row[] result = new Row[RIJEN];
  for (int i = 0; i < result.length; i++)
  {
    result[i] = new Row(Deck.pop());
  }
  return result;
}

Plaats[] generatePlaatsen()
{
  Plaats[] result = new Plaats[RIJEN*2];
  for (int i = 0; i < RIJEN; i++)
  {
    result[i] = new Plaats(i, true);
  }
  for (int i = 0; i < RIJEN; i++)
  {
    result[i+RIJEN] = new Plaats(i, false);
  }
  return result;
}


void draw() { 
  clear();
  //Hoogte Kaart met 5 pixels tussenruimte
  hitboxes.clear();
  int kaartHoogte = ((height-(SPACE*(RIJEN+1)))/RIJEN);
  int kaartBreedte = (kaartHoogte*2)/3;
  int xPos = SPACE, yPos = SPACE;
  int rowNum = 0;

  //Reserveer Links en Rechts Ruimte voor UI elements

  int uiHeight = (height-(3*SPACE))/2;
  int uiWidth = uiHeight/4;


  //Links
  knophogerlager lagerl = new knophogerlager(false);
  lagerl.tekenen(xPos, yPos, uiWidth, uiHeight);
  hitboxes.add(lagerl);
  yPos += uiHeight + SPACE;
  knophogerlager hogerl = new knophogerlager(true);
  hogerl.tekenen(xPos, yPos, uiWidth, uiHeight);
  hitboxes.add(hogerl);
  yPos = SPACE;

  if (geefVolgendeWeer)
  {
    xPos += uiWidth + SPACE;
    knop kvolgende = new knop("volgende", "Volgende");
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

    //Teken Middelste Kaart
    xPos = (width/2)-(kaartBreedte/2)-SPACE;
    row.getMidden().tekenen(xPos, yPos, kaartBreedte, kaartHoogte);

    xPos -=(row.getLinks().size() + 1) * (kaartBreedte + SPACE); 

    //Teken Plaats Links
    Plaatsen[rowNum].tekenen(xPos, yPos, kaartBreedte, kaartHoogte);
    hitboxes.add(Plaatsen[rowNum]);

    xPos = (width/2)-(kaartBreedte/2)-kaartBreedte - SPACE - SPACE;

    //Teken Kaarten Links
    for (Kaart l : row.getLinks())
    {
      l.tekenen(xPos, yPos, kaartBreedte, kaartHoogte);
      xPos -= kaartBreedte + SPACE;
    }

    //Teken Kaarten Rechts
    xPos = (width/2)+(kaartBreedte/2);
    for (Kaart r : row.getRechts())
    {
      r.tekenen(xPos, yPos, kaartBreedte, kaartHoogte);
      xPos += kaartBreedte + SPACE;
    }

    //Teken Plaats Rechts
    Plaatsen[rowNum+RIJEN].tekenen(xPos, yPos, kaartBreedte, kaartHoogte);
    hitboxes.add(Plaatsen[rowNum+RIJEN]);
    xPos += kaartBreedte + SPACE;

    //Volgende Rij
    yPos += (kaartHoogte + SPACE);
    rowNum++;


    //Temporair UI
  }
}

void mouseClicked() {
  println("Geklikt op: "+mouseX + ":" + mouseY);
  for (Hitbox hb : hitboxes)
  {
    if (hb.Match()&& hb instanceof knophogerlager)
    {
      for (Plaats p : Plaatsen)
      {
        if (p.getSelect())
        {
          runGameLogic(Speelveld[p.getRij()], p.getLinks(), ((knophogerlager) hb).getHoger());
        }
      }
    }
    if (hb.Match()&& hb instanceof knop)
    {
      if (((knop) hb).getNaam().equals("volgende"));
      {
        volgendeSpeler();
      }
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
