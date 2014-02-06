class GFxBattleUI extends GFxMoviePlayer;

var GFxObject RootMC;
var MouseInterfaceHUD MouseInterfaceHUD;
var MCPlayerController MCPC;
var MCPawn MCP;

var int SaveWhoseTurn;

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

var GFxObject GameRoundMC;	// Round MovieClip
var GFxObject GameRoundTF; 	// roundINS
var GFxObject BackgroundMC;	// Option Background



// Widgets for spells
var GFxCLIKWidget Earth01;
var GFxCLIKWidget Earth02;
var GFxCLIKWidget Earth03;
var GFxCLIKWidget Earth04;

var GFxCLIKWidget Fire01;
var GFxCLIKWidget Fire02;
var GFxCLIKWidget Fire03;
var GFxCLIKWidget Fire04;

// Widget for AP Reset button
var GFxCLIKWidget ResetAPBtn;
// Widget for Option Buttons
var GFxCLIKWidget OptionBtn;
var GFxCLIKWidget ContinueBtn;
var GFxCLIKWidget RestartBattleBtn;
var GFxCLIKWidget ReturnToTownBtn;

// Widget for Spells
var GFxCLIKWidget Spell1;
var GFxCLIKWidget Spell2;
var GFxCLIKWidget Spell3;
var GFxCLIKWidget Spell4;

// Just check if it has started
var bool bInitialized;

/*
function Init(optional LocalPlayer LocalPlayer)
{
	// Initialize the ScaleForm movie
	Super.Init(LocalPlayer);
	Start();
    Advance(0.f);

 	RootMC = GetVariableObject("root");
	`log("------------------------------------ Start Movie");
}
*/

function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0.f);

	RootMC = GetVariableObject("root");

	if (!bInitialized)
	{
		ConfigHUD();
    `log("-----------------------------------------------------------------------");
    `log("---------------------------------main----------------------------------");
    `log("-----------------------------------------------------------------------");
	}
	
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

// Sent function from ActionScript
function getActionscript(int find)
{
	//`log(find);
	//`log("I GOT THE STUPID THING!!!!!!!!!!!!!!!!!");
}



function SaveCodeAS()
{
	
//	RootMC.SetInt("LightUPNumber", setTheNumber);
//	ActionScriptVoid("root.LightUpIndicator");





	// first page
//	TitleMC = RootMC.GetObject("test0101").GetObject("Title");
//	TitleMC.SetText(shopText[0]);
	// second page
	//RootMC.GotoAndStop("TimeShopText");
	//TitleMC = RootMC.GetObject("text_mc02").GetObject("TextFieldTitle");    
	//TitleMC.SetText(shopText[0]);
}








/*
// We start off by setting the initial settings
// @network					Client
*/
function ConfigHUD()
{
	// GameRound
	GameRoundTF = RootMC.GetObject("gameroundareaINS").GetObject("roundINS");
	// Background
	BackgroundMC = RootMC.GetObject("backgroundINS");
	BackgroundMC.SetVisible(false);

	ConfigPlayerStats();
	ConfigAPButton();
	ConfigSpells();
	ConfigOptionButton();

	bInitialized = true;
}

/*
// Set up Player Stats to link them all with Scaleform
// @network					Client
*/
function ConfigPlayerStats()
{
	`log("Hello PlayerConfigStats");

	// Player 1 Stats
	// Player 1 Area MovieClip
	P01areaMC = RootMC.GetObject("player01areaINS");
	if (P01areaMC != none)
	{
		// Name
		P01NameTF = P01areaMC.GetObject("playernameINS");
		// Health Text
		P01HPTextTF = P01areaMC.GetObject("healthbartextINS");
		// AP Area MovieClip
		P01APareaMC = P01areaMC.GetObject("playerapareaINS");
		if (P01APareaMC != none)
		{
			// AP Number
			P01APNumbTF = P01APareaMC.GetObject("apINS");
			// AP Text
			P01APTextTF = P01APareaMC.GetObject("aptextINS");
		}
	}

	// Player 2 Stats
	// Player 2 Area MovieClip
	P02areaMC = RootMC.GetObject("player02areaINS");
	if (P02areaMC != none)
	{
		// Name
		P02NameTF = P02areaMC.GetObject("playernameINS");
		// Health Text
		P02HPTextTF = P02areaMC.GetObject("healthbartextINS");
		// AP Area MovieClip
		P02APareaMC = P02areaMC.GetObject("playerapareaINS");
		if (P02APareaMC != none)
		{
			// AP Number
			P02APNumbTF = P02APareaMC.GetObject("apINS");
			// AP Text
			P02APTextTF = P02APareaMC.GetObject("aptextINS");
		}
	}

	`log("GoodBye PlayerConfigStats");
}

