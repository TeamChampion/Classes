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
	var int FirePoints, IcePoints, EarthPoints, AcidPoints, ThunderPoints;
	var int currentSpells01, currentSpells02, currentSpells03, currentSpells04;
	var int Level;
	var int Money;
	var bool bSetLevelLoadChar;

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
var Actor ScriptedMoveTarget;		// Move target from last scripted action
var Route ScriptedRoute;			// Route from last scripted action; if valid, sets ScriptedMoveTarget with the points along the route
var Actor NewHitActor;				// Setting MouseInterfaceActor to this and then assigning it to DescActor
var MCTestActor SpawnActor;			// debug Actor for showing where to go

//	Camera calling
///////////////////////////////////////////////
// The Camera Properties link
var const MCCameraProperties CameraProperties;

//	Replication Variables
///////////////////////////////////////////////
var int PlayerUniqueID;					// Player Unique ID
var playerstart closestPlayerStart;		// Used to set where our Player spawns and then assign ID
var MCPawn MCPlayer;					// This Controllers Pawn
var MCPawn MCEnemy;						// Enemy Pawn

//	Others
///////////////////////////////////////////////
// Struct that contains all the PathNodes and Tiles
struct MCActors
{
	var array<MCPathNode> Paths;
	var array<MCTile> Tiles;
};
var MCActors MCA;						// struct object
var bool bCanStartMoving;				// used for turning on and off PlayerMove, so they all don\t collide
var bool bIsTileActive;					// If true then we can look for places to
var array <MCTile> TilesWeCanMoveOn;	// Add Tiles to an array to later check what Tiles we are going to lightup

var bool bIsSpellActive;			// used to check if we have a spell in here, also used in different spells
var MCTile ClickSpell;				// When spell is clicked this jsut show that we have it
var bool bButtonHovering;			// From battleHud, used so we don't click on a Tile while clicking button
var MCTile TileColor;				// Used for when marking Spell on an area
var array <MCTile> FireTiles;		// What Tiles we have in a Spell area
var bool bDebugFlag;				// debugging flag shown, false for hiding it
var MCSpell InstantiateSpell;		// What we need to spawn the spell + use in PlayerTick, Click function for selecting spells etc
var array <MCTile> SpellTiles;		// What Tiles we have a Spell on

//----------------------------

/** Whether or not we are quitting to the main menu. */
var transient bool bQuittingToMainMenu;

/** The disconnect command stored from 'NotifyDisconnect', which is to be called when cleanup is done */
var string DisconnectCommand;

/** whether or not pre-disconnect cleanup is in progress */
var bool bCleanupInProgress;

/** whether or not cleanup has finished; if false, 'NotifyDisconnect' blocks disconnection */
var bool bCleanupComplete;



// Replication block
replication
{
	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		NewHitActor, ScriptedMoveTarget, MCA, MCPlayer, MCEnemy, bIsTileActive, HeroPawn;
	
	if(bNetDirty)
		setCharacterSelect, InstantiateSpell, ClickSpell, bIsSpellActive;

	if(bNetDirty)
		PlayerEmpty, PlayerStruct01, PlayerStruct02, PlayerStruct03, PlayerStruct04;
}


// Server only
event Possess(Pawn inPawn, bool bVehicleTransition)
{
	super.Possess(inPawn, bVehicleTransition);
	MCPlayer = MCPawn(inPawn);
}

// Just a function to check to see if pawn is spawned in the game, and then sets him to Mystras Champion Pawn
// Only on Client
simulated function AcknowledgePossession( Pawn P )
{
    super.AcknowledgePossession(P);
	// If we have any form of Pawn then set him to MCPawn
    `log("AcknowledgePossession:"@ P);
}
reliable client function SetCharStatsClient()
{
//	if ( Role < Role_Authority )
//	{
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

		`log("We have " @ PlayerEmpty.PawnName);
		`log("We have " @ PlayerEmpty.PawnName);
		`log("We have " @ PlayerEmpty.PawnName);
}




simulated event PostBeginPlay()
{
	CameraProperties.bSetToMatch = false;
    super.PostBeginPlay();


	if ( (WorldInfo.NetMode == NM_Client) )
		SetCharStatsClient();
	// If this is server && the one that hosted the server
	else if ( (WorldInfo.NetMode == NM_ListenServer) && self.name == 'MCPlayerController_0')
		SetCharStatsClient();
//	else if ( (WorldInfo.NetMode == NM_DedicatedServer) )
		// log do nothing
	else if ( (WorldInfo.NetMode == NM_StandAlone) )
	{
		// Set hero archetype after Character Select Number
		if (setCharacterSelect == 1)
			PlayerEmpty = PlayerStruct01;
		else if(setCharacterSelect == 2)
			PlayerEmpty = PlayerStruct02;
		else if(setCharacterSelect == 3)
			PlayerEmpty = PlayerStruct03;
		else if(setCharacterSelect == 4)
			PlayerEmpty = PlayerStruct04;

		// Set Characther Name
		ResetHeroName = ResetHeroPawn.PawnName2;
	}
	// For Standalone game we set Character Name for Scenario
//	if (WorldInfo.GetMapName() != "movement_test16" || WorldInfo.GetMapName() != "TestMoveAlot" )
//	{

//	}

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

	// Checks for Pawn, when we get him turn this off in the SetMyPawn function
	SetTimer(1.0f, true, 'SetMyPawn');
}

/*
// Adding Spells, @FIX for the time being just 4 spells in PostbeginPlay, make dynamic
*/
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

