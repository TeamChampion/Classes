//----------------------------------------------------------------------------
// GFxWTPlayerItems
//
// Wizards Tower - Setup Player Weapons and Accessories
//
// Gustav Knutsson 2014-09-10
//----------------------------------------------------------------------------
class GFxWTPlayerItems extends GFxMain;

// Button Clicks for Selecting
var GFxCLIKWidget wReturnButton;
// Weapon Shop
var archetype MCShop MCShopArche;

// Storing Number + Index place of our Accessories
struct AccesoryPlacement
{
	var array<string> ItemName;
	var array<string> ItemDesc;
	var array<int> Active;
	var array<int> IndexNumber;
};

// Ring
var array<MCItem_Accessories> MyRings;
var AccesoryPlacement		MyRingsEquipt;
// Earring
var array<MCItem_Accessories> MyEarings;
var AccesoryPlacement		MyEaringsEquipt;
// Necklace
var array<MCItem_Accessories> MyNecklaces;
var AccesoryPlacement		MyNecklacesEquipt;

function bool Start(optional bool StartPaused = false)
{
	super.Start();
	Advance(0.f);

	RootMC = GetVariableObject("root");

	MCP = MCPawn(GetPC().Pawn);
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
	SetupItems();
	// Send Shops, we use this to find what item we have in order to add information to it
//	SetShops();
	// Send Inventory
//	SetInventory();
	bInitialized = true;
}

function SetupItems()
{
	// Remove At start to not multiply every time
	MCP.MyInventory.OwnedWeapons.Remove(0,MCP.MyInventory.OwnedWeapons.Length);
	MCP.MyInventory.OwnedAccessories.Remove(0,MCP.MyInventory.OwnedAccessories.Length);
	// Add Current saved items
	MCP.MyInventory.OwnedWeapons = AddItemWeapon(MCShopArche.AllWeapons, MCP.MyInventory.OwnedWeapons, MCP.MyInventory.ConfigWeapons.ItemNumber);					// Good
	MCP.MyInventory.OwnedAccessories = AddItemAccessory(MCShopArche.AllAccessories, MCP.MyInventory.OwnedAccessories, MCP.MyInventory.ConfigAccessories.ItemNumber);	// Good
	// Seperate
	SeperateAccesories(MCP.MyInventory.OwnedAccessories, MCP.MyInventory.ConfigAccessories.Active);
	// Add Inventory First here

/*
	`log("======================================================");
	`log("My Inventory Rings");
	`log("======================================================");
	for (i = 0;i < MyRings.Length ; i++)
	{
		`log(i @ "- Shop Here=" @ MyRings[i].sItemName @ " - " @ MyRings[i].ID @ "-" @ "Accessory=" @ MyRings[i].Accessory);
	}
	`log("======================================================");

	`log("======================================================");
	`log("My Inventory Earings");
	`log("======================================================");
	for (i = 0;i < MyEarings.Length ; i++)
	{
		`log(i @ "- Shop Here=" @ MyEarings[i].sItemName @ " - " @ MyEarings[i].ID @ "-" @ "Accessory=" @ MyEarings[i].Accessory);
	}
	`log("======================================================");

	`log("======================================================");
	`log("My Inventory Necklace");
	`log("======================================================");
	for (i = 0;i < MyNecklaces.Length ; i++)
	{
		`log(i @ "- Shop Here=" @ MyNecklaces[i].sItemName @ " - " @ MyNecklaces[i].ID @ "-" @ "Accessory=" @ MyNecklaces[i].Accessory);
	}
	`log("======================================================");
*/

	AddInventoryToFlash();
}

function AddInventoryToFlash()
{
	// Add Weapons and Accesories
	SetupInventoryItems(MCP.MyInventory.OwnedWeapons,	MCP.MyInventory.ConfigWeapons.Active,	"WeaponsUC");
	SetupInventoryItems(MyRings,						MyRingsEquipt.Active, 					"RingsUC");
	SetupInventoryItems(MyEarings,						MyEaringsEquipt.Active,					"EarringsUC");
	SetupInventoryItems(MyNecklaces, 					MyNecklacesEquipt.Active,				"NecklaceUC");
}


