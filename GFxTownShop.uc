//----------------------------------------------------------------------------
// GFxTownShop
//
// Main File that contains most functions for all other GFx classes
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class GFxTownShop extends GFxMain;

// Button Clicks for Selecting
var GFxCLIKWidget wReturnButton;
// Weapon Shop
var archetype MCShop MCShopArche;

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
//	ConfigSelectMenu();
	// Send WeaponShop
	SetShops();
	// Send Inventory
	SetInventory();
	// Set Money
	SetMoney();
	bInitialized = true;
}

function SetMoney()
{
	local MCPlayerController MCPC;
	local int moneyGrab;

	MCPC = MCPlayerController(GetPC());

	if (MCPC != none)
	{
		// get selected Player
		if (MCPC.setCharacterSelect == 1)
		{
			RootMC.SetInt("MoneyUC", MCPC.PlayerStruct01.Money);
			moneyGrab = MCPC.PlayerStruct01.Money;
		}
		else if (MCPC.setCharacterSelect == 2)
		{
			RootMC.SetInt("MoneyUC", MCPC.PlayerStruct02.Money);
			moneyGrab = MCPC.PlayerStruct02.Money;
		}
		else if (MCPC.setCharacterSelect == 3)
		{
			RootMC.SetInt("MoneyUC", MCPC.PlayerStruct03.Money);
			moneyGrab = MCPC.PlayerStruct03.Money;
		}
		else if (MCPC.setCharacterSelect == 4)
		{
			RootMC.SetInt("MoneyUC", MCPC.PlayerStruct04.Money);
			moneyGrab = MCPC.PlayerStruct04.Money;
		}

		`log("Money Grab is =" @ moneyGrab);
	}
}

/*
// Recieves Money from AS when we bought something, we then send it back to Actionscript to update the money
*/
function SendMoneyToUC(int RecievedMoney)
{
	local MCPlayerController MCPC;

	MCPC = MCPlayerController(GetPC());

	`log("We got something from Actionscript, Money =" @ RecievedMoney);

	if (MCPC != none)
	{
		// get selected Player
		if (MCPC.setCharacterSelect == 1)
		{
			// set money to him
			MCPC.PlayerStruct01.Money = RecievedMoney;
			// save his status
			MCPC.SaveConfig();
			// Set Money
			RootMC.SetInt("MoneyUC", MCPC.PlayerStruct01.Money);
		}
		else if (MCPC.setCharacterSelect == 2)
		{
			MCPC.PlayerStruct02.Money = RecievedMoney;
			MCPC.SaveConfig();
			RootMC.SetInt("MoneyUC", MCPC.PlayerStruct02.Money);
		}
		else if (MCPC.setCharacterSelect == 3)
		{
			MCPC.PlayerStruct03.Money = RecievedMoney;
			MCPC.SaveConfig();
			RootMC.SetInt("MoneyUC", MCPC.PlayerStruct03.Money);
		}
		else if (MCPC.setCharacterSelect == 4)
		{
			MCPC.PlayerStruct04.Money = RecievedMoney;
			MCPC.SaveConfig();
			RootMC.SetInt("MoneyUC", MCPC.PlayerStruct04.Money);
		}

		`log("We Send it back to AS!");

		// send back to AS function that updates it
		ActionScriptVoid("root.SendMoneyToAS");
	}

}

/*
// Call from Actionscript to load all the information
*/
function SetShops()
{
	SetUpWeaponShop(MCShopArche, MCShopArche.AllWeapons, "WeaponShopUC");
	SetUpWeaponShop(MCShopArche, MCShopArche.AllAccessories, "AccessoryShopUC");
	SetUpWeaponShop(MCShopArche, MCShopArche.AllEnchantments, "EnchantShopUC");
	SetUpWeaponShop(MCShopArche, MCShopArche.AllResearchMaterial, "ResearchMaterialShopUC");
}
/*
// Call from Actionscript to load the Inventory
*/
function SetInventory()
{
	// Send Config Saved dynamic array int
	SetUpInventoryINTArray(MCP.MyInventory.ConfigWeapons.ItemNumber, 			MCP.MyInventory.ConfigWeapons.Active,			"WeaponInvUC");
	SetUpInventoryINTArray(MCP.MyInventory.ConfigAccessories.ItemNumber,		MCP.MyInventory.ConfigAccessories.Active,		"AccessoryInvUC");
	SetUpInventoryINTArray(MCP.MyInventory.ConfigEnchantments.ItemNumber,		MCP.MyInventory.ConfigEnchantments.Active,		"EnchantInvUC");
	SetUpInventoryINTArray(MCP.MyInventory.ConfigResearchMaterial.ItemNumber,	MCP.MyInventory.ConfigResearchMaterial.Active,	"ResearchMaterialInvUC");
}







/*
// From Actionscript, Reset Item Array so that we can ReSave the files later on
*/
function ResetItem(String WhatInv)
{
	`log("We Reset stuff in here");
	// From the menu we remove text
	switch (WhatInv)
	{
		case "Weapon":
			MCP.MyInventory.ConfigWeapons.ItemNumber.Remove(0, MCP.MyInventory.ConfigWeapons.ItemNumber.Length);
			MCP.MyInventory.ConfigWeapons.Active.Remove(0, MCP.MyInventory.ConfigWeapons.Active.Length);
			MCP.MyInventory.SaveConfig();
			break;
			
		case "Accessory":
			MCP.MyInventory.ConfigAccessories.ItemNumber.Remove(0, MCP.MyInventory.ConfigAccessories.ItemNumber.Length);
			MCP.MyInventory.ConfigAccessories.Active.Remove(0, MCP.MyInventory.ConfigAccessories.Active.Length);
			MCP.MyInventory.SaveConfig();
			break;
			
		case "Enchant":
			MCP.MyInventory.ConfigEnchantments.ItemNumber.Remove(0, MCP.MyInventory.ConfigEnchantments.ItemNumber.Length);
			MCP.MyInventory.ConfigEnchantments.Active.Remove(0, MCP.MyInventory.ConfigEnchantments.Active.Length);
			MCP.MyInventory.SaveConfig();
			break;
			
		case "ResearchMaterial":
			MCP.MyInventory.ConfigResearchMaterial.ItemNumber.Remove(0, MCP.MyInventory.ConfigResearchMaterial.ItemNumber.Length);
			MCP.MyInventory.ConfigResearchMaterial.Active.Remove(0, MCP.MyInventory.ConfigResearchMaterial.Active.Length);
			MCP.MyInventory.SaveConfig();
			break;

		default:
	}
}
/*
// From Actionscript, Save Item one by one in Unrealscript from Flash Actionscript
// @TODO find out we we can send array instead
*/
function SaveItem(String WhatInv, int WhatID)
{
	// From the menu we save here
	switch (WhatInv)
	{
		case "Weapon":
			MCP.MyInventory.ConfigWeapons.ItemNumber.AddItem(WhatID);
			MCP.MyInventory.ConfigWeapons.Active.AddItem(0);
			MCP.MyInventory.SaveConfig();
			break;

		case "Accessory":
			MCP.MyInventory.ConfigAccessories.ItemNumber.AddItem(WhatID);
			MCP.MyInventory.ConfigAccessories.Active.AddItem(0);
			MCP.MyInventory.SaveConfig();
			break;

		case "Enchant":
			MCP.MyInventory.ConfigEnchantments.ItemNumber.AddItem(WhatID);
			MCP.MyInventory.ConfigEnchantments.Active.AddItem(0);
			MCP.MyInventory.SaveConfig();
			break;

		case "ResearchMaterial":
			MCP.MyInventory.ConfigResearchMaterial.ItemNumber.AddItem(WhatID);
			MCP.MyInventory.ConfigResearchMaterial.Active.AddItem(0);
			MCP.MyInventory.SaveConfig();
			break;
		default:
	}
}


/*
// From Actionscript, @NEW
// @param		WhatCase		What weapon, accessory shop etc we are currently using
// @param		WhatIndex		Where we are removing it
*/
function RemoveItem(int WhatCase, int WhatIndex)
{
	// From the menu we save here
	switch (WhatCase)
	{
		// Weapon
		case 0:
			MCP.MyInventory.ConfigWeapons.ItemNumber.Remove(WhatIndex,1);
			MCP.MyInventory.ConfigWeapons.Active.Remove(WhatIndex,1);
			MCP.MyInventory.SaveConfig();
			break;

		// Accessory
		case 1:
			MCP.MyInventory.ConfigAccessories.ItemNumber.Remove(WhatIndex,1);
			MCP.MyInventory.ConfigAccessories.Active.Remove(WhatIndex,1);
			MCP.MyInventory.SaveConfig();
			break;

		// Enchant
		case 2:
			MCP.MyInventory.ConfigEnchantments.ItemNumber.Remove(WhatIndex,1);
			MCP.MyInventory.ConfigEnchantments.Active.Remove(WhatIndex,1);
			MCP.MyInventory.SaveConfig();
			break;

		// ResearchMaterial
		case 3:
			MCP.MyInventory.ConfigResearchMaterial.ItemNumber.Remove(WhatIndex,1);
			MCP.MyInventory.ConfigResearchMaterial.Active.Remove(WhatIndex,1);
			MCP.MyInventory.SaveConfig();
			break;
		default:
	}
}

/*
// From Actionscript, @NEW
// @param		WhatInv			What weapon, accessory shop etc we are currently using
// @param		WhatIndex		Where we are removing it
*/
function AddItem(int WhatCase, int WhatIndex, int ItemNumber, int IsActive)
{
	// From the menu we save here
	switch (WhatCase)
	{
		// Weapon
		case 0:
			MCP.MyInventory.ConfigWeapons.ItemNumber.AddItem(ItemNumber);
			MCP.MyInventory.ConfigWeapons.Active.AddItem(IsActive);
			MCP.MyInventory.SaveConfig();
			break;

		// Accessory
		case 1:
			MCP.MyInventory.ConfigAccessories.ItemNumber.AddItem(ItemNumber);
			MCP.MyInventory.ConfigAccessories.Active.AddItem(IsActive);
			MCP.MyInventory.SaveConfig();
			break;

		// Enchant
		case 2:
			MCP.MyInventory.ConfigEnchantments.ItemNumber.AddItem(ItemNumber);
			MCP.MyInventory.ConfigEnchantments.Active.AddItem(IsActive);
			MCP.MyInventory.SaveConfig();
			break;

		// ResearchMaterial
		case 3:
			MCP.MyInventory.ConfigResearchMaterial.ItemNumber.AddItem(ItemNumber);
			MCP.MyInventory.ConfigResearchMaterial.Active.AddItem(IsActive);
			MCP.MyInventory.SaveConfig();
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// debug
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function DebugSetWeaponInvUC(int i)
{
	`log("AS - SetWeaponInvUC - pushing Inv spot =" @ i); 
}
function DebugTextThis(int i, int ID, string whatArray)
{
	`log(i @ "- AS - SetWeaponInvUC -" @ whatArray @ "- ID=" @ ID); 
}
function DebugTextThisLine()
{
	`log("------------------------------------------------------------------------------");
}
function DebugTextThisLineTitle(string ThisIs)
{
	`log("-" @ ThisIs);
}



function RecieveCheckItem(String Names, int Cost, String Desc)
{
	`log("----------------------------------------");
	`log("Names=" @ Names);
	`log("Cost=" @ Cost);
	`log("Desc=" @ Desc);
	`log("----------------------------------------");
}

function weaponLength(int Length)
{
	`log("----------------------------------------");
	`log("Length=" @ Length);
	`log("----------------------------------------");
}

function FoundInventory()
{
	`log("Found Inventory");
	`log("Found Inventory");
	`log("Found Inventory");
	`log("Found Inventory");
}

function SaveFound(int where, int MyID)
{
	`log(where @ " - Saving item ID =" @ MyID);
}

defaultproperties
{
	WidgetBindings.Add((WidgetName="backButtonsIns",    WidgetClass=class'GFxCLIKWidget'))

	MCShopArche = MCShop'MystrasChampionContent.TownShops.MCShop'

	bDisplayWithHudOff=false
	TimingMode=TM_Game
	MovieInfo=SwfMovie'MystrasChampionFlash.Shop.selectShop'
}