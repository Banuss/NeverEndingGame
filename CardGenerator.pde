private String[] getRanks() 
{
  return new String[] {"2","3","4","5","6","7","8","9","10","J","Q","H","A"};
}

private String[][] getSuits()
{
  return new String[][] {{"settings/0.png", "S"}, {"settings/1.png", "K"}, {"settings/2.png", "R"}, {"settings/3.png", "H"}};
}

private final String cardsLocation = "cards" + File.separator;
private final String cardFilenameFormat = "%s_%s.png";

void generateCardfaces() {
  print("Generating cards..."); //<>//
  PGraphics PG_card = createGraphics(640, 890);
  String[] ranks = getRanks();
  String[][] suits = getSuits();

  PG_card.beginDraw();
  PG_card.imageMode(CENTER);
  PG_card.textAlign(CENTER, CENTER);
  PG_card.textSize(300);
  PG_card.fill(0);
  PG_card.endDraw();
  int center_x = int( PG_card.width / 2 );
  int center_y = int( PG_card.height / 2 );

  for (String[] suit : suits) {
    PImage card_image = loadImage(suit[0]);
    for (String rank : ranks) {
      String fname = dataPath(cardsLocation + String.format(cardFilenameFormat, suit[1], rank));
      PG_card.beginDraw();
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
  String[][] suits = getSuits(); //<>//
  String[] ranks = getRanks();
  for (String[] suit : suits)
  {
    for (String rank : ranks)
    {
      String fileName = dataPath(cardsLocation + String.format(cardFilenameFormat, suit[1], rank));
      if (!new File(fileName).exists()) return false;
      //TODO: check if image size is correct
    }
  }
  return true;
}

ArrayDeque<Kaart> createDeck()
{
  String[][] suits = getSuits();
  String[] ranks = getRanks();
  
  ArrayList<Kaart> kaarten = new ArrayList<Kaart>(suits.length * ranks.length);
  
  for (String[] suit : suits)
  {
    int waarde = 2;
    for (String rank : ranks)
    {
      PImage image = loadImage(dataPath(cardsLocation+String.format(cardFilenameFormat, suit[1], rank)));
      kaarten.add(new Kaart(image, waarde));
      waarde++;
    }
  }
  
  schud(kaarten);
  
  return new ArrayDeque<Kaart>(kaarten);
}