function DebugTextThis(int i, string WhatName, string ASItemName, string UCItemName)
{
	`log(i @ "- AS - Set"$WhatName$"UC - AS=" @ ASItemName @ "- UC=" @ UCItemName); 
}
function DebugTextThisLine()
{
	`log("------------------------------------------------------------------------------");
}
function DebugTextThisLineTitle(string ThisIs)
{
	`log("-" @ ThisIs);
}

function DebugEquipped(int i, int Equipped)
{
	`log(i @ "- AS - Equipped=" @ Equipped);
}

function DebugStartLength(int Length)
{
	`log("- AS - Start.Length=" @ Length);
}


/**
 * Sets up the Inventory in here
 */
function SetupInventoryItems(array<MCItem> MyItem, array<int> Equipped, string FlashArrayName)
{
	local byte i;
	local GFxObject DataProvider;
	local GFxObject TempObj;

///	`log("======================================================");
//	`log("- Send Items to Flash =" @ FlashArrayName);
//	`log("======================================================");
	DataProvider = CreateArray();
	for (i = 0; i < MyItem.Length; i++)
	{       
		// Creates and returns a new GFxObject of a specific ActionScript class.
		TempObj = CreateObject("Object");
		TempObj.SetString(	"UCItemName",		MyItem[i].sItemName);
		TempObj.SetString(	"UCDescription",	MyItem[i].sDescription);
		TempObj.SetInt(		"UCEquiped",		Equipped[i]);

//		`log(i @ "- ItemName =" @ MyItem[i].sItemName);
//		`log(i @ "- Descript =" @ MyItem[i].sDescription);
//		`log(i @ "- Equipped =" @ Equipped[i]);

		DataProvider.SetElementObject(i, TempObj);
	}
//	`log("======================================================");

	// sets to flash array
	RootMC.SetObject(FlashArrayName, DataProvider);     
	ShowWeaponShop(FlashArrayName);
}

function array<MCItem_Weapon> AddItemWeapon(array<MCItem_Weapon> WhatItemShop, array<MCItem_Weapon> InsertTo, array<int> FindID, optional string de)
{
	local int i, j;

	// Add Current saved items
	for (i = 0; i < FindID.Length; i++)
	{
		for (j = 0; j < WhatItemShop.Length ; j++)
		{
			if (FindID[i] == WhatItemShop[j].ID)
			{	
				InsertTo.AddItem(WhatItemShop[j]);
			}
		}
	}

	return InsertTo;
}
function array<MCItem_Accessories> AddItemAccessory(array<MCItem_Accessories> WhatItemShop, array<MCItem_Accessories> InsertTo, array<int> FindID, optional string de)
{
	local int i, j;

	// Add Current saved items
	for (i = 0; i < FindID.Length; i++)
	{
		for (j = 0; j < WhatItemShop.Length ; j++)
		{
			if (FindID[i] == WhatItemShop[j].ID)
			{
				InsertTo.AddItem(WhatItemShop[j]);
			}
		}
	}

	return InsertTo;
}

function SeperateAccesories(array<MCItem_Accessories> WhatItem, array<int> WhatEquipped)
{
	local int i;

	// Seperate the Items
	for (i = 0; i < WhatItem.Length; i++)
	{
		// Earring
		if (WhatItem[i].Accessory == Earring)
		{
			// Add Item
			MyEarings.AddItem(WhatItem[i]);
			// Add Is it equipped for 1 for true, 0 for false
			MyEaringsEquipt.Active.AddItem(WhatEquipped[i]);
			// Add Index ID
			MyEaringsEquipt.IndexNumber.AddItem(i);
		}
			
		// Necklace
		if (WhatItem[i].Accessory == Necklace)
		{
			MyNecklaces.AddItem(WhatItem[i]);
			MyNecklacesEquipt.Active.AddItem(WhatEquipped[i]);
			MyNecklacesEquipt.IndexNumber.AddItem(i);
		}
		// Ring
		if (WhatItem[i].Accessory == Ring)
		{
			MyRings.AddItem(WhatItem[i]);
			MyRingsEquipt.Active.AddItem(WhatEquipped[i]);
			MyRingsEquipt.IndexNumber.AddItem(i);
		}
	}
}