// Send from PlayercontrollerUsed in PlayerController when we set what Character Selected number we should spawn
reliable server function SetHeroNumberServer(int setServerChar)
{
	if (Role == Role_Authority)
	{
		setCharacterSelect = setServerChar;
	//	SetHero();
		`log("SETTING SetHeroNumberServer!!!!!!!!!");
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

	// Send Charachter Information
	if ( (WorldInfo.NetMode == NM_Client) )
		SendPawnInfoToServer();
	else if ( (WorldInfo.NetMode == NM_ListenServer && self.name == 'MCPlayerController_0') )
		SendPawnInfoToServer();
//	else if ( (WorldInfo.NetMode == NM_DedicatedServer) )
		// nothing

	// If we have any form of Pawn then set him to MCPawn
	if (Pawn != none)
		MCPlayer = MCPawn(Pawn);

	// If Pawn is found then stop the timer and clear the spam
	if (MCPlayer != none)
	{
		// For Standalone game we set Character Name for Scenario
		if (WorldInfo.GetMapName() != "movement_test16" || WorldInfo.GetMapName() != "TestMoveAlot")
		{
			if ( (WorldInfo.NetMode == NM_StandAlone) )
			{
				MCPlayer.PawnName = PlayerEmpty.PawnName;
				MCPlayer.PawnName2 = PlayerEmpty.PawnName;
			}
		}
		// Set PC in Pawn class
		MCPlayer.setYourPC(self);
		// Set unique ID to Players
		SetTimer(1.0, false, 'findClosestPlayerStart');

		// Check to see if we have 2 chars so that we can start
		ClearTimer('SetMyPawn');
	}
}

reliable client function SendPawnInfoToServer()
{
	setCharacterSelect = ResetCharSelect;

	// Set Archertype
	HeroPawn = ResetHeroPawn;
//	SendToServer = MyPawnReturn(ResetHeroPawn);

	SpawnThisNumberCharacter(setCharacterSelect, ResetHeroPawn);	//@FIX remove this prob, not being used, but test on both comps to confirm that it is not required
	CheckNewData(PlayerEmpty);
}

/*
// Sends correct Spawn number to server
// @param 		setServerChar		What charachter is selected from 1 - 4 in Select Screen
// @param 		setServerPawn		
*/
reliable server function SpawnThisNumberCharacter(int setServerChar, MCPawn setServerPawn)
{
	// Server only
	if (Role == Role_Authority)
	{
		setCharacterSelect = setServerChar;

		if (PlayerReplicationInfo != none)
			MCPlayerReplication(PlayerReplicationInfo).setCharacterSelect = setServerChar;

		// Same thing for Hero Archetype
		HeroPawn = setServerPawn;
		
		if (PlayerReplicationInfo != none)
			MCPlayerReplication(PlayerReplicationInfo).HeroArchetype = HeroPawn;
	}
}

reliable server function CheckNewData(PlayerStats MyStruct)
{
	if (Role == Role_Authority)
	{
		PlayerEmpty = MyStruct;
		if (PlayerReplicationInfo != none)
		{
			// Send Name
			MCPlayerReplication(PlayerReplicationInfo).PawnName = PlayerEmpty.PawnName;

			// Send Spells
			MCPlayerReplication(PlayerReplicationInfo).currentSpells01 = PlayerEmpty.currentSpells01;
			MCPlayerReplication(PlayerReplicationInfo).currentSpells02 = PlayerEmpty.currentSpells02;
			MCPlayerReplication(PlayerReplicationInfo).currentSpells03 = PlayerEmpty.currentSpells03;
			MCPlayerReplication(PlayerReplicationInfo).currentSpells04 = PlayerEmpty.currentSpells04;

			// Send Elemental Stats
			MCPlayerReplication(PlayerReplicationInfo).ResistanceValues[0] = PlayerEmpty.FirePoints;
			MCPlayerReplication(PlayerReplicationInfo).ResistanceValues[1] = PlayerEmpty.IcePoints;
			MCPlayerReplication(PlayerReplicationInfo).ResistanceValues[2] = PlayerEmpty.EarthPoints;
			MCPlayerReplication(PlayerReplicationInfo).ResistanceValues[3] = PlayerEmpty.AcidPoints;
			MCPlayerReplication(PlayerReplicationInfo).ResistanceValues[4] = PlayerEmpty.ThunderPoints;
		}
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
		return;

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

	if ( (WorldInfo.NetMode == NM_ListenServer) )
	{
		`log("Listen - findClosestPlayerStart - PC.PlayerUniqueID =" @ PlayerUniqueID );
		`log("Listen - findClosestPlayerStart - MCPlayer.PlayerUniqueID =" @ MCPlayer.PlayerUniqueID );
		`log("Listen - findClosestPlayerStart - closestPlayerStart =" @ closestPlayerStart );
		MCPlayer.changePlayerColor();
		MCPlayer.SpawnDecal();
	}
	else if ( (WorldInfo.NetMode == NM_DedicatedServer) )
	{
		`log("Server - findClosestPlayerStart - PC.PlayerUniqueID =" @ PlayerUniqueID );
		`log("Server - findClosestPlayerStart - MCPlayer.PlayerUniqueID =" @ MCPlayer.PlayerUniqueID );
		`log("Server - findClosestPlayerStart - closestPlayerStart =" @ closestPlayerStart );
	}
	else if ( (WorldInfo.NetMode == NM_Client) )
	{
		`log("Client - findClosestPlayerStart - PC.PlayerUniqueID =" @ PlayerUniqueID );
		`log("Client - findClosestPlayerStart - MCPlayer.PlayerUniqueID =" @ MCPlayer.PlayerUniqueID );
		`log("Client - findClosestPlayerStart - closestPlayerStart =" @ closestPlayerStart );
	}

	// Start looking for Enemy Player
    SetTimer(0.5,true,'checkForTwoPlayers');
}


