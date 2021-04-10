Row[] generateSpeelveld()
{
  Row[] result = new Row[RIJEN];
  for (int i = 0; i < result.length; i++)
  {
    result[i] = new Row(Deck.pop(), new PVector( 0, i * height / RIJEN ) );
  }
  return result;
}

knophogerlager[] generateHogerLager()
{
  int xcl = SPACE+uiWidth/2;
  int xcr = width-xcl;
  int yct = SPACE+uiHeight/2;
  int ycb = height-yct;
  int[] x = {xcl, xcl, xcr, xcr};
  int[] y = {yct, ycb, yct, ycb};
  boolean[] buttonType = {true, false, false, true};
  knophogerlager[] result = new knophogerlager[4];

  for (int i = 0; i < result.length; i++ )
  {
    result[i] = new knophogerlager( buttonType[i], x[i], y[i], uiWidth, uiHeight);
  }
  return result;
}

volgendeKnop[] generateVolgende()
{
  int xcl = SPACE+uiWidth/2;
  int xcr = width - xcl;
  int yc = height/2;
  int[] x = {xcl, xcr};
  int[] y = {yc, yc };
  volgendeKnop[] result = new volgendeKnop[2];
  for (int i = 0; i < result.length; i++ )
  {
    result[i] = new volgendeKnop(x[i], y[i], uiWidth, uiHeight);
  }
  return result;
}
