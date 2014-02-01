class GFxBattleUI extends GFxMoviePlayer;

var GFxObject RootMC;
var MouseInterfaceHUD MouseInterfaceHUD;
var MCPlayerController MCPC;
var MCPawn MCP;



/*
// TF = TextField - texts, ints, floats etc
// MC = MovieClip - Areas, inside symbols etc
// Btn = Buttons
// CB = GFxClikWidget = Click button 	ButtonPress / RollOver / RollOut
// RB = GFxClikWidget = Roll button 	RollOver / RollOut
*/




// Player 01 things That we change on MovieClip symbols
/*
//	plyaer01area - 
//	
*/
var GFxObject P01areaMC;	// Player Area
var GFxObject P01APareaMC;	// Player AP Area
var GFxObject P01NameTF;	// Set Player Name
var GFxObject P01HPTextTF;	// Set Player HP
var GFxObject P01APNumbTF;	// Set His AP Number
var GFxObject P01APTextTF;	// Set His AP Text
// Send HP to code
// Send MAXHP to code
//	- Indicator checks if we have AP, IF AP is more then 0 then show it


// Player 02 things That we change on MovieClip symbols
var GFxObject P02areaMC;	// Player Area
var GFxObject P02APareaMC;	// Player AP Area
var GFxObject P02NameTF;	// Set Player Name
var GFxObject P02HPTextTF;	// Set Player HP
var GFxObject P02APNumbTF;	// Set His AP Number
var GFxObject P02APTextTF;	// Set His AP Text
// Send HP to code
// Send MAXHP to code
//	- Indicator checks if we have AP, IF AP is more then 0 then show it

var GFxObject GameRoundMC;
var GFxObject GameRoundTF; //roundINS


/*
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
*/



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

function findThisInPC()
{
	`log("I found you from HUD and PC");
}

function setPlayerLightUpIndicator()
{
//	local MCPlayerController MyPC;
	local MCGameReplication MyGMRep;
//	local MCPawn MyPawn;
	local int i;
//	local GFxObject GetIndicator;
	local int setTheNumber;

	// Get PlayerControoler
//	MyPC = MCPlayerController(GetPC());
	// Get Pawn
//	MyPawn = MCPawn(GetPC().Pawn);
	// Get GameReplication
	MyGMRep = MCGameReplication(class'WorldInfo'.static.GetWorldInfo().GRI);

	for (i = 0; i < MyGMRep.MCPRIArray.Length ; i++)
	{
		// If My Rep char has my current Characters AP then set indicator
		if (MyGMRep.MCPRIArray[i].bHaveAp)
		{

			setTheNumber = MyGMRep.MCPRIArray[i].PlayerUniqueID;
		}


		RootMC.SetInt("LightUPNumber", setTheNumber);
		ActionScriptVoid("root.LightUpIndicator");
	}
}	


function getActionscript(int find)
{
	//`log(find);
	//`log("I GOT THE STUPID THING!!!!!!!!!!!!!!!!!");
}





function GetPlayerInformation()
{
	local MCGameReplication MCGRep;
	local int i;


	// Get PlayerControoler
	MCPC = MCPlayerController(GetPC());
	// Get Pawn
	MCP = MCPawn(GetPC().Pawn);
	// Get GameReplication
	MCGRep = MCGameReplication(class'WorldInfo'.static.GetWorldInfo().GRI);

	setPlayerLightUpIndicator();




	// GameRound
	GameRoundTF = RootMC.GetObject("gameroundareaINS").GetObject("roundINS");
	if (GameRoundTF != none)
	{
		GameRoundTF.SetInt("text", MCGRep.GameRound);
	}
	// Players
	for (i = 0; i < MCGRep.MCPRIArray.Length ; i++)
	{

		// Player 2 Stats
		// if we have the same id then show our stuff
		// otherwise hide it for other player.
		P01areaMC = RootMC.GetObject("player01areaINS");
		if (P01areaMC != none && MCGRep.MCPRIArray[i].PlayerUniqueID == 1)
		{
			// Player 02 Name
			P01NameTF = P01areaMC.GetObject("playernameINS");
			if (P01NameTF != none)
			{
				P01NameTF.SetString("text", MCGRep.MCPRIArray[i].PawnName);
			}

			// Player 02 Health Text
			P01HPTextTF = P01areaMC.GetObject("healthbartextINS");
			if (P02HPTextTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MCPC.PlayerUniqueID)
			{
				P01HPTextTF.SetInt("text", MCGRep.MCPRIArray[i].Health);
			}else
			{
				P01HPTextTF.SetString("text", "");
			}

			// Player 02 AP Text
			P01APareaMC = P01areaMC.GetObject("playerapareaINS");
			if (P01APareaMC != none)
			{
				// AP Number
				P01APNumbTF = P01APareaMC.GetObject("apINS");
				if (P02APNumbTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MCPC.PlayerUniqueID)
				{
					P01APNumbTF.SetInt("text", MCGRep.MCPRIArray[i].APf);
				}else
				{
					P01APNumbTF.SetString("text", "");
				}

				// AP Text
				P01APTextTF = P01APareaMC.GetObject("aptextINS");
				if (P01APTextTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MCPC.PlayerUniqueID)
				{
					//P01APTextTF.SetString("text", "AP");
				}else
				{
					P01APTextTF.SetString("text", "");
				}
			}
		}

		// Player 2 Stats
		// if we have the same id then show our stuff
		// otherwise hide it for other player.
		P02areaMC = RootMC.GetObject("player02areaINS");
		if (P02areaMC != none && MCGRep.MCPRIArray[i].PlayerUniqueID == 2)
		{
			// Player 02 Name
			P02NameTF = P02areaMC.GetObject("playernameINS");
			if (P02NameTF != none)
			{
				P02NameTF.SetString("text", MCGRep.MCPRIArray[i].PawnName);
			}

			// Player 02 Health Text
			P02HPTextTF = P02areaMC.GetObject("healthbartextINS");
			if (P02HPTextTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MCPC.PlayerUniqueID)
			{
				P02HPTextTF.SetInt("text", MCGRep.MCPRIArray[i].Health);
			}else
			{
				P02HPTextTF.SetString("text", "");
			}

			// Player 02 AP Text
			P02APareaMC = P02areaMC.GetObject("playerapareaINS");
			if (P02APareaMC != none)
			{
				// AP Number
				P02APNumbTF = P02APareaMC.GetObject("apINS");
				if (P02APNumbTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MCPC.PlayerUniqueID)
				{
					P02APNumbTF.SetInt("text", MCGRep.MCPRIArray[i].APf);
				}else
				{
					P02APNumbTF.SetString("text", "");
				}

				// AP Text
				P02APTextTF = P02APareaMC.GetObject("aptextINS");
				if (P02APTextTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MCPC.PlayerUniqueID)
				{
					//P02APTextTF.SetString("text", "AP");
				}else
				{
					P02APTextTF.SetString("text", "");
				}
			}
		}
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