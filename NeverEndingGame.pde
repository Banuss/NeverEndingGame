import java.util.ArrayDeque;

final int RIJEN = 5;

ArrayDeque<Kaart> Deck;
Row[] Speelveld;

void setup() {
  size(1024, 640);
  surface.setTitle("Never Ending Game...");
  surface.setLocation(100, 100);
  surface.setResizable(true);
  background(0);
  
  
  
  if (!cardfacesAreIntegrous()) generateCardfaces();
  
  Deck = createDeck();
  Speelveld = generateSpeelveld();
  
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

Row[] generateSpeelveld()
{
  Row[] result = new Row[RIJEN];
  for (int i = 0; i < result.length; i++)
  {
    result[i] = new Row(Deck.pop());
  }
  return result;
}

void draw() { 
  //Hoogte Kaart met 5 pixels tussenruimte
  int kaartHoogte = ((height-30)/5);
  int kaartBreedte = (kaartHoogte*2)/3;
  int xPos, yPos = 5;
  int rowNum = 1;
  
  for (Row row : Speelveld) 
  { 
    //Teken Middelste Kaart
    xPos = (width/2)-(kaartBreedte/2)-5;
    drawKaart(row.getMidden(), kaartBreedte, kaartHoogte, xPos, yPos);
    
    xPos -=(row.getLinks().size() + 1) * (kaartBreedte + 5); 
    
    //Teken Plaats Links
    drawPlaats(new Plaats(rowNum, true), kaartBreedte, kaartHoogte, xPos, yPos);
    xPos += kaartBreedte + 5;
   
    //Teken Kaarten Links
    for (Kaart l : row.getLinks())
    {
      drawKaart(l, kaartBreedte, kaartHoogte, xPos, yPos);
      xPos += kaartBreedte + 5;
    }
    
    //Teken Kaarten Rechts
    xPos = (width/2)+(kaartBreedte/2);
    for (Kaart r : row.getRechts())
    {
      drawKaart(r, kaartBreedte, kaartHoogte, xPos, yPos);
      xPos += kaartBreedte + 5;
    }
    
    //Teken Plaats Rechts
    drawPlaats(new Plaats(rowNum, false), kaartBreedte, kaartHoogte, xPos, yPos);
    xPos += kaartBreedte + 5;

    //Volgende Rij + 10
    yPos += (kaartHoogte +5);
  }
}

void drawKaart(Kaart kaart, int kaartBreedte, int kaartHoogte, int xPos, int yPos)
{
  rect(xPos, yPos, kaartBreedte, kaartHoogte, 10);
}

void drawPlaats(Plaats plaats, int plaatsBreedte, int plaatsHoogte, int xPos, int yPos)
{
  rect(xPos, yPos, plaatsBreedte, plaatsHoogte);
}


public void schud(ArrayList<Kaart> pak)
{
  // Fisher-Yates shuffle
  for(int i = 0; i < pak.size(); i++)
  {
    int nieuwePositie = (int) (Math.random() * pak.size());
    Kaart huidig = pak.get(i);
    pak.set(i, pak.get(nieuwePositie));
    pak.set(nieuwePositie, huidig);
  }
}
