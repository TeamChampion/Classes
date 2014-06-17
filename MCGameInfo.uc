class MCGameInfo extends MouseInterfaceGameInfo
    config(MystrasConfig);

var MCPawn Wizard;
var archetype Player01 WizardArche01;
var archetype Player02 WizardArche02;
var archetype Player03 WizardArche03;
var archetype Player04 WizardArche04;
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
	local MCPawn FindPawn;					// Pawn by this Pc
	local NavigationPoint FindStartNavi;	// Start Positions Placements
	local GFxSelectScreen MySelectScreen;	// Where we store the current selected character
	local int i;							// for loop value
	local int iPlayersMAX;					// Current Players we can Max have

	// Get Stored Selected Caharacter class
	if (MySelectScreen == none)
	{
		MySelectScreen = new class'GFxSelectScreen';
	}

	// Set Player amount
	iPlayersMAX = 4;

	// Abort if the default pawn archetype is none
	if (WizardArche01 == None || WizardArche02 == None || WizardArche03 == None || WizardArche04 == None)
	{
		`log("Couldn't spawn player of type ??? at "$StartSpot);
		return None;
	}

	// find the main pawn
	foreach AllActors(Class'MCPawn', FindPawn)
	{
		if (FindPawn != none)
		{
			`log("FindPawn" @ FindPawn);
			break;
		}
	}

	// Go threw the Start Spawn positions and see if we have can spawn a character
	foreach AllActors(Class'NavigationPoint', FindStartNavi)
	{

		if (FindStartNavi.Name == 'PlayerStart_0' || FindStartNavi.Name == 'PlayerStart_1')
		{
			for (i = 0; i < iPlayersMAX; i++)
			{
				// If a Pawn is withing 70 feet from spawn && his unique id already exists in the game
				if (VSize(FindPawn.Location - FindStartNavi.Location) < 70.0f || FindPawn.PlayerUniqueID == i)
				{
				//	`log("Someone Already here");
				}else
				{
					// Find the character selected in selection scren and spawn him, default archetype 1
					if(MySelectScreen.setCharacterSelect == 1)
						return Spawn(WizardArche01.Class,,, FindStartNavi.Location,, WizardArche01);
					else if(MySelectScreen.setCharacterSelect == 2)
						return Spawn(WizardArche02.Class,,, FindStartNavi.Location,, WizardArche02);
					else if(MySelectScreen.setCharacterSelect == 3)
						return Spawn(WizardArche03.Class,,, FindStartNavi.Location,, WizardArche03);
					else if(MySelectScreen.setCharacterSelect == 4)
						return Spawn(WizardArche04.Class,,, FindStartNavi.Location,, WizardArche04);
					else
						return Spawn(WizardArche01.Class,,, FindStartNavi.Location,, WizardArche01);
				}
			}
		}
		/*
		if (FindStartNavi.Name == 'PlayerStart_1')
		{
			if (VSize(FindPawn.Location - FindStartNavi.Location) < 70.0f || FindPawn.PlayerUniqueID == 2)
			{
				`log("he be here bitch!!!");
				
			}else
			{
				return Spawn(WizardArche02.Class,,, FindStartNavi.Location,, WizardArche02);
			}
		}
		*/
		continue;	// do again for next spawn point
	}
// Tag: PlayerSpawn00, Name: PlayerStart_0 
// Tag: PlayerSpawn01, Name: PlayerStart_1	
}






