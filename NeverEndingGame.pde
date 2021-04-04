import java.util.ArrayDeque;

ArrayDeque<Kaart> Deck;
ArrayList<Row> Speelveld;

void setup() {
  size(1024, 640);
  surface.setTitle("Never Ending Game...");
  surface.setLocation(100, 100);
  surface.setResizable(true);
  background(0);
  
  
  
  if (!cardfacesAreIntegrous()) generateCardfaces();
  
  Deck = schudden();
  Speelveld = generateSpeelveld();
  
  // even een voorbeeld
  Kaart h2 = new Kaart("Harten", 2);
  Kaart s7 = new Kaart("Schoppen", 7);
  Kaart ha = new Kaart("Harten", 14);
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
    println(r.getSize());
    // Maak de rij weer leeg en leg de getrokken harten aas in het midden
    ArrayList<Kaart> eruit = r.bijFout(ha);
    Deck.addAll(eruit);
  }
}

ArrayDeque<Kaart> schudden()
{
  String[] soorten = new String[] {"Schoppen", "Harten", "Klaver", "Ruiten"};
  ArrayList<Kaart> kaarten = new ArrayList<Kaart>();
  
  for (String soort : soorten)
  {
    for (int i = 2; i < 15; i++)
    {
      kaarten.add(new Kaart(soort, i));
    }
  }
  schud(kaarten);
  
  return new ArrayDeque<Kaart>(kaarten);
}

ArrayList<Row> generateSpeelveld()
{
  ArrayList<Row> result = new ArrayList<Row>();
  for (int i = 0; i < 5; i++)
  {
    result.add(new Row(Deck.pop()));
  }
  return result;
}

void draw() { 
  //Hoogte Kaart met 5 pixels tussenruimte
  int kaartHoogte = ((height-30)/5);
  int kaartBreedte = (kaartHoogte*2)/3;
  int xPos, yPos = 5;
  
  for (Row row : Speelveld) 
  {
    xPos = (width/2)-(kaartBreedte/2)-5;
    drawKaart(row.getMidden(), kaartBreedte, kaartHoogte, xPos, yPos);
    xPos = row.getLinks().size() * (kaartBreedte + 5); 
    for (Kaart l : row.getLinks())
    {
      drawKaart(l, kaartBreedte, kaartHoogte, xPos, yPos);
      xPos += kaartBreedte + 5;
    }

    xPos = (width/2)+(kaartBreedte/2)+5;
    for (Kaart r : row.getRechts())
    {
      drawKaart(r, kaartBreedte, kaartHoogte, xPos, yPos);
      xPos += kaartBreedte + 5;
    }

    //Volgende Rij + 10
    yPos += (kaartHoogte +5);
  }
}

void drawKaart(Kaart kaart, int kaartBreedte, int kaartHoogte, int xPos, int yPos)
{
  rect(xPos, yPos, kaartBreedte, kaartHoogte, 7);
}

class Kaart
{
  final String soort;
  final int waarde;
  
  Kaart(String soort, int waarde)
  {
    this.soort = soort;
    
    assert waarde >= 2;
    assert waarde <= 14;
    this.waarde = waarde;
  }
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

class Row
{
  ArrayList<Kaart> links;
  ArrayList<Kaart> rechts;
  Kaart midden;

  Row(Kaart midden)
  {
    links = new ArrayList<Kaart>();
    rechts = new ArrayList<Kaart>();
    this.midden = midden;
  }
  
  public int getSize()
  {
    return 1 + links.size() + rechts.size();
  }
  
  /**
  * Roep dit aan om een nieuw midden te plaatsen
  * Alle andere kaarten worden uit de rij gehaald en geschud zodat je ze onder op de stapel kan doen
  */
  public ArrayList<Kaart> bijFout(Kaart nieuwMidden)
  {
    ArrayList<Kaart> alle = new ArrayList<Kaart>(links);
    alle.add(midden);
    alle.addAll(rechts);
    
    schud(alle);
    
    links.clear();
    rechts.clear();
    midden = nieuwMidden;
    
    return alle;
  }

  public boolean addLinks(Kaart add, boolean hoger)
  {
    return addGeneric(add, hoger, links);
  }

  public boolean addRechts(Kaart add, boolean hoger)
  {
    return addGeneric(add, hoger, rechts);
  }
  
  private boolean addGeneric(Kaart add, boolean hoger, ArrayList<Kaart> kant)
  {
    // Vergelijk de kaart met de uiterste aan die kant (mogelijk het midden)
    Kaart huidig = kant.isEmpty() ? midden : kant.get(kant.size() - 1);
    
    if (hoger)
    {
      // Als de waarde niet hoger is maar dat wel gegokt is, voeg het dan niet toe
      if (!(add.waarde > huidig.waarde)) return false;
    }
    else
    {
      // idem dito voor lager gegokt
      if (!(add.waarde < huidig.waarde)) return false;
    }
    
    kant.add(add);
    return true;
  }
  
  public Kaart getMidden()
  {
    return midden;
  }

  public  ArrayList<Kaart> getLinks()
  {
    return links;
  } 

  public  ArrayList<Kaart> getRechts()
  {
    return rechts;
  }
}