/*
// Call from Actionscript to load all the information
*/
/*
function SetShops()
{
	SetUpWeaponShop(MCShopArche, MCShopArche.AllWeapons, "WeaponShopUC");
	SetUpWeaponShop(MCShopArche, MCShopArche.AllAccessories, "AccessoryShopUC");
	SetUpWeaponShop(MCShopArche, MCShopArche.AllEnchantments, "EnchantShopUC");
	SetUpWeaponShop(MCShopArche, MCShopArche.AllResearchMaterial, "ResearchMaterialShopUC");
}
*/

/*
// Call from Actionscript to load the Inventory
*/
/*
function SetInventory()
{
	// Send Config Saved dynamic array int
	SetUpInventoryINTArray(MCP.MyInventory.ConfigWeapons.ItemNumber, 			"WeaponInvUC");
	SetUpInventoryINTArray(MCP.MyInventory.ConfigAccessories.ItemNumber,		"AccessoryInvUC");
	SetUpInventoryINTArray(MCP.MyInventory.ConfigEnchantments.ItemNumber,		"EnchantInvUC");
	SetUpInventoryINTArray(MCP.MyInventory.ConfigResearchMaterial.ItemNumber,	"ResearchMaterialInvUC");
}
*/

/*
// Updates the The Hud the entire time
// @network                 Client
*/
function Tick(float DeltaTime)
{
	// Menu buttons

}

/*
// Recieve from Flash, will save Items in here into 
*/
function SaveEquip(int WhatItem, int ItemIndex)
{
	`log("UC - SaveEquip - WhatCase=" @ WhatItem @ "--- Index=" @ ItemIndex);

	switch (WhatItem)
	{
		// Weapons
		case 0:
			MCP.MyInventory.ConfigWeapons.Active[ItemIndex] = 1;
			MCP.MyInventory.SaveConfig();
			// Send back
			SetupInventoryItems(MCP.MyInventory.OwnedWeapons,	MCP.MyInventory.ConfigWeapons.Active,	"WeaponsUC");
			`log("Saving Weapons");
			break;

		// Rings
		case 1:
			MyRingsEquipt.Active[ItemIndex] = 1;
			SaveAccessoriesConfig();
			SetupInventoryItems(MyRings,						MyRingsEquipt.Active, 					"RingsUC");
			`log("Saving Rings");
			break;
			
		// Earrings
		case 2:
			MyEaringsEquipt.Active[ItemIndex] = 1;
			SaveAccessoriesConfig();
			SetupInventoryItems(MyEarings,						MyEaringsEquipt.Active,					"EarringsUC");
			`log("Saving Earrings");
			break;
			
		// Necklaces
		case 3:
			MyNecklacesEquipt.Active[ItemIndex] = 1;
			SaveAccessoriesConfig();
			SetupInventoryItems(MyNecklaces, 					MyNecklacesEquipt.Active,				"NecklaceUC");
			`log("Saving Necklace");
			break;

		default:
	}
}

function DebugSave(int WhatCase, int WhatIndex)
{
	`log("AS - WhatCase=" @ WhatCase @ "--- Index=" @ WhatIndex);
}

