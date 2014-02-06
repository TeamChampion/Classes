class MCPlayerController extends MouseInterfacePlayerController;
/*
// Guides that can be helpful

// http://forums.epicgames.com/threads/936393-Drawing-names-above-player-head-referencing-PlayerReplicationInfo
*/

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
var bool bCanTurnBlue;
// Add Tiles to an array to later check what Tiles we are going to lightup
var array <MCTile> BlueTiles;
<<<<<<< HEAD

=======
>>>>>>> 69ca7878fffce8c34d2deff5d3f03d64175dddaf

var bool bIsSelectingFireFountain;
var bool bIsSelectingStoneWall;
var bool bIsRed;
var array <MCTile> FireTiles;
var MCTile TileColor;
//	Others
///////////////////////////////////////////////
// Struct that contains all the PathNodes, Triggers and Tiles
//var MCPawn MyPlayers[2];
//var int setActivePlayer;
//var array <MCPawn> MyPawns;
//var array <PathNode> RouteCacheCheck;	// Where we want to go all the time
//var array <MCTile> RoutedTiles;	// add Tile Pathnotes Check in here

// Replication block
replication
{
	// Replicate only if the values are dirty, this replication info is owned by the player and from server to client
//	if (bNetDirty && bNetOwner)
		 //setActivePlayer;

	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		NewHitActor, ScriptedMoveTarget, MCA, MCPlayer, MCEnemy, bCanTurnBlue;
}

