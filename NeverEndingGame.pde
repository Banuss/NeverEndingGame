import java.util.ArrayDeque;

final int RIJEN = 5;
final int SPACE = 8;

ArrayDeque<Kaart> Deck;
Row[] Speelveld;
Plaats[] Plaatsen;
ArrayList<Hitbox> hitboxes = new ArrayList<Hitbox>();

void setup() {
  size(1024, 640);
  surface.setTitle("Never Ending Game...");
  surface.setLocation(100, 100);
  surface.setResizable(true);
  background(0);

  if (!cardfacesAreIntegrous()) generateCardfaces();

  Deck = createDeck();
  Speelveld = generateSpeelveld();
  Plaatsen = generatePlaatsen();

  // even een voorbeeld
  Kaart h2 = new Kaart(null, 2);
  Kaart s7 = new Kaart(null, 7);
  Kaart ha = new Kaart(null, 14);
  // er ligt een rij met een harten 2 in het midden
  Row r = new Row(h2);
  // Piet legt een kaart aan de linkerkant en gokt naturlijk op hoger (true)
  boolean gelukt = r.addLinks(s7, true);
  // Piet trok de schoppen 7 dus het is true
  assert gelukt;
  // Piet legt nog een kaart aan de linkerkant en gokt op lager (false)
  gelukt = r.addLinks(ha, false);
  // Piet had het fout, het was een harten aas 
  if (!gelukt)
  {
    // hoeveel moet Piet drinken
    println("Piet moet " + r.getSize() + " keer drinken");
    // Maak de rij weer leeg en leg de getrokken harten aas in het midden
    ArrayList<Kaart> eruit = r.bijFout(ha);
    // Doe de kaarten onderop de stapel, de kaarten zijn al geschud door row.bijFout
    Deck.addAll(eruit);
  }
}

void runGameLogic(Row rij, boolean links, boolean hoger)
{
  Kaart k = Deck.pop(); 
  if (!rij.addKaart(k, links, hoger))
  {
    ArrayList<Kaart> eruit = rij.bijFout(k);
    Deck.addAll(eruit);
  }
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
  for (int i = 0; i < (result.length); i++)
  {
    result[i] = new Plaats(i, true);
    println(i);
  }
  for (int i = 0; i < (result.length); i++)
  {
    println(i);
  }
  return result;
}


void draw() { 
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
  knophogerlager hogerl = new knophogerlager(true);
  hogerl.tekenen(xPos, yPos, uiWidth, uiHeight);
  hitboxes.add(hogerl);
  yPos += uiHeight + SPACE;
  knophogerlager lagerl = new knophogerlager(false);
  lagerl.tekenen(xPos, yPos, uiWidth, uiHeight);
  hitboxes.add(lagerl);
  yPos = SPACE;

  xPos = width - uiWidth - SPACE;
  yPos = SPACE;

  //Rechts
  knophogerlager lagerr= new knophogerlager(false);
  lagerr.tekenen(xPos, yPos, uiWidth, uiHeight);
  hitboxes.add(lagerr);
  yPos += uiHeight + SPACE;
  knophogerlager hogerr = new knophogerlager(true);
  hogerr.tekenen(xPos, yPos, uiWidth, uiHeight);
  hitboxes.add(hogerr);
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
    xPos += kaartBreedte + SPACE;

    //Teken Kaarten Links
    for (Kaart l : row.getLinks())
    {
      l.tekenen(xPos, yPos, kaartBreedte, kaartHoogte);
      xPos += kaartBreedte + SPACE;
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
