class MCPlayerController extends MouseInterfacePlayerController;

/*
	Variables Section
*/
//	AI Movement Variables
///////////////////////////////////////////////
/** Move target from last scripted action */
var Actor ScriptedMoveTarget;

/** Route from last scripted action; if valid, sets ScriptedMoveTarget with the points along the route */
var Route ScriptedRoute;

/** view focus from last scripted action */
var Actor ScriptedFocus;

/** using for setting mouseInterfaceHud actor to this*/
var Actor NewHitActor;



//	Camera calling
///////////////////////////////////////////////
// The Camera Properties link
var const MCCameraProperties CameraProperties;





//	Others
///////////////////////////////////////////////
// Struct that contains all the PathNodes, Triggers and Tiles
struct MCActors
{
	var array<PathNode> Paths;
	var array<Trigger> Triggers;
	var array<MCTile> Tiles;
};

// struct object
var MCActors MCA;
// Pawn char calling
var MCPawn MCP;
var MCPawn MyPlayers[2];
var int setActivePlayer;

var array <MCPawn> MyPawns;
var MCPawn CurrentTurnPawn;

// used for turning on and off PlayerMove, so they all don\t collide
var bool bCanStartMoving;

///////////////////////////////////////////////

var bool bFlagIsHere;	// used for debug flag to know when to remove it
var bool bCanGreenGoBack;
var bool bCanTurnBlue;
var array <PathNode> RouteCacheCheck;	// Where we want to go all the time
var actor aSetPath;				// Save The Current Actor
var array <MCTile> RoutedTiles;	// add Tile Pathnotes Check in here
var array <MCTile> BlueTiles;	// add Tile Pathnotes Check in here

var int addPlusThree;


var bool bFirstTurn;	// In set round sets first round to Player 01




// Replication block
replication
{
	// Replicate only if the values are dirty, this replication info is owned by the player and from server to client
	if (bNetDirty && bNetOwner)
		 bCanTurnBlue, addPlusThree, CurrentTurnPawn, setActivePlayer;

	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		NewHitActor, ScriptedMoveTarget, MCA, bFirstTurn, MyPlayers;
}



simulated event ReplicatedEvent(name VarName)
{
	if(VarName == 'NewHitActor') //this variable has changed so update the clients
		ActuallyDoSomething();

}