/*
// Config the AP Reset Button
// @network					Client
*/
function ConfigAPButton()
{
	`log("Hello ConfigAPButton");
	
	// Get the Widget
	ResetAPBtn = GFxClikWidget(RootMC.GetObject("resetapINS",class'GFxClikWidget'));
	if (ResetAPBtn != none)
	{
		// Add button press, mouse over, mouse out
		ResetAPBtn.AddEventListener('CLIK_buttonPress', APResetButton);
	}

	`log("GoodBye ConfigAPButton");
}


/*
// Config the AP Reset Button
// @network					Client
*/
function ConfigOptionButton()
{
	`log("Hello OptionButton");
	
	// Get the Widget
	// Main Option button
	OptionBtn = GFxClikWidget(RootMC.GetObject("optionINS",class'GFxClikWidget'));
	if (OptionBtn != none)
	{
		// Add button press, mouse over, mouse out
		OptionBtn.AddEventListener('CLIK_buttonPress', OptionButton);
	}
	// Continue Button
	ContinueBtn = GFxClikWidget(RootMC.GetObject("continueINS",class'GFxClikWidget'));
	if (ContinueBtn != none)
	{
		ContinueBtn.AddEventListener('CLIK_buttonPress', ContinueButton);
		ContinueBtn.SetVisible(false);
	}
	// Restart Battle Button
	RestartBattleBtn = GFxClikWidget(RootMC.GetObject("restartbattleINS",class'GFxClikWidget'));
	if (RestartBattleBtn != none)
	{
		RestartBattleBtn.AddEventListener('CLIK_buttonPress', RestartBattleButton);
		RestartBattleBtn.SetVisible(false);
	}
	// Return To Town Button
	ReturnToTownBtn = GFxClikWidget(RootMC.GetObject("returntotownINS",class'GFxClikWidget'));
	if (ReturnToTownBtn != none)
	{
		ReturnToTownBtn.AddEventListener('CLIK_buttonPress', ReturnToTownButton);
		ReturnToTownBtn.SetVisible(false);
	}
	`log("GoodBye OptionButton");
}


