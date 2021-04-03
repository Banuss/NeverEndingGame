import java.util.ArrayDeque;

ArrayDeque<Kaart> Deck;
ArrayList<Row> Speelveld;
int horizontaal = 1920;
int verticaal = 1080;

void setup() {
  size(1920, 1080);
  surface.setTitle("Never Ending Game...");
  surface.setLocation(100, 100);
  surface.setResizable(true);
  background(0);
  Deck = schudden();
  Speelveld = generateSpeelveld();
  
  // even een voorbeeld
  Kaart h2 = new Kaart(2);
  Kaart s7 = new Kaart(7);
  Kaart ha = new Kaart(14);
  // er ligt een rij met een harten 2 in het midden
  Row r = new Row(h2);
  // Piet legt een kaart aan de linkerkant en gokt naturlijk op hoger (true)
  boolean gelukt = r.addLinks(s7, true);
  // Piet trok de schoppen 7 dus het is true
  if (!gelukt) {/**/}
  // Piet legt nog een kaart aan de linkerkant en gokt op lager (false)
  gelukt = r.addLinks(ha, false);
  // Piet had het fout, het was een harten aas 
  if (!gelukt)
  {
    // hoeveel moet Piet drinken
    println(r.getSize());
    // Maak de rij weer leeg
    r.bijFout(ha);
  }
}

ArrayDeque<Kaart> schudden()
{
  ArrayDeque<Kaart> result = new ArrayDeque<Kaart>();
  for (int i = 0; i < 54; i++)
  {
    result.add(new Kaart(i % 13 + 2));
  }
//  schud(result);
  return result;
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
  int xPos, yPos = 5;
  
  for (Row row : Speelveld) 
  {
    xPos = (1920/2)-50;
    drawKaart(row.getMidden(), xPos, yPos);
    xPos = row.getLinks().size() * 110; 
    for (Kaart l : row.getLinks())
    {
      drawKaart(l, xPos, yPos);
      xPos += 110;
    }

    xPos = (1920/2)+60;
    for (Kaart r : row.getRechts())
    {
      drawKaart(r, xPos, yPos);
      xPos += 110;
    }

    //Volgende Rij + 10
    yPos += 160;
  }
}

void drawKaart(Kaart kaart, int xPos, int yPos)
{
  rect(xPos, yPos, 100, 150, 7);
}




class Kaart
{
  final int waarde;
  
  Kaart(int waarde)
  {
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
  ArrayList<Kaart> Links;
  ArrayList<Kaart> Rechts;
  Kaart midden;

  Row(Kaart midden)
  {
    Links = new ArrayList<Kaart>();
    Rechts = new ArrayList<Kaart>();
    this.midden = midden;
  }
  
  public int getSize()
  {
    return 1 + Links.size() + Rechts.size();
  }
  
  /**
  * Roep dit aan om een nieuw midden te plaatsen
  * Alle andere kaarten worden uit de rij gehaald en geschud zodat je ze onder op de stapel kan doen
  */
  public ArrayList<Kaart> bijFout(Kaart nieuwMidden)
  {
    ArrayList<Kaart> alle = new ArrayList<Kaart>(Links);
    alle.add(midden);
    alle.addAll(Rechts);
    
    schud(alle);
    
    Links.clear();
    Rechts.clear();
    midden = nieuwMidden;
    
    return alle;
  }

  public boolean addLinks(Kaart add, boolean hoger)
  {
    return addGeneric(add, hoger, Links);
  }

  public boolean addRechts(Kaart add, boolean hoger)
  {
    return addGeneric(add, hoger, Rechts);
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
    
    Links.add(add);
    return true;
  }
  
  public Kaart getMidden()
  {
    return midden;
  }

  public  ArrayList<Kaart> getLinks()
  {
    return Links;
  } 

  public  ArrayList<Kaart> getRechts()
  {
    return Rechts;
  }
}
