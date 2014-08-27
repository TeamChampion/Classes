//----------------------------------------------------------------------------
// GFxBattleUI
//
// Main Battle HUD file, will load character information, load replication
// information, spawn spell buttons & change items, health etc
// @TODO P01area etc make a struct
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class GFxBattleUI extends GFxMoviePlayer;

var GFxObject RootMC;
var MouseInterfaceHUD MouseInterfaceHUD;
var MCPlayerController MCPC;				// not used, was used in GetPlayerinfo
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
var GFxObject Player01AreaMC;	// Indicator
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
var GFxObject Player02AreaMC;	// Indicator
// Send HP to code
// Send MAXHP to code
//	- Indicator checks if we have AP, IF AP is more then 0 then show it

var GFxObject GameRoundMC;	// Round MovieClip
var GFxObject GameRoundTF; 	// roundINS
var GFxObject BackgroundMC;	// Option Background

var GFxObject GameWinMessageMC;	// Message that shows if we won or not
var GFxObject TurnMessageMC;


// Widgets for spells
/*
var GFxCLIKWidget Earth01;
var GFxCLIKWidget Earth02;
var GFxCLIKWidget Earth03;
var GFxCLIKWidget Earth04;

var GFxCLIKWidget Fire01;
var GFxCLIKWidget Fire02;
var GFxCLIKWidget Fire03;
var GFxCLIKWidget Fire04;
*/

// Widget for AP Reset button
var GFxCLIKWidget ResetAPBtn;
// Widget for Option Buttons
var GFxCLIKWidget OptionBtn;
var GFxCLIKWidget ContinueBtn;
var GFxCLIKWidget RestartBattleBtn;
var GFxCLIKWidget ReturnToTownBtn;

// Widget for Spells
/*
var GFxObject Spell1;	// GFxCLIKWidget
var GFxObject Spell2;
var GFxObject Spell3;
var GFxObject Spell4;
*/

// Just check if it has started
var bool bInitialized;
// If I clicked a button then don't do anything
var bool bButtonClicked;

function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0.f);

	RootMC = GetVariableObject("root");

	if (!bInitialized)
		ConfigHUD();
	
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

/*
// Show Win Message
*/
function ShowWinMessage(string PlayerName)
{
	if (GameWinMessageMC != none)
	{
		GameWinMessageMC.SetString("text", PlayerName @ "Wins!");
	}
}

/*
// Show Lose Message
*/
function ShowLoseMessage(string PlayerName)
{
	if (GameWinMessageMC != none)
	{
		GameWinMessageMC.SetString("text", PlayerName @ "Lost!");
	}
}

/*
// Show Options after certain Timer from PC.ShowOptionTimer()
*/
simulated function ShowOptionsAfterWinOrLose()
{
	OptionButtonFunction();
}

function ShowPlayerTurnMessage(string Message)
{
	if (TurnMessageMC != none)
	{
		TurnMessageMC.SetString("text", Message);
	}
}

function HidePlayerTurnMessage()
{
	if (TurnMessageMC != none)
	{
		TurnMessageMC.SetString("text", "");
	}
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
	// Indicator
	Player01AreaMC = RootMC.GetObject("player01areaINS").GetObject("indicatorINS");
	Player02AreaMC = RootMC.GetObject("player02areaINS").GetObject("indicatorINS");
	Player01AreaMC.SetVisible(false);
	Player02AreaMC.SetVisible(false);

	ConfigPlayerStats();
	ConfigAPButton();
	ConfigSpells();
	ConfigOptionButton();
	ConfigMessages();

	bInitialized = true;
}