simulated event ReplicatedEvent(name VarName)
{
	if(VarName == 'NewHitActor') //this variable has changed so update the clients
		`log("changed");
}

simulated event PostBeginPlay()
{
	local MCPathNode PathNode;
	local MCTile Tile;
	local int i;

    super.PostBeginPlay();

	// Adds Tiles and PathNode in to an array if they are close to eachother
	foreach AllActors(Class'MCTile', Tile)
	{
		foreach AllActors(Class'MCPathNode', PathNode)
		{
			if ( VSize(Tile.Location - PathNode.Location) < 70.0f)
			{
			//	`log("Tile" @ Tile @ "PathNode" @ PathNode);
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

	//	debug to check this tile
	for (i = 0; i < MCA.Paths.Length ; i++)
	{
		if (MCA.Paths[i].name == 'MCPathNode_40')
		{
			`log(MCA.Paths[i].APValue);
			MCA.Paths[i].bBlocked = true;
		}
	}
	
	// Checks for Pawn, when we get him turn this off
	SetTimer(0.1f, true, 'beforeWeStart');
}

/* Step 01
// Sets The Pawn and then sets the color for them
*/
simulated function beforeWeStart()
{
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
		ClearTimer('beforeWeStart');
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
		//`log("found a playerstart named" @ P.name);

		currentDist = VSize(MCPlayer.Location - P.Location);
		if (currentDist < dist)
		{
			dist = currentDist;
			closestPlayerStart = P;
		}
	}

	//SET UNIQUE PLAYER ID BASED ON START POINT
	if (closestPlayerStart.Name == 'PlayerStart_0')	{	PlayerUniqueID = 1;	}	// Olgar
	if (closestPlayerStart.Name == 'PlayerStart_1')	{	PlayerUniqueID = 2;	}	// waas
//	if (closestPlayerStart.Name == 'PlayerStart_2')	{	PlayerUniqueID = 3;	}	
//	if (closestPlayerStart.Name == 'PlayerStart_3')	{	PlayerUniqueID = 4;	}

	// Update Replication Info so other players know this playerrep's new ID value
	MCPlayerReplication(PlayerReplicationInfo).PlayerUniqueID = PlayerUniqueID;

    MCPlayerReplication(PlayerReplicationInfo).PawnName = MCPlayer.PawnName;
    MCPlayerReplication(PlayerReplicationInfo).APf = MCPlayer.APf;

	MCPlayer.PlayerUniqueID = PlayerUniqueID;

	//setting this var triggers color change for every version 
    //of YourPawn present in each player's reality.

 //   checkForTwoPlayers();
    SetTimer(0.5,true,'checkForTwoPlayers');
}


/* Step 03
function that checks if we have 2 players available at start and if so add them to the array
*/
simulated function checkForTwoPlayers()
{
	local MCPawn NewMCP;
	local int HowMany;
//	local int goPlus;
//	local int i;

	HowMany = 0;

	// check how many players we have
	foreach AllActors(Class'MCPawn', NewMCP)
	{
		HowMany++;
		continue;
	}
	//`log("in CheckForTwoPlayers");
	// if we have 2 players then add them to the array
	if (HowMany == 2)
	{
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
<<<<<<< HEAD
		// clear this check
		ClearTimer('checkForTwoPlayers');
=======
>>>>>>> 69ca7878fffce8c34d2deff5d3f03d64175dddaf

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

}


/*
// Will set which Player is active and will let him do his move. Then switched to the other Player and so forth.
*/
reliable server function TurnBased(int TurnPlayer)
{
	local MCGameReplication MCPR;	// Game Replication
	local MCPawn WhatPeople;		// All our Pawns in the game

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
				WhatPeople.APf = 6.0;

				// Update his Replication
				MCPlayerReplication(PlayerReplicationInfo).APf = MCPlayer.APf;
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
		// Search for replications
		foreach DynamicActors(Class'MCPawn', WhatPeople)
		{
			// If we find a Player 1 then give him some AP
			if (WhatPeople.PlayerUniqueID == TurnPlayer)
			{
				// Give person AP
				WhatPeople.APf = 6.0;
				`log("You" @ WhatPeople @ "got" @ WhatPeople.APf @ "new AP, congratulations");

				// Update his Replication
				MCPlayerReplication(PlayerReplicationInfo).APf = MCPlayer.APf;
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

/*
// Check if we have pawn
// Only on Server
*/
event Possess( Pawn aPawn, bool bVehicleTransition )
{
    `log("Possess:"@ aPawn);
    super.Possess(aPawn, bVehicleTransition);
}

/*
// Just a function to check to see if pawn is spawned in the game, and then sets him to Mystras Champion Pawn
// Only on Client
*/
simulated function AcknowledgePossession( Pawn P )
{
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

<<<<<<< HEAD
function PlayerTick(float DeltaTime)
{
	super.PlayerTick(DeltaTime);
}
=======
>>>>>>> 69ca7878fffce8c34d2deff5d3f03d64175dddaf

/*
// Test function that calls something from replication
// @NOT_WORKING It doesn't get the message, will try later 
*/
simulated function optimize(int whatPlayerID)
{

	//MyCharacters();
	`log("<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
}

/*
// Function that Turns of the Tiles after lightover
// @NOT_USING currently not being used
*/
function TurnOffTiles()
{
	local int i;

	for (i = 0; i < MCA.Paths.length ; i++)
	{
		MCA.Tiles[i].TurnTileOff();
		/*
		if ( VSize(RouteCache[index].Location - MCA.Paths[i].Location) < 70.0f)
		{
			//
		}else
		{
			MCA.Tiles[i].TurnTileOff();
		}
		*/
	}
}

















































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
	BlueTiles.Remove(index, BlueTiles.length);

	// do we want to add tiles
	if (bCanTurnBlue)
	{
		// Search all of our current Tiles
		for (i = 0; i < MCA.Tiles.Length ; i++)
		{
			// find the Tiles we can move towards
			MoveTarget = FindPathToward(MCA.Tiles[i]);

			// if we have a Movetarget, AP and if that Tiles PathNode is not blocked then add them to an Array
			//if (MoveTarget != none && getPathAPCost() <= MCPawn.APf && !MCA.Tiles[i].PathNode.bBlocked)
			if (MoveTarget != none && getPathAPCost() <= MCPlayer.APf && !MCA.Tiles[i].PathNode.bBlocked && VSize(MCEnemy.Location - MCA.Tiles[i].Location) > 50.0f)
			{
				BlueTiles.InsertItem(index++,MCA.Tiles[i]);
			}
			else
			{
				// Otherwise turn of other Tiles, if this is not used then it will keep all Tiles Lit up
				MCA.Tiles[i].TurnTileOff();
			}
		}

		// If he Pawn has 0 AP reset adding Tiles until next round
		if (MCPlayer.APf == 0)
		{
			bCanTurnBlue=true;		
		}else
		{	
			// Otherwise turn of using this function
			bCanTurnBlue=false;
		}

		// resets Movetarget to 0 so we don't bug out
		MoveTarget = FindPathToward(MCPlayer);

		// turn on the added Tiles in the Array
		TurnTilesOn();
	}
}

/*
// Light up all Tiles that we can move towards
*/
simulated function TurnTilesOn()
{
	local int i;

	for (i = 0;i < BlueTiles.length ; i++)
	{
		BlueTiles[i].TileTurnBlue();
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


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


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

	// function that will use find mouseover to find what location to go to
	// if we can use mouse over & out that would be better
	function PlayerTick(float DeltaTime)
	{
		local int i;
		local Actor DestActor;
		local MouseInterfaceHUD MouseInterfaceHUD;	
		local actor HitActor;			// What Tile we are looking at
		//local MCTile TileColor;
		// If we are not moving then please use this

		if (MCPlayer != none && !bCanStartMoving && bIsRed)
		{
			MouseInterfaceHUD = MouseInterfaceHUD(myHUD);
			HitActor = MouseInterfaceHUD.HitActor2;
		
			if (HitActor.tag == 'MouseInterfaceKActor' || HitActor.tag == 'MCTile' )
				for (i = 0; i < MCA.Tiles.Length; i++)
					if (MCA.Tiles[i].name == HitActor.name)
						TileColor = MCA.Tiles[i];
			
			// Turns Tile color
			SpellTileTurnOn();
		}

		if (MCPlayer != none && !bCanStartMoving && !bIsRed)
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
			if (MCPlayer.APf == 6 && bCanTurnBlue)
			{
				FindPathsWeCanGoTo();
			}



			// For debugging Where we can go
			if (SpawnActor != none)
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
					// Debugging direction where we should go to
					for (i = 0;i < RouteCache.Length; i++)
					{
						SpawnActor = Spawn(class'MCTestActor', , , RouteCache[i].Location,);
					}
					
				}
			}
		}
		global.PlayerTick(DeltaTime);
	}

	// sets of the click to move place
	exec function StartFire(optional byte FireModeNum)
	{
		local MouseInterfaceHUD MouseInterfaceHUD;	
		local actor HitActor;			// What Tile we are looking at
		local MCPathNode PathNode;		// PathNode

		if (SpawnActor != none)
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
			if (MCPlayer != none && !bCanStartMoving && bIsRed)
			{
				// If Fire Fan
				if (bIsSelectingFireFountain)
				{
					// Set What Tile is clicked
					if (HitActor.tag == 'MouseInterfaceKActor' || HitActor.tag == 'MCTile' )
						for (i = 0; i < MCA.Tiles.Length; i++)
							if (MCA.Tiles[i].name == HitActor.name)
								TileColor = MCA.Tiles[i];

					//TileColor.DoSomethingToSetItToFireFanDamage();
				}

				// If Stone Wall
				if (bIsSelectingStoneWall)
				{
					if (Phase1)
					{
						// PlaceOneStone
						if (Phase2)
						{
							//Place StoneDirection && Spawn
							//TileColor.DoSomethingToSetItToFireFanDamage();
						}
					}


				}
			}








			// Moving Press
			if (MCPlayer != none && !bCanStartMoving && !bIsRed)
			{
				//if you have AP and you can not move
				if (getPathAPCost() <= MCPlayer.APf) 
				{

					foreach AllActors(Class'MCPathNode', PathNode)
					{
						// If the Tiles && Paths X & Y match then we know where to move
						if(HitActor.Location.X == PathNode.Location.X &&
						   HitActor.Location.Y == PathNode.Location.Y &&
						   !PathNode.bBlocked && VSize(MCEnemy.Location - PathNode.Location) > 50.0f )
						{
							NewHitActor = PathNode;
							OnAIMoveToActor();
							bCanStartMoving = true;
						}
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

	function PlayerMove(float DeltaTime)
	{
		local vector NewAccel;	// where we want to go
		local vector X,Y,Z;		// Axes (Not used?)
		local vector PlayerPosition, Destination;	// rotation
		local rotator newRotation;	// set previous vectors as new location

		// Pawn != None && 

		if( MCPlayer != none && ScriptedMoveTarget != None && !MCPlayer.ReachedDestination(ScriptedMoveTarget) && bCanStartMoving )
		{
			//`log(CurrentPawnOn());
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



			if (MCPlayer.APf < 0.90f && MCPlayer.PlayerUniqueID == 1 && IsInState('PlayerWalking') && bCanStartMoving)
			{
				`log("we will change AP from" @ MCPlayer.PawnName @ "to" @ MCEnemy);
				//SetTimer(1.0f, false, 'TurnBasedTwo');
				SetWhoseTurn(2);
				//TurnBased(2);
			}

			if (MCPlayer.APf < 0.90f && MCPlayer.PlayerUniqueID == 2 && IsInState('PlayerWalking') && bCanStartMoving)
			{
				`log("we will change AP from" @ MCPlayer.PawnName @ "to" @ MCEnemy);
				//SetTimer(1.0f, false, 'TurnBasedOne');
				SetWhoseTurn(1);
				//TurnBased(1);
			}

			bCanTurnBlue = true;		// sets Tiles on
			FindPathsWeCanGoTo();
			// sets movement off
			bCanStartMoving = false;
			ScriptedMoveTarget = none;
//			`log("Reached a destination so change bCanTurnBlue" @ bCanTurnBlue);


////////////////////////////////////////////////////////////////////////////////////
			// Step 03
			// When player has less than 0.90 AP we switch CurrentTurnPawn
////////////////////////////////////////////////////////////////////////////////////
		}

		// ROLE_Authority is used for the server or the machine which is controlling the actor.
		if( Role < ROLE_Authority ) // then save this move and replicate it
		{
			//ReplicateMove(DeltaTime, NewAccel, DCLICK_None, OldRotation - Rotation);
			ReplicateMove(DeltaTime, NewAccel, DCLICK_None, newRotation);
		}
		else
		{
			//ProcessMove(DeltaTime, NewAccel, DCLICK_None, OldRotation - Rotation);
			ProcessMove(DeltaTime, NewAccel, DCLICK_None, newRotation);
		}
		//	super.PlayerMove(DeltaTime);

				// when he has reached the destination then go back.

	}

	function EndState(Name NextStateName)
	{
		`log( "Bye Bye" @ GetStateName() );
	}
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




/*
// When in Waiting state you set the Pawns block and ExtraCost so that the enemy can't touch him
*/
reliable server function ChangePathOn()
{
	local int i;

	for (i = 0; i < MCA.Tiles.Length ; i++)
	{
		if ( VSize(MCPlayer.Location - MCA.Paths[i].Location) < 50.0f )
		{
			`log("Where we at" @ MCA.Paths[i]);
			//MCA.Paths[i].bBlocked = true;
			//MCA.Paths[i].ShutDown();
			MCA.Paths[i].ExtraCost = 200;
			break;
		}
	}
}

/*
// When in Waiting state you set the Pawns block and ExtraCost so that the enemy can't touch him
*/
reliable server function ChangePathOff()
{
	local int i;

		for (i = 0; i < MCA.Tiles.Length ; i++)
		{
			if ( VSize(MCPlayer.Location - MCA.Paths[i].Location) < 50.0f )
			{
				`log("Where we at" @ MCA.Paths[i]);
				//MCA.Paths[i].bBlocked = false;
				MCA.Paths[i].ExtraCost = 0;
				break;
			}
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
<<<<<<< HEAD


	simulated function BeginState(Name PreviousStateName)
=======
	function BeginState(Name PreviousStateName)
>>>>>>> 69ca7878fffce8c34d2deff5d3f03d64175dddaf
	{
		`log( "Welcome to" @ GetStateName() );
	}

	function PlayerTick(float DeltaTime)
	{
<<<<<<< HEAD
		//local int i;
		
		if (MCPlayer.APf == 6 && !IsInState('PlayerWalking'))
=======
		if (MCPlayer != none && MCEnemy != none)
>>>>>>> 69ca7878fffce8c34d2deff5d3f03d64175dddaf
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
	}
}





/*
state AdjustCamera
{
	function BeginState(Name PreviousStateName)
	{
		`log( "Welcome to" @ GetStateName() );
	}
/////////////////////////////////////////////////////////


	function PlayerTick(float DeltaTime)
	{
		
		local int i;

		if (	MCPlayer.APf == 6 && MCEnemy.APf == 0 && MCPlayer != none && MCEnemy != none ||
				MCPlayer.APf == 0 && MCEnemy.APf == 6 && MCPlayer != none && MCEnemy != none)
		{



			for (i = 0;i < MCGameReplication(WorldInfo.GRI).MCPRIArray.Length ; i++)
			{
				// IF PC MCPawn is me & I have AP
				if (MCGameReplication(WorldInfo.GRI).MCPRIArray[i].PlayerUniqueID == MCPlayer.PlayerUniqueID &&
					MCGameReplication(WorldInfo.GRI).MCPRIArray[i].bHaveAp)
				{
					CameraProperties.IsTrackingHeroPawn = true;
					`log("Follow Player CAM cam");
					PrepairTurnOfCamera();
					//GotoState('WaitingForTurn');
					break;

				}else if(	MCGameReplication(WorldInfo.GRI).MCPRIArray[i].PlayerUniqueID == MCPlayer.PlayerUniqueID &&
							!MCGameReplication(WorldInfo.GRI).MCPRIArray[i].bHaveAp)
				{
					CameraProperties.IsTrackingEnemyPawn = true;
					`log("Follow Enemy cam");
					PrepairTurnOfCamera();
					//GotoState('WaitingForTurn');
					break;
				}
			}
<<<<<<< HEAD
		}
*/
		Global.PlayerTick(DeltaTime);
	}
=======
>>>>>>> 69ca7878fffce8c34d2deff5d3f03d64175dddaf



		} //if
	//	Global.PlayerTick(DeltaTime);
	
	}


