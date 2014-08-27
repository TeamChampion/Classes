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
//	PrintInventory();
	bInitialized = true;
}

/*
// Updates the The Hud the entire time
// @network                 Client
*/
function Tick(float DeltaTime)
{
	// Menu buttons
/*
	var emptyText01:String = "武器";
	var emptyText02:String = "アクセサリー";
	var emptyText03:String = "エンチャント管理";
	var emptyText04:String = "研究材料";

	weaponBtn.   textFields.text = emptyText01;
	accessoryBtn.textFields.text = emptyText02;
	enchantBtn.  textFields.text = emptyText03;
	researchBtn. textFields.text = emptyText04;
*/


}

function SetMoney()
{
	local MCPlayerController MCPC;
	local int moneyGrab;

	MCPC = MCPlayerController(GetPC());

	`log("Found This money prob" @ RootMC.GetInt("MoneyUC"));
	`log("Found This money prob" @ RootMC.GetInt("MoneyUC"));
	`log("Found This money prob" @ RootMC.GetInt("MoneyUC"));
	`log("Found This money prob" @ RootMC.GetInt("MoneyUC"));
//	RootMC.SetInt("MoneyUC", 999);
	`log("Found This money prob" @ RootMC.GetInt("MoneyUC"));
	`log("Found This money prob" @ RootMC.GetInt("MoneyUC"));
	`log("Found This money prob" @ RootMC.GetInt("MoneyUC"));

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
	SetUpInventoryINTArray(MCP.MyInventory.MyOwnedWeapons, 			"WeaponInvUC");
	SetUpInventoryINTArray(MCP.MyInventory.MyOwnedAccessories,		"AccessoryInvUC");
	SetUpInventoryINTArray(MCP.MyInventory.MyOwnedEnchantments,		"EnchantInvUC");
	SetUpInventoryINTArray(MCP.MyInventory.MyOwnedResearchMaterial,	"ResearchMaterialInvUC");

	// Send to Flash MCITEM
	/*
	SetUpInventory(MCP.MyInventory.OwnedWeapons, 			"WeaponInvUC");
	SetUpInventory(MCP.MyInventory.OwnedAccessories,		"AccessoryInvUC");
	SetUpInventory(MCP.MyInventory.OwnedEnchantments,		"EnchantInvUC");
	SetUpInventory(MCP.MyInventory.OwnedResearchMaterial,	"ResearchMaterialInvUC");
	*/
}
/*
// Reset Item Array so that we can ReSave the files later on
*/
function ResetItem(String WhatInv)
{
	// From the menu we remove text
	switch (WhatInv)
	{
		case "Weapon":
			MCP.MyInventory.MyOwnedWeapons.Remove(0, MCP.MyInventory.MyOwnedWeapons.Length);
			MCP.MyInventory.SaveConfig();
			`log("Inventory cleared Weapon" @ MCP.MyInventory.MyOwnedWeapons.Length);
			break;
			
		case "Accessory":
			MCP.MyInventory.MyOwnedAccessories.Remove(0, MCP.MyInventory.MyOwnedAccessories.Length);
			MCP.MyInventory.SaveConfig();
			`log("Inventory cleared Accessory" @ MCP.MyInventory.MyOwnedAccessories.Length);
			break;
			
		case "Enchant":
			MCP.MyInventory.MyOwnedEnchantments.Remove(0, MCP.MyInventory.MyOwnedEnchantments.Length);
			MCP.MyInventory.SaveConfig();
			`log("Inventory cleared Enchant" @ MCP.MyInventory.MyOwnedEnchantments.Length);
			break;
			
		case "ResearchMaterial":
			MCP.MyInventory.MyOwnedResearchMaterial.Remove(0, MCP.MyInventory.MyOwnedResearchMaterial.Length);
			MCP.MyInventory.SaveConfig();
			`log("Inventory cleared ResearchMaterial" @ MCP.MyInventory.MyOwnedResearchMaterial.Length);
			break;

		default:
	}
}
/*
// Save Item one by one in Unrealscript from Flash Actionscript
// @TODO find out we we can send array instead
*/
function SaveItem(String WhatInv, int WhatID)
{
	// From the menu we save here
	switch (WhatInv)
	{
		case "Weapon":
			MCP.MyInventory.MyOwnedWeapons.AddItem(WhatID);
			MCP.MyInventory.SaveConfig();
			`log("Added to Inventory Weapon" @ WhatID);
			break;

		case "Accessory":
			MCP.MyInventory.MyOwnedAccessories.AddItem(WhatID);
			MCP.MyInventory.SaveConfig();
			`log("Added to Inventory Accessory" @ WhatID);
			break;

		case "Enchant":
			MCP.MyInventory.MyOwnedEnchantments.AddItem(WhatID);
			MCP.MyInventory.SaveConfig();
			`log("Added to Inventory Enchant" @ WhatID);
			break;

		case "ResearchMaterial":
			MCP.MyInventory.MyOwnedResearchMaterial.AddItem(WhatID);
			MCP.MyInventory.SaveConfig();
			`log("Added to Inventory ResearchMaterial" @ WhatID);
			break;
		default:
	}

}

function PrintInventory()
{
	local int i;

	`log("Item ===================================");
	for (i = 0; i < MCP.MyInventory.MyOwnedAccessories.Length ; i++)
	{
		`log("Item -" @ i @ "-" @ MCP.MyInventory.MyOwnedAccessories[i]);
	}
	`log("Item ===================================");
	
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


function FoundShop()
{
	`log("Found Shop");
	`log("Found Shop");
	`log("Found Shop");
	`log("Found Shop");
}
function FoundInventory()
{
	`log("Found Inventory");
	`log("Found Inventory");
	`log("Found Inventory");
	`log("Found Inventory");
}

defaultproperties
{
	WidgetBindings.Add((WidgetName="backButtonsIns",    WidgetClass=class'GFxCLIKWidget'))

	MCShopArche = MCShop'MystrasChampionContent.TownShops.MCShop'

	bDisplayWithHudOff=false
	TimingMode=TM_Game
	MovieInfo=SwfMovie'MystrasChampionFlash.Shop.selectShop'
}