/*
// Set up Player Stats to link them all with Scaleform
// @network					Client
*/
function ConfigPlayerStats()
{

	// Player 1 Stats
	// Player 1 Area MovieClip
	P01areaMC = RootMC.GetObject("player01areaINS");
	if (P01areaMC != none)
	{
		// Name @NAME
		P01NameTF = P01areaMC.GetObject("playernameINS");
	//	P01NameTF.SetVisible(false);
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
		//Healthbar
		//P01HPBarMC = P01areaMC.GetObject("healthbararea");
		


	}

	// Player 2 Stats
	// Player 2 Area MovieClip
	P02areaMC = RootMC.GetObject("player02areaINS");
	if (P02areaMC != none)
	{
		// Name @NAME
		P02NameTF = P02areaMC.GetObject("playernameINS");
	//	P02NameTF.SetVisible(false);
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
}

/*
// Config the AP Reset Button
// @network					Client
*/
function ConfigAPButton()
{
	
	// Get the Widget
	ResetAPBtn = GFxClikWidget(RootMC.GetObject("resetapINS",class'GFxClikWidget'));
	if (ResetAPBtn != none)
	{
		// Add button press, mouse over, mouse out
		ResetAPBtn.AddEventListener('CLIK_buttonPress', APResetButton);
		ResetAPBtn.AddEventListener('CLIK_rollOver', EnableMouseCapture);
		ResetAPBtn.AddEventListener('CLIK_rollOut', DisableMouseCapture);
	}
}


/*
// Config the AP Reset Button
// @network					Client
*/
function ConfigOptionButton()
{
	
	// Get the Widget
	// Main Option button
	OptionBtn = GFxClikWidget(RootMC.GetObject("optionINS",class'GFxClikWidget'));
	if (OptionBtn != none)
	{
		// Add button press, mouse over, mouse out
		OptionBtn.AddEventListener('CLIK_buttonPress', OptionButton);
		OptionBtn.AddEventListener('CLIK_rollOver', EnableMouseCapture);
		OptionBtn.AddEventListener('CLIK_rollOut', DisableMouseCapture);
	}
	// Continue Button
	ContinueBtn = GFxClikWidget(RootMC.GetObject("continueINS",class'GFxClikWidget'));
	if (ContinueBtn != none)
	{
		ContinueBtn.AddEventListener('CLIK_buttonPress', ContinueButton);
		ContinueBtn.AddEventListener('CLIK_rollOver', EnableMouseCapture);
		ContinueBtn.AddEventListener('CLIK_rollOut', DisableMouseCapture);
		ContinueBtn.SetVisible(false);
	}
/*
	// Restart Battle Button
	RestartBattleBtn = GFxClikWidget(RootMC.GetObject("restartbattleINS",class'GFxClikWidget'));
	if (RestartBattleBtn != none)
	{
		RestartBattleBtn.AddEventListener('CLIK_buttonPress', RestartBattleButton);
		RestartBattleBtn.AddEventListener('CLIK_rollOver', EnableMouseCapture);
		RestartBattleBtn.AddEventListener('CLIK_rollOut', DisableMouseCapture);
		RestartBattleBtn.SetVisible(false);
	}
*/	
	// Return To Town Button
	ReturnToTownBtn = GFxClikWidget(RootMC.GetObject("returntotownINS",class'GFxClikWidget'));
	if (ReturnToTownBtn != none)
	{
		ReturnToTownBtn.AddEventListener('CLIK_buttonPress', ReturnToTownButton);
		ReturnToTownBtn.AddEventListener('CLIK_rollOver', EnableMouseCapture);
		ReturnToTownBtn.AddEventListener('CLIK_rollOut', DisableMouseCapture);
		ReturnToTownBtn.SetVisible(false);
	}
}

/*
// Configs Winning Text Message so that we can send it a message when we win or lose when the game is over.
*/
function ConfigMessages()
{
	GameWinMessageMC = RootMC.GetObject("winmessageIns");
	TurnMessageMC = RootMC.GetObject("TurnMessageINS");
}

function SendToUC(string iconimagename)
{
	/*
	`log("-------------------------------------------");
	`log("-------------------------------------------");
	`log("-------------------------------------------");
	`log("iconimagename =" @ iconimagename);
	`log("-------------------------------------------");
	`log("-------------------------------------------");
	`log("-------------------------------------------");
	*/
}

/*
// Config the Spell buttons to work with the game
// @network					Client
*/
function ConfigSpells()
{
//	local MCPawn MyPawn;
	local ASDisplayInfo ASDisplayInfo;
	local MCSpell SpellName;
	local int SpellIndex;
	local GFxClikWidget ThisClikButton;
	local GFxObject AbilityMC;
	local GFxObject InformationMC;
	local GFxSetIconObject IconMC;
	local array <int> CheckSpellAddedNr;
	local int i;
	local bool bSameSpell;
	local MCPlayerController MyPC;
	local int HowManySameSpell;

//	MyPawn = MCPawn(GetPC().Pawn);
	MyPC = MCPlayerController(GetPC());
	SpellIndex = 0;

	// Check all the Spells the Pawn has
	foreach MyPC.MyArchetypeSpells(SpellName)
	{
		// Add to spellArray to check if we should spawn this spell or not
		CheckSpellAddedNr.AddItem(SpellName.spellNumber);
		// Set Test bool at start false;
		bSameSpell = false;

		// Search if We already have a spell like that
		for (i = SpellIndex;i < CheckSpellAddedNr.length ; i++)
		{
			// if we have more than 1 spell do this check
			if (CheckSpellAddedNr.length > 1)
			{
				// Check if previous spell has the same ID as this one
				if(SpellName.spellNumber == CheckSpellAddedNr[i-1])
				{
					bSameSpell = true;
					// Add so that if it's the same spell, we remove that SpellIndex when placing buttons
					HowManySameSpell++;
				}
			}
		}

		i = 0;

		// Get the Object Button 
		AbilityMC = RootMC.GetObject("HeroSpellAreaIns").AttachMovie("SpellField", "herospell"$SpellIndex);
		ThisClikButton = GFxClikWidget(AbilityMC.GetObject("SpellButtonIns", class'GFxClikWidget'));
		if (ThisClikButton != none)		
		{
			// Adds click buttons, mouse over & mouse out
			if (SpellName.bIsEnabled)
			{
				ThisClikButton.AddEventListener('CLIK_buttonPress', PressSpellButton);
				ThisClikButton.AddEventListener('CLIK_rollOver', EnableMouseCaptureSpell);
				ThisClikButton.AddEventListener('CLIK_rollOut', DisableMouseCaptureSpell);
			}else
			{
				// If we can't use button set it disabled.
				ThisClikButton.AddEventListener('CLIK_rollOver', EnableMouseCaptureSpell);
				ThisClikButton.AddEventListener('CLIK_rollOut', DisableMouseCaptureSpell);
				ThisClikButton.SetBool("enabled", false);	// Turns it off but removes all other things
			//	ThisClikButton.GotoAndStop("disabled");
			}

			// Add a number for the button, so we can find out what button we are clicking in PC or for Information Field in mouse over/out
			ThisClikButton.SetInt("SpellIndex", SpellIndex);

			// Hide Button if same spell
			if (bSameSpell)
			{
				ThisClikButton.SetVisible(false);
			}

			// Set the icon image
			if(AbilityMC != none)
			{
				IconMC = GFxSetIconObject(AbilityMC.GetObject("IconImageIns",  class'GFxSetIconObject'));
				// Set Icon in AS to something new
				IconMC.ChangeIconImage(SpellName.spellTextureName);

				// Hide Icon if same spell
				if (bSameSpell)
				{
					IconMC.SetVisible(false);
				}
			}
		}

		// Add a Spell Information Field
		InformationMC = RootMC.AttachMovie("InformationField", "information"$SpellIndex);
		if(InformationMC != none)
		{
			// Set information for Information Field, Spell Name, AP Cost & Description
			InformationMC.SetVisible(false);
			InformationMC.GetObject("SpellNameIns").SetString("text", SpellName.spellName[SpellName.spellNumber]);
			InformationMC.GetObject("APNameIns").SetInt("text", SpellName.AP);
			InformationMC.GetObject("DescNameIns").SetString("text", SpellName.Description[SpellName.spellNumber]);
		}

		// Set button placement
		ASDisplayInfo = AbilityMC.GetDisplayInfo();
		ASDisplayInfo.x = 0 + ((100 + 10) * (SpellIndex - HowManySameSpell) );	// Sets
		ASDisplayInfo.y = 0;
		AbilityMC.SetDisplayInfo(ASDisplayInfo);

		// Set Spell Information Field, Get HeroSpellAreaIns + The Location in there +/- a value
		ASDisplayInfo = InformationMC.GetDisplayInfo();
		ASDisplayInfo.x = RootMC.GetObject("HeroSpellAreaIns").GetDisplayInfo().X + AbilityMC.GetDisplayInfo().X + 40;
		ASDisplayInfo.y = RootMC.GetObject("HeroSpellAreaIns").GetDisplayInfo().Y + AbilityMC.GetDisplayInfo().Y - 140;
		InformationMC.SetDisplayInfo(ASDisplayInfo);

		// Adds +1 to ForEach Index
		SpellIndex++;
		

	}
}

function PressSpellButton(GFxClikWidget.EventData ev)
{
	local GFxObject Button;
	
	Button = ev._this.GetObject("target");
	ConsoleCommand("MySpell"@Button.GetInt("SpellIndex"));
}


/*
// Enable mouse capturing from GFxBattleUI.uc for Spell buttons
// @param		ev		Event data generated by the CLIKwidget
*/
function EnableMouseCaptureSpell(GFxClikWidget.EventData ev)
{
	local MCPlayerController PC;
	local GFxObject PopUp;

	// Set button hovering true so we don't walk when we click
	PC = MCPlayerController(GetPC());
	PC.bButtonHovering = true;

	// Set Field visible by getting "information0", 1, 2 or 3
	PopUp = RootMC.GetObject("information"$ev._this.GetObject("target").GetInt("SpellIndex"));
	if(PopUp != none)
		PopUp.SetVisible(true);

	bButtonClicked = true;
}

/*
// Disable mouse capturing from GFxBattleUI.uc for Spell buttons
// @param		ev		Event data generated by the CLIKwidget
*/
function DisableMouseCaptureSpell(GFxClikWidget.EventData ev)
{
	local MCPlayerController PC;
	local GFxObject PopUp;

	// Set button hovering false so we can walk again when clicked
	PC = MCPlayerController(GetPC());
	PC.bButtonHovering = false;

	// Set Field hidden by getting "information0", 1, 2 or 3
	PopUp = RootMC.GetObject("information"$ev._this.GetObject("target").GetInt("SpellIndex"));
	if(PopUp != none)
		PopUp.SetVisible(false);

	bButtonClicked = false;
}

/*
// Enable mouse capturing from GFxBattleUI.uc for Other Buttons
// @param		ev		Event data generated by the CLIKwidget
*/
function EnableMouseCapture(GFxClikWidget.EventData ev)
{
	local MCPlayerController PC;

	// Set button hovering true so we don't walk when we click
	PC = MCPlayerController(GetPC());
	PC.bButtonHovering = true;

	bButtonClicked = true;
}

/*
// Disable mouse capturing from GFxBattleUI.uc for Other Buttons
// @param		ev		Event data generated by the CLIKwidget
*/
function DisableMouseCapture(GFxClikWidget.EventData ev)
{
	local MCPlayerController PC;

	// Set button hovering false so we can walk again when clicked
	PC = MCPlayerController(GetPC());
	PC.bButtonHovering = false;

	bButtonClicked = false;
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
		// Update Replication
		MCPlayerReplication(PC.PlayerReplicationInfo).APf = MyPawn.APf;
		// If we had a Spell here, turn it off, just for safety
		if (PC.InstantiateSpell != none)
		{
			PC.InstantiateSpell.Destroy();
			PC.InstantiateSpell = none;
			PC.SpellTileTurnOff();
			PC.FireTiles.Remove(0, PC.FireTiles.length);
			PC.ClickSpell = none;
		}
		// Activate the Timer for next round
		PC.SetWhoseTurn(2);
		// Can we use FindPathsWeCanGoTo() function, yes we can to find paths
		PC.bIsTileActive = true;
		PC.FindPathsWeCanGoTo(MyPawn.APf);
		// Turn off Movement so we don't start walking
		PC.bCanStartMoving = false;
		// Reset MoveTo Target
		PC.ScriptedMoveTarget = none;
		// Turn Of Spell
		PC.bIsSpellActive = false;
	//	PC.CheckCurrentAPCalculation();

	}else if(MyPawn.APf > 0.90 && MyPawn.PlayerUniqueID == 2 && !PC.bCanStartMoving)
	{
		MyPawn.APf = 0;
		MCPlayerReplication(PC.PlayerReplicationInfo).APf = MyPawn.APf;

		if (PC.InstantiateSpell != none)
		{
			PC.InstantiateSpell.Destroy();
			PC.InstantiateSpell = none;
			PC.SpellTileTurnOff();
			PC.FireTiles.Remove(0, PC.FireTiles.length);
			PC.ClickSpell = none;	
		}

		PC.SetWhoseTurn(1);
		PC.bIsTileActive = true;
		PC.FindPathsWeCanGoTo(MyPawn.APf);
		PC.bCanStartMoving = false;
		PC.ScriptedMoveTarget = none;
		PC.bIsSpellActive = false;
		
		
	//	PC.CheckCurrentAPCalculation();
	}
}

