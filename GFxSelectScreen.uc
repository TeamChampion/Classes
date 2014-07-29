//----------------------------------------------------------------------------
// GFxSelectScreen
//
// Open Select Character Screen
// @TODO add buttons to go back, create, delete etc
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class GFxSelectScreen extends GFxMain
	config(MystrasConfig);

// Select Player Area
var GFxObject P01SelectAreaMC, P02SelectAreaMC, P03SelectAreaMC, P04SelectAreaMC;

//Set PlayerName inside Player Area - PlayerName_Ins
var GFxObject P01SelectNameTF, P02SelectNameTF, P03SelectNameTF, P04SelectNameTF;

// Button Clicks for Selecting
var GFxCLIKWidget P01Button, P02Button, P03Button, P04Button;
// Switch for Characters
var int setSwitch;
// Save Character for Spawning
var config int setCharacterSelect;

// Characters
var archetype Player01 P01;
var archetype Player02 P02;
var archetype Player03 P03;
var archetype Player04 P04;

// shop buttons
//var GFxObject InShopMC, InShopReturnMC, InShopGoMC, InShopReturnMainMC;

function bool Start(optional bool StartPaused = false)
{
	super.Start();
	Advance(0.f);

	RootMC = GetVariableObject("root");

	if (!bInitialized)
	{
		ConfigHUD();
	}

	return true;
}

/*
// We start off by setting the initial settings
// @network                 Client
*/
function ConfigHUD()
{
	ConfigSelectMenu();
	bInitialized = true;
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
	// Updates Box
	SetShowPlayerSelectBox();
	// Update Name
	UpdateName();
}

function UpdateName()
{
	local MCPlayerController cMCP;

	cMCP = MCPlayerController(GetPC());

	if (P01SelectNameTF != none){	P01SelectNameTF.SetString("text", cMCP.PlayerStruct01.PawnName);	}
	if (P02SelectNameTF != none){	P02SelectNameTF.SetString("text", cMCP.PlayerStruct02.PawnName);	}
	if (P03SelectNameTF != none){	P03SelectNameTF.SetString("text", cMCP.PlayerStruct03.PawnName);	}
	if (P04SelectNameTF != none){	P04SelectNameTF.SetString("text", cMCP.PlayerStruct04.PawnName);	}

}

/*
// Get Name Object from flash file
*/
function ConfigSelectMenu()
{
	// Configs Player Text
	P01SelectAreaMC = RootMC.GetObject("Player01");
	if (P01SelectAreaMC != none){	P01SelectNameTF = P01SelectAreaMC.GetObject("PlayerName_Ins");	}

	P02SelectAreaMC = RootMC.GetObject("Player02");
	if (P02SelectAreaMC != none){	P02SelectNameTF = P02SelectAreaMC.GetObject("PlayerName_Ins");	}

	P03SelectAreaMC = RootMC.GetObject("Player03");
	if (P03SelectAreaMC != none){	P03SelectNameTF = P03SelectAreaMC.GetObject("PlayerName_Ins");}

	P04SelectAreaMC = RootMC.GetObject("Player04");
	if (P04SelectAreaMC != none){	P04SelectNameTF = P04SelectAreaMC.GetObject("PlayerName_Ins");}
}

/*
// Create a new character and set that archetype to Hud class, Call from Flash file
*/
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