/*
// Store All different Accessories into the One and All Mighty Accessory.
*/
function SaveAccessoriesConfig()
{
	local int i;

	for (i = 0; i < MCP.MyInventory.ConfigAccessories.Active.Length; i++)
	{
		// Adding Rings
		MCP.MyInventory.ConfigAccessories.Active = SearchAccessories(i, MyRingsEquipt,		MCP.MyInventory.ConfigAccessories.Active);
		// Adding Earings
		MCP.MyInventory.ConfigAccessories.Active = SearchAccessories(i, MyEaringsEquipt,	MCP.MyInventory.ConfigAccessories.Active);
		// Adding Earings
		MCP.MyInventory.ConfigAccessories.Active = SearchAccessories(i, MyNecklacesEquipt,	MCP.MyInventory.ConfigAccessories.Active);
	}
	MCP.MyInventory.SaveConfig();
}
/*
// Add each Accessory in here
*/
function array<int> SearchAccessories(int i, AccesoryPlacement SortedItem, array<int> Active)
{
	local int j;

	for (j = 0; j < SortedItem.IndexNumber.Length; j++)
	{
		// If we found saved Index number here we add
		if (i == SortedItem.IndexNumber[j]){
			Active[i] = SortedItem.Active[j];
		}
	}

	return Active;
}

/*
// Recieve from Flash, will save All of the UnEquipped items in here and send it back to flash
*/
function SaveUnEquip(int WhatItem)
{
	local int i;

	`log("UC - SaveUnEquip - WhatCase =" @ WhatItem);

	switch (WhatItem)
	{
		// Weapons
		case 0:
			for (i = 0; i < MCP.MyInventory.ConfigWeapons.Active.Length ; i++)
			{
				// set all to false
				MCP.MyInventory.ConfigWeapons.Active[i] = 0;
			}
			MCP.MyInventory.SaveConfig();
			SetupInventoryItems(MCP.MyInventory.OwnedWeapons,	MCP.MyInventory.ConfigWeapons.Active,	"WeaponsUC");
			`log("Resetting Save Weapons");
			break;

		// Rings
		case 1:
			for (i = 0; i < MyRingsEquipt.Active.Length ; i++)
				MyRingsEquipt.Active[i] = 0;
			SaveAccessoriesConfig();
			SetupInventoryItems(MyRings,						MyRingsEquipt.Active, 					"RingsUC");
			`log("Resetting Save Rings");
			break;

		// Earrings
		case 2:
			for (i = 0; i < MyEaringsEquipt.Active.Length ; i++)
				MyEaringsEquipt.Active[i] = 0;
			SaveAccessoriesConfig();
			SetupInventoryItems(MyEarings,						MyEaringsEquipt.Active,					"EarringsUC");
			`log("Resetting Save Earrings");
			break;

		// Necklaces
		case 3:
			for (i = 0; i < MyNecklacesEquipt.Active.Length ; i++)
				MyNecklacesEquipt.Active[i] = 0;
			SaveAccessoriesConfig();
			SetupInventoryItems(MyNecklaces, 					MyNecklacesEquipt.Active,				"NecklaceUC");
			`log("Resetting Save Necklace");
			break;

		default:
	}
}

// Callback automatically called for each object in the movie with enableInitCallback enabled
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	// Determine which widget is being initialized and handle it accordingly
	switch(Widgetname)
	{
		case 'backButtonsIns':	// Ins name i flash
			wReturnButton = GFxCLIKWidget(Widget);
			// Set switch for next GoToFrame function
			wReturnButton.AddEventListener('CLIK_click', ReturnButton);
			break;
		default:
			break;
	}
	return true;
}

function ReturnButton(EventData data)
{
	`log("Return To Main City View");
}


defaultproperties
{
	WidgetBindings.Add((WidgetName="backButtonsIns",    WidgetClass=class'GFxCLIKWidget'))

	MCShopArche = MCShop'MystrasChampionContent.TownShops.MCShop'

	bDisplayWithHudOff=false
	TimingMode=TM_Game
	MovieInfo=SwfMovie'MystrasChampionFlash.WizardsTower.SelectTower'
}