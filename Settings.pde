public static final String GAME_SETTINGS = "game.properties";

int RIJEN = 5;
int MIN_KAARTEN_PER_BEURT = 3;
int PAKJES_KAARTEN = 1;
boolean TEL_FOUT_MEE = true;
boolean RESET_BIJ_FOUT = true;
boolean VEREIS_LANGSTE_RIJ = true;
boolean DUBBEL_BIJ_DUBBEL = true;

void loadSettings()
{
  String gameSettingsLocation = dataPath("settings" + File.separator + GAME_SETTINGS);
  String[] settings = loadStrings(gameSettingsLocation);
  if (settings != null)
  {
    for (String setting : settings)
    {
      int separatorPos = setting.indexOf("=");
      if (separatorPos > 1)
      {
        switch (setting.substring(0, separatorPos))
        {
        case "RIJEN":
          RIJEN = Integer.parseInt(setting.substring(separatorPos+1));
          break;
        case "MIN_KAARTEN_PER_BEURT":
          MIN_KAARTEN_PER_BEURT = Integer.parseInt(setting.substring(separatorPos+1));
          break;
        case "PAKJES_KAARTEN":
          PAKJES_KAARTEN = Integer.parseInt(setting.substring(separatorPos+1));
          break;
        case "TEL_FOUT_MEE":
          TEL_FOUT_MEE = Boolean.parseBoolean(setting.substring(separatorPos+1));
          break;
        case "RESET_BIJ_FOUT":
          RESET_BIJ_FOUT = Boolean.parseBoolean(setting.substring(separatorPos+1));
          break;
        case "VEREIS_LANGSTE_RIJ":
          VEREIS_LANGSTE_RIJ = Boolean.parseBoolean(setting.substring(separatorPos+1));
          break;
        case "DUBBEL_BIJ_DUBBEL":
          DUBBEL_BIJ_DUBBEL = Boolean.parseBoolean(setting.substring(separatorPos+1));
          break;
        default:
          println("Unknown setting: \"" + setting + "\"");
          break;
        }
      }
    }
  }
  settings = new String[] {
    "RIJEN=" + RIJEN,
    "MIN_KAARTEN_PER_BEURT=" + MIN_KAARTEN_PER_BEURT,
    "PAKJES_KAARTEN=" + PAKJES_KAARTEN,
    "TEL_FOUT_MEE=" + TEL_FOUT_MEE,
    "RESET_BIJ_FOUT=" + RESET_BIJ_FOUT,
    "VEREIS_LANGSTE_RIJ=" + VEREIS_LANGSTE_RIJ,
    "DUBBEL_BIJ_DUBBEL=" + DUBBEL_BIJ_DUBBEL
  };
  
  for (String setting : settings)
  {
    println(setting);
  }
  
  saveStrings(gameSettingsLocation, settings);
}
