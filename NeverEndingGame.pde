import java.util.ArrayDeque;

final int SPACE = 8;

ArrayDeque<Kaart> Deck;
Row[] Speelveld;
Plaats[] Plaatsen;
ArrayList<Hitbox> hitboxes = new ArrayList<Hitbox>();

void setup() {
  loadSettings();
  resetTellers();
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

int kaartTellerDezeBeurt;
boolean langsteDezeBeurt;
boolean geefVolgendeWeer;
boolean geefStrafWeer;
strafvenster straf;

void runGameLogic(Row rij, boolean links, boolean hoger)
{
  kaartTellerDezeBeurt++;
  langsteDezeBeurt = langsteDezeBeurt || isLangsteRij(rij);
  if (kaartTellerDezeBeurt >= MIN_KAARTEN_PER_BEURT && langsteDezeBeurt) geefVolgendeWeer = true;

  if (Deck.isEmpty()) Deck = createDeck();
  Kaart k = Deck.pop();
  if (!rij.addKaart(k, links, hoger))
  {
    println("drink " + rij.getSize() + " keer");
    geefStrafWeer = true;
    straf = new strafvenster(rij.getSize() + (TEL_FOUT_MEE ? 1 : 0));
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
  kaartTellerDezeBeurt = 0;
  langsteDezeBeurt = !VEREIS_LANGSTE_RIJ;
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
  int xPos = SPACE, yPos = SPACE;
  if (geefStrafWeer && straf!=null)
  {
    xPos = 100;
    yPos = 100;
    straf.tekenen(xPos, yPos, (width-200), (height-200));
    hitboxes.add(straf);
  } else
  {
    hitboxes.clear();
    int kaartHoogte = ((height-(SPACE*(RIJEN+1)))/RIJEN);
    int kaartBreedte = (kaartHoogte*2)/3;
    int rowNum = 0;


    //Reserveer Links en Rechts Ruimte voor UI elements
    int uiHeight = (height-(3*SPACE))/2;
    int uiWidth = uiHeight/4;

    int maxRijBreedte = (width/2) - SPACE - uiWidth - SPACE - kaartBreedte - SPACE - SPACE - SPACE - (kaartBreedte/2);

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

      xPos = (width/2)-(kaartBreedte/2)-kaartBreedte - SPACE - SPACE;

      //Teken Kaarten Links
      for (Kaart l : row.getLinks())
      {
        l.tekenen(xPos, yPos, kaartBreedte, kaartHoogte);
        if ((row.getLinks().size() * kaartBreedte+SPACE)> maxRijBreedte)
        {
          xPos -= kaartBreedte/3;
        } else
        {
          xPos -= kaartBreedte + SPACE;
        }
      }
      if ((row.getLinks().size() * kaartBreedte+SPACE)> maxRijBreedte)
      {
        xPos -= (kaartBreedte/3 + kaartBreedte/3 + SPACE);
      }

      //Teken Plaats Links
      Plaatsen[rowNum].tekenen(xPos, yPos, kaartBreedte, kaartHoogte);
      hitboxes.add(Plaatsen[rowNum]);

      //Teken Kaarten Rechts
      xPos = (width/2)+(kaartBreedte/2);
      for (Kaart r : row.getRechts())
      {
        r.tekenen(xPos, yPos, kaartBreedte, kaartHoogte);
        if ((row.getRechts().size() * kaartBreedte+SPACE)> maxRijBreedte)
        {
          xPos += kaartBreedte/3;
        } else
        {
          xPos += kaartBreedte + SPACE;
        }
      }
      if ((row.getRechts().size() * kaartBreedte+SPACE)> maxRijBreedte)
      {
        xPos += (kaartBreedte/3 + kaartBreedte/3 + SPACE);
      }

      //Teken Plaats Rechts
      Plaatsen[rowNum+RIJEN].tekenen(xPos, yPos, kaartBreedte, kaartHoogte);
      hitboxes.add(Plaatsen[rowNum+RIJEN]);
      xPos += kaartBreedte + SPACE;

      //Volgende Rij
      yPos += (kaartHoogte + SPACE);
      rowNum++;


      //OverLay Straf
      if (geefStrafWeer && straf!=null)
      {
        xPos = SPACE;
        yPos = SPACE;
        straf.tekenen(xPos, yPos, (width-SPACE-SPACE), (height-SPACE-SPACE));
        hitboxes.add(straf);
      }
    }
  }
}

void mousePressed() {
  println("Geklikt op: "+mouseX + ":" + mouseY);
  for (Hitbox hb : hitboxes)
  {
    if (hb.Match())
    {
      if (hb instanceof strafvenster)
      {
        geefStrafWeer = false;
        return;
      } else if (hb instanceof knophogerlager)
      {
        for (Plaats p : Plaatsen)
        {
          if (p.getSelect())
          {
            runGameLogic(Speelveld[p.getRij()], p.getLinks(), ((knophogerlager) hb).getHoger());
            return;
          }
        }
      } else if (hb instanceof knop)
      {
        if (((knop) hb).getNaam().equals("volgende"));
        {
          volgendeSpeler();
          return;
        }
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