simulated function ActuallyDoSomething()
{
	`log("NewHitActor was replicated!"); //clients do something
}

simulated event PostBeginPlay()
{
//	local int i;
	local PathNode PathNode;
	local MCTile Tile;
//	local string newText01, newText02;
//	local int newInt01;
	//local vector veccy;

    super.PostBeginPlay();

    SetTimer(1.0f, false, 'CheckPawnFast');
    //`log("State Name:"GetStateName());

	// Sets Tiles and PathNode in an array if they are close to eachother
	foreach AllActors(Class'MCTile', Tile)
	{
		foreach AllActors(Class'PathNode', PathNode)
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

/*
	// debug test for checking so that they are at the same place
	for (i = 0; i < MCA.Tiles.Length; i++)
	{
		`log("Tile[" $ i $ "] =" @ MCA.Tiles[i]  @     "    Path[" $ i $ "] =" @ MCA.Paths[i]       );
	}
*/
	CheckPawnFast();


	if (Role == ROLE_Authority)
	{
		//SetTimer(1.0, true, 'ServerTest');
		SetTimer(1.0, true, 'checkForTwoPlayers');
	}else
	{
		//SetTimer(1.0, true, 'ClientTest');
		SetTimer(1.0, true, 'checkForTwoPlayers');
	}

}

/*
function that checks if we have 2 players available at start and if so add them to the array
*/
simulated function checkForTwoPlayers()
{
	local MCPawn NewMCP;
	local int HowMany, goPlus;
	local int i;

	HowMany = 0;

	// check how many players we have
	foreach AllActors(Class'MCPawn', NewMCP)
	{
		HowMany++;
		continue;
	}

	// if we have 2 players then add them to the array
	if (HowMany == 2)
	{
		goPlus = 0;
		foreach AllActors(Class'MCPawn', NewMCP)
		{
			// dynamic array
			MyPawns.InsertItem(goPlus, NewMCP);
			// normal array
			MyPlayers[goPlus] = NewMCP;
			goPlus++;
			continue;
		}

		// lastly clear the check
		ClearTimer('checkForTwoPlayers');

/*
		for (i = 0; i < MCA.Paths.Length ; i++)
		{
			if (MCA.Paths[i].name == 'MCPathNode_48')
			{
				MyPawns[0].SetLocation(MCA.Paths[i].Location);
			}

			if (MCA.Paths[i].name == 'MCPathNode_0')
			{
				MyPawns[1].SetLocation(MCA.Paths[i].Location);
			}
		}
*/
	//	`log("bFirstTurn" @ bFirstTurn);
		MyPlayers[0].APf = 0.0f;
		MyPlayers[1].APf = 0.0f;
		`log("now CurrentTurnPawn is:" @ CurrentTurnPawn);
		CurrentTurnPawn = MyPlayers[0];
		`log("again CurrentTurnPawn is:" @ CurrentTurnPawn);
	//	`log("step 01: At the bFirstTurn Player 01");
		TurnBased();
	}

}


function ServerTest()
{
	local int i;
	local MCGameInfo MCGI;
	local MCPlayerReplication MCPR;

	MCGI = MCGameInfo(WorldInfo.Game);
	MCPR = MCPlayerReplication(WorldInfo.GRI);

	if (MCGI != none)
	{
//		`log(MCGI.GameRound);
	}

	if (MCPR != none)
	{
//		`log(MCPR.GameRound);
	}
/*
	for (i = 0; i < 2 ; i++)
	{
		`log("Players["$ i $ "]" @MyPlayers[i]);
		`log(String or variable)
	}
*/
	for (i = 0; i < MyPawns.length ; i++)
	{
		`log("Players["$ i $ "]" @MyPawns[i]);
	}
	

}
/*
function ClientTest()
{
	local int i;
	local MCGameInfo MCGI;
	local MCPlayerReplication MCPR;

	MCGI = MCGameInfo(WorldInfo.Game);
	MCPR = MCPlayerReplication(WorldInfo.GRI);

	if (MCGI != none)
	{
//		`log(MCGI.GameRound);
	}

	if (MCPR != none)
	{
//		`log(MCPR.GameRound);
	}

	for (i = 0; i < 2 ; i++)
	{
		`log("Players" @MyPlayers[i]);
	}

}
*/



// Just a functin to check to see if pawn is spawned in the game, and then sets him to Mystras Champion Pawn
singular function CheckPawnFast()
{
	if (Pawn != none)
	{
		MCP = MCPawn(Pawn);
		`log(MCP);
		`log(GetALocalPlayerController());
		`log(GetALocalPlayerController().Pawn);
		`log(GetALocalPlayerController().Pawn.Health);
	}else
	{
		`log("no Pawn Here");
	}
}

/*
// Check if we have pawn
*/
event Possess( Pawn aPawn, bool bVehicleTransition )
{

    `log("Possess:"@ aPawn);
    super.Possess(aPawn, bVehicleTransition);
}

function AcknowledgePossession( Pawn P )
{
    `log("AcknowledgePossession:"@ P);
    super.AcknowledgePossession(P);
}


singular function PlayerTick(float DeltaTime)
{
//	`log("State -------------:" @ GetStateName());
	super.PlayerTick(DeltaTime);
	///
}


/*
// Will set which Player is active and will let him do his move. Then switched to the other Player and so forth.
*/
reliable client function TurnBased()
{
	local MCPlayerReplication MCPR;
	local int i;

	MCPR = MCPlayerReplication(WorldInfo.GRI);

	if (MCPR != none)
	{
		//MCPR.GameRound++;
	}
////////////////////////////////////////////////////////////////////////////
	// Step 01
	// First round sets character 1 AP to 6 and state in PlayerWalking
	// Player 2 goes to idle
	// Then we add Player 1 as the CurrentTurnPawn;
////////////////////////////////////////////////////////////////////////////
	if (bFirstTurn)
	{
		`log("----------------------------------------------");
		`log("----------------------------------------------");
		`log("----------------------------------------------");
		`log("MyPlayers[0]" @ MyPlayers[0]);
		`log("MyPlayers[1]" @ MyPlayers[1]);

		`log("bFirstTurn" @ bFirstTurn);
		MyPlayers[0].APf = 0.0f;
		CurrentTurnPawn = MyPlayers[0];
		`log("step 01: At the bFirstTurn Player 01");
		MyPlayers[1].APf = 0.0f;
		`log("step 01: At the bFirstTurn Player 01");
		//GotoState('WaitingForTurn');
		bFirstTurn = false;
		`log("----------------------------------------------");
		`log("----------------------------------------------");
		`log("----------------------------------------------");
	}

	`log("after step 01: ho is CurrentTurnPawn = " @ CurrentTurnPawn);
////////////////////////////////////////////////////////////////////////////
	// Step 02
	// We take the Current Player and give him some AP
	// We set him in the right State
////////////////////////////////////////////////////////////////////////////

	if ( CurrentTurnPawn != none && CurrentTurnPawn.APf == 0 && CurrentTurnPawn == MyPlayers[0])
	{
		`log("we have erached" @CurrentTurnPawn);
		setActivePlayer = 1;
		CurrentTurnPawn.APf = 6.0f;
		//GotoState('PlayerWalking');
	}else
	{
		for (i = 0; i < 2 ; i++)
		{
			if (CurrentTurnPawn != MyPlayers[i])
			{
				`log("CurrentTurnPawn is not the same, he is" @ MyPlayers[i]);
				MyPlayers[i].APf = 0.0f;
				//GotoState('WaitingForTurn');
			}
		}
	}

	if ( CurrentTurnPawn != none && CurrentTurnPawn.APf == 0 && CurrentTurnPawn == MyPlayers[1])
	{
		`log("we have erached" @CurrentTurnPawn);
		setActivePlayer = 2;
		CurrentTurnPawn.APf = 6.0f;
		//GotoState('PlayerWalking');
	}else
	{
		for (i = 0; i < 2 ; i++)
		{
			if (CurrentTurnPawn != MyPlayers[i])
			{
				`log("CurrentTurnPawn is not the same, he is" @ MyPlayers[i]);
				MyPlayers[i].APf = 0.0f;
				//GotoState('WaitingForTurn');
			}
		}
	}


