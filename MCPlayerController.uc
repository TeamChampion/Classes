//----------------------------------------------------------------------------
// MCPlayerController
//
// PlayerController, controls Pathfinding, whoose turn it is etc
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCPlayerController extends MouseInterfacePlayerController
	config(MystrasConfig);

////////////////////////////
// Character Information & Spells
////////////////////////////
// Struct for Player to be saved @TODO make cleaner for TGS
struct PlayerStats
{
	var string PawnName;
	var int FirePoints, IcePoints, EarthPoints, PosionPoints, ThunderPoints;
	var int currentSpells01, currentSpells02, currentSpells03, currentSpells04;
	var int Level;
	var int Money;

	structdefaultproperties
	{
		Level = 1;
		Money = 1000;
	}
};

// @TODO Make easier for TGS
var PlayerStats PlayerEmpty;			// Used to send to Replication
var PlayerStats RemovePlayerStats;		// When removing char in select screen set it to this
var config PlayerStats PlayerStruct01;
var config PlayerStats PlayerStruct02;
var config PlayerStats PlayerStruct03;
var config PlayerStats PlayerStruct04;


// Spells
var array <MCSpell> MyArchetypeSpells;
// All Spells in a list
var archetype MCSpellArchetypeList MySpellList;
////////////////////////////

// What character we selected
var config Repnotify int setCharacterSelect;
var ProtectedWrite RepNotify MCPawn HeroPawn;

// Set what character we selected in Select Screen and attach his information
var int ResetCharSelect;
// Set Current Hero
var MCPawn ResetHeroPawn;
// Set Current Hero name
var string ResetHeroName;

// Archetype Characters @TODO remove later on
var  Player01 WizardArche01;
var  Player02 WizardArche02;
var  Player03 WizardArche03;
var  Player04 WizardArche04;

//	AI Movement Variables
///////////////////////////////////////////////
// Move target from last scripted action
var Actor ScriptedMoveTarget;
// Route from last scripted action; if valid, sets ScriptedMoveTarget with the points along the route
var Route ScriptedRoute;
// Setting MouseInterfaceActor to this and then assigning it to DescActor
var Actor NewHitActor;
// debug Actor for showing where to go
var MCTestActor SpawnActor;

//	Camera calling
///////////////////////////////////////////////
// The Camera Properties link
var const MCCameraProperties CameraProperties;

//	Replication Variables
///////////////////////////////////////////////
// Player Unique ID
var int PlayerUniqueID;
var playerstart closestPlayerStart;
var MCPawn MCPlayer;
var MCPawn MCEnemy;

//	Others
///////////////////////////////////////////////
// Struct that contains all the PathNodes, Triggers and Tiles
struct MCActors
{
	var array<MCPathNode> Paths;
	var array<Trigger> Triggers;
	var array<MCTile> Tiles;
};
// struct object
var MCActors MCA;
// used for turning on and off PlayerMove, so they all don\t collide
var bool bCanStartMoving;
// If true then we can look for places to
var bool bIsTileActive;
// Add Tiles to an array to later check what Tiles we are going to lightup
var array <MCTile> CanUseTiles;


var bool bIsSpellActive;	// used to check if we have a spell in here, also used in different spells
var MCTile ClickSpell;		// When spell is clicked this jsut show that we have it
var bool bButtonHovering;	// From battleHud, used so we don't click on a Tile while clicking button
var MCTile TileColor;
var array <MCTile> FireTiles;
var bool bDebugFlag;		// debugging flag shown, false for hiding it

// 
// New files since 2014-06-14
// - ////////////////////////////////////////
var MCSpell InstantiateSpell;		// What we need to spawn the spell + use in PlayerTick, Click function for selecting spells etc

// OLD VARIABLES @TODO remove later on
var bool bIsSelectingFireFountain;
var bool bIsSelectingStoneWall;

// Replication block
replication
{
	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		NewHitActor, ScriptedMoveTarget, MCA, MCPlayer, MCEnemy, bIsTileActive, HeroPawn;
	
//	bNetOwner && 
	if(bNetDirty)
		setCharacterSelect, InstantiateSpell, ClickSpell, bIsSpellActive;

	if(bNetDirty)
		PlayerEmpty, PlayerStruct01, PlayerStruct02, PlayerStruct03, PlayerStruct04;

}

simulated event ReplicatedEvent(name VarName)
{
	if(VarName == 'NewHitActor') //this variable has changed so update the clients
		`log("changed");
	if(VarName == 'HeroPawn') //this variable has changed so update the clients
	{
	//	`log("changed");
	}
}

/*
// Server only
*/
event Possess(Pawn inPawn, bool bVehicleTransition)
{

//	local UDKMOBAHeroPawnReplicationInfo UDKMOBAHeroPawnReplicationInfo;
//	local MCPlayerReplication MCPRep;
	super.Possess(inPawn, bVehicleTransition);

//	`log("Me Get Spawn on server" @ inPawn);

	MCPlayer = MCPawn(inPawn);
/*
	// Attempt to assign hero pawn, if it fails then abort
	HeroPawn = MCPawn(inPawn);
	MCPlayer = MCPawn(inPawn);
	if (HeroPawn == None || MCPlayer == none)
	{
		return;
	}

	// Set This Player Replication in Pawns replication
	HeroPawn.PlayerReplicationInfo = PlayerReplicationInfo;
	MCPlayer.PlayerReplicationInfo = PlayerReplicationInfo;

*/
	// Restart the player controller
//	Restart(bVehicleTransition);
}

simulated event PostBeginPlay()
{
	local MCPathNode PathNode;
	local MCTile Tile;

	ResetGame();

	CameraProperties.bSetToMatch = false;
    super.PostBeginPlay();

	// Adds Tiles and PathNode in to an array if they are close to eachother
	foreach DynamicActors(Class'MCTile', Tile)
	{
		foreach WorldInfo.AllNavigationPoints(Class'MCPathNode', PathNode)
		{
			if ( VSize(Tile.Location - PathNode.Location) < 70.0f)
			{
			//	`log("Tile" @ Tile @ "PathNode" @ PathNode);
			//	`log("Tile Location    " @ Tile.Location.X @ " " @ Tile.Location.Y );
			//	`log("PathNode Location" @ PathNode.Location.X @ " " @ PathNode.Location.Y );
			//	`log("Vsize bitch" @ VSize(Tile.Location - PathNode.Location) );
			//	`log("----------------------------------------------------------");
				PathNode.bBlocked = false;
				MCA.Paths.AddItem(PathNode);
				continue;
			}
		}
		Tile.bSpellTileMode = false;
		Tile.bFireFountain = false;
		MCA.Tiles.AddItem(Tile);
		continue;
	}

	
	// Set basic client information
	if (Role < Role_Authority)
	{
		// Set Character Select Number
		ResetCharSelect = setCharacterSelect;

		// Set hero archetype after Character Select Number
		if (ResetCharSelect == 1)
		{
			ResetHeroPawn = WizardArche01;
			PlayerEmpty = PlayerStruct01;
		}
		else if(ResetCharSelect == 2)
		{
			ResetHeroPawn = WizardArche02;
			PlayerEmpty = PlayerStruct02;
		}
		else if(ResetCharSelect == 3)
		{
			ResetHeroPawn = WizardArche02;
			PlayerEmpty = PlayerStruct03;
		}
		else if(ResetCharSelect == 4)
		{
			ResetHeroPawn = WizardArche02;
			PlayerEmpty = PlayerStruct04;
		}

		// Set Characther Name
		ResetHeroName = ResetHeroPawn.PawnName2;

	//	`log("MY HERO WILL BE !!!!!!!" @ ResetHeroPawn.PawnName2);
	}
	
/*
	`log("----------------------------------------------");
	`log("-- My struct for Player 2");
	`log("----------------------------------------------");
	`log("PlayerName: "   @ PlayerStruct02.PawnName); 
	`log("-------------------"); 
	`log("Spells");
	`log("-------------------"); 
	`log("Archetype spells 01" @ PlayerStruct02.currentSpells01);
	`log("Archetype spells 02" @ PlayerStruct02.currentSpells02);
	`log("Archetype spells 03" @ PlayerStruct02.currentSpells03);
	`log("Archetype spells 04" @ PlayerStruct02.currentSpells04);
	`log("----------------------------------------------");
*/
	// Adding Spells for MyArchetypeSpells, this won't add for server thou
	if (setCharacterSelect == 1)
	{
		AddSpells(PlayerStruct01.currentSpells01, 0);
		AddSpells(PlayerStruct01.currentSpells02, 1);
		AddSpells(PlayerStruct01.currentSpells03, 2);
		AddSpells(PlayerStruct01.currentSpells04, 3);
	}
	else if (setCharacterSelect == 2)
	{
		AddSpells(PlayerStruct02.currentSpells01, 0);
		AddSpells(PlayerStruct02.currentSpells02, 1);
		AddSpells(PlayerStruct02.currentSpells03, 2);
		AddSpells(PlayerStruct02.currentSpells04, 3);
	}
	else if (setCharacterSelect == 3)
	{
		AddSpells(PlayerStruct03.currentSpells01, 0);
		AddSpells(PlayerStruct03.currentSpells02, 1);
		AddSpells(PlayerStruct03.currentSpells03, 2);
		AddSpells(PlayerStruct03.currentSpells04, 3);
	}
	else if (setCharacterSelect == 4)
	{
		AddSpells(PlayerStruct04.currentSpells01, 0);
		AddSpells(PlayerStruct04.currentSpells02, 1);
		AddSpells(PlayerStruct04.currentSpells03, 2);
		AddSpells(PlayerStruct04.currentSpells04, 3);
	}

	// Adding arhetypes

	// Checks for Pawn, when we get him turn this off in the SetMyPawn function
	SetTimer(0.1f, true, 'SetMyPawn');
}