/////////////////////////////////////////////////////////
	function EndState(Name NextStateName)
	{

		`log( "Bye Bye" @ GetStateName() );
	}
}

simulated function PrepairTurnOfCamera()
{
	`log("Preparation");
	GotoState('WaitingForTurn');
	SetTimer(1.5f, false,'TurnOfCameraTrack');
}

simulated function TurnOfCameraTrack()
{
	//`log("We Stop this now");
	CameraProperties.IsTrackingHeroPawn = false;
	CameraProperties.IsTrackingEnemyPawn = false;
}
*/













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









function crap()
{
	local MCGameReplication MCPR;	// Game Replication

	MCPR = MCGameReplication(WorldInfo.GRI);

	if (MCPR != none)
	{
		`log(MCPR.PRIArray[0]);
	}


}








/*
//
// Function that check which Tiles we can go to and add them to an Array so that we can Light them Up
//
reliable client function FindPathsWeCanGoTo()
{
	local int index;	// Where we start to remove/insert ni the array
	local int i;

	// start by setting start index for adding Tiles to 0
	index=0;
	// remove old Tiles so that we can add new Tiles
	BlueTiles.Remove(index, BlueTiles.length);

	// do we want to add tiles
	if (bCanTurnBlue)
	{
		// Search all of our current Tiles
		for (i = 0; i < MCA.Tiles.Length ; i++)
		{
			// find the Tiles we can move towards
			MoveTarget = FindPathToward(MCA.Tiles[i]);

			// if we have a Movetarget, AP and if that Tiles PathNode is not blocked then add them to an Array
			//if (MoveTarget != none && getPathAPCost() <= MCPawn.APf && !MCA.Tiles[i].PathNode.bBlocked)
			if (MoveTarget != none && getPathAPCost() <= MCPlayer.APf && !MCA.Tiles[i].PathNode.bBlocked && VSize(MCEnemy.Location - MCA.Tiles[i].Location) > 50.0f)
			{
				BlueTiles.InsertItem(index++,MCA.Tiles[i]);
			}
			else
			{
				// Otherwise turn of other Tiles, if this is not used then it will keep all Tiles Lit up
				MCA.Tiles[i].TurnTileOff();
			}
		}

		// If he Pawn has 0 AP reset adding Tiles until next round
		if (MCPlayer.APf == 0)
		{
			bCanTurnBlue=true;		
		}else
		{	
			// Otherwise turn of using this function
			bCanTurnBlue=false;
		}

		// resets Movetarget to 0 so we don't bug out
		MoveTarget = FindPathToward(MCPlayer);

		// turn on the added Tiles in the Array
		TurnTilesOn();
	}
}

//
// Light up all Tiles that we can move towards
//
simulated function TurnTilesOn()
{
	local int i;

	for (i = 0;i < BlueTiles.length ; i++)
	{
		BlueTiles[i].TileTurnBlue();
	}

}

//
// Function that calculates how much it cost to a certain destination and then
// return a number equal to what AP it should cost
//
simulated function int getPathAPCost()
{
	local int i,j;
	local int NewAPCost;	// What will the AP be

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
*/



/*
bIsSelectingFireFountain
FireTiles
bIsRed
*/
exec function SelectFireFountain(GFxClikWidget.EventData ev)
{
	local int i;
	local MCFireFountain fountain;

	fountain = Spawn(class'MCFireFountain');

	if (fountain.AP < MCPlayer.APf)
	{
		for (i = 0;i < BlueTiles.length ; i++)
		{
			BlueTiles[i].TurnTileOff();
		}

		// bIsRed = Spell Active
		bIsRed = true;
		// What Spell we will use
		bIsSelectingFireFountain = true;
		CheckDistanceNearPlayer();
	}
}

reliable client function CheckDistanceNearPlayer()
{
	local int index;	// Where we start to remove/insert ni the array
	local int i;


	// start by setting start index for adding Tiles to 0
	index=0;
	// remove old Tiles so that we can add new Tiles
	FireTiles.Remove(index, FireTiles.length);

	// do we want to add tiles
	if (bIsRed)
	{
		// Search all of our current Tiles
		for (i = 0; i < MCA.Tiles.Length ; i++)
		{
			// find the Tiles we can move towards
			if (bIsSelectingFireFountain && VSize(MCPlayer.Location - MCA.Tiles[i].Location) < 230.0f &&
				VSize(MCPlayer.Location - MCA.Tiles[i].Location) > 70.0f)
			{
				FireTiles.InsertItem(index++,MCA.Tiles[i]);
			}else
			{
				// Otherwise turn of other Tiles, if this is not used then it will keep all Tiles Lit up
				MCA.Tiles[i].TurnTileOff();
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
				MCA.Tiles[i].TurnTileOff();
			}
		}

		// turn on the added Tiles in the Array
		SpellTileTurnOn();

		//bIsRed = false;
	}
}

simulated function SpellTileTurnOn()
{
	local int i;

	for (i = 0;i < FireTiles.length ; i++)
	{
		if (TileColor == FireTiles[i])
		{
			FireTiles[i].SpellTileTurnRed();
		}else
		{
			FireTiles[i].SpellTileTurnBlue();
		}
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

exec function MCRotationLeft()
{
	CameraProperties.Rotation.Roll += CameraProperties.RoationSpeed;
}

exec function MCRotationRight()
{
	CameraProperties.Rotation.Roll -= CameraProperties.RoationSpeed;
}

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




simulated function moveCameraEnemy()
{
	`log("HI ME LOGGING");
	CameraProperties.IsTrackingEnemyPawn = true;
	SetTimer(1.0f, false, 'stopMpveCameraEnemy');
}

simulated function stopMpveCameraEnemy()
{
	CameraProperties.IsTrackingEnemyPawn = false;
}






exec function CastFireball (GFxClikWidget.EventData ev)
{
	local MCFireball spell;
	moveCameraEnemy();
	spell = Spawn(class'MCFireball');
	spell.Cast(MCPlayer, MCEnemy);
	ServerCastFireball();
}

server reliable function ServerCastFireball()
{
	local MCFireball spell;
	moveCameraEnemy();
	spell = Spawn(class'MCFireball');
	spell.Cast(MCPlayer, MCEnemy);
}

exec function CastFireFan (GFxClikWidget.EventData ev)
{
	local MCFireFan spell;
	spell = Spawn(class'MCFireFan');
	spell.Cast(MCPlayer, MCEnemy);
	ServerCastFireFan();
}

server reliable function ServerCastFireFan ()
{
	local MCFireFan spell;
	spell = Spawn(class'MCFireFan');
	spell.Cast(MCPlayer, MCEnemy);
}

exec function CastRockAndRoll (GFxClikWidget.EventData ev)
{
	local MCRockAndRoll spell;
	spell = Spawn(class'MCRockAndroll');
	spell.Cast(MCPlayer, MCEnemy);
	ServerCastRockAndRoll();
}

reliable server function ServerCastRockAndRoll ()
{
	local MCRockAndRoll spell;
	spell = Spawn(class'MCRockAndroll');
	spell.Cast(MCPlayer, MCEnemy);
}

// Rock Wall just spawns on the server for both players
exec function CastStoneWall()
{
	ServerCastStoneWall();
}

reliable server function ServerCastStoneWall()
{
	local MCStoneWall spell;
	spell = spawn(class'MCStoneWall');
	spell.Cast(MCPlayer, (MCEnemy.Location - MCPlayer.Location) / 2);
}

exec function CastRockFang()
{
	ServerCastRockFang();
}

reliable server function ServerCastRockFang()
{
	local MCRockFang spell;
	spell = spawn(class'MCRockFang');
	spell.Cast(MCPlayer, MCEnemy.Location);
}

defaultproperties
{
	CameraClass=class'MystrasChampion.MCCamera'
	CameraProperties=MCCameraProperties'mystraschampionsettings.Camera.CameraProperties'

	InputClass=class'MouseInterfacePlayerInput'

	bCanStartMoving=false
	bCanTurnBlue=true
}