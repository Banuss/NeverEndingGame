class Card {
  int imgIndex;
  PGraphics canvas;
  PImage[] cards;
  PVector pos, dim;
  
  Card(PGraphics card_canvas, PImage[] card_images, int imageIndex, PVector position, PVector dimensions) {
    imgIndex = imageIndex;
    cards = card_images;
    canvas = card_canvas;
    pos = position;
    dim = dimensions;
  }
  void render() {
    canvas.beginDraw();
    canvas.imageMode(CENTER);
    canvas.image(cards[imgIndex], pos.x, pos.y, dim.x, dim.y);
    canvas.endDraw();
  }
}
