class Row
{
  ArrayList<Kaart> links;
  ArrayList<Kaart> rechts;
  Kaart midden;
  PGraphics canvas;

  Row(Kaart midden)
  {
    links = new ArrayList<Kaart>();
    rechts = new ArrayList<Kaart>();
    this.midden = midden;
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
