void GenerateCards() {
  print("Generating cards...");
  PGraphics PG_card = createGraphics(640, 890);
  String[] ranks = loadStrings("settings/settings.txt");
  String[][] suits = {{"settings/0.png", "S"}, {"settings/1.png", "K"}, {"settings/2.png", "R"}, {"settings/3.png", "H"}};

  PG_card.beginDraw();
  PG_card.imageMode(CENTER);
  PG_card.textAlign(CENTER, CENTER);
  PG_card.textSize(300);
  PG_card.fill(0);
  PG_card.endDraw();
  int center_x = int( PG_card.width / 2 );
  int center_y = int( PG_card.height / 2 );

  for ( String[] suit : suits ) {
    PImage card_image = loadImage(suit[0]);
    for ( String rank : ranks ) {
      String fname = "data/cards/"+suit[1]+"_"+rank+".png";
      PG_card.beginDraw();
      PG_card.background(255);
      PG_card.text(rank, center_x, center_y/2);
      PG_card.image(card_image, center_x, 1.5*center_y);
      PG_card.endDraw();
      PG_card.save(fname);
    }
  }
  println(" cards generated.");
}
