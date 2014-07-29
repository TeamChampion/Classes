//----------------------------------------------------------------------------
// MCGameInfo
//
// Setting up Game basics, also has Character Spawn functions & states for
// setting battle hud on when we have 2 Players active on the server
// @TODO remove Shops function (might not be using them at all, if using place them in GFxMain or HUD)
// @TODO add a winning state and pre game state when waiting for players
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCGameInfo extends MouseInterfaceGameInfo
	config(MystrasConfig);

var MCPawn Wizard;

var int GameRound;

var config string selectedPawn;
var MCCameraProperties CameraProperties;


function PostBeginPlay()
{
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
	local MCPlayerController MyPC;
	local MCPawn MyPawn;
	local MCPlayerReplication MCPRep;
	// Get Stored Selected Caharacter class
	if (MySelectScreen == none)
	{
		MySelectScreen = new class'GFxSelectScreen';
	}

	// Set Controller
	if (MyPC == none)
	{
		MyPC = MCPlayerController(NewPlayer);
	}
	// Set Pawn
	if (MyPawn == none)
	{
		MyPawn = MCPawn(MyPC.Pawn);
	}

	if (WorldInfo.GetMapName() == "movement_test16")
	{
		// get player rep
		MCPRep = MCPlayerReplication(MyPC.PlayerReplicationInfo);
		if (MCPRep == none || MCPRep.HeroArchetype == none)
		{
			return None;
		}
	}else
	{
		`log("Not the battle map");
	}

	// Set Player amount
	iPlayersMAX = 4;
/*
	// Abort if the default pawn archetype is none
	if (WizardArche01 == None || WizardArche02 == None || WizardArche03 == None || WizardArche04 == None)
	{
		`log("Couldn't spawn player of type ??? at "$StartSpot);
		return None;
	}
*/
	// find the already spawned pawn, does only work for second spawn
	foreach AllActors(Class'MCPawn', FindPawn)
	{
		if (FindPawn != none)
		{
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
					// Set PlayerReplication archetype
					if (MCPRep != none)
					{
						return Spawn(MCPRep.HeroArchetype.Class,,, FindStartNavi.Location,, MCPRep.HeroArchetype);
					}

					// Spawn a Character for Town so that we can access the Shops to store our inventory
					if (WorldInfo.GetMapName() == "town01")
					{
						`log("WE CAN SPAWN THIS GUY!!!!!!!!!!!!!!!!!!!!!!!");

						if (MyPC.setCharacterSelect == 1)
						{
							return Spawn(MyPC.WizardArche01.Class,,, FindStartNavi.Location,,MyPC.WizardArche01);
						}
						else if (MyPC.setCharacterSelect == 2)
						{
							return Spawn(MyPC.WizardArche02.Class,,, FindStartNavi.Location,,MyPC.WizardArche02);
						}
						else if (MyPC.setCharacterSelect == 3)
						{
							return Spawn(MyPC.WizardArche03.Class,,, FindStartNavi.Location,,MyPC.WizardArche03);
						}
						else if (MyPC.setCharacterSelect == 4)
						{
							return Spawn(MyPC.WizardArche04.Class,,, FindStartNavi.Location,,MyPC.WizardArche04);
						}
					}
					
				/*
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
				*/
				}
			}
		}
		continue;	// do again for next spawn point
	}
}

/*
// Called every time the game is updated
// @param		DeltaTime		Time since the last update was called
// @network						Server
*/
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

/*
// Called every time the game is updated
// @param		DeltaTime		Time since the last update was called
// @network						Server
*/
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

/*
// Set Camera Off on the Server
*/
exec function SetMatchModeOff()
{
	CameraProperties.bSetToMatch = false;
}

/*
// Set Camera On on the Server
*/
exec function SetMatchModeOn()
{
	CameraProperties.bSetToMatch = true;
}


defaultproperties
{
	bDelayedStart=false
	// Camera Properties
	CameraProperties=MCCameraProperties'mystraschampionsettings.Camera.CameraProperties'




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