private String[] getRanks() 
{
  return new String[] {"2","3","4","5","6","7","8","9","10","J","Q","H","A"};
}

enum Suit {
  schoppen("settings/0.png", "S", 0),
  klaver("settings/1.png", "K", 0),
  ruiten("settings/2.png", "R", #FF0000),
  harten("settings/3.png", "H", #FF0000);
  
  final String image;
  final String id;
  final int kleur;
  
  private Suit(String image, String id, int kleur)
  {
    this.image = image;
    this.id = id;
    this.kleur = kleur;
  }
}

private static final String cardsLocation = "cards" + File.separator;
private static final String cardFilenameFormat = "%s_%s.png";

void generateCardfaces() {
  print("Generating cards..."); //<>//
  PGraphics PG_card = createGraphics(640, 890);
  String[] ranks = getRanks();
  Suit[] suits = Suit.values();

  PG_card.beginDraw();
  PG_card.imageMode(CENTER);
  PG_card.textAlign(CENTER, CENTER);
  PG_card.textSize(300);
  PG_card.fill(0);
  PG_card.endDraw();
  int center_x = int( PG_card.width / 2 );
  int center_y = int( PG_card.height / 2 );

  for (Suit suit : suits) {
    PImage card_image = loadImage(suit.image); //<>//
    for (String rank : ranks) {
      String fname = getLocation(suit, rank);
      PG_card.beginDraw();
      PG_card.fill(suit.kleur);
      PG_card.background(255);
      PG_card.text(rank, center_x, center_y/2);
      PG_card.image(card_image, center_x, 1.5*center_y);
      PG_card.endDraw();
      PG_card.save(fname);
    }
  }
  assert cardfacesAreIntegrous();
  println(" cards generated.");
}

/**
 * Check to see if new cards need to be generated
 */
boolean cardfacesAreIntegrous()
{
  Suit[] suits = Suit.values(); //<>//
  String[] ranks = getRanks();
  for (Suit suit : suits)
  {
    for (String rank : ranks)
    {
      String fileName = getLocation(suit, rank);
      if (!new File(fileName).exists()) return false;
      //TODO: check if image size is correct
    }
  }
  return true;
}

ArrayDeque<Kaart> createDeck()
{
  Suit[] suits = Suit.values();
  String[] ranks = getRanks();
  
  ArrayList<Kaart> kaarten = new ArrayList<Kaart>(suits.length * ranks.length);
  
  for (int i = 0; i < PAKJES_KAARTEN; i++)
  {
    for (Suit suit : suits)
    {
      int waarde = 2;
      for (String rank : ranks)
      {
        PImage image = loadImage(getLocation(suit, rank));
        kaarten.add(new Kaart(image, waarde));
        waarde++;
      }
    }
  }
  
  schud(kaarten);
  println("Er zitten " + kaarten.size() + " kaarten in de stapel");
  
  return new ArrayDeque<Kaart>(kaarten);
}

String getLocation(Suit suit, String rank)
{
  return dataPath(cardsLocation + String.format(cardFilenameFormat, suit.id, rank));
}
