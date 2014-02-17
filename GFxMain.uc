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

function thingsThatWork()
{
	// Will set the AS var to UC var
	RootMC.SetString("sNameAS",  MCP.OwnedWeapons[0].itemName); 
	RootMC.SetInt("sCostAS",  MCP.OwnedWeapons[0].Prize); 
	RootMC.SetString("sDescAS",  MCP.OwnedWeapons[0].Description); 
}

/**
 * Sets the Inventory for the pawn
 */
function SetUpInventory(MCPawn MyMystrasPawn)
{
	local byte i;
	local GFxObject DataProvider;
	local GFxObject TempObj;
	local array<MCWeapon> OwnedWeapons;

	MCP = MyMystrasPawn;
	// Characters Weapons
	OwnedWeapons = MCP.OwnedWeapons;


	DataProvider = CreateArray();
	for (i = 0; i < OwnedWeapons.Length; i++)
	{       
		// Creates and returns a new GFxObject of a specific ActionScript class.
		TempObj = CreateObject("Object");
		TempObj.SetString("ItemName", OwnedWeapons[i].itemName);
		TempObj.SetInt("Prize", OwnedWeapons[i].Prize);
		TempObj.SetString("Description", OwnedWeapons[i].Description);
		DataProvider.SetElementObject(i, TempObj);
	}

	RootMC.SetObject("inventoryUC", DataProvider);     
	ShowInventory();

	// Log debug UDK
	for (i = 0; i < OwnedWeapons.Length; i++)
	{
		`log("------------- itemName " @ OwnedWeapons[i].itemName @ "    Prize " @ OwnedWeapons[i].Prize @ "    Description " @ OwnedWeapons[i].Description);
	}
}

/**
 * Sets The Weapon Shop
 */
function SetUpWeaponShop(MCShop WShop)
{
	local byte i;
	local GFxObject DataProvider;
	local GFxObject TempObj;
	
	// Links shop from GameInfo
	WeaponShop = WShop;

	DataProvider = CreateArray();
	for (i = 0; i < WeaponShop.AllWeapons.Length; i++)
	{       
		// Creates and returns a new GFxObject of a specific ActionScript class.
		TempObj = CreateObject("Object");
		TempObj.SetString("ItemName", WeaponShop.AllWeapons[i].itemName);
		TempObj.SetInt("Prize", WeaponShop.AllWeapons[i].Prize);
		TempObj.SetString("Description", WeaponShop.AllWeapons[i].Description);
		DataProvider.SetElementObject(i, TempObj);
	}

	// sets to flash array
	RootMC.SetObject("weaponShopUC", DataProvider);     
	ShowWeaponShop();

	`log("------------------------------WeaponShop Inventory");
	// Log debug UDK
	for (i = 0; i < WeaponShop.AllWeapons.Length; i++)
	{
		`log("------------- itemName " @ WeaponShop.AllWeapons[i].itemName @ "    Prize " @ WeaponShop.AllWeapons[i].Prize @ "    Description " @ WeaponShop.AllWeapons[i].Description);
	}

}

function TestFlash()
{
    `log("---------------------I Can read you");
    `log("---------------------I Can read you");
    `log("---------------------I Can read you");
}

function ShowInventory()
{
	ActionScriptVoid("showInventory");
	`log("------------------------------------ Inventory Sent");
}

function ShowWeaponShop()
{
	// uses this flash function
	ActionScriptVoid("sd.showWeaponShop");
	`log("------------------------------------ Weaponshop Sent");
}


function InventoryItemNotAdded()
{

	`log("------------------------------------ InventoryItem not added");

}

DefaultProperties
{
    bDisplayWithHudOff=false
    TimingMode=TM_Game
}