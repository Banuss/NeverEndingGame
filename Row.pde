class Row
{
  ArrayList<Kaart> links;
  ArrayList<Kaart> rechts;
  Kaart midden;
  PGraphics pg;
  Plaats optieLinks;
  Plaats optieRechts;
  PVector pos;

  Row(Kaart midden, PVector position)
  {
    pg = createGraphics(width, height / RIJEN, P2D);
    pg.beginDraw();
    pg.imageMode(CENTER);
    pg.endDraw();

    pos = position;

    links = new ArrayList<Kaart>();
    optieLinks = new Plaats(this, true);
    rechts = new ArrayList<Kaart>();
    optieRechts = new Plaats(this, false);
    this.midden = midden;
  }

  void render()
  {
    int rowNum = 0;
    int xPos = SPACE;
    int yPos = SPACE;
    //Teken Middelste Kaart
    xPos = pg.width/2;
    yPos = pg.height/2;
    getMidden().tekenen(pg, xPos, yPos, kaartBreedte, kaartHoogte);


    //Teken Kaarten Links
    xPos = pg.width/2 - (kaartBreedte+SPACE);
    for (Kaart k : getLinks())
    {
      k.tekenen(pg, xPos, yPos, kaartBreedte, kaartHoogte);
      xPos -= (( getLinks().size() * (kaartBreedte + SPACE) ) > maxRijBreedte) ? kaartBreedte/3 : kaartBreedte + SPACE;
    }
    
    pg.beginDraw();
    pg.fill(color(255,0,0));
    pg.ellipse(xPos, yPos, 10, 10);
    pg.fill(color(0,0,0));
    pg.endDraw();

    //Teken Plaats Links
    rectMode(CENTER);
    Plaatsen[rowNum].tekenen(xPos, yPos, kaartBreedte, kaartHoogte);
    hitboxes.add(Plaatsen[rowNum]);
    

    //Teken Kaarten Rechts
    xPos = (pg.width/2)+(kaartBreedte/2);
    for (Kaart r : getRechts())
    {
      r.tekenen(pg, xPos, yPos, kaartBreedte, kaartHoogte);
      if ((getRechts().size() * kaartBreedte+SPACE) > maxRijBreedte)
      {
        xPos += kaartBreedte/3;
      } else
      {
        xPos += kaartBreedte + SPACE;
      }
    }
    if ((getRechts().size() * kaartBreedte+SPACE) > maxRijBreedte)
    {
      xPos += (kaartBreedte/3 + kaartBreedte/3 + SPACE);
    }

    //Teken Plaats Rechts
    Plaatsen[rowNum+RIJEN].tekenen(xPos, yPos, kaartBreedte, kaartHoogte);
    hitboxes.add(Plaatsen[rowNum+RIJEN]);
    xPos += kaartBreedte + SPACE;

    //Volgende Rij
    image(pg, pos.x, pos.y);
  }


  public int getStraf(Kaart k, boolean links)
  {
    return (getSize() + (TEL_FOUT_MEE ? 1 : 0)) * (DUBBEL_BIJ_DUBBEL && isDubbel(k, links) ? 2 : 1);
  }

  public int getSize()
  {
    return 1 + links.size() + rechts.size();
  }

  /*
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

  public boolean isDubbel(Kaart k, boolean linkerkant)
  {
    return k.waarde == getUiterste(linkerkant ? links : rechts).waarde;
  }

  public boolean addKaart(Kaart add, boolean links, boolean hoger)
  {
    return addGeneric(add, hoger, links ? this.links : rechts);
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
    Kaart huidig = getUiterste(kant);

    if (hoger)
    {
      // Als de waarde niet hoger is maar dat wel gegokt is, voeg het dan niet toe
      if (!(add.waarde > huidig.waarde)) return false;
    } else
    {
      // idem dito voor lager gegokt
      if (!(add.waarde < huidig.waarde)) return false;
    }

    kant.add(add);
    return true;
  }

  public Kaart getUiterste(ArrayList<Kaart> kant)
  {
    return kant.isEmpty() ? midden : kant.get(kant.size() - 1);
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
