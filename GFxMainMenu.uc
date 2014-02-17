class GFxMainMenu extends GFxMain;


function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0.f);

    RootMC = GetVariableObject("root");

    if (!bInitialized)
    {
        ConfigHUD();
    `log("-----------------------------------------------------------------------");
    `log("-------------------------------MainMenu--------------------------------");
    `log("-----------------------------------------------------------------------");
    }
    
    return true;
}

/*
// We start off by setting the initial settings
// @network                 Client
*/
function ConfigHUD()
{
    /*
    // GameRound
    GameRoundTF = RootMC.GetObject("gameroundareaINS").GetObject("roundINS");
    // Background
    BackgroundMC = RootMC.GetObject("backgroundINS");
    BackgroundMC.SetVisible(false);
*/
    bInitialized = true;
}


DefaultProperties
{
    bDisplayWithHudOff=false
    TimingMode=TM_Game
	//MovieInfo=SwfMovie'UDNHud.array_test'
//    MovieInfo=SwfMovie'MystrasChampionFlash.shops.ShopMaterial'
}