simulated function ResetGame()
{
	local MCActor_Rock MyRock;

	// Set Heroes
	HeroPawn = none;
	MCPlayer = none;
	MCEnemy = none;

	// Reset spawned things
	foreach AllActors(Class'MCActor_Rock', MyRock)
	{
		MyRock.destroy();
	}
}

simulated function AddSpells(int SpellNumber, int MySpellSlot)
{
	local MCSpell SpellName;

	// Search for Spells in List we have in an Archetype
	foreach MySpellList.AllArchetypeSpells(SpellName)
	{
		// If searched result is the same as created spell, save it in the character
		if (SpellName.spellNumber == SpellNumber)
		{
		//	`log("found Spell" @ SpellName.spellNumber);
			MyArchetypeSpells[MySpellSlot] = SpellName;
		}
	}
}

/*
// Sends correct Spawn number to server
*/
reliable server function SpawnThisNumberCharacter(int setServerChar, MCPawn setServerPawn)
{
	// Server only
	if (Role == Role_Authority)
	{
		setCharacterSelect = setServerChar;

		if (PlayerReplicationInfo != none)
		{
			MCPlayerReplication(PlayerReplicationInfo).setCharacterSelect = setServerChar;
//			`log("Replicate Server NOW=" @ MCPlayerReplication(PlayerReplicationInfo).setCharacterSelect);
		}


		// Same thing for Hero Archetype
		HeroPawn = setServerPawn;
		
		if (PlayerReplicationInfo != none)
		{
			MCPlayerReplication(PlayerReplicationInfo).HeroArchetype = HeroPawn;
//			`log("Replicate Server NOW=" @ MCPlayerReplication(PlayerReplicationInfo).HeroArchetype);
		}
	}
}

reliable server function CheckNewData(PlayerStats MyStruct)
{
	if (Role == Role_Authority)
	{
		PlayerEmpty = MyStruct;
		/*
		`log("----------------------------------------------");
		`log("Sent to Server Mother Fucker!!!!!!!!");
		`log("----------------------------------------------");
		`log("-- My struct for Player 2");
		`log("----------------------------------------------");
		`log("PlayerName: "   @ PlayerEmpty.PawnName); 
		`log("-------------------"); 
		`log("Spells");
		`log("-------------------"); 
		`log("Archetype spells 01" @ PlayerEmpty.currentSpells01);
		`log("Archetype spells 02" @ PlayerEmpty.currentSpells02);
		`log("Archetype spells 03" @ PlayerEmpty.currentSpells03);
		`log("Archetype spells 04" @ PlayerEmpty.currentSpells04);
		`log("----------------------------------------------");
		*/
		if (PlayerReplicationInfo != none)
		{
			MCPlayerReplication(PlayerReplicationInfo).PawnName = PlayerEmpty.PawnName;
		//	MCPlayer.PawnName = PlayerEmpty.PawnName;

			MCPlayerReplication(PlayerReplicationInfo).currentSpells01 = PlayerEmpty.currentSpells01;
			MCPlayerReplication(PlayerReplicationInfo).currentSpells02 = PlayerEmpty.currentSpells02;
			MCPlayerReplication(PlayerReplicationInfo).currentSpells03 = PlayerEmpty.currentSpells03;

			MCPlayerReplication(PlayerReplicationInfo).currentSpells04 = PlayerEmpty.currentSpells04;

		}

	}
}

// Send from PlayercontrollerUsed in PlayerController when we set what Character Selected number we should spawn
reliable server function SetHeroNumberServer(int setServerChar)
{
	if (Role == Role_Authority)
	{
		setCharacterSelect = setServerChar;
	//	SetHero();
	//	`log("SETTING HERO!!!!!!!!!");
	}
}

// @TODO remove function
function MCPawn MyPawnReturn(MCPawn ReturnHim)
{
	return ReturnHim;
}

/* Step 01
// Sets The Pawn and then sets the color for them
*/
simulated function SetMyPawn()
{
//	local int i;
	local MCPawn SendToServer;
	// During Client, send the new char to server and replicate it there
	if (Role < Role_Authority)
	{
		setCharacterSelect = ResetCharSelect;

		// Set Archertype
		// Says it's P01.waas for MAC
		// Says it's P02.Randalof for PC
		HeroPawn = ResetHeroPawn;
		SendToServer = MyPawnReturn(ResetHeroPawn);

		SpawnThisNumberCharacter(setCharacterSelect, SendToServer);
		CheckNewData(PlayerEmpty);
	}

	if(PlayerReplicationInfo != none)
	{
		if (MCPlayerReplication(PlayerReplicationInfo).PlayerUniqueID == PlayerUniqueID)
		{
			
		}
	//	MCPlayerReplication(PlayerReplicationInfo).setCharacterSelect = setCharacterSelect;
	//	SetHero();
	}

	// If we have any form of Pawn then set him to MCPawn
	if (Pawn != none)
	{
		MCPlayer = MCPawn(Pawn);
	}

	// If Pawn is found then stop the timer and clear the spam
	if (MCPlayer != none)
	{
		// Set PC in Pawn class
		MCPlayer.setYourPC(self);
		// Set unique ID to Players
		SetTimer(1.0, false, 'findClosestPlayerStart');

		// Check to see if we have 2 chars so that we can start
		ClearTimer('SetMyPawn');
	}
}

/* Step 02
// Sets a Player a special Unique ID
*/
simulated function findClosestPlayerStart()
{
	local float dist;
	local float currentDist;
	local playerstart p;

	// if we don't have a pawn then abort
	if (MCPlayer == none)
	{
		return;
	}

	dist = 100000000000000000;
	foreach WorldInfo.AllNavigationPoints(Class'PlayerStart', P)
	{
		//make sure default playerstart tag / name has not been altered in UDK
		//confirm that you are getting these names as possible options

		currentDist = VSize(MCPlayer.Location - P.Location);
		if (currentDist < dist)
		{
			dist = currentDist;
			closestPlayerStart = P;
		}
	}

	// SET UNIQUE PLAYER ID BASED ON START POINT
	if (closestPlayerStart.Name == 'PlayerStart_0')	{	PlayerUniqueID = 1;	}	// waas
	if (closestPlayerStart.Name == 'PlayerStart_1')	{	PlayerUniqueID = 2;	}	// Randalf
//	if (closestPlayerStart.Name == 'PlayerStart_2')	{	PlayerUniqueID = 3;	}	
//	if (closestPlayerStart.Name == 'PlayerStart_3')	{	PlayerUniqueID = 4;	}

	// Update This Characters Pawn Information
	MCPlayer.Level = PlayerEmpty.Level + 0;
	MCPlayer.APfMax = 6.0f + ((PlayerEmpty.Level+0) - 1);	// Level - 1
	MCPlayer.PlayerUniqueID = PlayerUniqueID;

	// Update Replication Info so other players know this playerrep's new ID value
	MCPlayerReplication(PlayerReplicationInfo).PlayerUniqueID = PlayerUniqueID;
	MCPlayerReplication(PlayerReplicationInfo).APf = MCPlayer.APf;
	MCPlayerReplication(PlayerReplicationInfo).APfMax = MCPlayer.APfMax;
//	MCPlayerReplication(PlayerReplicationInfo).PawnName = MCPlayer.PawnName;

	// Start looking for Enemy Player
    SetTimer(0.5,true,'checkForTwoPlayers');
}


