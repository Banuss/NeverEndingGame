void runGameLogic(Row rij, boolean links, boolean hoger)
{
  println("runGameLogic()");
  kaartTellerDezeBeurt++;
  langsteDezeBeurt = langsteDezeBeurt || isLangsteRij(rij);
  if (kaartTellerDezeBeurt >= MIN_KAARTEN_PER_BEURT && langsteDezeBeurt) geefVolgendeWeer = true;

  if (Deck.isEmpty()) Deck = createDeck();
  Kaart k = Deck.pop();
  if (!rij.addKaart(k, links, hoger))
  {
    println("drink " + rij.getStraf(k, links) + " keer");
    geefStrafWeer = true;
    straf = new strafvenster(rij.getStraf(k, links));
    ArrayList<Kaart> eruit = rij.bijFout(k);
    Deck.addAll(eruit);
    if (RESET_BIJ_FOUT) {
      resetTellers();
    }
  }
}

void volgendeSpeler()
{
  println("volgendeSpeler()");
  println("De volgende speler is aan de beurt");
  resetTellers();
  geselecteerd = null;
}

void resetTellers()
{
  println("resetTellers()");
  if (!REALTIME_LANGSTE_RIJ)
  {
    langsteRijenBegin.clear();
    int langste = 0;
    for (Row row : Speelveld)
    {
      langste = Math.max(langste, row.getSize());
    }
    for (Row row : Speelveld)
    {
      if (row.getSize() == langste)
      {
        langsteRijenBegin.add(row);
      }
    }
  }
  kaartTellerDezeBeurt = 0;
  langsteDezeBeurt = !VEREIS_LANGSTE_RIJ;
  geefVolgendeWeer = false;
}

boolean isLangsteRij(Row teVergelijken)
{
  println("isLangsteRij()");
  if (REALTIME_LANGSTE_RIJ)
  {
    int langste = 0;
    for (Row rij : Speelveld)
    {
      langste = Math.max(langste, rij.getSize());
    }
    return langste == teVergelijken.getSize();
  }
  return langsteRijenBegin.contains(teVergelijken);
}

void stelUIin()
{
  println("stelUIin()");
  kaartHoogte = ((height-(SPACE*(RIJEN+1)))/RIJEN);
  kaartBreedte = (kaartHoogte*2)/3;
  //Reserveer Links en Rechts Ruimte voor UI elements
  uiHeight = (height - (4*SPACE))/3;
  uiWidth = uiHeight/4;

  maxRijBreedte = (width/2) - SPACE - uiWidth - SPACE - kaartBreedte - SPACE - SPACE - SPACE - (kaartBreedte/2);

  pgUI = createGraphics(width, height, P2D);
  pgUI.beginDraw();
  pgUI.rectMode(CENTER);
  pgUI.noStroke();
  pgUI.endDraw();

  pgStraf = createGraphics(width, height, P2D);
  pgStraf.beginDraw();
  pgStraf.rectMode(CENTER);
  pgStraf.textFont(uiFont);
  pgStraf.textAlign(CENTER, CENTER);
  pgStraf.textSize(150);
  pgStraf.endDraw();
}

void render() {
  println("render()");
  background(0);
  if (geefStrafWeer && straf!=null)
  {
    straf.render();
  } else
  {
    renderBoard();
  }
}

void renderBoard()
{
  println("renderBoard()");

  // Knoppen
  pgUI.beginDraw();
  pgUI.clear();
  pgUI.endDraw();
  for (volgendeKnop knop : KnoppenVolgende) {
    knop.render();
  }
  for (knophogerlager knop : KnoppenHoogLaag)
  {
    knop.render();
  }
  image(pgUI, 0, 0);

  for (Row row : Speelveld) 
  {
    row.render();
  }
}

public void schud(ArrayList<Kaart> pak)
{
  println("schud()");
  // Fisher-Yates shuffle
  for (int i = 0; i < pak.size(); i++)
  {
    int nieuwePositie = (int) (Math.random() * pak.size());
    Kaart huidig = pak.get(i);
    pak.set(i, pak.get(nieuwePositie));
    pak.set(nieuwePositie, huidig);
  }
}