////////////////////////////////////////////////////////////////////////////
	// Step 03
	// When player has no more AP we set him to the idle state
////////////////////////////////////////////////////////////////////////////


}


function pawn CurrentPawnOn()
{
	if (CurrentTurnPawn == MyPlayers[0])
	{
		`log("01");
		return CurrentTurnPawn;
	}

	if (CurrentTurnPawn == MyPlayers[1])
	{
		`log("02");
		return CurrentTurnPawn;
	}

}
























/*
// Function that Turns on Tiles after Lightover
*/
function SetTileChangeColor(int index)
{
	local int i;

	for (i = 0; i < MCA.Paths.Length ; i++)
	{
		if (MCA.Paths[i].Name == RouteCache[index].Name)
		{
			MCA.Tiles[i].TileTurnBlue();
			//RoutedTiles.InsertItem(index,MCA.Tiles[i]);
		}
	}
}

/*
// Function that Turns of the Tiles after lightover
*/
function TurnOffTiles(int index)
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

*/

simulated function FindPathsWeCanGoTo()
{
//	local MCTile Tile;
	local int addPlus;
	local int i, ii;

	addPlus=0;
	BlueTiles.Remove(0, BlueTiles.length);

	if (bCanTurnBlue)
	{
		for (ii = 0; ii < MCA.Tiles.Length ; ii++)
		{
			MoveTarget = FindPathToward(MCA.Tiles[ii]);
			//
			if (MoveTarget != none && RouteCache.length <= CurrentTurnPawn.APf)
			{
				BlueTiles.InsertItem(addPlus++,MCA.Tiles[ii]);
			}
			else
			{
				MCA.Tiles[ii].TurnTileOff();
			}
		}
		
		for (i = 0;i < BlueTiles.length ; i++)
		{
			BlueTiles[i].TileTurnBlue();
		}
		`log("I want to leave please");
		//`log("MoveTarget =" @ MoveTarget);
		MoveTarget = FindPathToward(Pawn);
		if (MoveTarget != none)
	//	`log("MoveTarget =" @ MoveTarget);
		bCanTurnBlue=false;
	}
}


		/*
		foreach AllActors(Class'MCTile', Tile)
		{
			//Tile.TileTurnBlue();
			MoveTarget = FindPathToward(Tile);

			if (MoveTarget != none && RouteCache.length <= MCP.APf)
			{
				//Tile.TileTurnBlue();
				BlueTiles.InsertItem(addPlus++,Tile);
			}
		//	else
		//	{
		//		Tile.TurnTileOff();
		//	}
			continue;
		}
		*/

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// PlayerWalking is the main state (set by mouseinterface controller).
// Can we go to somewhere with the current AP checks, and the press to
// go there.