/* Step 03
function that checks if we have 2 players available at start and if so add them to the array
*/
simulated function checkForTwoPlayers()
{
	local MCPawn NewMCP;
//	local int HowMany;
	//	local int goPlus;
//	local int i;
	local MCGameReplication MCGRI;

	// How many Pawns we find
//	HowMany = 0;

	// Get Game Replication
	MCGRI = MCGameReplication(WorldInfo.GRI);

	if (MCGRI.MCPRIArray.Length > 1)
	{
		// 2 or more
/*
		for (i = 0; i < MCGRI.MCPRIArray.length ; i++)
		{
			if(MCGRI.MCPRIArray[i].PlayerUniqueID == MCPlayer.PlayerUniqueID)
			{
				`log("Found!!!!!!!!!!");
				MCEnemy = MCGRI.MCPRIArray[i].HeroArchetype;
			}else
			{
				MCEnemy = MCGRI.MCPRIArray[i].HeroArchetype;
				`log("-------------- no");
			}
		}
*/

		foreach DynamicActors(class'MCPawn', NewMCP)
		{
			if (PlayerUniqueID == NewMCP.PlayerUniqueID)
			{
				MCPlayer = NewMCP;
			}else
			{
				MCEnemy = NewMCP;
			}
		}

		// clear this check
		ClearTimer('checkForTwoPlayers');

		// Camera Settings, set MatchMode ON and follow char at start, then we turn it off
		CameraProperties.bSetToMatch = true;
		CameraProperties.IsTrackingHeroPawn = true;
		SetTimer(1.5,false,'SetCameraSettingsStart');

		// Go and set the round so that Player 1 Starts the game
		// Only use 0 this one time
		TurnBased(0);
	}
/*

	// check how many players we have
	foreach AllActors(Class'MCPawn', NewMCP)
	{
		HowMany++;
		continue;
	}

	// if we have 2 players then add them to the array
	if (HowMany == 2)
	{
*/
		/*
		goPlus = 0;
		foreach AllActors(Class'MCPawn', NewMCP)
		{
			// dynamic array
			MyPawns.InsertItem(goPlus, NewMCP);
			// normal array
			//MyPlayers[goPlus] = NewMCP;
			goPlus++;
			continue;
		}
		*/
/*
		// set Enemy Pawn for Hud etc
		foreach DynamicActors(class'MCPawn', NewMCP)
		{
			if (NewMCP != MCPlayer)
			{
				MCEnemy = NewMCP;
			}
		}
		// clear this check
		ClearTimer('checkForTwoPlayers');

		// Go and set the round so that Player 1 Starts the game
		// Only use 0 this one time
		TurnBased(0);
	}
*/
}

/*
// After We have started, will deactivate Character Lock ON, we can start using the Mouse
*/
simulated function SetCameraSettingsStart()
{
	CameraProperties.bSetMouseMovement = true;
}

/*
// Will set which Player is active and will let him do his move. Then switched to the other Player and so forth.
*/
reliable server function TurnBased(int TurnPlayer)
{
	local MCGameReplication MCPR;	// Game Replication
	local MCPawn WhatPeople;		// All our Pawns in the game to search for
//	local MCPlayerController cMCPC;
//	local PlayerController PC;

	// Set Game Replication so we can update Rounds
	MCPR = MCGameReplication(WorldInfo.GRI);

	if (MCPR != none)
	{
		// If it's the first round of the game. Set GameRound to 0 (Will become 4 because of 4 Chars)
		if (TurnPlayer == 0)
		{
			MCPR.GameRound = 0;
		}
		// Add a GameRound per turn
		MCPR.GameRound++;
	}

	MCPlayerReplication(PlayerReplicationInfo).GetPlayerHealth(MCPlayer.Health);
	// just update all Pawns all once so it doesn't fail later
	foreach DynamicActors(Class'MCPawn', WhatPeople)
	{
		MCPlayerReplication(PlayerReplicationInfo).APf = WhatPeople.APf;
	}



////////////////////////////////////////////////////////////////////////////
	// Step 01
	// First round sets character 1 AP to 6 and state in PlayerWalking
	// Player 2 goes to idle
////////////////////////////////////////////////////////////////////////////

	// First round only is TurnPlayer 0
	if (TurnPlayer == 0)
	{
		// Set the turn to Player 1
		TurnPlayer = 1;

		// Search for replications
		foreach DynamicActors(Class'MCPawn', WhatPeople)
		{
			// If we find a Player 1 then give him some AP
			if (WhatPeople.PlayerUniqueID == TurnPlayer)
			{
				WhatPeople.APf = WhatPeople.APfMax;
				// Set Use Tile function on
			//	WhatPeople.bSetTiles = true;	//@NOTUSING

				// Update his Replication
				MCPlayerReplication(PlayerReplicationInfo).APf = MCPlayer.APf;

			//	SendVictoryOrLossMessage();
			//	GetTilesAndPaths(TurnPlayer);
		//		SetTilePathClient(TurnPlayer, MCPlayer);
		//		MeClient(TurnPlayer, MCPlayer);
			}else
			{
				// Otherwise do something to Player 2
			}
		}
		return;
	}

////////////////////////////////////////////////////////////////////////////
	// Step 02
	// We take next Person in line and give him new AP
	// We set him in the right State
////////////////////////////////////////////////////////////////////////////

	// If it's Player 1 or 2's turn then give one fo them 6 AP and the other one 0 AP
	if (TurnPlayer == 2 || TurnPlayer == 1)
	{
		/*
		foreach WorldInfo.AllControllers(class'PlayerController', PC)
		{
			cMCPC = MCPlayerController(PC);

			if (cMCPC.MCPlayer.PlayerUniqueID == TurnPlayer)
			{
				// Give person AP
				// Make a function that checks current statuses, and add that to APfMax and update the information.
			//	WhatPeople.APf = float CalculateNewAP(WhatPeople.APf)	
				cMCPC.MCPlayer.APf = cMCPC.MCPlayer.APfMax;
				// Set Use Tile function on
			//	cMCPC.MCPlayer.bSetTiles = true;	//@NOTUSING
		//		`log("You" @ WhatPeople @ "got" @ WhatPeople.APf @ "new AP, congratulations");
			}else
			{
				// Otherwise Reset AP
				cMCPC.MCPlayer.APf = 0.0;
		//		`log("MR" @ WhatPeople.PawnName @ "" @ WhatPeople.PlayerUniqueID @ "Got resetted");

				// Update his Replication
				MCPlayerReplication(PlayerReplicationInfo).APf = MCPlayer.APf;
			}
		}
		*/









		// Search for replications
		foreach DynamicActors(Class'MCPawn', WhatPeople)
		{
			// If we find a Player 1 then give him some AP
			if (WhatPeople.PlayerUniqueID == TurnPlayer)
			{
				// Give person AP
				// Make a function that checks current statuses, and add that to APfMax and update the information.
			//	WhatPeople.APf = float CalculateNewAP(WhatPeople.APf)	
				WhatPeople.APf = WhatPeople.APfMax;

				`log("You" @ WhatPeople @ "got" @ WhatPeople.APf @ "new AP, congratulations");

				// Update his Replication
			//	MCPlayerReplication(PlayerReplicationInfo).APf = MCPlayer.APf;

			

			//	SetTilePathClient(TurnPlayer);
			}else
			{
				// Otherwise Reset AP
				WhatPeople.APf = 0.0;
				`log("MR" @ WhatPeople.PawnName @ "" @ WhatPeople.PlayerUniqueID @ "Got resetted");

				// Update his Replication
				MCPlayerReplication(PlayerReplicationInfo).APf = MCPlayer.APf;
			}
		}

	}




	// All Characters goes to WaitForTurn state
	GoToWaiting();
}

/*
// Function That makes Pawns go to WaitingForTurn State
*/
reliable client function GoToWaiting()
{
	GotoState('WaitingForTurn');
}

simulated function Craps2(int ID)
{
	`log("2 = INSIDE CRAPS!!" @ ID @ "PC.ID=" @PlayerUniqueID @ "MCPlayer.APf=" @ MCPlayer.APf);
	`log("2 = INSIDE CRAPS!!" @ ID @ "PC.ID=" @PlayerUniqueID @ "MCPlayer.APf=" @ MCPlayer.APf);
	`log("2 = INSIDE CRAPS!!" @ ID @ "PC.ID=" @PlayerUniqueID @ "MCPlayer.APf=" @ MCPlayer.APf);
	`log("2 = INSIDE CRAPS!!" @ ID @ "PC.ID=" @PlayerUniqueID @ "MCPlayer.APf=" @ MCPlayer.APf);
	Craps2Server(ID, MCPlayer);
	GetTilesAndPaths(ID, MCPlayer);
}

