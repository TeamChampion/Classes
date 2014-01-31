class GFxBattleUI extends GFxMoviePlayer;

var GFxObject RootMC;
var MouseInterfaceHUD MouseInterfaceHUD;
var MCPlayerController MCPC;
var MCPawn MCP;


/*
// TF = texts, ints, floats etc
// MC = Areas, inside symbols etc
// Btn = Buttons
*/

// Player 01 things
var GFxObject P01_Name;

function Init(optional LocalPlayer LocalPlayer)
{
	// Initialize the ScaleForm movie
	Super.Init(LocalPlayer);
	Start();
    Advance(0.f);

 	RootMC = GetVariableObject("root");
	`log("------------------------------------ Start Movie");
}

function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0.f);

    `log("-----------------------------------------------------------------------");
    `log("---------------------------------main----------------------------------");
    `log("-----------------------------------------------------------------------");
	RootMC = GetVariableObject("root");
	return true;
}

event UpdateMousePosition(float X, float Y)
{
	local MouseInterfacePlayerInput MouseInterfacePlayerInput;

	if (MouseInterfaceHUD != None && MouseInterfaceHUD.PlayerOwner != None)
	{
		MouseInterfacePlayerInput = MouseInterfacePlayerInput(MouseInterfaceHUD.PlayerOwner.PlayerInput);

		if (MouseInterfacePlayerInput != None)
		{
			MouseInterfacePlayerInput.SetMousePosition(X, Y);
		}
	}
}

function GetPlayerInformation()
{
	local MCGameReplication MOBAGRI;

	// Get PlayerControoler
	MCPC = MCPlayerController(GetPC());
	// Get Pawn
	MCP = MCPawn(GetPC().Pawn);
	// Get GameReplication
	MOBAGRI = MCGameReplication(class'WorldInfo'.static.GetWorldInfo().GRI);




	P01_Name = RootMC.GetObject("NAME_player01_instance");
	if (P01_Name != none)
	{
		P01_Name.SetString("text", MOBAGRI.MCPRIArray[0].PawnName);
		//`log(stuff);
	}




	// first page
//	TitleMC = RootMC.GetObject("test0101").GetObject("Title");
//	TitleMC.SetText(shopText[0]);
	// second page
	//RootMC.GotoAndStop("TimeShopText");
	//TitleMC = RootMC.GetObject("text_mc02").GetObject("TextFieldTitle");    
	//TitleMC.SetText(shopText[0]);
}






DefaultProperties
{
    bDisplayWithHudOff=false
    TimingMode=TM_Game
    MovieInfo=SwfMovie'MystrasChampionFlash.Battle.BattleHUD'

	bPauseGameWhileActive=false
}