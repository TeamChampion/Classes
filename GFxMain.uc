//----------------------------------------------------------------------------
// GFxMain
//
// Main File that contains most functions for all other GFx classes
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class GFxMain extends GFxMoviePlayer;

// Just check if it has started
var bool bInitialized;

var MCPawn MCP;
var GFxObject RootMC;
var() MCShop WeaponShop;

function Init(optional LocalPlayer LocalPlayer)
{
	// Initialize the ScaleForm movie
	Super.Init(LocalPlayer);
	Start();
    Advance(0.f);

 	RootMC = GetVariableObject("root");
}

function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0.f);

	RootMC = GetVariableObject("root");
	return true;
}

/**
 * Sets the Inventory for the pawn
 */
function SetUpInventory(array<MCItem> MyThings, string FlashArrayName)	// old
{
	local byte i;
	local GFxObject DataProvider;
	local GFxObject TempObj;

	DataProvider = CreateArray();
	for (i = 0; i < MyThings.Length; i++)
	{       
		// Creates and returns a new GFxObject of a specific ActionScript class.
		// We send The ID of the item so we know where to set it
		TempObj = CreateObject("Object");
		TempObj.SetInt("UCID", MyThings[i].ID);
		DataProvider.SetElementObject(i, TempObj);
	}

	RootMC.SetObject(FlashArrayName, DataProvider);     
	ShowInventory(FlashArrayName);
}

/*
// Sends the Config File int array to Flash
*/
function SetUpInventoryINTArray(array<int> MyThings, string FlashArrayName)
{
	local byte i;
	local GFxObject DataProvider;
	local GFxObject TempObj;

	DataProvider = CreateArray();
	for (i = 0; i < MyThings.Length; i++)
	{       
		// Creates and returns a new GFxObject of a specific ActionScript class.
		// We send The ID of the item so we know where to set it
		TempObj = CreateObject("Object");
		TempObj.SetInt("UCID", MyThings[i]);
		DataProvider.SetElementObject(i, TempObj);
	}

	RootMC.SetObject(FlashArrayName, DataProvider);     
	ShowInventory(FlashArrayName);
}

/**
 * Sets The Weapon Shop
 */
function SetUpWeaponShop(MCShop WShop, array<MCItem> MyThings, string FlashArrayName)
{
	local byte i;
	local GFxObject DataProvider;
	local GFxObject TempObj;
	
	// Links shop from GameInfo
//	WeaponShop = WShop;

	DataProvider = CreateArray();
	for (i = 0; i < MyThings.Length; i++)
	{       
		// Creates and returns a new GFxObject of a specific ActionScript class.
		TempObj = CreateObject("Object");
		TempObj.SetString("UCItemName", MyThings[i].sItemName);
		TempObj.SetInt("UCCost", MyThings[i].Cost);
		TempObj.SetString("UCDescription", MyThings[i].sDescription);
		TempObj.SetInt("UCID", MyThings[i].ID);
		DataProvider.SetElementObject(i, TempObj);
	}

	// sets to flash array
	RootMC.SetObject(FlashArrayName, DataProvider);     
	ShowWeaponShop(FlashArrayName);

//	`log("------------------------------WeaponShop Inventory");
	// Log debug UDK
	/*
	for (i = 0; i < WShop.AllWeapons.Length; i++)
	{
		`log("------------- itemName " @ WShop.AllWeapons[i].sItemName @ "    Prize " @ WShop.AllWeapons[i].Cost @ "    Description " @ WShop.AllWeapons[i].sDescription);
	}
	*/
}

function TestFlash()
{
//	`log("---------------------Searching");
}

function ShowInventory(string SetInvItem)
{
	ActionScriptVoid("root.Set"$SetInvItem);
//	ActionScriptVoid("root.showInventory");

//	`log("------------------------------------ Inventory Sent");
}

function ShowWeaponShop(string SetShop)
{
	// uses this flash function
	// Set Shop name
	ActionScriptVoid("root.Set"$SetShop);
//	ActionScriptVoid("root.showWeaponShop");
//	`log("------------------------------------ Weaponshop Sent");
}




function InventoryItemNotAdded()
{
//	`log("------------------------------------ InventoryItem not added");
}

DefaultProperties
{
    bDisplayWithHudOff=false
    TimingMode=TM_Game
}