reliable server Function Craps2Server(int ID, MCPawn ServerPawn)
{
	`log("2 Server = INSIDE CRAPS!!" @ ID @ "PC.ID=" @PlayerUniqueID @ "MCPlayer.APf=" @ MCPlayer.APf);
	`log("2 Server = INSIDE CRAPS!!" @ ID @ "PC.ID=" @PlayerUniqueID @ "MCPlayer.APf=" @ MCPlayer.APf);
	`log("2 Server = INSIDE CRAPS!!" @ ID @ "PC.ID=" @PlayerUniqueID @ "MCPlayer.APf=" @ MCPlayer.APf);
	`log("2 Server = INSIDE CRAPS!!" @ ID @ "PC.ID=" @PlayerUniqueID @ "MCPlayer.APf=" @ MCPlayer.APf);
	`log("SentPawn =" @ ServerPawn);
	`log("MCPlayer =" @ MCPlayer);
	GetTilesAndPaths(ID, ServerPawn);
}

simulated function Craps()
{
	local MCPlayerController cMCPC;
	local PlayerController PC;

	`log("INSIDE CRAPS!!");
	`log("INSIDE CRAPS!!");
	`log("INSIDE CRAPS!!");
	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		cMCPC = MCPlayerController(PC);

		cMCPC.SetTilePathClient(1, cMCPC.Pawn);
	}
}

simulated function SetTilePathClient(int TurnPlayer, Pawn MyPawn)
{
	// In server
	`log("WHERE ARE WE NOW!!!!!!!!" @ TurnPlayer @ MyPawn);
	`log("WHERE ARE WE NOW!!!!!!!!" @ TurnPlayer @ MyPawn);
	`log("WHERE ARE WE NOW!!!!!!!!" @ TurnPlayer @ MyPawn);
	MeClient(TurnPlayer, MyPawn);
	MeServer(TurnPlayer, MyPawn);
//	GetTilesAndPaths(TurnPlayer, MyPawn);

//	GetTilesAndPaths(TurnPlayer);
}

reliable client function MeClient(int TurnPlayer, Pawn MyPawn)
{
	// On client. Both?
	`log("This is being displayed where? Client" @ TurnPlayer @ MyPawn);
	`log("This is being displayed where? Client" @ TurnPlayer @ MyPawn);
	`log("This is being displayed where? Client" @ TurnPlayer @ MyPawn);
	GetTilesAndPaths(TurnPlayer, MyPawn);
}

reliable server function MeServer(int TurnPlayer, Pawn MyPawn)
{
	// On client. Both?
	`log("This is being displayed where? Server" @ TurnPlayer @ MyPawn);
	`log("This is being displayed where? Server" @ TurnPlayer @ MyPawn);
	`log("This is being displayed where? Server" @ TurnPlayer @ MyPawn);
	GetTilesAndPaths(TurnPlayer, MyPawn);
}

/*
// Just a function to check to see if pawn is spawned in the game, and then sets him to Mystras Champion Pawn
// Only on Client
*/
simulated function AcknowledgePossession( Pawn P )
{
	// If we have any form of Pawn then set him to MCPawn

    `log("AcknowledgePossession:"@ P);
    super.AcknowledgePossession(P);
}


simulated event Destroyed()
{
	Local MCHud MyMCHud;
	local MouseInterfaceHUD MouseInterfaceHUD;

	MyMCHud = MCHud(myHUD);
	// Type cast to get our HUD
	MouseInterfaceHUD = MouseInterfaceHUD(myHUD);


	if (MyMCHud.GFxBattleUI != none)
	{
		MyMCHud.GFxBattleUI.close(true);
	}

	if (MouseInterfaceHUD != none)
	{
		MouseInterfaceHUD.MouseInterfaceGFx.close(true);
	}

	if (LocalPlayer(Player) != None)
	{
		LocalPlayer(Player).ViewportClient.bDisableWorldRendering = false;
	}

	KillMCEnemy();

	MCPlayer.Destroy();

	Super.Destroyed();
}

reliable server function KillMCEnemy()
{
	local MCPlayerController MCPC;
	foreach DynamicActors(class'MCPlayerController', MCPC)
	{
		MCPC.MCEnemy = none;
	}

	SetNewMCEnemy();
}

reliable client function SetNewMCEnemy()
{
	local MCPawn NewMCP;

	foreach DynamicActors(class'MCPawn', NewMCP)
	{
		if (NewMCP != MCPlayer)
		{
			MCEnemy = NewMCP;
		}
	}
}



/*
// Function that Turns of the Tiles after lightover
// @NOT_USING currently not being used
*/


















































/*
// Function that check which Tiles we can go to and add them to an Array so that we can Light them Up
*/
reliable client function FindPathsWeCanGoTo()
{
	local int index;	// Where we start to remove/insert ni the array
	local int i;

	// start by setting start index for adding Tiles to 0
	index=0;
	// remove old Tiles so that we can add new Tiles
	CanUseTiles.Remove(index, CanUseTiles.length);

	// do we want to add tiles
	if (bIsTileActive)
	{
		// Search all of our current Tiles
		for (i = 0; i < MCA.Tiles.Length ; i++)
		{
			// Only search MoveTargets that are withing a certain range from the Player. This makes it less laggy when using this function after moving etc
			if ( VSize(MCPlayer.Location - MCA.Tiles[i].Location) < (MCPlayer.APf * ((128)+16)) )
			{
				// find the Tiles we can move towards
				MoveTarget = FindPathToward(MCA.Tiles[i]);
			}else
			{
				MoveTarget = none;
			}

			// if we have a Movetarget, AP and if that Tiles PathNode is not blocked then add them to an Array
			//if (MoveTarget != none && getPathAPCost() <= MCPawn.APf && !MCA.Tiles[i].PathNode.bBlocked)
			// @BUG MCEnemy Is not found at start spawn. Find solution. (Doesn't mater if they spawn far from eachother)
			if (MoveTarget != none && getPathAPCost() <= MCPlayer.APf && !MCA.Tiles[i].PathNode.bBlocked)
			{
		//		`log("How Far =" @VSize(MCPlayer.Location - MCA.Tiles[i].Location));
				if (MCEnemy != none)
				{
					// Temp bug fix for the bug up here
					if (VSize(MCEnemy.Location - MCA.Tiles[i].Location) > 50.0f)
					{
						CanUseTiles.InsertItem(index++,MCA.Tiles[i]);
					}
				}else
				{
					CanUseTiles.InsertItem(index++,MCA.Tiles[i]);
				}

				
			}
			else
			{
				// Otherwise turn of other Tiles, if this is not used then it will keep all Tiles Lit up
				// If it's not spellmode the don;t use
			//	if(!MCA.Tiles[i].bSpellTileMode)
			//	{
					MCA.Tiles[i].ResetTileToNormal();
			//	}
			//	else
			//	{
				//	MCA.Tiles[i].SetFireFountain();
			//	}
			}
		}

		// If he Pawn has 0 AP reset adding Tiles until next round
		if (MCPlayer.APf == 0)
		{
			bIsTileActive = true;		
		}else
		{	
			// Otherwise turn of using this function
			bIsTileActive = false;
		}

		// resets Movetarget to 0 so we don't bug out
		MoveTarget = FindPathToward(MCPlayer);

		// turn on the added Tiles in the Array
		TurnTilesOn();
		TurnTileSpellModeOn();	// If Tile has damage set here
	}
}

/*
// Light up all Tiles that we can move towards
*/
simulated function TurnTilesOn()
{
	local int i;

	for (i = 0;i < CanUseTiles.length ; i++)
	{
		if(CanUseTiles[i].bSpellTileMode)
		{
		//	CanUseTiles[i].SetActiveTiles();
		//	CanUseTiles[i].SetFireFountain();
		//	`log("TurnTilesOn NONO" @ CanUseTiles[i]);
		}else
		{
			CanUseTiles[i].SetActiveTiles();
		}
	}
}

/*
// Turn of Tiles, used in certain spells
*/
simulated function TurnOffTiles()
{
	local int i;

	for (i = 0;i < CanUseTiles.length ; i++)
	{
		if(CanUseTiles[i].bSpellTileMode)
		{
		//	`log("TurnOffTiles NONO" @ CanUseTiles[i]);
		}else
		{
			CanUseTiles[i].ResetTileToNormal();
		}
		
	}
}