/*

//
// This state is when the match has not yet started, and players are choosing their heros or waiting to be started
// @network		Server
//
auto state PendingMatch
{
	//
	 //Checks if the match should start or not
	 //
	 // @network		Server
	 //
	function CheckMatchStart()
	{
		local int i;
		local MCPlayerReplication MCPlayerReplicationInfo;
		local MCGameReplication MCGrep;

		MCGrep = MCGameReplication(GameReplicationInfo);

		// Check we have access to the game replication info and the PRI array
		if (GameReplicationInfo == None || GameReplicationInfo.PRIArray.Length < 0)
		{
			return;
		}

		// Iterate through the player replication info
		for (i = 0; i < MCGrep.MCPRIArray.Length; ++i)
		{
			UDKMOBAPlayerReplicationInfo = UDKMOBAPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]);			
			if (UDKMOBAPlayerReplicationInfo != None)
			{
				// Return if this player has not picked a team yet
				// Return if this player has not picked a hero yet
				if (UDKMOBAPlayerReplicationInfo.Team == None || UDKMOBAPlayerReplicationInfo.HeroArchetype == None)
				{
					return;
				}
			}
		}

		// Everyone has picked, start the game
		StartMatch();
	}
}



///
//Called when the game should start the match
// @network		Server
//
function StartMatch()
{
	local MCGameReplication MCGRI;

	Super.StartMatch();

	MCGRI = MCGameReplication(GameReplicationInfo);
	MCGRI.GameRound = 0;
	MCGRI.SetMatchModeOn();

	// Go to the match in progress state
	GotoState('MatchInProgress');
}


///
// This state is used when the match is in progress
//
// @network		Server
//
state MatchInProgress
{
	//
	//
	function Tick(float DeltaTime)
	{
		local MCPlayerReplication MCPlayerReplicationInfo;
		local MCPlayerController MCPC;
		local MCGameReplication MCGRI;
		local int i;

		Super.Tick(DeltaTime);

		MCGRI = MCGameReplication(GameReplicationInfo);

		if (GameReplicationInfo != None && GameReplicationInfo.PRIArray.Length > 0)
		{
			for (i = 0; i < MCGRI.MCPRIArray.Length; ++i)
			{
				MCPlayerReplicationInfo = MCPlayerReplication(GameReplicationInfo.PRIArray[i]);
			}
		}
	}
}
*/


//
// Called every time the game is updated
// @param		DeltaTime		Time since the last update was called
// @network						Server
function Tick (float DeltaTime)
{
	Super.Tick(DeltaTime);
}

///
//Called when the game should start the match
// @network		Server
//
function StartMatch()
{
	local MCGameReplication MCGRI;

	Super.StartMatch();

	MCGRI = MCGameReplication(GameReplicationInfo);
	MCGRI.GameRound = 0;
	// Turn Camera ON
	MCGRI.SetMatchModeOn();
	SetMatchModeOn();

	// Go to the match in progress state
	GotoState('MatchInProgress');
}


auto state PendingMatch
{

	function Tick(float DeltaTime)
	{
		local MCGameReplication MCGrep;

		MCGrep = MCGameReplication(GameReplicationInfo);

		// Check we have access to the game replication info and the PRI array
		if (MCGrep == None || MCGrep.MCPRIArray.Length < 1)
		{
			//`log("waiting");
			return;
		}else
		{
			StartMatch();
			GotoState('MatchInProgress');
		}
	}	
}

state MatchInProgress
{
	function Tick(float DeltaTime)
	{
		local MCGameReplication MCGRI;

		Super.Tick(DeltaTime);

		MCGRI = MCGameReplication(GameReplicationInfo);

		if (GameReplicationInfo != None && MCGRI.MCPRIArray.Length > 0)
		{
			//`log("Play ball");
			/*
			for (i = 0; i < MCGRI.MCPRIArray.Length; ++i)
			{
				MCPlayerReplicationInfo = MCPlayerReplication(GameReplicationInfo.PRIArray[i]);
			}
			*/
		}else
		{
			GotoState('PendingMatch');
		}
	}
}












exec function SetMatchModeOff()
{
	`log("Not match mode");
	CameraProperties.bSetToMatch = false;
}

exec function SetMatchModeOn()
{
	`log("match mode");
	CameraProperties.bSetToMatch = true;
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
	GFxWeaponShop.SetUpInventory(WizardArche01);
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
	GFxAccessoriesShop.SetUpInventory(WizardArche01);
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
	GFxEnchantmentShop.SetUpInventory(WizardArche01);
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
	GFxResearchMaterialShop.SetUpInventory(WizardArche01);
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

	WizardArche01=Player01'mystraschampionsettings.Character.P01'
	WizardArche02=Player02'mystraschampionsettings.Character.P02'
	WizardArche03=Player03'mystraschampionsettings.Character.P03'
	WizardArche04=Player04'mystraschampionsettings.Character.P04'
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