/* Step 03
function that checks if we have 2 players available at start and if so add them to the array
*/
simulated function checkForTwoPlayers()
{
	local MCPawn NewMCP;
	local MCGameReplication MCGRI;

	// Get Game Replication
	MCGRI = MCGameReplication(WorldInfo.GRI);

	if (MCGRI.MCPRIArray.Length > 1)
	{
		// Find Main Character and Enemy @TODO sometimes Enemy won't get added
		foreach DynamicActors(class'MCPawn', NewMCP)
		{
		//	iFindPlay++;

			if (PlayerUniqueID == NewMCP.PlayerUniqueID)
			{
				MCPlayer = NewMCP;
			}else
			{
				MCEnemy = NewMCP;
			}
		}

		// If we have an Enemy then we can go to next stage
		if (MCEnemy != none)
		{
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

	}
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
	local MCPlayerReplication MCPRep;
	local float StoreAPf;

	// Set Game Replication so we can update Rounds
	MCPR = MCGameReplication(WorldInfo.GRI);

	if (MCPR != none)
	{
		// If it's the first round of the game. Set GameRound to 0 (Will become 4 because of 4 Chars)
		if (TurnPlayer == 0)
			MCPR.GameRound = 0;
		// Add a GameRound per turn
		MCPR.GameRound++;
	}

	MCPlayerReplication(PlayerReplicationInfo).GetPlayerHealth(MCPlayer.Health);
	// just update all Pawns all once so it doesn't fail later
	foreach DynamicActors(Class'MCPawn', WhatPeople)
		MCPlayerReplication(PlayerReplicationInfo).APf = WhatPeople.APf;

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
				// Give him his Max AP at start
				StoreAPf += WhatPeople.APfMax;

				// Give AP
				WhatPeople.APf = StoreAPf;
				WhatPeople.CurrentStartAPf = StoreAPf;
				// Set Use Tile function on

				// Update his Replication
				MCPlayerReplication(PlayerReplicationInfo).APf = MCPlayer.APf;

				// Send information to add Tiles
				WhatPeople.PC.SendToGetTilesServer(WhatPeople.APf);

				// Send Turnbased Message
				SendTurnMessageToClient("Your Turn");
			}else
			{
				// Otherwise do something to Player 2
				// Send Turnbased Message
				SendTurnMessageToClient("Enemy Turn");
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
		// Search for replications
		foreach DynamicActors(Class'MCPawn', WhatPeople)
		{
			// If we find a Player 1 then give him some AP
			if (WhatPeople.PlayerUniqueID == TurnPlayer)
			{
				// Initializing PlayerReplication
				MCPRep = MCPlayerReplication(WhatPeople.PlayerReplicationInfo);

				// Give him his Max AP at start
				StoreAPf += WhatPeople.APfMax;

				// Do the Buffs
				if (MCPRep !=none)
					StoreAPf += MCPRep.DoBuffCalculation(WhatPeople, StoreAPf);

				// Store the New AP and assign it
				WhatPeople.APf = StoreAPf;
				WhatPeople.CurrentStartAPf = StoreAPf;

				// Send information to add Tiles
				WhatPeople.PC.SendToGetTilesServer(WhatPeople.APf);

				// Do Damage to Tiles if we have Fire Fountain
				DoTileDamage();

				// Remove Spell if we have
				if (WhatPeople.PC.bIsSpellActive)
					WhatPeople.PC.bIsSpellActive = false;

				`log("You" @ WhatPeople @ "got" @ WhatPeople.APf @ "new AP, congratulations");

				// Send Turnbased Message
				WhatPeople.PC.SendTurnMessageToClient("Your Turn");
			}else
			{
				// Otherwise Reset AP

				WhatPeople.APf = 0.0f;
				`log("MR" @ WhatPeople.PawnName @ "" @ WhatPeople.PlayerUniqueID @ "Got resetted");

				// Update his Replication
				MCPlayerReplication(PlayerReplicationInfo).APf = MCPlayer.APf;

				// Send Turnbased Message
				WhatPeople.PC.SendTurnMessageToClient("Enemy Turn");
			}
		}

	}




	// All Characters goes to WaitForTurn state
//	GoToWaiting();
}

reliable client function SendTurnMessageToClient(string Message)
{
	local MCHud MCHud;

	MCHud = MCHud(myHUD);

	if (MCHud != none && MCHud.GFxBattleUI != none)
	{
		MCHud.GFxBattleUI.ShowPlayerTurnMessage(Message);
		SetTimer(1.5f,false,'ResetSentMessage');
	}
}

reliable client function ResetSentMessage()
{
	local MCHud MCHud;

	MCHud = MCHud(myHUD);

	if (MCHud != none && MCHud.GFxBattleUI != none)
	{
		MCHud.GFxBattleUI.HidePlayerTurnMessage();
	}
}





/*
// Function That makes Pawns go to WaitingForTurn State @FIX not being used
*/
reliable client function GoToWaiting()
{
	GotoState('WaitingForTurn');
}

/*
// Sends new AP client to Server so that we can setup Tiles
// @param 		SendAP		What APf value we send from Turnbased()
*/
reliable server function SendToGetTilesServer(float SendAP)
{
	SendToGetTilesClient(SendAP);
	AddTilesToArray(MCPlayer.PlayerUniqueID, MCPlayer, SendAP);
}

/*
// Sends new AP back from server to client
// @param 		SendAP		What APf value we send from Turnbased()
*/
reliable client function SendToGetTilesClient(float SendAP)
{
	AddTilesToArray(MCPlayer.PlayerUniqueID, MCPlayer, SendAP);
}