function OptionButton(GFxClikWidget.EventData ev)
{
	OptionButtonFunction();
}

function OptionButtonFunction()
{
	local MCPlayerController PC;
	if (OptionBtn != None)
	{
		PC = MCPlayerController(GetPC());

		if (PC != None)
		{
			// Sets hovering over button so we can't use Spells any more
			PC.bButtonHovering = true;
			// Pauses the game
			PC.SetPause(true);
			// Show Buttons And Background
			BackgroundMC.SetVisible(true);
			ReturnToTownBtn.SetVisible(true);
			ContinueBtn.SetVisible(true);
		//	RestartBattleBtn.SetVisible(true);
		}
	}
}

/*
// Return Back in to the game
*/
function ContinueButton(GFxClikWidget.EventData ev)
{
	local MCPlayerController PC;

	if (ContinueBtn != None)
	{
		PC = MCPlayerController(GetPC());

		if (PC != None)
		{
			// Sets hovering over button so we can't use Spells any more
			PC.bButtonHovering = false;
			// Unpause the game
			PC.SetPause(false);
			// Show Buttons And Background
			BackgroundMC.SetVisible(false);
			ReturnToTownBtn.SetVisible(false);
			ContinueBtn.SetVisible(false);
		//	RestartBattleBtn.SetVisible(false);
		}
	}
}