/*
// Config the Spell buttons to work with the game
// @network					Client
*/
function ConfigSpells()
{
	local MCPawn MyPawn;
	local MCPlayerController PC;
	local ASDisplayInfo ASDisplayInfo;
	local string SpellName;
	local int SpellIndex;
	local GFxClikWidget ThisClikButton;

	MyPawn = MCPawn(GetPC().Pawn);
	PC = MCPlayerController(GetPC());
	SpellIndex = 0;


	// Check all the Spells the Pawn has
	foreach MyPawn.MyDynamicSpells(SpellName)
	{
		// If the SpellName matches with the case, then assign it please.
		switch (SpellName)
		{
			case "kaleidoscope":
				// Get the Object Button 
				ThisClikButton = GFxClikWidget(RootMC.GetObject("kaleidoscopeINS", class'GFxClikWidget'));
				if (ThisClikButton != none)
				{
					// Add the press and rollover
					// @TODO Add Mouse Capture Features
					ThisClikButton.AddEventListener('CLIK_buttonPress', PressSpell);
				}
				break;
			case "firefan":
				ThisClikButton = GFxClikWidget(RootMC.GetObject("firefanINS", class'GFxClikWidget'));
				if (ThisClikButton != none)
				{
					ThisClikButton.AddEventListener('CLIK_buttonPress', PC.CastFireFan);
				}
				break;
			case "fireball":
				ThisClikButton = GFxClikWidget(RootMC.GetObject("fireballINS", class'GFxClikWidget'));
				if (ThisClikButton != none)
				{
					ThisClikButton.AddEventListener('CLIK_buttonPress', PC.CastFireball);
				}
				break;
			case "firefountain":
				ThisClikButton = GFxClikWidget(RootMC.GetObject("firefountainINS", class'GFxClikWidget'));
				if (ThisClikButton != none)
				{
					ThisClikButton.AddEventListener('CLIK_buttonPress', PC.SelectFireFountain);
				}
				break;



			case "stonewall":
				ThisClikButton = GFxClikWidget(RootMC.GetObject("stonewallINS", class'GFxClikWidget'));
				if (ThisClikButton != none)
				{
					ThisClikButton.AddEventListener('CLIK_buttonPress', PressSpell);
				}
				break;	
			case "rockandroll":
				ThisClikButton = GFxClikWidget(RootMC.GetObject("rockandrollINS", class'GFxClikWidget'));
				if (ThisClikButton != none)
				{
					ThisClikButton.AddEventListener('CLIK_buttonPress', PC.CastRockAndRoll);
				}
				break;	
			case "rockfang":
				ThisClikButton = GFxClikWidget(RootMC.GetObject("rockfangINS", class'GFxClikWidget'));
				if (ThisClikButton != none)
				{
					ThisClikButton.AddEventListener('CLIK_buttonPress', PressSpell);
				}
				break;	
			case "unearthmaterial":
				ThisClikButton = GFxClikWidget(RootMC.GetObject("unearthmaterialINS", class'GFxClikWidget'));
				if (ThisClikButton != none)
				{
					ThisClikButton.AddEventListener('CLIK_buttonPress', PressSpell);
				}
				break;

			default:
				//`log("no Spell String");
		}

		switch (SpellIndex)
		{
			case 0:
				// If it's in the first index then make it into Spell NR 1
				Spell1 = ThisClikButton;
				// Get where it is at
				ASDisplayInfo = Spell1.GetDisplayInfo();
				// Set position
				ASDisplayInfo.x = 425;
				ASDisplayInfo.y = 600;
				Spell1.SetDisplayInfo(ASDisplayInfo);
				break;
			case 1:
				Spell2 = ThisClikButton;
				ASDisplayInfo = Spell2.GetDisplayInfo();
				ASDisplayInfo.x = 535;
				ASDisplayInfo.y = 600;
				Spell2.SetDisplayInfo(ASDisplayInfo);
				break;
			case 2:
				Spell3 = ThisClikButton;
				ASDisplayInfo = Spell3.GetDisplayInfo();
				ASDisplayInfo.x = 645;
				ASDisplayInfo.y = 600;
				Spell3.SetDisplayInfo(ASDisplayInfo);
				break;
			case 3:
				Spell4 = ThisClikButton;
				ASDisplayInfo = Spell4.GetDisplayInfo();
				ASDisplayInfo.x = 755;
				ASDisplayInfo.y = 600;
				Spell4.SetDisplayInfo(ASDisplayInfo);
				break;
			default:
				//`log("no SpellIndex");
		}
		// Adds +1 to ForEach Index
		SpellIndex++;
	}
}

/*
// Set up Player Stats to link them all with Scaleform
// @param		ev		Event data generated by the CLIKwidget
// @network				Client
*/
function APResetButton(GFxClikWidget.EventData ev)
{
	local MCPawn MyPawn;
	local MCPlayerController PC;

	PC = MCPlayerController(GetPC());
	MyPawn = MCPawn(GetPC().Pawn);

	// If AP is more than 0.90 && My ID is this && if we aren't moving at all
	if (MyPawn.APf > 0.90 && MyPawn.PlayerUniqueID == 1 && !PC.bCanStartMoving)
	{
		MyPawn.APf = 0;
		// Activate the Timer for next round
		PC.SetWhoseTurn(2);
		// Update Replication
		MCPlayerReplication(PC.PlayerReplicationInfo).APf = MyPawn.APf;
		// Can we use FindPathsWeCanGoTo() function, yes we can to find paths
		PC.bCanTurnBlue = true;
		PC.FindPathsWeCanGoTo();
		// Turn off Movement so we don't start walking
		PC.bCanStartMoving = false;
		// Reset MoveTo Target
		PC.ScriptedMoveTarget = none;

	}else if(MyPawn.APf > 0.90 && MyPawn.PlayerUniqueID == 2 && !PC.bCanStartMoving)
	{
		MyPawn.APf = 0;
		PC.SetWhoseTurn(1);
		MCPlayerReplication(PC.PlayerReplicationInfo).APf = MyPawn.APf;
		PC.bCanTurnBlue = true;
		PC.FindPathsWeCanGoTo();
		PC.bCanStartMoving = false;
		PC.ScriptedMoveTarget = none;
	}
}