/*
// Function that check which Tiles we can go to and add them to an Array so that we can Light them Up
*/
reliable client function FindPathsWeCanGoTo(float PlayerAPf)
{
	local int index;	// Where we start to remove/insert ni the array
	local int i;

	// start by setting start index for adding Tiles to 0
	index=0;
	// remove old Tiles so that we can add new Tiles
	TilesWeCanMoveOn.Remove(index, TilesWeCanMoveOn.length);

	// do we want to add tiles
	if (bIsTileActive)
	{
		// Search all of our current Tiles
		for (i = 0; i < MCA.Tiles.Length ; i++)
		{
			if (PlayerAPf == 1.0f)
			{
				// If onyl 1 AP we look for a bigger Tile range, so that if the the Player is not in the middle of the tile he searches for a bigger area to get the tiles
				if ( VSize(MCPlayer.Location - MCA.Tiles[i].Location) < (PlayerAPf * ((128)+40)) )
					MoveTarget = FindPathToward(MCA.Tiles[i]);
				else
					MoveTarget = none;
			}
			else if(PlayerAPf > 1.0f)
			{
				// Only search MoveTargets that are withing a certain range from the Player. This makes it less laggy when using this function after moving etc
				if ( VSize(MCPlayer.Location - MCA.Tiles[i].Location) < (PlayerAPf * ((128)+16)) )
				{
					// find the Tiles we can move towards
					MoveTarget = FindPathToward(MCA.Tiles[i]);
				}else
					MoveTarget = none;
			}

			// if we have a Movetarget, AP and if that Tiles PathNode is not blocked then add them to an Array
			// @BUG MCEnemy Is not found at start spawn. Find solution. (Doesn't mater if they spawn far from eachother)
			if (MoveTarget != none && getPathAPCost() <= PlayerAPf && !MCA.Tiles[i].PathNode.bBlocked)
			{
		//		`log("How Far =" @VSize(MCPlayer.Location - MCA.Tiles[i].Location));
				if (MCEnemy != none)
				{
					// Temp bug fix for the bug up here
					if (VSize(MCEnemy.Location - MCA.Tiles[i].Location) > 50.0f)
					{
						TilesWeCanMoveOn.InsertItem(index++,MCA.Tiles[i]);
					}
				}else
				{
					TilesWeCanMoveOn.InsertItem(index++,MCA.Tiles[i]);
				}
			}
			else
			{
				// Otherwise turn of other Tiles, if this is not used then it will keep all Tiles Lit up
				// If it's not spellmode the don't use
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

/*
		// If he Pawn has 0 AP reset adding Tiles until next round
		if (MCPlayer.APf == 0)
		{
			bIsTileActive = true;		
		}else
		{	
			// Otherwise turn of using this function
			bIsTileActive = false;
		}
*/
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

	`log("PC - TurnTilesOn - MoveableTiles=" @ TilesWeCanMoveOn.length);
	`log("PC - TurnTilesOn - MoveableTiles=" @ TilesWeCanMoveOn.length);

	for (i = 0;i < TilesWeCanMoveOn.length ; i++)
	{
		if(TilesWeCanMoveOn[i].bSpellTileMode)
		{
		//	TilesWeCanMoveOn[i].SetActiveTiles();
		//	TilesWeCanMoveOn[i].SetFireFountain();
		}else
		{
			TilesWeCanMoveOn[i].SetActiveTiles();
		}
	}
}

/*
// Turn of Tiles, used in certain spells, Mainly used inside Spells
*/
simulated function TurnOffTiles()
{
	local int i;

	for (i = 0;i < TilesWeCanMoveOn.length ; i++)
	{
		if(TilesWeCanMoveOn[i].bSpellTileMode)
		{
		//	`log("TurnOffTiles NONO" @ TilesWeCanMoveOn[i]);
		}else
		{
			TilesWeCanMoveOn[i].ResetTileToNormal();
		}
	}
}

/*
// Used to show what Spells we have, @FIX add spells to a seperate array and from that one we control the entire maps spell Tiles
*/
reliable client function TurnTileSpellModeOn()
{
	local int i;

	// If we have spells here then add them to the list
	for (i = 0;i < SpellTiles.length ; i++)
	{
		if(SpellTiles[i].bSpellTileMode)
			SpellTiles[i].ShowDisplayColor();
	}
}


/*
// Function that calculates how much it cost to a certain destination and then
// @return 			number equal to what AP it should cost to move to that area
*/
simulated function int getPathAPCost()
{
	local int i;
//	local int j;
	local int NewAPCost;	// What will the AP be
	local MCPathnode MyPath;

	// Search all Paths to get What RouteCache we have
	for (i = 0; i < RouteCache.Length; i++)
	{
		MyPath = MCPathNode(RouteCache[i]);

		NewAPCost += MyPath.APValue;
		// If AP is equal to AP or a little bit more then stop the search
		if (MCPlayer.APf < NewAPCost)
		{
			//`warn("You're Cost is Too much"@ NewAPCost);
		}
	}
	// Return our new Cost
	return NewAPCost;
}

/*
// Removes previous Tiles and adds the new Tiles to an array depending on cost
// @param 		PlayerID 		What ID we have @FIX not being used
// @param 		MyPawn			What Pawn we send it to @FIX not being used
// @param 		RecieveAP		What AP cost we send from Turnbased after buff calc is complete
*/
simulated function AddTilesToArray(int PlayerID, MCPawn MyPawn, float RecieveAP)
{
	local MCTile Tile;

	// Start by removing current once
	MCA.Tiles.Remove(0, MCA.Tiles.length);
/*
	`log("-------------------------------------------");
	`log("-------------------------------------------");
	`log("Current MCPlayer.PlayerUniqueID" @ MCPlayer.PlayerUniqueID);
	`log("Current PlayerID" @ PlayerID);
	`log("Current MCPlayer" @ MCPlayer);
	`log("Current Sent MCPlayer" @ MyPawn);
	`log("-------------------------------------------");
	`log("-------------------------------------------");
	`log("Inside foreach with" @ MCPlayer @"and AP is" @RecieveAP);
*/

	// Adds Tiles and PathNode in to an array if they are close to eachother
	if (RecieveAP > 0)
	{
		foreach DynamicActors(Class'MCTile', Tile)
		{
			// takes players current ap and check around him for every AP point + 10, (+10 is to make sure we get enought space to find it)
		//	if ( PlayerID == MCPlayer.PlayerUniqueID && VSize(MCPlayer.Location - Tile.Location) < (MCPlayer.APf * ((128)+10)) )
			if ( VSize(MCPlayer.Location - Tile.Location) < (RecieveAP * ((128)+5)) )	//  < (MCPlayer.APf * ((128)+10))
			{	
				MCA.Tiles.AddItem(Tile);
				continue;
			}
		}

		`log("We Add More Tiles" @ MCA.Tiles.length);

	//	bIsTileActive = true;
		FindPathsWeCanGoTo(RecieveAP);	// Check to where we can go
		ClearTimer('AddTilesToArray');
	}else
	{
	//	SetTimer(0.3f, true, 'AddTilesToArray');
	}
}


function string FindDirection(vector LocVec)
{
	local Float FloX;
	local Float FloY;

	FloX = LocVec.x;
	FloY = LocVec.y;

	// Up
	if(FloX <= -15)
		return "DirUp";
	// Down
	else if(FloX >= 15)
		return "DirDown";
	// Right
	else if(FloY <= -15)
		return "DirRight";
	// Left
	else if(FloY >= 15)
		return "DirLeft";
}

simulated function SetTileImageRotation(MCPathNode WhatPath, string Direction)
{
	if (WhatPath == none || Direction == "")
		return;

	if (WhatPath != none)
	{
		// Her Set Tile to rotate if something
	//	`log("-----------------------------------------------------");
		switch (Direction)
		{
			case "DirUp":
			//	`log("Up Direction");
				WhatPath.Tile.SetArrows(Direction);
				break;
			case "DirDown":
			//	`log("Down Direction");
				WhatPath.Tile.SetArrows(Direction);
				break;
			case "DirRight":
			//	`log("Right Direction");
				WhatPath.Tile.SetArrows(Direction);
				break;
			case "DirLeft":
			//	`log("Left Direction");
				WhatPath.Tile.SetArrows(Direction);
				break;

			default:
			//	Texture2D'mystraschampionsettings.Texture.arrowTest'
		}
	}
}

simulated function SetWhereToGo()
{
	local int i;
	local String Direction;
	local MCPathnode MyPath;

	// Check to reset information
	for (i = 0;i < TilesWeCanMoveOn.length ; i++)
	{
		if(TilesWeCanMoveOn[i].bSpellTileMode)
		{
		//	TilesWeCanMoveOn[i].SetActiveTiles();
		//	TilesWeCanMoveOn[i].SetFireFountain();
		}else if(TilesWeCanMoveOn[i].bArrowActive)
		{
			TilesWeCanMoveOn[i].SetArrowOFF();
		}else
		{
		//	TilesWeCanMoveOn[i].SetActiveTiles();
		}
	}

	// Search all Paths to get What RouteCache we have
	for (i = 0; i < RouteCache.Length; i++)
	{
		MyPath = MCPathNode(RouteCache[i]);

		// 1st Tile, check where we are from Character and Set Arrow to Point That Direction
		if (i == 0)
		{
			if (MCPlayer != none && MCEnemy != none)
			{
				if (VSize(MCEnemy.Location - RouteCache[i].Location) < 50.0f)
				{
					
				}else
				{
					Direction = FindDirection(MCPlayer.Location - RouteCache[i].Location);
					// DirUp , DirDown, DirRight, DirLeft
					SetTileImageRotation(MyPath, Direction);
				}
			}
		}

		// After First Tile
		if ( (i-1) >= 0)
		{
			if (MCPlayer != none && MCEnemy != none)
			{
				if (VSize(MCEnemy.Location - RouteCache[i].Location) < 50.0f)
				{
					
				}else
				{
					// Checks Previous one and Current one and sends it to a certain Direction
					Direction = FindDirection(RouteCache[i-1].Location - RouteCache[i].Location);
					// DirUp , DirDown, DirRight, DirLeft
					SetTileImageRotation(MyPath, Direction);
				}
			}
		}
	}
}


/*
// Does Damage every time we have a new round.
*/
reliable client function DoTileDamage()
{
	local int i;

	`log("<========================================================================================>");
	`log("<========================================================================================>");

	// If we have spells here then add them to the list
	for (i = 0;i < SpellTiles.length ; i++)
	{
		`log("PC - DoTileDamage - inside loop" @ SpellTiles.length @ "-" @ SpellTiles[i]);

		// Does Damage
		if(SpellTiles[i].bSpellTileMode && SpellTiles[i].bFireFountain)
		{
			SendTileInfo(SpellTiles[i]);
		}
		// Since it won't get removed in @RemoveTileSpellAreaClient(), we remove it here.
		else if(!SpellTiles[i].bSpellTileMode && !SpellTiles[i].bFireFountain)
		{
			SpellTiles.RemoveItem(SpellTiles[i]);
		}
	}

	`log("<========================================================================================>");
	`log("<========================================================================================>");
}

reliable server function SendTileInfo(MCTile SendTile)
{
	`log("PC - SendTileInfo - Sending to Tile");
	SendTile.NewRoundDamage();
}


// PlayerWalking is the main state (set by mouseinterface controller).
// Can we go to somewhere with the current AP checks, and the press to
// go there.
auto state PlayerWalking
{
	ignores SeePlayer, HearNoise, Bump;

	function BeginState(Name PreviousStateName)
	{
	//	`log( "Welcome" @ GetStateName() @ "Player =" @ MCPlayer @ "ID =" @ PlayerUniqueID);
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
		if (WorldInfo.GetMapName() != "movement_test16")		//	TestMoveAlot, 	movement_test16
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
				PlayerTickSpellArea(HitActor);

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
						// sets PathNode to DestActor
						DestActor = MCA.Tiles[i];
					}
				}
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
					// Set Where we can go Arrows
					SetWhereToGo();
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
		
		super.PlayerTick(DeltaTime);
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

		if (MCPlayer.APf == 0.0f)
			return;

		if (SpawnActor != none && bDebugFlag)
		{
			// debug For Flag to kill them off
			foreach AllActors(Class'MCTestActor', SpawnActor)
			{
				SpawnActor.destroy();
				continue;
			}
		}

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
					StartFireSpellArea(HitActor);

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
			ReplicateMove(DeltaTime, NewAccel, DCLICK_None, newRotation);
		else
			ProcessMove(DeltaTime, NewAccel, DCLICK_None, newRotation);

	//	super.PlayerMove(DeltaTime);
	}

	function EndState(Name NextStateName)
	{
	//	`log( "Bye Bye" @ GetStateName() );
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
	local int j;
	local bool bFindActor;
//	local MCPawn WhatPeople;

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

			// If it's the wrong one, we do a search
			else if(FireTiles[i].name != ClickedTileActor.name)
			{
				for (j = 0; j < FireTiles.Length; j++)
				{
					// Find if we have this actor, if true SET, if false turn off spell
					if (FireTiles[j].name == ClickedTileActor.name)
						bFindActor=true;
				}

				// If we didn't find an actor before (If we press outside) Turn off spell
				if (!bFindActor)
				{
					InstantiateSpell.Destroy();
					InstantiateSpell = none;
					SpellTileTurnOff();
					FireTiles.Remove(0, FireTiles.length);
					CheckCurrentAPCalculation();
					ClickSpell = none;
					return;
				}

			}

		}
	}

	if(ClickSpell != none)
	{
		// This is client only, remove AP
		`log("initialized " @ InstantiateSpell.name);

		`log("PC - StartFireSpellArea -" @ ClickSpell.RandomElement);
		if (InstantiateSpell.SpellNumber == 21)
		{
			`log("--------------------------------------");
			`log("PC - StartFireSpellArea -" @ ClickSpell.RandomElement);
			`log("--------------------------------------");
			ClickSpell.SetRandomElementServer(ClickSpell.RandomElement);
		}
		// Send spell to Server to activate, and in there also set AP
		SendSpellToServer(MCPlayer, ClickSpell, ClickSpell.PathNode);
	//	SendSpellToClient(MCPlayer, ClickSpell, ClickSpell.PathNode);	// not needed, inside spell we also do the client

		// Add Tiles to Spell
		if (!InstantiateSpell.bAreaDestroy)
			SendTileSpellAreaToAllClients(ClickSpell);
	
		// Set spell mode off && destroy it
	//	bIsSpellActive = false;	// turn off this at CheckCurrentAPCalculation()
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

/*
// Send Tiles to Clients
// @param 		SendTile		What Affected Tile we send
*/
reliable server function SendTileSpellAreaToAllClients(MCTile SendTile)
{
	local MCPawn WhatPeople;

	// Send to Clients
	foreach DynamicActors(Class'MCPawn', WhatPeople)
		WhatPeople.PC.SendTileSpellAreaClient(SendTile);
}

/*
// Gets a Tile and adds it to it's Own Array that will lightup Spell Tiles
// @param 		SendTile		What Affected Tile we send
*/
reliable client function SendTileSpellAreaClient(MCTile SendTile)
{
	// Add to all Clients here
	SpellTiles.AddItem(SendTile);

	// Send to servers
	SendTileSpellAreaServer(SendTile);
}

/*
// Send Tile to Server so he can send the Tile to All the Clients
// @param 		SendTile		What Affected Tile we send
*/
reliable server function SendTileSpellAreaServer(MCTile SendTile)
{
	// Add here
	SpellTiles.AddItem(SendTile);
}

/*
// From MCTile ActivateDissolveElement we turn off This tile and remove it from Spell Affected Tile Array
// @FIX It does remove it but not really, so in DoTileDamage() we actually remove it
// @param 		SendTile		What Affected Tile we send
*/
reliable client function RemoveTileSpellAreaClient(MCTile SendTile)
{
	// Removes it from array
	SpellTiles.RemoveItem(SendTile);
	// Since update is slow we set it off here as well
	SendTile.bSpellTileMode = false;
	// We reset Tile so it can't be shown anymore
	SendTile.ResetTileToNormal();
	// Remove on Server
	RemoveTileSpellAreaServer(SendTile);
}

/*
// From MCTile ActivateDissolveElement we turn off This tile and remove it from Spell Affected Tile Array
// @FIX It does remove it but not really, so in DoTileDamage() we actually remove it
// @param 		SendTile		What Affected Tile we send
*/
reliable server function RemoveTileSpellAreaServer(MCTile SendTile)
{

	// Removes it from array
	SpellTiles.RemoveItem(SendTile);
	// Since update is slow we set it off here as well
	SendTile.bSpellTileMode = false;
	// We reset Tile so it can't be shown anymore
	SendTile.ResetTileToNormal();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
// Test State for Waiting at start
*/
state WaitingForTurn
{
	ignores SeePlayer, HearNoise, Bump;

	function BeginState(Name PreviousStateName)
	{
		`log( "Welcome to" @ GetStateName() );
	}

	event PushedState()
	{
		if (Pawn != None)
		{
			// make sure the pawn physics are initialized
			Pawn.SetMovementPhysics();
		}
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

			if (MCPlayer.APf > 0 && MCEnemy.APf == 0 && !IsInState('PlayerWalking'))
			{
				`log("Let's Go To PlayerWalking Shall we");
				`log("Let's Go To PlayerWalking Shall we");
				`log("Let's Go To PlayerWalking Shall we");
				`log("Let's Go To PlayerWalking Shall we");
				`log("Let's Go To PlayerWalking Shall we");
				GotoState('PlayerWalking');
			}
		}
	//	super.PlayerTick(DeltaTime);
	}

	function EndState(Name NextStateName)
	{
		`log( "Bye Bye" @ GetStateName() );

		// Track Hero at Start
	//	CameraProperties.IsTrackingHeroPawn = true;
	//	SetTimer(1.0f, false, 'EndTrackingHero');
	}
}

/*
// When in Waiting state you set the Pawns block and ExtraCost so that the enemy can't touch him
*/
function EndTrackingHero()
{
//	CameraProperties.IsTrackingHeroPawn = false;
}

//
// Check After movement and Spell use to see if we have AP or we change person
//
reliable client function CheckCurrentAPCalculation()
{
	// If a Spell was active, we turn it off here
	if (bIsSpellActive)
		bIsSpellActive = false;
	if (InstantiateSpell != none)
		InstantiateSpell = none;

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
	FindPathsWeCanGoTo(MCPlayer.APf);
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
//	DoTileDamage();
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
// Removes Buffs after Our Turn is done
*/
reliable server function RemoveBuffAtEnd()
{
	local MCPlayerReplication MCPRep;
	MCPRep = MCPlayerReplication(PlayerReplicationInfo);

	if (MCPRep != none)
		MCPRep.RemoveStatus();
}

/*
// Cooldown until next persons round will be calculated
// @network						Client
*/
function TurnBasedTwo()
{
	// Remove buff
	RemoveBuffAtEnd();
//	CameraProperties.IsTrackingEnemyPawn = false;
	TurnBased(2);
}

/*
// Cooldown until next persons round will be calculated
// @network						Client
*/
function TurnBasedOne()
{
	// Remove buff
	RemoveBuffAtEnd();
//	CameraProperties.IsTrackingEnemyPawn = false;
	TurnBased(1);
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
			MCPlayerReplication(PlayerReplicationInfo).APf = MCPlayer.APf;

			`log("AP is now=" @ WhatPeople.APf);
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
	//	`log("AP" @ MCPlayer.APf @ "-" @ getPathAPCost());
		// Calculate AP Cost
		MCPlayer.APf -= getPathAPCost();
		SendAPCost = getPathAPCost();

		// Enemy can also see AP reduction
		// If Listen don't Enter this call @BUG gets replicated somewhere else???
		if ( (WorldInfo.NetMode == NM_ListenServer) ){}
		// If Client then Enter here
		else if( (WorldInfo.NetMode == NM_Client) )
			ChangeAPWithMove(SendAPCost, MCPlayer.PlayerUniqueID);
		
	//	ChangeAPWithMove(SendAPCost, MCPlayer.PlayerUniqueID);
		
		// Set so that we will be Walking
		if (!IsInState('PlayerWalking'))
			GotoState('PlayerWalking');

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
				FireTiles[i].SpellMarkTileCurrentlySelected();
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
				
				if (InstantiateSpell != none)
				{
					// If Spell is Dissolved Element, show a Yellow color to stop it, prob change to an X mark or something later on
					if (InstantiateSpell.spellNumber == 25)
						FireTiles[i].bDissolveElement = true;
				}

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
			// new 2014-06-14
			// find the Tiles we can spawn something
			if (InstantiateSpell != none &&
				VSize(MCPlayer.Location - MCA.Tiles[i].Location) < InstantiateSpell.fMaxSpellDistance &&
				VSize(MCPlayer.Location - MCA.Tiles[i].Location) > InstantiateSpell.fCharacterDistance &&
				VSize(MCEnemy.Location - MCA.Tiles[i].Location) > InstantiateSpell.fCharacterDistance
				)
			{
				//  We Set What Tiles we can't use in here @FIX
			//	if(!MCA.Tiles[i].PathNode.bBlocked)
				if(InstantiateSpell.Type == eArea)
				{
				//	`log("PC - CheckDistanceNearPlayer -" @ InstantiateSpell.spellNumber);
					// If UnearthMaterial
					if (InstantiateSpell.spellNumber == 21)
					{
						// Turns on Special Lightup Tile
						MCA.Tiles[i].bUnearthMaterialActive = true;
						// Set Random Number in here
						TestSetThings(MCA.Tiles[i], MCA.Tiles[i].SetRandomElement() );
					//	MCA.Tiles[i].SetRandomElementServer(3);
						`log("PC - CheckdistanceNearPlayer -" @ MCA.Tiles[i].RandomElement);
					}
					FireTiles.InsertItem(index++,MCA.Tiles[i]);
				}
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

reliable server function TestSetThings(MCTile WhatTile, int RandomInt)
{
	`log("We do things here where" @ WhatTile @ RandomInt);
	WhatTile.SetRandomElementServer(RandomInt);
}

reliable client function CheckTeleportArea(int APValue)
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
			// Only search MoveTargets that are withing a certain range from the Player. This makes it less laggy when using this function after moving etc
			if ( VSize(MCPlayer.Location - MCA.Tiles[i].Location) < (APValue * ((128)+16)) )
			{
				// find the Tiles we can move towards
				MoveTarget = FindPathToward(MCA.Tiles[i]);
			}else
				MoveTarget = none;
			

			// if we have a Movetarget, AP and if that Tiles PathNode is not blocked then add them to an Array
			// @BUG MCEnemy Is not found at start spawn. Find solution. (Doesn't mater if they spawn far from eachother)
			if (MoveTarget != none && getPathAPCost() <= APValue && !MCA.Tiles[i].PathNode.bBlocked)
		//	if (MoveTarget != none && !MCA.Tiles[i].PathNode.bBlocked)
			{
		//		`log("How Far =" @VSize(MCPlayer.Location - MCA.Tiles[i].Location));
				if (MCEnemy != none)
				{
					// Temp bug fix for the bug up here
					if (VSize(MCEnemy.Location - MCA.Tiles[i].Location) > 50.0f)
					{
						FireTiles.InsertItem(index++,MCA.Tiles[i]);
					}
				}else
				{
					FireTiles.InsertItem(index++,MCA.Tiles[i]);
				}
			}
			else
			{
				// Otherwise turn of other Tiles, if this is not used then it will keep all Tiles Lit up
				if(!MCA.Tiles[i].bSpellTileMode)
					MCA.Tiles[i].ResetTileToNormal();
			}
		}
	}

	// turn on the added Tiles in the Array
	SpellTileTurnOn();
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

	// If we happend to have a Spell active
	if (bIsSpellActive)
		bIsSpellActive = false;

	// check if we have enought AP to use the spell
//	if (MyArchetypeSpells[SpellIndex].AP <= MCPlayer.APf)
//	{
		// If this is on the client, then sync with the server
		if (Role < Role_Authority)
		{
			ServerActivateSpell(SpellIndex);
			`log("0 - Client Sends things to Server");
		}

		// Begin casting the spell
		BeginActivatingSpell(SpellIndex);
//	}
	// Show message that says we don&t have enought AP
//	else
//	{
//		`log("Not enought AP, missing" @ MyArchetypeSpells[SpellIndex].AP - MCPlayer.APf);
//	}
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

simulated function ActivateOnEnemy()
{
	
}

/*
// Takes the Information from ClickButton and sends it in to the spell so it can Spawn on server & client
*/
protected reliable server function SendSpellToServer(MCPawn Caster, MCTile WhatTile, MCPathNode PathNode)
{
	if(Role == Role_Authority)
	{
		// check if We have AP to cast spell
		if (InstantiateSpell.APCost <= MCPlayer.APf)
		{
			// Start by Reducing AP on server
			MCPlayer.APf -= InstantiateSpell.APCost;
			MCPlayerReplication(PlayerReplicationInfo).APf = MCPlayer.APf;

			`log("PC - SendSpellToServer -" @ WhatTile.RandomElement);

			`log("We Are sending Spell to Server" @InstantiateSpell);
			InstantiateSpell.CastClickSpellServer(Caster, WhatTile, PathNode);
		}

		else
		{
			// We don't have AP, Reset all
			InstantiateSpell.Destroy();
			InstantiateSpell = none;
			SpellTileTurnOff();
			FireTiles.Remove(0, FireTiles.length);
			CheckCurrentAPCalculation();
			ClickSpell = none;
		}


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
		SetTimer(10.0f,false,'ShowOptionTimer');
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
		SetTimer(10.0f,false,'ShowOptionTimer');
	}
}

simulated function ShowOptionTimer()
{
	local MCHud cMCHud;

	cMCHud = MCHud(myHUD);
	if (cMCHud != none)
	{
		cMCHud.GFxBattleUI.ShowOptionsAfterWinOrLose();
	}
}

























///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Are we using ??? ??? ??? ???
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
// When this class is destroyed, remove movieclip + Pawn
*/
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

// ??????????????????????????
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
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// Things for Lan, When we select exit, it resets the online Game so that we can rehost, and when a player is forced out the same thing occurs.
// Does'nt work with doing a 'open map' command in console. Must be exited properly
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

// NOTE: This never gets called, 'NotifyDisconnect' handles this instead
exec function Disconnect()
{
	QuitToMainMenu();
}

/**
 * Triggered when the 'disconnect' console command is called, to allow cleanup before disconnecting (e.g. for the online subsystem)
 * NOTE: If you block disconnect, store the 'Command' parameter, and trigger ConsoleCommand(Command) when done; be careful to avoid recursion
 *
 * @param Command	The command which triggered disconnection, e.g. "disconnect" or "disconnect local" (can parse additional parameters here)
 * @return		Return True to block the disconnect command from going through, if cleanup can't be completed immediately
 */
event bool NotifyDisconnect(string Command)
{
	// "disconnect force" forces a disconnect, without cleanup
	if (Right(Command, 6) ~= " force" || InStr(Command, " force ", true, true) != INDEX_None)
		return false;


	// Call QuitToMainMenu to start the cleanup process
	if (!bCleanupInProgress)
	{
		DisconnectCommand = Command;
		QuitToMainMenu();
	}

	// Only block the disconnect command, if a cleanup is in progress, and it has not yet completed
	return bCleanupInProgress && !bCleanupComplete;
}

/** Called when returning to the main menu. */
function QuitToMainMenu()
{
	bCleanupInProgress = true;
	bQuittingToMainMenu = true;

	if(CleanupOnlineSubsystemSession(true)==false)
	{
		`Log("UTPlayerController::QuitToMainMenu() - Online cleanup failed, finishing quit.");
		FinishQuitToMainMenu();
	}
}

/** Called after onlinesubsystem game cleanup has completed. */
function FinishQuitToMainMenu()
{
	// stop any movies currently playing before we quit out
	class'Engine'.static.StopMovie(true);

	bCleanupComplete = true;

	// Call disconnect to force us back to the menu level
	if (DisconnectCommand != "")
	{
		ConsoleCommand(DisconnectCommand);
		DisconnectCommand = "";
	}
	else
	{
		ConsoleCommand("Disconnect");
	}

	`Log("------ QUIT TO MAIN MENU --------");
}


/** Cleans up online subsystem game sessions and posts stats if the match is arbitrated. */
function bool CleanupOnlineSubsystemSession(bool bWasFromMenu)
{
	local OnlineGameSettings CurGameSettings;
	local bool bSuccess;

	if (WorldInfo.NetMode != NM_Standalone && OnlineSub != none && OnlineSub.GameInterface != none)
	{
		CurGameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
	}

	if (CurGameSettings != none)
	{
		// If StartOnlineGame has not been called, destroy the online session immediately
		if (CurGameSettings.GameState != OGS_InProgress)
		{
			OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyOnlineGameComplete);
			OnlineSub.GameInterface.DestroyOnlineGame('Game');
		}
		else
		{
			// Set the end delegate so we can know when that is complete and call destroy
			OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(OnEndOnlineGameComplete);
			OnlineSub.GameInterface.EndOnlineGame('Game');
		}

		bSuccess = true;
	}

	return bSuccess;
}


/**
 * Called when the online game has finished ending.
 */
function OnEndOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
	OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndOnlineGameComplete);

	if (bQuittingToMainMenu)
	{
		// Now we can destroy the game (NOTE: If DestroyOnlineGame returns false, it will still trigger the delegate)
		OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyOnlineGameComplete);
		OnlineSub.GameInterface.DestroyOnlineGame('Game');
	}
}

/**
 * Called when the destroy online game has completed. At this point it is safe
 * to travel back to the menus
 *
 * @param SessionName the name of the session the event is for
 * @param bWasSuccessful whether it worked ok or not
 */
function OnDestroyOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
	OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyOnlineGameComplete);
	FinishQuitToMainMenu();
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