/*
simulated function RestartBattleButton(GFxClikWidget.EventData ev)
{
	`log("RestartBattleButton here");
	//ConsoleCommand("open TestMap01");
}
*/

/*
// Function that will return to Town from a game
*/
simulated function ReturnToTownButton(GFxClikWidget.EventData ev)
{
	local MCPlayerController cMCPC;

	cMCPC = MCPlayerController(GetPC());
	
	// Turn off Hud
	Close(true);
	// Go in to PC and reset Mu;tiplayer game
	cMCPC.QuitToMainMenu();

//	ConsoleCommand("open town01");
}


/*
// Updates in the The Hud the entire time
// @network					Client
*/
function Tick(float DeltaTime)
{
//	ConfigPlayerStats();
	// AP Button
	SetAPButtonPosition( getWhoseTurn() );
	// Blue or Red Indicator
	setPlayerLightUpPosition( getWhoseTurn() );
	// Player 1 or 2 stats
	GetPlayerInformation();
	// Update The healthbar all the time
	ActionScriptVoid("root.Update");
}


/*
// Enable Mouse Clicking example
// @param		ev		Event data generated by the CLIKwidget
// @network				Client
*/
function PressSpell(GFxClikWidget.EventData ev)
{
//	`log("Something Pressed!");
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
		// If A Player has BHaveAP true then assign him the UniqueID and return it, @ADDED changed to check if a player has AP instead
	//	if (MyGMRep.MCPRIArray[i].bHaveAp)
		if (MyGMRep.MCPRIArray[i].APf > 0)
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

	if (MyPawn != none)
	{
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
}





/*
// Update function that will update player stats
*/
function GetPlayerInformation()
{
	local MCGameReplication MCGRep;
	local MCPlayerController MyPC;
	local MCPawn MyPawn;
	local int i;


	// Get PlayerControoler
	MyPC = MCPlayerController(GetPC());
	// Get Pawn
	MyPawn = MCPawn(GetPC().Pawn);
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
		if (P01areaMC != none && MCGRep.MCPRIArray[i].PlayerUniqueID == 1)	// Both Players can Enter here
		{
			// Player 01 Name
			if (P01NameTF != none)
			{
				P01NameTF.SetString("text", MCGRep.MCPRIArray[i].PawnName);
			}
			// Player 01 Health Text
			if (P01HPTextTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MyPC.PlayerUniqueID)
			{
				P01HPTextTF.SetInt("text", MCGRep.MCPRIArray[i].Health);
			}else if(P01HPTextTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID != MyPC.PlayerUniqueID)
			{
				P01HPTextTF.SetVisible(false);
			}
			// Player 01 AP Text
			if (P01APareaMC != none)
			{
				// AP Number
				if (MyPawn != none)
				{
//					if (P01APNumbTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MyPC.PlayerUniqueID)
					if (P01APNumbTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MyPawn.PlayerUniqueID)
					{
						P01APNumbTF.SetString("text", string(int(MCGRep.MCPRIArray[i].APf)));
					}
					else if(P01APNumbTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID != MyPC.PlayerUniqueID)
					{
						P01APNumbTF.SetVisible(false);
					}
				}
				// AP Text
				if (P01APTextTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MyPC.PlayerUniqueID)
				{
					P01APTextTF.SetString("text", "AP");
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
			if (P02HPTextTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MyPC.PlayerUniqueID)
			{
			//	`log("My ID= " @ MyPC.PlayerUniqueID);
				P02HPTextTF.SetInt("text", MCGRep.MCPRIArray[i].Health);
			}else if(P02HPTextTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID != MyPC.PlayerUniqueID)
			{
				P02HPTextTF.SetVisible(false);
			}
			// Player 02 AP Text
			if (P02APareaMC != none)
			{
				if (MyPawn != none)
				{
					// AP Number
//					if (P02APNumbTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MyPC.PlayerUniqueID)
					if (P02APNumbTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MyPawn.PlayerUniqueID)
					{
						P02APNumbTF.SetString("text", string(int(MCGRep.MCPRIArray[i].APf)));
					}else if(P02APNumbTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID != MyPC.PlayerUniqueID)
					{
						P02APNumbTF.SetVisible(false);
					}
				}
				// AP Text
				if (P02APTextTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MyPC.PlayerUniqueID)
				{
					P02APTextTF.SetString("text", "AP");
				}else
				{
					P02APTextTF.SetString("text", "");
				}
			}
		}
		//////////////////////////
		// Healthbar
		if (MCGRep.MCPRIArray[i].PlayerUniqueID == 1)
		{
			RootMC.SetInt("P01currentHP", MCGRep.MCPRIArray[i].Health);
		}

		if (MCGRep.MCPRIArray[i].PlayerUniqueID == 2)
		{
			RootMC.SetInt("P02currentHP", MCGRep.MCPRIArray[i].Health);
		}
	}

}


/*
function findThisInPC()
{
	`log("I found you from HUD and PC");
}

// Sent function from ActionScript
function getActionscript(int find)
{
	//`log(find);
}
*/






DefaultProperties
{
    bDisplayWithHudOff=false
    TimingMode=TM_Game
    MovieInfo=SwfMovie'MystrasChampionFlash.Battle.BattleHUD'

	bPauseGameWhileActive=false
}