simulated function OptionButton(GFxClikWidget.EventData ev)
{
	local MCPlayerController PC;

	if (OptionBtn != None)
	{
		PC = MCPlayerController(GetPC());

		if (PC != None)
		{
			PC.SetPause(true);
			// Show Buttons And Background
			BackgroundMC.SetVisible(true);
			ReturnToTownBtn.SetVisible(true);
			ContinueBtn.SetVisible(true);
			RestartBattleBtn.SetVisible(true);
		}
	}
}



function ContinueButton(GFxClikWidget.EventData ev)
{
	local MCPlayerController PC;

	`log("ContinueButton here");

	if (ContinueBtn != None)
	{
		PC = MCPlayerController(GetPC());

		if (PC != None)
		{
			PC.SetPause(false);
			// Show Buttons And Background
			BackgroundMC.SetVisible(false);
			ReturnToTownBtn.SetVisible(false);
			ContinueBtn.SetVisible(false);
			RestartBattleBtn.SetVisible(false);
		}
	}
}

simulated function RestartBattleButton(GFxClikWidget.EventData ev)
{
	`log("RestartBattleButton here");
	//ConsoleCommand("open TestMap01");
}

simulated function ReturnToTownButton(GFxClikWidget.EventData ev)
{

/*
	local MCGameReplication MyGMRep;
	local int i;
	local int setTheNumber;

	// Get GameReplication
	MyGMRep = MCGameReplication(class'WorldInfo'.static.GetWorldInfo().GRI);
	*/
	Close(true);
	ConsoleCommand("open TestMap01");
	`log("ReturnToTownButton here");


}


/*
// Updates the The Hud the entire time
// @network					Client
*/
function Tick(float DeltaTime)
{
	// AP Button
	SetAPButtonPosition( getWhoseTurn() );
	// Blue or Red Indicator
	setPlayerLightUpPosition( getWhoseTurn() );
	// Player 1 or 2 stats
	GetPlayerInformation();
}


/*
// Enable Mouse Clicking example
// @param		ev		Event data generated by the CLIKwidget
// @network				Client
*/
function PressSpell(GFxClikWidget.EventData ev)
{
	`log("Something Pressed!");
}


/*
// Enable mouse capturing
// @param		ev		Event data generated by the CLIKwidget
// @network				Client
*/
function EnableMouseCapture(GFxClikWidget.EventData ev)
{
	//`log("MouseOver");
}

/*
// Disable mouse capturing
// @param		ev		Event data generated by the CLIKwidget
// @network				Client
*/
function DisableMouseCapture(GFxClikWidget.EventData ev)
{
	//`log("MouseOut");
}



/*
// Sets the position of AP button based on whos turn it is
// @network					Client
*/
function int getWhoseTurn()
{
	local MCGameReplication MyGMRep;
	local int i;
	local int setTheNumber;

	// Get GameReplication
	MyGMRep = MCGameReplication(class'WorldInfo'.static.GetWorldInfo().GRI);

	if (MyGMRep.MCPRIArray.length < 0)
	{
		return SaveWhoseTurn;
	}

	for (i = 0; i < MyGMRep.MCPRIArray.Length ; i++)
	{
		// If A Player has BHaveAP true then assign him the UniqueID and return it
		if (MyGMRep.MCPRIArray[i].bHaveAp)
		{
			setTheNumber = MyGMRep.MCPRIArray[i].PlayerUniqueID;
			// Save this as a Global int and return later, fixes a bug so it doesn't turn to 0 when BHaveAP is switching
			SaveWhoseTurn = MyGMRep.MCPRIArray[i].PlayerUniqueID;;
			return setTheNumber;
		}
	}
	return SaveWhoseTurn;
}	

/*
// Function that sets the indicator color, whos turn is red or blue
// @param		WhatID		PlayerUniqueID to be passed in
// @network					Client
*/
function setPlayerLightUpPosition(int WhatID)
{
	local GFxObject Player01AreaMC;;
	local GFxObject Player02AreaMC;;

	Player01AreaMC = RootMC.GetObject("player01areaINS").GetObject("indicatorINS");
	Player02AreaMC = RootMC.GetObject("player02areaINS").GetObject("indicatorINS");

	// If Player 1 then Light up his
	if (WhatID == 1)
	{
		Player01AreaMC.SetVisible(true);
		Player02AreaMC.SetVisible(false);
	}
	// If Player 2 then Light up his
	else if (WhatID == 2)
	{
		Player02AreaMC.SetVisible(true);
		Player01AreaMC.SetVisible(false);
	}
}	