/*
// Deleting a char if bool is true, Call from Flash file
*/
function deleteChar(int CreateDelete)
{
	`log("Deleting" @ CreateDelete);

	if (CreateDelete == 1){		WhatCharToDelete(P01, 1);	}
	if (CreateDelete == 2){		WhatCharToDelete(P02, 2);	}
	if (CreateDelete == 3){		WhatCharToDelete(P03, 3);	}
	if (CreateDelete == 4){		WhatCharToDelete(P04, 4);	}
}

// Delete the chars name and show if loaded stats then save
function WhatCharToDelete(MCPawn WhatPawn, int PawnNumber)
{
	local MCPlayerController cMCP;

	cMCP = MCPlayerController(GetPC());

	// Remove name and active
	WhatPawn.PawnName2 = "";
	WhatPawn.bSetLevelLoadChar = false;
	WhatPawn.SaveConfig();

	// Remove Pawn stats in PlayerController
	if (PawnNumber == 1){		cMCP.PlayerStruct01 = cMCP.RemovePlayerStats;	cMCP.SaveConfig();	}
	if (PawnNumber == 2){		cMCP.PlayerStruct02 = cMCP.RemovePlayerStats;	cMCP.SaveConfig();	}
	if (PawnNumber == 3){		cMCP.PlayerStruct03 = cMCP.RemovePlayerStats;	cMCP.SaveConfig();	}
	if (PawnNumber == 4){		cMCP.PlayerStruct04 = cMCP.RemovePlayerStats;	cMCP.SaveConfig();	}

	// remove inventory
	WhatPawn.MyInventory.MyOwnedWeapons.Remove(0,WhatPawn.MyInventory.MyOwnedWeapons.length);
	WhatPawn.MyInventory.MyOwnedAccessories.Remove(0,WhatPawn.MyInventory.MyOwnedWeapons.length);
	WhatPawn.MyInventory.MyOwnedEnchantments.Remove(0,WhatPawn.MyInventory.MyOwnedEnchantments.length);
	WhatPawn.MyInventory.MyOwnedResearchMaterial.Remove(0,WhatPawn.MyInventory.MyOwnedResearchMaterial.length);
	WhatPawn.MyInventory.SaveConfig();
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
	if (P01SelectNameTF != none){	P01SelectNameTF.SetString("text", P01.PawnName2);	}
	if (P02SelectNameTF != none){	P02SelectNameTF.SetString("text", P02.PawnName2);	}
	if (P03SelectNameTF != none){	P03SelectNameTF.SetString("text", P03.PawnName2);	}
	if (P04SelectNameTF != none){	P04SelectNameTF.SetString("text", P04.PawnName2);	}
}

/*
// Sets Character Names
*/
function SetShowPlayerSelectBox()
{
	// If we have a Select Box && if the character is made
	if(P01.bSetLevelLoadChar)
		P01SelectAreaMC.SetVisible(true);
	else
		P01SelectAreaMC.SetVisible(false);
	// Plyaer 2
	if(P02.bSetLevelLoadChar)
		P02SelectAreaMC.SetVisible(true);
	else
		P02SelectAreaMC.SetVisible(false);
	// Plyaer 3
	if(P03.bSetLevelLoadChar)
		P03SelectAreaMC.SetVisible(true);
	else
		P03SelectAreaMC.SetVisible(false);
	// Plyaer 4
	if(P04.bSetLevelLoadChar)
		P04SelectAreaMC.SetVisible(true);
	else
		P04SelectAreaMC.SetVisible(false);
}

// Callback automatically called for each object in the movie with enableInitCallback enabled
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	// Determine which widget is being initialized and handle it accordingly
	switch(Widgetname)
	{
		case 'Player01':
			P01Button = GFxCLIKWidget(Widget);
			// Set switch for next GoToFrame function
			P01Button.AddEventListener('CLIK_click', ReturnPlayer01);
			break;
		case 'Player02':
			P02Button = GFxCLIKWidget(Widget);
			P02Button.AddEventListener('CLIK_click', ReturnPlayer02);
			break;
		case 'Player03':
			P03Button = GFxCLIKWidget(Widget);
			P03Button.AddEventListener('CLIK_click', ReturnPlayer03);
			break;
		case 'Player04':
			P04Button = GFxCLIKWidget(Widget);
			P04Button.AddEventListener('CLIK_click', ReturnPlayer04);
			break;
		default:
			break;
	}
	return true;
}


/*
// Sets What Character we pressed on
*/
function ReturnPlayer01(EventData data){	MCPlayerController(GetPC()).setCharacterSelect = 1;	OpenSelectedMap();	}
function ReturnPlayer02(EventData data){	MCPlayerController(GetPC()).setCharacterSelect = 2;	OpenSelectedMap();	}
function ReturnPlayer03(EventData data){	MCPlayerController(GetPC()).setCharacterSelect = 3;	OpenSelectedMap();	}
function ReturnPlayer04(EventData data){	MCPlayerController(GetPC()).setCharacterSelect = 4;	OpenSelectedMap();	}

/*
// Takes the Last step and opens a specific map
*/
function OpenSelectedMap()
{
	// Save stored character
	MCPlayerController(GetPC()).SaveConfig();
	// Open specific map
	ConsoleCommand("open chapter01_gate");
}

DefaultProperties
{
	P01 = Player01'mystraschampionsettings.Character.P01';
	P02 = Player02'mystraschampionsettings.Character.P02';
	P03 = Player03'mystraschampionsettings.Character.P03';
	P04 = Player04'mystraschampionsettings.Character.P04';

	// ScaleForm widgets being used for WidgetInitialized
	WidgetBindings.Add((WidgetName="Player01",    WidgetClass=class'GFxCLIKWidget'))
	WidgetBindings.Add((WidgetName="Player02",    WidgetClass=class'GFxCLIKWidget'))
	WidgetBindings.Add((WidgetName="Player03",    WidgetClass=class'GFxCLIKWidget'))
	WidgetBindings.Add((WidgetName="Player04",    WidgetClass=class'GFxCLIKWidget'))

	// Sets s that you can type names correctly
//	bCaptureInput=true
	bDisplayWithHudOff=false
	TimingMode=TM_Game
	MovieInfo=SwfMovie'MystrasChampionFlash.menus.SelectionScreen'
}