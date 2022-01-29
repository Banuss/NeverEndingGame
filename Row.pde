class Row implements Render
{
  ArrayList<Kaart> links;
  ArrayList<Kaart> rechts;
  Kaart midden;
  PGraphics pg;
  PVector pos;
  Plaats optieLinks;
  Plaats optieRechts;

  Row(Kaart midden, PVector position)
  {
    pg = createGraphics(width, height / RIJEN); //Hier stond renderer
    pg.beginDraw();
    pg.imageMode(CENTER);
    pg.rectMode(CENTER);
    pg.noStroke();
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
    pg.beginDraw();
    pg.clear();
    pg.endDraw();
    //Teken Middelste Kaart
    int xPos = pg.width/2;
    int yPos = pg.height/2;
    getMidden().tekenen(pg, xPos, yPos, kaartBreedte, kaartHoogte);

    renderSide(yPos, true, getLinks(), optieLinks);
    renderSide(yPos, false, getRechts(), optieRechts);

    image(pg, pos.x, pos.y);
  }
  
  void renderSide(int yPos, boolean links,  ArrayList<Kaart> kaarten, Plaats optie)
  {
    boolean overMax = ( kaarten.size() * (kaartBreedte + SPACE) ) > maxRijBreedte;
    
    int xPos = pg.width / 2;
    int xPosChange = overMax ? kaartBreedte / 3 : kaartBreedte + SPACE;
    
    if (links) {
      xPos -= (kaartBreedte+SPACE);
      xPosChange *= -1;
    } else {
      xPos += (kaartBreedte+SPACE);
    }
    
    for (Kaart k : kaarten)
    {
      k.tekenen(pg, xPos, yPos, kaartBreedte, kaartHoogte);
      xPos += xPosChange;
    }
    //Teken Plaats Links
    optie.tekenen(pg, xPos + (overMax ? (links ? -1 : 1) * (2 * kaartBreedte / 3 + SPACE) : 0), yPos, kaartBreedte, kaartHoogte);
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

    for (Kaart kaart : alle)
    {
      // invalidate image cache
      kaart.image = null;
    }
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
  
  public Kaart getUiterst(boolean linkerkant)
  {
      ArrayList<Kaart> welke_kant;
      welke_kant = linkerkant ?  links : rechts;
      return welke_kant.isEmpty()? midden : welke_kant.get(welke_kant.size()-1);
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