/*
// Function that calculates how much it cost to a certain destination and then
// return a number equal to what AP it should cost
*/
simulated function int getPathAPCost()
{
	local int i,j;
	local int NewAPCost;	// What will the AP be

/*
769.1558	6 AP
641.3865	5 AP
513.7321	4 AP
386.3063	3 AP
259.4467	2 AP
134.7612	1 AP
*/


	// Search all Paths to get What RouteCache we have
	for (j = 0;j < MCA.Paths.Length; j++)
	{

		for (i = 0; i < RouteCache.Length; i++)
		{
			// If they are the same then add the new AP
			if (RouteCache[i] == MCA.Paths[j])
			{
				NewAPCost += MCA.Paths[j].APValue;
				// If AP is equal to AP or a little bit more then stop the search
				if (MCPlayer.APf < NewAPCost)
				{
					//`warn("You're Cost is Too much"@ NewAPCost);
				}
			}
		}
		
	}

	// Return our new Cost
	return NewAPCost;
}


/*
// @NOTUSING
*/
simulated function GetTilesAndPaths(int PlayerID, Pawn MyPawn)
{
	local MCPathNode PathNode;
	local MCTile Tile;
//	FireTiles.Remove(index, FireTiles.length);
//	FireTiles.InsertItem(index++,MCA.Tiles[i]);

	// Start by removing current once
	MCA.Tiles.Remove(0, MCA.Tiles.length);
	MCA.Paths.Remove(0, MCA.Paths.length);

	`log("-------------------------------------------");
	`log("-------------------------------------------");
	`log("Current MCPlayer.PlayerUniqueID" @ MCPlayer.PlayerUniqueID);
	`log("Current PlayerID" @ PlayerID);
	`log("Current MCPlayer" @ MCPlayer);
	`log("Current Sent MCPlayer" @ MyPawn);
	`log("-------------------------------------------");
	`log("-------------------------------------------");
	`log("Inside foreach with" @ MCPlayer @"and AP is" @MCPlayer.APf);
	// Adds Tiles and PathNode in to an array if they are close to eachother
	if (MCPlayer.APf > 0)
	{
		`log("We have AP to add this");
		
		foreach DynamicActors(Class'MCTile', Tile)
		{
			// takes players current ap and check around him for every AP point + 10, (+10 is to make sure we get enought space to find it)
		//	if ( PlayerID == MCPlayer.PlayerUniqueID && VSize(MCPlayer.Location - Tile.Location) < (MCPlayer.APf * ((128)+10)) )
			if ( VSize(MCPlayer.Location - Tile.Location) < (MCPlayer.APf * ((128)+10)) )
			{
				foreach WorldInfo.AllNavigationPoints(Class'MCPathNode', PathNode)
				{
					if ( VSize(Tile.Location - PathNode.Location) < 70.0f)
					{
				//		`log("Tile" @ Tile @ "PathNode" @ PathNode);
					//	`log("Tile Location    " @ Tile.Location.X @ " " @ Tile.Location.Y );
					//	`log("PathNode Location" @ PathNode.Location.X @ " " @ PathNode.Location.Y );
					//	`log("Vsize bitch" @ VSize(Tile.Location - PathNode.Location) );
					//	`log("----------------------------------------------------------");
						MCA.Paths.AddItem(PathNode);
						continue;
					}
				}
				
				MCA.Tiles.AddItem(Tile);
				continue;
			}
		}
		`log("Before Sending" @ MCA.Tiles.length);
		ClearTimer('GetTilesAndPaths');
		
	//			TurnOffTiles();
	//			TurnTilesOn();
	//	TurnTileSpellModeOn();	// If Tile has damage set here
		
	}else
	{
	//	SetTimer(0.3f, true, 'GetTilesAndPaths');
	}
}


reliable client function TurnTileSpellModeOn()
{
	local int i;
	for (i = 0; i < MCA.Tiles.Length ; i++)
	{
		if(MCA.Tiles[i].bSpellTileMode)
		{
			MCA.Tiles[i].ShowDisplayColor();
		}
	}
}

// PlayerWalking is the main state (set by mouseinterface controller).
// Can we go to somewhere with the current AP checks, and the press to
// go there.
auto state PlayerWalking
{
	ignores SeePlayer, HearNoise, Bump;

	function BeginState(Name PreviousStateName)
	{
		`log( "Welcome to" @ GetStateName() );
		Super.BeginState(PreviousStateName);
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// function that will use find mouseover to find what location to go to
	// if we can use mouse over & out that would be better
	function PlayerTick(float DeltaTime)
	{
		local int i;
		local Actor DestActor;
		local MouseInterfaceHUD MouseInterfaceHUD;	
		local actor HitActor;			// What Tile we are looking at

		// if it's not battlemap then we return, aka if it's town or select screen don't use this function
		if (WorldInfo.GetMapName() != "movement_test16")
			return;
		// If we don't have matchmode on
		if (!CameraProperties.bSetToMatch)
			return;

		// Spell Move
		if (MCPlayer != none && !bCanStartMoving && bIsSpellActive && CameraProperties.bSetToMatch)
		{
			MouseInterfaceHUD = MouseInterfaceHUD(myHUD);
			HitActor = MouseInterfaceHUD.HitActor2;

			// Do this Click if it's a Projectile Spell
			if (InstantiateSpell != none && InstantiateSpell.Type == eProjectile){	return;	}
			// Do this Click if it's an Area kind of Spell
			else if(InstantiateSpell != none && InstantiateSpell.Type == eArea)
			{
				PlayerTickSpellArea(HitActor);
			}
			// Do this Click if it's an Status kind of Spell
			else if(InstantiateSpell != none && InstantiateSpell.Type == eStatus){	return;	}
		}

		// For normal draggin mouse around with movement if click
		else if (MCPlayer != none && !bCanStartMoving && !bIsSpellActive && CameraProperties.bSetToMatch)
		{
			// Type cast to get our HUD
			MouseInterfaceHUD = MouseInterfaceHUD(myHUD);
			// What tile
			HitActor = MouseInterfaceHUD.HitActor2;
		
			// Sets PathNode to what actor we want it to target.
			if (HitActor.tag == 'MouseInterfaceKActor' || HitActor.tag == 'MCTile' )
			{
				for (i = 0; i < MCA.Tiles.Length; i++)
				{
					if (MCA.Tiles[i].name == HitActor.name)
					{
						//`log("Tile" @ MCA.Tiles[i] @ "  and PathNode" @ MCA.Paths[i]);
						// sets PathNode to DestActor
						DestActor = MCA.Tiles[i];
					}
				}
			}

			// If we Just got 6 AP and if You can jump in to FindPathsWeCanGoTo() then go
			if (MCPlayer.APf == 6 && bIsTileActive)
			{
				FindPathsWeCanGoTo();
			}

			// For debugging Where we can go destroys it's flag
			if (SpawnActor != none && bDebugFlag)
			{
				foreach AllActors(Class'MCTestActor', SpawnActor)
				{
					SpawnActor.destroy();
					continue;
				}
			}

			// Checking if we can move to the destination by hoovering over it
			if (DestActor != None)
			{
				// Where we should go to
				ScriptedMoveTarget = DestActor;

				// Set First Path we should move towards if we move
				MoveTarget = FindPathToward(ScriptedMoveTarget);

				// If we have a Path && if we have AP
				if (MoveTarget != None && getPathAPCost() <= MCPlayer.APf) 
				{
					if (bDebugFlag)
					{				
						// Debugging direction where we should go to
						for (i = 0;i < RouteCache.Length; i++)
						{
							SpawnActor = Spawn(class'MCTestActor', , , RouteCache[i].Location,);
						}
					}
					
				}
			}
		}
		global.PlayerTick(DeltaTime);
	}
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// sets of the click to move place
	exec function StartFire(optional byte FireModeNum)
	{
		local MouseInterfaceHUD MouseInterfaceHUD;	
		local actor HitActor;			// What Tile we are looking at
		local MCTile NewMCTile;
		local int i;

		if (SpawnActor != none && bDebugFlag)
		{
			// debug For Flag to kill them off
			foreach AllActors(Class'MCTestActor', SpawnActor)
			{
				SpawnActor.destroy();
				continue;
			}
		}

	//	TurnOffTiles();

		// Type cast to get our HUD
		MouseInterfaceHUD = MouseInterfaceHUD(myHUD);
		// What tile
		HitActor = MouseInterfaceHUD.HitActor2;

		// next is to set destination to pathnode and not tile
		if (HitActor.tag == 'MouseInterfaceKActor' || HitActor.tag == 'MCTile' )
		{
			// Spells Press
			if (MCPlayer != none && !bCanStartMoving && bIsSpellActive)
			{
				// Do this Click if it's a Projectile Spell
				if (InstantiateSpell != none && InstantiateSpell.Type == eProjectile){	return;	}
				// Do this Click if it's an Area kind of Spell
				else if(InstantiateSpell != none && InstantiateSpell.Type == eArea)
				{
					StartFireSpellArea(HitActor);
				}
				// Do this Click if it's an Status kind of Spell
				else if(InstantiateSpell != none && InstantiateSpell.Type == eStatus){	return;	}
			}

			// Moving Press, no spell, not having mouse on spell button, not moving
			else if (MCPlayer != none && !bCanStartMoving && !bIsSpellActive && !bButtonHovering)
			{
				//if you have AP and you can not move
				if (getPathAPCost() <= MCPlayer.APf) 
				{
					// Set What Tile is clicked
					if (HitActor.tag == 'MouseInterfaceKActor' || HitActor.tag == 'MCTile' )
						for (i = 0; i < MCA.Tiles.Length; i++)
							if (MCA.Tiles[i].name == HitActor.name)
								NewMCTile = MCA.Tiles[i];

					// If Targeted Tile is !bBlocked we can move there
					if (!NewMCTile.PathNode.bBlocked)
					{
					//	`log("MOVING!!!!");
						NewHitActor = NewMCTile.PathNode;
						if (VSize(MCEnemy.Location - NewHitActor.Location) > 50.0f)
						{
							OnAIMoveToActor();
							bCanStartMoving = true;
						}	
					}else
					{
					//	`log("WE CAN't MOVE!");
					}
		
				}
			}
		}
		super.StartFire(FireModeNum);
	}

	event PushedState()
	{
		if (Pawn != None)
		{
			// make sure the pawn physics are initialized
			Pawn.SetMovementPhysics();
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	function PlayerMove(float DeltaTime)
	{
		local vector NewAccel;	// where we want to go
		local vector X,Y,Z;		// Axes (Not used?)
		local vector PlayerPosition, Destination;	// rotation
		local rotator newRotation;	// set previous vectors as new location

		// If we got Spell then we don't move
		if (bIsSpellActive){	return;	}

		else if( MCPlayer != none && ScriptedMoveTarget != None && !MCPlayer.ReachedDestination(ScriptedMoveTarget) && bCanStartMoving && !bIsSpellActive)
		{
			GetAxes(Pawn.Rotation,X,Y,Z);

			//update our rotation location
			PlayerPosition.X = Pawn.Location.X;
			PlayerPosition.Y = Pawn.Location.Y;

			Destination.X = ScriptedMoveTarget.Location.X;
			Destination.Y = ScriptedMoveTarget.Location.Y;

			// set Rotation
			newRotation = Rotator(Destination - PlayerPosition);
			Pawn.SetRotation(newRotation);
			UpdateRotation( DeltaTime );
			
			if ( IsLocalPlayerController() )
			{
				AdjustPlayerWalkingMoveAccel(NewAccel);
			}
			
			// This is the END DESTINATION, if it's only one pathnode then yes go there otherwise no find a path before.
			if ( ActorReachable(ScriptedMoveTarget) )
			{
				// Move towards the Last Location / Pressed Location	
				NewAccel -= normal(Pawn.Location - ScriptedMoveTarget.Location);
				NewAccel.Z	= 0;
				NewAccel = Pawn.AccelRate * Normal(NewAccel);
			}
			else
			{
				// attempt to find a path to the next Location
				MoveTarget = FindPathToward(ScriptedMoveTarget);
				
				// take next Path and go there
				if (MoveTarget != None)
				{
					// Move towards the next PathNode Location
					NewAccel -= normal(Pawn.Location - MoveTarget.Location);
					NewAccel.Z	= 0;
					NewAccel = Pawn.AccelRate * Normal(NewAccel);
				}
				else
				{
					// abort the move
					`warn("Failed to find path to"@ ScriptedMoveTarget);
					ScriptedMoveTarget = None;
				}
			}
		}

		if (MCPlayer.ReachedDestination(ScriptedMoveTarget) && bCanStartMoving)
		{
			// Check AP Cost to see if we can continue
			CheckCurrentAPCalculation();
		}

		// ROLE_Authority is used for the server or the machine which is controlling the actor.
		if( Role < ROLE_Authority ) // then save this move and replicate it
		{
			ReplicateMove(DeltaTime, NewAccel, DCLICK_None, newRotation);
			//ReplicateMove(DeltaTime, NewAccel, DCLICK_None, OldRotation - Rotation);
		}
		else
		{
			ProcessMove(DeltaTime, NewAccel, DCLICK_None, newRotation);
			//ProcessMove(DeltaTime, NewAccel, DCLICK_None, OldRotation - Rotation);
		}
	//	super.PlayerMove(DeltaTime);
	}

	function EndState(Name NextStateName)
	{
		`log( "Bye Bye" @ GetStateName() );
	}
}

// SpellMode is active use this for Area Spells
// @param	ClickedTileActor	Where the mouse is currently at
//
function PlayerTickSpellArea(Actor ClickedTileActor)
{
	local int i;

	// If we are placing mouse on this place light up this tile to a special color
	if (ClickedTileActor.tag == 'MouseInterfaceKActor' || ClickedTileActor.tag == 'MCTile' )
		for (i = 0; i < FireTiles.Length; i++)
			if (FireTiles[i].name == ClickedTileActor.name)
				TileColor = FireTiles[i];
	
	// Turns Tile color
	SpellTileTurnOn();
/*
	// debug flag
	if (bDebugFlag)
	{				
		// Debugging direction where we should go to
		for (i = 0;i < FireTiles.length; i++)
		{
			if(FireTiles[i].PathNode != none)
			{
				SpawnActor = Spawn(class'MCTestActor', , , FireTiles[i].PathNode.Location,);
			}
		}
	}
*/
}

// SpellMode Clicking Area Spells
// @param	ClickedTileActor	Where the mouse is clicking
//
function StartFireSpellArea(Actor ClickedTileActor)
{
	local int i;

	// Set What Tile is clicked
	if (ClickedTileActor.tag == 'MouseInterfaceKActor' || ClickedTileActor.tag == 'MCTile' )
	{
		for (i = 0; i < FireTiles.Length; i++)
		{
			if (FireTiles[i].name == ClickedTileActor.name && FireTiles[i].PathNode != none)
			{
				ClickSpell = FireTiles[i];
				break;
			}
		}
	}

	if(ClickSpell != none)
	{
		// This is client only, remove AP
		`log("initialized " @ InstantiateSpell.name);
		MCPlayer.APf -= InstantiateSpell.AP;
		MCPlayerReplication(PlayerReplicationInfo).APf = MCPlayer.APf;

		// Send spell to Server to activate
		SendSpellToServer(MCPlayer, ClickSpell, ClickSpell.PathNode);
	//	SendSpellToClient(MCPlayer, ClickSpell, ClickSpell.PathNode);	// not needed, inside spell we also do the client

		// Set spell mode off && destroy it
		bIsSpellActive = false;
		InstantiateSpell.Destroy();
		InstantiateSpell = none;

		// Turn of Tiles, Check for remaining AP, Reset Tile we clicked on
		SpellTileTurnOff();
		SetTimer(1.0f,false,'CheckCurrentAPCalculation');
		ClickSpell = none;

		FireTiles.Remove(0, FireTiles.length);
	}else
	{
		`log("No place to set spell");
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
// Test State for Waiting at start
*/
state WaitingForTurn
{
	function BeginState(Name PreviousStateName)

	{
		`log( "Welcome to" @ GetStateName() );
	//	if (MCPlayer.APf == 0)
	//	{
			//ChangePathOn();
	//	}
	}

	function PlayerTick(float DeltaTime)
	{

		if (MCPlayer != none && MCEnemy != none)
		{
			if (MCPlayer.APf == 0 && MCEnemy.APf == 0)
			{
			//	`log("Let's Go To AdjustCamera Shall we");
				//GotoState('AdjustCamera');
			}

			if (MCPlayer.APf == 6 && MCEnemy.APf == 0 && !IsInState('PlayerWalking'))
			{
				`log("Let's Go To PlayerWalking Shall we");
				GotoState('PlayerWalking');
			}
		}
	//	super.PlayerTick(DeltaTime);
	}

	function EndState(Name NextStateName)
	{
		`log( "Bye Bye" @ GetStateName() );
	//	if (MCPlayer.APf < 6)
	//	{
		//	ChangePathOff();
	//	}
	}
}

//
// When in Waiting state you set the Pawns block and ExtraCost so that the enemy can't touch him
// @NOTUSING
reliable client function ChangePathOff()
{
	local int i;

	for (i = 0; i < MCA.Paths.Length ; i++)
	{
		if ( VSize(MCPlayer.Location - MCA.Paths[i].Location) < 50.0f )
		{
//			`log("Where we at" @ MCA.Paths[i]);
		//	MCA.Paths[i].bBlocked = false;
			MCA.Paths[i].ExtraCost = 0;
			break;
		}
	}
}

//
// Check After movement and Spell use to see if we have AP or we change person
//
reliable client function CheckCurrentAPCalculation()
{
	bCanStartMoving = true;

	if (MCPlayer.APf < 0.90f && MCPlayer.PlayerUniqueID == 1 && IsInState('PlayerWalking') && bCanStartMoving)
	{
		`log("CheckCurrentAPCalculation - we will change AP from" @ MCPlayer.PawnName @ "to" @ MCEnemy);
		SetWhoseTurn(2);
	}
	else if (MCPlayer.APf < 0.90f && MCPlayer.PlayerUniqueID == 2 && IsInState('PlayerWalking') && bCanStartMoving)
	{
		`log("CheckCurrentAPCalculation - we will change AP from" @ MCPlayer.PawnName @ "to" @ MCEnemy);
		SetWhoseTurn(1);
	}

	bIsTileActive = true;		// sets Tiles on
	// Change so that we update the bBlocked
	FindPathsWeCanGoTo();
	// sets movement off
	bCanStartMoving = false;
	ScriptedMoveTarget = none;
}



/*
// Set up Player Stats to link them all with Scaleform
// @param		WhoseTurnIsIt	Sets what person we will switch to
// @network						Client
*/
simulated function SetWhoseTurn(int WhoseTurnIsIt)
{
	// Track Enemy
//	CameraProperties.IsTrackingEnemyPawn = true;
	//AdjustCamera
	// Sets next person
	if (WhoseTurnIsIt == 1)
	{
		SetTimer(1.0f, false, 'TurnBasedOne');

	}else if(WhoseTurnIsIt == 2)
	{
		SetTimer(1.0f, false, 'TurnBasedTwo');
	}
}

/*
// Cooldown until next persons round will be calculated
// @network						Client
*/
function TurnBasedTwo()
{
//	CameraProperties.IsTrackingEnemyPawn = false;
	TurnBased(2);
}

/*
// Cooldown until next persons round will be calculated
// @network						Client
*/
function TurnBasedOne()
{
//	CameraProperties.IsTrackingEnemyPawn = false;
	TurnBased(1);
}




//
// When in Waiting state you set the Pawns block and ExtraCost so that the enemy can't touch him
//
reliable server function ChangePathOn()
{
	local int i;
//	local MCRock rock;

	for (i = 0; i < MCA.Paths.Length ; i++)
	{
		if ( VSize(MCPlayer.Location - MCA.Paths[i].Location) < 50.0f)
		{
//			`log("Where we at" @ MCA.Paths[i]);
			MCA.Paths[i].bBlocked = true;
			//MCA.Paths[i].ShutDown();
			MCA.Paths[i].ExtraCost = 500;
		//	`log("PawnBlock =" @ MCA.Paths[i]);

			//break;
		}
		/*else if (VSize(MCEnemy.Location - MCA.Paths[i].Location) < 50.0f)
		{
			MCA.Paths[i].bBlocked = true;
			
			MCA.Paths[i].ExtraCost = 500;

		//	`log("EnemyBlock =" @ MCA.Paths[i]);
		}
		*/
		else
		{
			MCA.Paths[i].bBlocked = false;
			//MCA.Paths[i].ShutDown();
			MCA.Paths[i].ExtraCost = 0;
		//	`log("NoBlock =" @ MCA.Paths[i]);
		}
	}
}

















/*
// Changes AP calculation Replication so that the Enemy can see Main Players AP change instantly.
*/
reliable server function ChangeAPWithMove(int RouteLength, int PlayerID)
{
	local MCPawn WhatPeople;

	foreach DynamicActors(Class'MCPawn', WhatPeople)
	{
		if (WhatPeople.PlayerUniqueID == PlayerID)
		{
			`log("AP" @ WhatPeople.APf @ "-" @ RouteLength);
			WhatPeople.APf -= RouteLength;
			`log("AP is now=" @ WhatPeople.APf);
			MCPlayerReplication(PlayerReplicationInfo).APf = MCPlayer.APf;
		}
	}
}

/*
// This will set of the current Pawn to go into walking mode + reduce it's AP.
// It will also use ChangeAPWithMove() to change AP after each click according to AP cost.
*/
reliable client function OnAIMoveToActor()
{
	local Actor DestActor;
	local int SendAPCost;

	// sets PathNode to DestActor
	DestActor = NewHitActor;

	// if we found a valid destination
	if (DestActor != None)
	{

		`log("AP" @ MCPlayer.APf @ "-" @ getPathAPCost());
		// Calculate AP Cost
		MCPlayer.APf -= getPathAPCost();
		SendAPCost = getPathAPCost();
		//MCPawn.APf = MCPlayerReplication(PlayerReplicationInfo).APf;
		`log("AP is now=" @ MCPlayer.APf);
		`log("SendAPCost =" @ SendAPCost);
		// Enemy can also see AP reduction
		ChangeAPWithMove(SendAPCost, MCPlayer.PlayerUniqueID);
		
		// Set so that we will be Walking
		if (!IsInState('PlayerWalking'))
		{
			//PushState('PlayerWalking');
			GotoState('PlayerWalking');
		}

		// Sets new actor as the Move target in PlayerMove
		ScriptedMoveTarget = DestActor;
	}
	else
	{
		`warn("Invalid destination for scripted move");
	}
}

















/*
// If we have a stonewall or firefountain active set the Tiles in a color
*/
simulated function SpellTileTurnOn()
{
	local int i;

	for (i = 0;i < FireTiles.length ; i++)
	{
		// If it has a pathnode in the tile
		if(FireTiles[i].PathNode != none)
		{
			//  && !FireTiles[i].PathNode.bBlocked @FIX
			// Indicates Red Mark
			if (TileColor == FireTiles[i])
			{
				if (InstantiateSpell != none)
				{
					// If Spell is Dissolved Element, show a Yellow color to stop it, prob change to an X mark or something later on
					if (InstantiateSpell.spellNumber == 25)
						FireTiles[i].bDissolveElement = true;
				}
				// we can target it here
				FireTiles[i].SpellMarkTileMain();
			}
			/*
			// Indicate an area we are using allready, special for Dissolve Element
			else if (TileColor != FireTiles[i] && InstantiateSpell.spellNumber == 25)
			{
				`log("We Found Spell");
				// If it's Dissolve Element
			//	if (InstantiateSpell.spellNumber == 25)
			//	{
					`log("Dissolve");
					FireTiles[i].SpellMarkDissolveArea();
			//	}
			}
			*/
			// Indicates LightBlue to show surrounding
			else
			{
				FireTiles[i].SpellMarkTileArea();
			}
		}
	}
}
/*
// remove color
*/
function SpellTileTurnOff()
{
	local int i;

	for (i = 0;i < FireTiles.length ; i++)
	{
		FireTiles[i].ResetTileToNormal();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//	Camera Functions for the game 
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

exec function MCZoomIn()
{
		CameraProperties.MovementPlane.Z -= CameraProperties.ZoomSpeed;
	//`log("Zooming IN NOW!!!!");
	//`log(CameraProperties.MovementPlane.Z);
}

exec function MCZoomOut()
{
	CameraProperties.MovementPlane.Z += CameraProperties.ZoomSpeed;
	//`log("Zooming OUT NOW!!!!");
	//`log(CameraProperties.MovementPlane.Z);
}

/*
exec function MCRotationLeft()
{
	CameraProperties.Rotation.Roll += CameraProperties.RoationSpeed;
}

exec function MCRotationRight()
{
	CameraProperties.Rotation.Roll -= CameraProperties.RoationSpeed;
}
*/
// Will move Camera to The Hero When pressed
exec function MCTrackHero()
{
	if (CameraProperties.IsTrackingHeroPawn)
	{
		CameraProperties.IsTrackingHeroPawn = false;
		`log("Setting to false");
		return;
	}else
	{
		CameraProperties.IsTrackingHeroPawn = true;
		`log("Setting to true");
		return;
	}
}

// @NOTUSING
simulated function moveCameraEnemy()
{
	`log("HI ME LOGGING");
	CameraProperties.IsTrackingEnemyPawn = true;
	SetTimer(1.0f, false, 'stopMpveCameraEnemy');
}
// @NOTUSING
simulated function stopMpveCameraEnemy()
{
	CameraProperties.IsTrackingEnemyPawn = false;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Spells
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

reliable client function CheckDistanceNearPlayer()
{
	local int index;	// Where we start to remove/insert ni the array
	local int i;

	// start by setting start index for adding Tiles to 0
	index=0;
	// remove old Tiles so that we can add new Tiles
	FireTiles.Remove(index, FireTiles.length);

	// do we want to add tiles
	if (bIsSpellActive)
	{
		// Search all of our current Tiles
		for (i = 0; i < MCA.Tiles.Length ; i++)
		{
			/*
			// find the Tiles we can move towards
			if (bIsSelectingFireFountain && VSize(MCPlayer.Location - MCA.Tiles[i].Location) < 230.0f &&
				VSize(MCPlayer.Location - MCA.Tiles[i].Location) > 70.0f)
			{
				FireTiles.InsertItem(index++,MCA.Tiles[i]);
			}else
			{
				// Otherwise turn of other Tiles, if this is not used then it will keep all Tiles Lit up
				MCA.Tiles[i].ResetTileToNormal();
			}
			// find the Tiles we can move towards
			if (bIsSelectingStoneWall && VSize(MCPlayer.Location - MCA.Tiles[i].Location) < 230.0f &&
				VSize(MCPlayer.Location - MCA.Tiles[i].Location) > 70.0f &&
				VSize(MCEnemy.Location - MCA.Tiles[i].Location) > 70.0f)
			{
				FireTiles.InsertItem(index++,MCA.Tiles[i]);
			}else
			{
				// Otherwise turn of other Tiles, if this is not used then it will keep all Tiles Lit up
				MCA.Tiles[i].ResetTileToNormal();
			}
			*/

			// new 2014-06-14
			// find the Tiles we can spawn something
			if (InstantiateSpell != none &&
				VSize(MCPlayer.Location - MCA.Tiles[i].Location) < InstantiateSpell.fMaxSpellDistance &&
				VSize(MCPlayer.Location - MCA.Tiles[i].Location) > InstantiateSpell.fCharacterDistance &&
				VSize(MCEnemy.Location - MCA.Tiles[i].Location) > InstantiateSpell.fCharacterDistance)
			{
				//  We Set What Tiles we can't use in here @FIX
			//	if(!MCA.Tiles[i].PathNode.bBlocked)
				if(InstantiateSpell.Type == eArea)
					FireTiles.InsertItem(index++,MCA.Tiles[i]);
			}else
			{
				// Otherwise turn of other Tiles, if this is not used then it will keep all Tiles Lit up
				if(!MCA.Tiles[i].bSpellTileMode)
					MCA.Tiles[i].ResetTileToNormal();
			}


		}

		// turn on the added Tiles in the Array
		SpellTileTurnOn();

		//bIsSpellActive = false;
	}
}

//01
exec function MySpell(byte SpellIndex)
{
//	local int i;
	// If Spell Is not made then we abort here
	if (!MyArchetypeSpells[SpellIndex].bIsEnabled)
	{
		`log("Spell Can not be used.");
		return;
	}

	// check if we have enought AP to use the spell
	if (MyArchetypeSpells[SpellIndex].AP <= MCPlayer.APf)
	{
		// If this is on the client, then sync with the server
		if (Role < Role_Authority)
		{
			ServerActivateSpell(SpellIndex);
			`log("0 - Client Sends things to Server");
		}

		// Begin casting the spell
		BeginActivatingSpell(SpellIndex);
	}
	// Show message that says we don&t have enought AP
	else
	{
		`log("Not enought AP, missing" @ MyArchetypeSpells[SpellIndex].AP - MCPlayer.APf);
	}
}

//02
reliable server function ServerActivateSpell(byte SpellIndex)
{
//	local int i;
	// Clients can never run this
	if (Role < Role_Authority)
	{
		return;
	}

	// Remove Previous List to add a newer one
	MyArchetypeSpells.Remove(0,MyArchetypeSpells.length);

	// Add Spells of tis char
	if (MyArchetypeSpells.length == 0)
	{
		// Add All the spells
		AddSpells(MCPlayerReplication(PlayerReplicationInfo).currentSpells01, 0);
		AddSpells(MCPlayerReplication(PlayerReplicationInfo).currentSpells02, 1);
		AddSpells(MCPlayerReplication(PlayerReplicationInfo).currentSpells03, 2);
		AddSpells(MCPlayerReplication(PlayerReplicationInfo).currentSpells04, 3);
	}

	`log(MCPlayerReplication(PlayerReplicationInfo).PawnName @ "Is doing this");
	`log("MyArchetypeSpells.length=" @ MyArchetypeSpells.length);

	// check if we have replication etc
	`log("0 - Server Gets things and activates spell, index=" @ SpellIndex);
	// Begin activating the spell
	BeginActivatingSpell(SpellIndex);
}

// 03
protected simulated function BeginActivatingSpell(byte SpellIndex)
{
//	local MCSpell InstantiateSpell;		// What we need to spawn the spell
	`log("1 - Spell Starts and we send it to MCSpell");
	`log("1 - MCPlayer =" @MCPlayer);
	`log("1 - MCEnemy  =" @MCEnemy);

	// Spawn the spell and Activate it for both Client && Server
	InstantiateSpell = spawn(MyArchetypeSpells[SpellIndex].Class, , , , , MyArchetypeSpells[SpellIndex]);
	InstantiateSpell.Activate(MCPlayer, MCEnemy);
}

/*
// Takes the Information from ClickButton and sends it in to the spell so it can Spawn on server & client
*/
protected reliable server function SendSpellToServer(MCPawn Caster, MCTile WhatTile, MCPathNode PathNode)
{
	if(Role == Role_Authority)
	{
		// Start by Reducing AP on server
		MCPlayer.APf -= InstantiateSpell.AP;
		MCPlayerReplication(PlayerReplicationInfo).APf = MCPlayer.APf;

		`log("We Are sending Spell to Server" @InstantiateSpell);
		InstantiateSpell.CastClickSpellServer(Caster, WhatTile, PathNode);

	//	InstantiateSpell.MeSpawn(WhatTile);
	}else
	{
		`log("We Are sending Spell to Server on client" @InstantiateSpell);
	}
}

// @NOTUSING
protected reliable client function SendSpellToClient(MCPawn Caster, MCTile WhatTile, MCPathNode PathNode)
{
	if(Role == Role_Authority)
	{
	}
	// Send to Client
	else
	{
	//	InstantiateSpell.MeSpawn(WhatTile);
		`log("test send crap");
	}
}




// Send Status to PlayerReplication so that we can get who wins or Loses
simulated function SendWinLoseToReplication()
{
	local int i;

	if (Role == Role_Authority)
	{
		for (i = 0;i < MCGameReplication(WorldInfo.GRI).MCPRIArray.length ; i++)
		{
			MCGameReplication(WorldInfo.GRI).MCPRIArray[i].SendWinAndLoseMessage();
		}
	}

}

// Set Loss Message for The one who died
reliable client function SendLossMessage()
{
	local MCHud cMCHud;

	cMCHud = MCHud(myHUD);

	if (cMCHud != none)
	{
		cMCHud.GFxBattleUI.ShowLoseMessage(MCPlayerReplication(PlayerReplicationInfo).PawnName);
	}
}

// Set Win Message for The one who is alive and wins
reliable client function SendWinMessage()
{
	local MCHud cMCHud;

	cMCHud = MCHud(myHUD);
	if (cMCHud != none)
	{
		cMCHud.GFxBattleUI.ShowWinMessage(MCPlayerReplication(PlayerReplicationInfo).PawnName);
	}
}



defaultproperties
{
	CameraClass=class'MystrasChampion.MCCamera'
	CameraProperties=MCCameraProperties'mystraschampionsettings.Camera.CameraProperties'

	// Custom made buttons for rotation
//	InputClass=class'MouseInterfacePlayerInput'
	InputClass=class'MCCustomButtons'

	bCanStartMoving=false
	bIsTileActive=true
	// Show a Flag that shows ehre you can go.
	bDebugFlag = false

	WizardArche01=Player01'mystraschampionsettings.Character.P01'
	WizardArche02=Player02'mystraschampionsettings.Character.P02'
	WizardArche03=Player03'mystraschampionsettings.Character.P03'
	WizardArche04=Player04'mystraschampionsettings.Character.P04'

	// Spell List
	MySpellList = MCSpellArchetypeList'MystrasChampionSpells.SpellList.AllArchetypeSpells'
}