/*
// Sets the position of AP button based on whos turn it is
// @param		WhatID		PlayerUniqueID to be passed in
// @network					Client
*/
function SetAPButtonPosition(int WhatID)
{
	local GFxObject ResetAPMC;
	local ASDisplayInfo ASDisplayInfo;
	local MCPawn MyPawn;

	// Get Pawn
	MyPawn = MCPawn(GetPC().Pawn);

	ResetAPMC = RootMC.GetObject("resetapINS");
	ASDisplayInfo = ResetAPMC.GetDisplayInfo();

	if (WhatID == MyPawn.PlayerUniqueID)
	{
		// If Player 1
		if (WhatID == 1)
		{
			// Set Position
			ASDisplayInfo.x = 5;
			ASDisplayInfo.y = 180;
		}
		// If Player 2
		if (WhatID == 2)
		{
			// Set Position
			ASDisplayInfo.x = 1158;
			ASDisplayInfo.y = 180;
		}
		ResetAPMC.SetDisplayInfo(ASDisplayInfo);
		ResetAPMC.SetVisible(true);
	}else
	{
		ResetAPMC.SetVisible(false);
	}
}





/*
// Update function that will update player stats
*/
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

	// GameRound
	GameRoundTF = RootMC.GetObject("gameroundareaINS").GetObject("roundINS");
	if (GameRoundTF != none)
	{
		GameRoundTF.SetInt("text", MCGRep.GameRound);
	}

//	`log("MCGRep.MCPRIArray.length =" @ MCGRep.PRIArray.length );

	if (MCGRep.MCPRIArray.length < 0)
	{
		return;
	}

	// Players
	for (i = 0; i < MCGRep.MCPRIArray.Length ; i++)
	{
		// Player 1 Stats
		// if we have the same id then show our stuff
		// otherwise hide it for other player.
		if (P01areaMC != none && MCGRep.MCPRIArray[i].PlayerUniqueID == 1)
		{
			// Player 01 Name
			if (P01NameTF != none)
			{
				P01NameTF.SetString("text", MCGRep.MCPRIArray[i].PawnName);
			}
			// Player 01 Health Text
			if (P01HPTextTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MCPC.PlayerUniqueID)
			{
				P01HPTextTF.SetInt("text", MCGRep.MCPRIArray[i].Health);
			}else
			{
				P01HPTextTF.SetVisible(false);
			}
			// Player 01 AP Text
			if (P01APareaMC != none)
			{
				// AP Number
				if (P01APNumbTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MCPC.PlayerUniqueID)
				{
					P01APNumbTF.SetInt("text", MCGRep.MCPRIArray[i].APf);
				}else
				{
					P01APNumbTF.SetVisible(false);
				}
				// AP Text
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
		if (P02areaMC != none && MCGRep.MCPRIArray[i].PlayerUniqueID == 2)
		{
			// Player 02 Name
			if (P02NameTF != none)
			{
				P02NameTF.SetString("text", MCGRep.MCPRIArray[i].PawnName);
			}
			// Player 02 Health Text
			if (P02HPTextTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MCPC.PlayerUniqueID)
			{
				P02HPTextTF.SetInt("text", MCGRep.MCPRIArray[i].Health);
			}else
			{
				P02HPTextTF.SetVisible(false);
			}
			// Player 02 AP Text
			if (P02APareaMC != none)
			{
				// AP Number
				if (P02APNumbTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MCPC.PlayerUniqueID)
				{
					P02APNumbTF.SetInt("text", MCGRep.MCPRIArray[i].APf);
				}else
				{
					P02APNumbTF.SetVisible(false);
				}
				// AP Text
				if (P02APTextTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MCPC.PlayerUniqueID)
				{
					//P02APTextTF.SetString("text", "AP");
				}else
				{
					P02APTextTF.SetString("text", "");
				}
			}
		}
		//////////////////////////
	}
}








DefaultProperties
{
    bDisplayWithHudOff=false
    TimingMode=TM_Game
    MovieInfo=SwfMovie'MystrasChampionFlash.Battle.BattleHUD'

	bPauseGameWhileActive=false
}