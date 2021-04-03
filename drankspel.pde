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
  Deck.addAll(Speelveld.get(1).bijFout(Deck.pop()));
}

ArrayDeque<Kaart> schudden()
{
  ArrayDeque<Kaart> result = new ArrayDeque<Kaart>();
  for (int i = 0; i < 54; i++)
  {
    result.add(new Kaart());
  }
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
  Kaart()
  {
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
    
    // Fisher-Yates shuffle
    for(int i = 0; i < alle.size(); i++)
    {
      int nieuwePositie = (int) (Math.random() * alle.size());
      Kaart huidig = alle.get(i);
      alle.set(i, alle.get(nieuwePositie));
      alle.set(nieuwePositie, huidig);
    }
    
    Links.clear();
    Rechts.clear();
    midden = nieuwMidden;
    
    return alle;
  }

  public Kaart getMidden()
  {
    return midden;
  }

  public void addLinks(Kaart add)
  {
    Links.add(add);
  }

  public void addRechts(Kaart add)
  {
    Rechts.add(add);
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