auto state PlayerWalking
{
	local int g;
	local MCTestActor SpawnActor;	// Spawning & destroying flags

	ignores SeePlayer, HearNoise, Bump;


	// function that will use find mouseover to find what location to go to
	// if we can use mouse over & out that would be better
	function PlayerTick(float DeltaTime)
	{
		local int i;
		local Actor DestActor;
//		local array<MCTestActor> CheckTestActor;
		local MouseInterfaceHUD MouseInterfaceHUD;	
		local actor HitActor;			// What Tile we are looking at
		// If we are not moving then please use this




		//`log("Current Pawn is" @ CurrentTurnPawn);
		if (Pawn != none && !bCanStartMoving)
		{
			// Type cast to get our HUD
			MouseInterfaceHUD = MouseInterfaceHUD(myHUD);
			// What tile
			HitActor = MouseInterfaceHUD.HitActor2;
			

			if (CurrentTurnPawn != none && bCanTurnBlue && addPlusThree == 0)
			{
				if (addPlusThree == 0)
				{
					FindPathsWeCanGoTo();
				}

				addPlusThree++;

				if (addPlusThree == 1)
				{
					bCanTurnBlue = false;
					addPlusThree = 0;
				}
				//bCanTurnBlue = false;
			}
	//	`log("State -------------:" @ GetStateName());
/*
			for (i = 0; i < MCA.Paths.Length ; i++)
			{
				//PathNode10
				if (MCA.Paths[i].name == 'PathNode_10')
				{
					MCA.Paths[i].Cost = 2;
					MCA.Paths[i].ExtraCost = 2;
					`log("Current Cost " @ MCA.Paths[i].Cost);
					`log("Current Cost " @ MCA.Paths[i].ExtraCost);
				}
			}
*/
			//FindPathsWeCanGoTo();

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

		//	`log("Dest" @ DestActor);		// What Tile we want to go to
		//	`log("Path" @ aSetPath);		// Last Path to reach
		//	`log("Rout" @ RouteCache[RouteCache.Length -1]);	// Last Path to reach
		//	`log("Move" @ MoveTarget);		// First Path to go to

			// checks how many flags are up atm and add them to an array
			// debug flag
			/*
			foreach AllActors(Class'MCTestActor', SpawnActor)
			{
				CheckTestActor.AddItem(SpawnActor);
				continue;
			}
			*/




/*

			// removes the once that aren't needed
			if (aSetPath != RouteCache[RouteCache.Length -1] && !bFlagIsHere)
			{

				// check how many Paths we have
				for (h = 0; h < RouteCache.Length; h++)
				{
					//
					// Turns off Tiles function
					TurnOffTiles(h);
				//bCanTurnBlue=true;
				}

				if (RouteCache[0] == none)
				{
					
				}else
				{
					bFlagIsHere = true;
				}
				
			}
*/

					/*
					// removes flag array
					for (j = 0;j < CheckTestActor.Length ; j++)
					{
						if (RouteCache[h].Location.X == CheckTestActor[j].Location.X && RouteCache[h].Location.Y == CheckTestActor[j].Location.Y)
						{
							
						}else
						{

							CheckTestActor[j].destroy();
							bFlagIsHere = false;
						}
					}
					*/
					//









			// if we have a Tile we can start moving to
			if (DestActor != None)
			{
				ScriptedMoveTarget = DestActor;

				// finds the route target for all
				// MoveTarget is the first PathNode to go to
				MoveTarget = FindPathToward(ScriptedMoveTarget);

				if (MoveTarget != None && RouteCache.Length <= CurrentTurnPawn.APf)
				{
					aSetPath = RouteCache[RouteCache.Length -1];
					//bFlagIsHere = false;

				// kill of all Actors if it's less then route
			
					// Spawn a flag if we can do there
				//	for (i = 0;i < RouteCache.Length; i++)
				//	{
						//`log("RouteCache" @ RouteCache[i]);	// how many pathnodes until destination
						//	SpawnActor = Spawn(class'MCTestActor', , , RouteCache[i].Location,);
						
						// Set Tiles to Turn green & add them to an array to see which are active
						//SetTileChangeColor(i);
						
						
						// Adds current RouteCache list into an empty Array
				//		if (RouteCache[i] != RouteCacheCheck[i])
				//		{
				//			//insert
				//			RouteCacheCheck.InsertItem(i,RouteCache[i]);
				//			// removes if there are more Checks
				//			if (RouteCache.Length < RouteCacheCheck.Length)
				//			{
				//				RouteCacheCheck.Remove(RouteCache.Length, 5);
				//			}
				//		}
						
				//	}
					//	`log("RouteCacheCheck.Length" @ RouteCacheCheck.Length);
					//	`log("RouteCache.Length     " @ RouteCache.Length);
					//`log("CheckTestActor.Length " @ CheckTestActor.Length);
					//`log("RouteCache.Length     " @ RouteCache.Length);
					//`log("------------------------------");	
				}
			}
	
		}
/*
		`log("RCLen" @ RouteCache.length);
		`log("AP" @ MCP.APf);
		`log("Path" @ MoveTarget);
		`log("----------------------------");
		for (i = 0; i < RouteCache.length ; i++)
		{
			`log("Path:" @ RouteCache[i]);
		}
*/
		super.PlayerTick(DeltaTime);
	}

	// sets of the click to move place
	exec function StartFire(optional byte FireModeNum)
	{
		//local int ii;
		local MouseInterfaceHUD MouseInterfaceHUD;	
		local actor HitActor;			// What Tile we are looking at
		local PathNode PathNode;		// PathNode
		// every click destroy last root path
		foreach AllActors(Class'MCTestActor', SpawnActor)
		{
			SpawnActor.destroy();
			continue;
		}
	
		// Type cast to get our HUD
		MouseInterfaceHUD = MouseInterfaceHUD(myHUD);
		// What tile
		HitActor = MouseInterfaceHUD.HitActor2;

		// next is to set destination to pathnode and not tile
		if (HitActor.tag == 'MouseInterfaceKActor' || HitActor.tag == 'MCTile' )
		{
			//if you have AP
			if (RouteCache.length <= CurrentTurnPawn.APf) 
			{
				//CurrentTurnPawn.APf -= RouteCache.length;
				foreach AllActors(Class'PathNode', PathNode)
				{
					//`log("crap");
					if(HitActor.Location.X == PathNode.Location.X &&
					   HitActor.Location.Y == PathNode.Location.Y)
					{
						NewHitActor = PathNode;
						OnAIMoveToActor();
						bCanStartMoving = true;
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

		if( ScriptedMoveTarget != None && !Pawn.ReachedDestination(ScriptedMoveTarget) && bCanStartMoving )
		{
			`log(CurrentPawnOn());
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

		if (Pawn.ReachedDestination(ScriptedMoveTarget))
		{
			// sets movement off
			bCanStartMoving = false;
			bCanTurnBlue = true;
			addPlusThree = 0;
			ScriptedMoveTarget = none;

////////////////////////////////////////////////////////////////////////////////////
			// Step 03
			// When player has less than 0.90 AP we switch CurrentTurnPawn
////////////////////////////////////////////////////////////////////////////////////
			if (CurrentTurnPawn == MyPlayers[0] && CurrentTurnPawn.APf < 0.90)
			{
				CurrentTurnPawn.APf = 0.0f;
				CurrentTurnPawn = MyPlayers[1];
				//SetTimer(1.0f, false,'TurnBased');
				TurnBased();
			}

			if (CurrentTurnPawn == MyPlayers[1] && CurrentTurnPawn.APf < 0.90)
			{
				CurrentTurnPawn.APf = 0.0f;
				CurrentTurnPawn = MyPlayers[0];
				//SetTimer(1.0f, false,'TurnBased');
				TurnBased();
			}


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

Begin:
	Sleep(0.5);
//	FindPathsWeCanGoTo();
	`log("State -------------:" @ GetStateName());
//	`log("restart");
	goto('Begin');
	/*

	// finds the route target for all
	// and also spawns the Test actor firstly to see where we are heading
	MoveTarget = FindPathToward(ScriptedMoveTarget);
	if (MoveTarget != None)
	{
		//`log("RouteCache" @ RouteCache.Length);

		for (g = 0;g < RouteCache.Length; g++)
		{
			SpawnActor = Spawn(class'MCTestActor', , , RouteCache[g].Location,);
			//`log("RouteCache" @ RouteCache[i]);
		}
	}
*/
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

state WaitingForTurn
{
/*
	function PlayerTick(float DeltaTime)
	{
		//`log("Current Pawn is" @ CurrentTurnPawn);
	}
*/
	Begin:
	Sleep(1.0f);
	`log("State -------------:" @ GetStateName());
	goto('Begin');
}












































/**
 * Scripting hook to move this AI to a specific actor.
 */
 
reliable client function OnAIMoveToActor()
{
	local Actor DestActor;
//	local PathNode PathNode;
	local int i;
//	local MCTestActor SpawnActor;



	// sets PathNode to DestActor
	DestActor = NewHitActor;

	if (Role == ROLE_Authority)
	{
		//`log("Executed on the server");
	//	`log("Client -> Server");
	//	`log("After DestActor: " @ DestActor);
	//	`log("After NewHitActor: " @ NewHitActor);
	}
	// if we found a valid destination
	if (DestActor != None)
	{
		`log("-------------------------------------");
		`log("RouteCache.length" @ RouteCache.length);
		`log("CurrentTurnPawn" @ CurrentTurnPawn.APf @ "-" @ RouteCache.length);
		CurrentTurnPawn.APf -= RouteCache.length;
		`log("= " @ CurrentTurnPawn.APf);
		`log("-------------------------------------");
		
	//	ScriptedMoveTarget = DestActor;
	//	if (!IsInState('ScriptedMove'))
	//	{
	//		// RouteCache is 0
	//		PushState('ScriptedMove');
	//		`log("PushState('ScriptedMove')");
	//	}
		
		if (!IsInState('PlayerWalking'))
		{
			// RouteCache is 0
			//PushState('PlayerWalking');

			GotoState('PlayerWalking');
			if (Role == ROLE_Authority)
			{
				`log("01 if DestActor true and not PlayerWalking");
				//`log("Server got it so == PushState('PlayerWalking')");
				//goPlayerWalking();
			}
		}

		ScriptedMoveTarget = DestActor;

		// finds the route target for all
		MoveTarget = FindPathToward(ScriptedMoveTarget);

		if (MoveTarget != None)
		{
			//`log("RouteCache" @ RouteCache.Length);

			for (i = 0;i < RouteCache.Length; i++)
			{
		//		SpawnActor = Spawn(class'MCTestActor', , , RouteCache[i].Location,);
				//MCP.SetLocation(RouteCache[0].Location);
			//	`log("RouteCache" @ RouteCache[i]);
			}

		}

	}
	else
	{
		`warn("Invalid destination for scripted move");
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

defaultproperties
{
	CameraClass=class'MystrasChampion.MCCamera'
	CameraProperties=MCCameraProperties'mystraschampionsettings.Camera.CameraProperties'

	InputClass=class'MouseInterfacePlayerInput'

	bCanStartMoving=false
	bFlagIsHere=true
	bCanTurnBlue=true
	addPlusThree=0
	bFirstTurn= true
	setActivePlayer= 0
}