class MCGameInfo extends MouseInterfaceGameInfo
    config(MystrasConfig);

var MCPawn Wizard;
var archetype Player01 WizardArhetype01;
var archetype Player02 WizardArhetype02;
var archetype MCShop WeaponShop;

// ScaleForm Movies
var GFxMain GFxMain;
var GFxInventory GFxInventory;
// ScaleForm Shops
var GFxWeaponShop GFxWeaponShop;
var GFxAccessoriesShop GFxAccessoriesShop;
var GFxEnchantmentShop GFxEnchantmentShop;
var GFxResearchMaterialShop GFxResearchMaterialShop;

var int GameRound;

var config string selectedPawn;
var MCCameraProperties CameraProperties;

//

function PostBeginPlay()
{
/*
	foreach AllActors(Class'Prefab', MCPrefab)
	{
		`log("Found Prefab " @ MCPrefab);
		break;
	}
*/
/*
	local PlayerStart MySpawnPoint;

	`log("------------------------ Starting PostBeginPlay ");
	foreach AllActors(class'PlayerStart', MySpawnPoint)
		if (MySpawnPoint.tag == 'PlayerSpawn')
		{
			`log("--------------------------------------------------------");
			`log("Char here" @ MySpawnPoint);
			break;
		}

// Spawn char	
WizardArhetype = spawn(class'Player01',,,MySpawnPoint.Location,,WizardArhetype);

`log("spawnpoint " @ MySpawnPoint.Name @ "char spawn" @ WizardArhetype);
*/



// Scaleform video clip gogo

	
// Weapons settings
//GFxMain.SetUpInventory(WizardArhetype);
//GFxMain.SetUpWeaponShop(WeaponShop);
/*
GFxInventory.SetUpInventory(WizardArhetype);
GFxInventory.SetUpWeaponShop(WeaponShop);
*/
	// Sets replications client Enemies left equal to servers Enemiesleft
	if (MCGameReplication(GameReplicationInfo) != none)
	{
		MCGameReplication(GameReplicationInfo).GameRound = GameRound;
	}
	super.PostBeginPlay();
}

/**
 * Returns a pawn of the default pawn class, "and spawns him somewhere"
 *
 * @param		NewPlayer		Controller for whom this pawn is spawned
 * @param		StartSpot		PlayerStart at which to spawn pawn
 * @return						Returns the spawned pawn
 */
 
function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot)
{
	local MCPawn FindPawn;
	local NavigationPoint StartSpot2;

	// Abort if the default pawn archetype is none
	if (WizardArhetype01 == None || WizardArhetype02 == None)
	{
		`log("Couldn't spawn player of type ??? at "$StartSpot);
		return None;
	}

	foreach AllActors(Class'MCPawn', FindPawn)
	{
		if (FindPawn != none)
		{
			`log("FindPawn" @ FindPawn);
			break;
		}
	}

	foreach AllActors(Class'NavigationPoint', StartSpot2)
	{
		if (StartSpot2.Name == 'PlayerStart_0')
		{
			if (VSize(FindPawn.Location - StartSpot2.Location) < 70.0f || FindPawn.PlayerUniqueID == 1)
			{
				`log("he be here bitch!!!");
				
			}else
			{
				return Spawn(WizardArhetype01.Class,,, StartSpot2.Location,, WizardArhetype01);
			}
		}
		
		if (StartSpot2.Name == 'PlayerStart_1')
		{
			if (VSize(FindPawn.Location - StartSpot2.Location) < 70.0f || FindPawn.PlayerUniqueID == 2)
			{
				`log("he be here bitch!!!");
				
			}else
			{
				return Spawn(WizardArhetype02.Class,,, StartSpot2.Location,, WizardArhetype02);
			}
		}
		continue;
	}

//	return Spawn(WizardArhetype.Class,,, StartSpot.Location,, WizardArhetype);
}

































exec function SetMatchModeOff()
{
	`log("Not match mode");
	CameraProperties.bSetToMatch = false;
}

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
	GFxWeaponShop.SetUpInventory(WizardArhetype01);
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
	GFxAccessoriesShop.SetUpInventory(WizardArhetype01);
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
	GFxEnchantmentShop.SetUpInventory(WizardArhetype01);
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
	GFxResearchMaterialShop.SetUpInventory(WizardArhetype01);
	GFxResearchMaterialShop.SetUpWeaponShop(WeaponShop);

}
exec function closeResearchMaterialShop()
{
	GFxResearchMaterialShop.Close(true);
	`log("its closed");
}






defaultproperties
{
	bDelayedStart=false
	// Camera Properties
	CameraProperties=MCCameraProperties'mystraschampionsettings.Camera.CameraProperties'

	WizardArhetype01=Player01'mystraschampionsettings.Character.P01'
	WizardArhetype02=Player02'mystraschampionsettings.Character.P02'
	WeaponShop=MCShop'MystrasChampionContent.TownShops.MCShop'


	// Set the HUD
	HUDType=class'MystrasChampion.MCHud'
	// Set PlayerController
	PlayerControllerClass=class'MystrasChampion.MCPlayerController'
	// Set Pawn
	DefaultPawnClass=class'MystrasChampion.MCPawn'
	// Game Replication
	GameReplicationInfoClass=class'MystrasChampion.MCGameReplication'
	// Player Replication
	PlayerReplicationInfoClass=class'MystrasChampion.MCPlayerReplication'

	GameRound = 0;
}