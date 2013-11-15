class MCGameInfo extends MouseInterfaceGameInfo
    config(MystrasConfig);

var MCPawn Wizard;
var archetype MCPawn WizardArhetype;
var archetype MCShop WeaponShop;

// ScaleForm Movies
var GFxMain GFxMain;
var GFxInventory GFxInventory;
// ScaleForm Shops
var GFxWeaponShop GFxWeaponShop;
var GFxAccessoriesShop GFxAccessoriesShop;
var GFxEnchantmentShop GFxEnchantmentShop;
var GFxResearchMaterialShop GFxResearchMaterialShop;


var config string selectedPawn;

function PostBeginPlay()
{
	local PlayerStart MySpawnPoint;

	`log("------------------------ Starting PostBeginPlay ");
	foreach AllActors(class'PlayerStart', MySpawnPoint)
		if (MySpawnPoint.tag == 'PlayerSpawn')
		{
			break;
		}

// Spawn char	
WizardArhetype = spawn(class'MCPawn',,,MySpawnPoint.Location,,WizardArhetype);
`log("spawnpoint " @ MySpawnPoint.Name @ "char spawn" @ WizardArhetype);

// Scaleform video clip gogo

	
// Weapons settings
//GFxMain.SetUpInventory(WizardArhetype);
//GFxMain.SetUpWeaponShop(WeaponShop);
/*
GFxInventory.SetUpInventory(WizardArhetype);
GFxInventory.SetUpWeaponShop(WeaponShop);
*/

	super.PostBeginPlay();
}

// Not using this function anymore since I deleted the file
/*
function GfxSelectedChar(SeqAct_SelectChar GFxSC)
{
  selectedPawn  = GFxSC.selectedChar;

  SaveConfig();
}
*/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////// Shops & Stuff
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
exec function startWeaponShop()
{
	if (GFxWeaponShop == none)
	{
		GFxWeaponShop = new class'GFxWeaponShop';
		if (GFxWeaponShop != none)
		{
			GFxWeaponShop.SetTimingMode(TM_Real);
			GFxWeaponShop.Start();
		}
	}
	//Set up weapons
	GFxWeaponShop.SetUpInventory(WizardArhetype);
	GFxWeaponShop.SetUpWeaponShop(WeaponShop);
}
exec function closeWeaponShop()
{
	GFxWeaponShop.Close(true);
	`log("its closed");
}



exec function startAccessoriesShop()
{
	
	if (GFxAccessoriesShop == none)
	{
		GFxAccessoriesShop = new class'GFxAccessoriesShop';
		if (GFxAccessoriesShop != none)
		{
			GFxAccessoriesShop.SetTimingMode(TM_Real);
			GFxAccessoriesShop.Start();
		}
	}
	//Set up weapons
	GFxAccessoriesShop.SetUpInventory(WizardArhetype);
	GFxAccessoriesShop.SetUpWeaponShop(WeaponShop);
}
exec function closeAccessoriesShop()
{
	GFxAccessoriesShop.Close(true);
	`log("its closed");
}



exec function startEnchantmentShop()
{
	if (GFxEnchantmentShop == none)
	{
		GFxEnchantmentShop = new class'GFxEnchantmentShop';
		if (GFxEnchantmentShop != none)
		{
			GFxEnchantmentShop.SetTimingMode(TM_Real);
			GFxEnchantmentShop.Start();
		}
	}
	//Set up weapons
	GFxEnchantmentShop.SetUpInventory(WizardArhetype);
	GFxEnchantmentShop.SetUpWeaponShop(WeaponShop);

}
exec function closeEnchantmentShop()
{
	GFxEnchantmentShop.Close(true);
	`log("its closed");
}



exec function startResearchMaterialShop()
{
	if (GFxAccessoriesShop == none)
	{
		GFxResearchMaterialShop = new class'GFxResearchMaterialShop';
		if (GFxResearchMaterialShop != none)
		{
			GFxResearchMaterialShop.SetTimingMode(TM_Real);
			GFxResearchMaterialShop.Start();
		}
	}
	//Set up weapons
	GFxResearchMaterialShop.SetUpInventory(WizardArhetype);
	GFxResearchMaterialShop.SetUpWeaponShop(WeaponShop);

}
exec function closeResearchMaterialShop()
{
	GFxResearchMaterialShop.Close(true);
	`log("its closed");
}






defaultproperties
{
	WizardArhetype=MCPawn'Main.Archetype.testPawn'
	WeaponShop=MCShop'Main.Shops.WeaponShop'


	// Set the HUD
		//HUDType=class'MystrasChampion.MouseInterfaceHUD'
	// Set PlayerController
	PlayerControllerClass=class'MystrasChampion.MCPlayerController'
	// Set Pawn
	DefaultPawnClass=class'MystrasChampion.MCPawn'
}