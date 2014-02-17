class GFxSelectScreen extends GFxMain;

// Select Player Area
var GFxObject P01SelectAreaMC;
var GFxObject P02SelectAreaMC;
var GFxObject P03SelectAreaMC;
var GFxObject P04SelectAreaMC;

//Set PlayerName inside Player Area - PlayerName_Ins
var GFxObject P01SelectNameTF;
var GFxObject P02SelectNameTF;
var GFxObject P03SelectNameTF;
var GFxObject P04SelectNameTF;

// Characters
var archetype Player01 P01;
var archetype Player02 P02;
var archetype Player03 P03;
var archetype Player04 P04;

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
    ConfigSelectMenu();
    bInitialized = true;
}

function ConfigSelectMenu()
{
    // Configs Player Text
    P01SelectAreaMC = RootMC.GetObject("Player01");
    if (P01SelectAreaMC != none)
    {
        P01SelectNameTF = P01SelectAreaMC.GetObject("PlayerName_Ins");
    }
    P02SelectAreaMC = RootMC.GetObject("Player02");
    if (P02SelectAreaMC != none)
    {
        P02SelectNameTF = P02SelectAreaMC.GetObject("PlayerName_Ins");
    }
    P03SelectAreaMC = RootMC.GetObject("Player03");
    if (P03SelectAreaMC != none)
    {
        P03SelectNameTF = P03SelectAreaMC.GetObject("PlayerName_Ins");
    }
    
    P04SelectAreaMC = RootMC.GetObject("Player04");
    if (P04SelectAreaMC != none)
    {
        P04SelectNameTF = P04SelectAreaMC.GetObject("PlayerName_Ins");
    }
    
}

function createChar(int CreateDelete)
{
    local MCHud MCHudAccess;

    MCHudAccess = MCHud(GetPC().MyHUD);

    `log("Creating" @ CreateDelete);
    if (CreateDelete == 1){     MCHudAccess.CreateThisCharacter = P01;  }
    if (CreateDelete == 2){     MCHudAccess.CreateThisCharacter = P02;  }
    if (CreateDelete == 3){     MCHudAccess.CreateThisCharacter = P03;  }
    if (CreateDelete == 4){     MCHudAccess.CreateThisCharacter = P04;  }

}
// Deleting a char if bool is true
function deleteChar(int CreateDelete)
{
    `log("Deleting" @ CreateDelete);

    if (CreateDelete == 1){     WhatCharToDelete(P01);     }
    if (CreateDelete == 2){     WhatCharToDelete(P02);     }
    if (CreateDelete == 3){     WhatCharToDelete(P03);     }
    if (CreateDelete == 4){     WhatCharToDelete(P04);     }
}

// Delete the chars name and show if loaded stats then save
function WhatCharToDelete(MCPawn WhatPawn)
{
    WhatPawn.PlayerName = "";
    WhatPawn.PawnName = "";
    WhatPawn.bSetLevelLoadChar = false;
    //WhatPawn.SaveConfig();
}

/*
// Updates the The Hud the entire time
// @network                 Client
*/
function Tick(float DeltaTime)
{
    // Updates the text
    ActionScriptVoid("root.updateBool");
    // Updates Character
    SetCharacterCreate();
}


/*
// Sets Character Names
*/
function SetCharacterCreate()
{
    // Sets Bool
    RootMC.SetBool("bDeleteChar01", P01.bSetLevelLoadChar);
    RootMC.SetBool("bDeleteChar02", P02.bSetLevelLoadChar);
    RootMC.SetBool("bDeleteChar03", P03.bSetLevelLoadChar);
    RootMC.SetBool("bDeleteChar04", P04.bSetLevelLoadChar);

    // Sets Pawn Name
    if (P01SelectNameTF != none){   P01SelectNameTF.SetString("text", P01.PawnName);    }
    if (P02SelectNameTF != none){   P02SelectNameTF.SetString("text", P02.PawnName);    }
    if (P03SelectNameTF != none){   P03SelectNameTF.SetString("text", P03.PawnName);    }
    if (P04SelectNameTF != none){   P04SelectNameTF.SetString("text", P04.PawnName);    }
}



DefaultProperties
{
    P01 = Player01'mystraschampionsettings.Character.P01';
    P02 = Player02'mystraschampionsettings.Character.P02';
    P03 = Player03'mystraschampionsettings.Character.P03';
    P04 = Player04'mystraschampionsettings.Character.P04';
    
    // Sets s that you can type names correctly
    bCaptureInput=true
    bDisplayWithHudOff=false
    TimingMode=TM_Game
	//MovieInfo=SwfMovie'UDNHud.array_test'
    MovieInfo=SwfMovie'MystrasChampionFlash.menus.SelectionScreen'
}
