PImage[] LoadCards() {
  String file_location = "data/cards/";
  String[] suit_names = {"S", "K", "R", "H"};
  String[] ranks = loadStrings("settings/settings.txt");

  PImage[] cards = new PImage[ranks.length*4];
  int card_index = 0;

  for ( String suit : suit_names ) {
    for ( String rank : ranks ) {
      cards[card_index] = loadImage(file_location+suit+"_"+rank+".png");
      card_index ++;
    }
  }

  return cards;
}
