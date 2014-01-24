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





replication
{
	if(bNetDirty)
		NewHitActor, MCP;
}

simulated event PostBeginPlay()
{
	local int i;
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

	// debug test for checking so that they are at the same place
	for (i = 0; i < MCA.Tiles.Length; i++)
	{
		`log("Tile[" $ i $ "] =" @ MCA.Tiles[i]  @     "    Path[" $ i $ "] =" @ MCA.Paths[i]       );
	}
}

// Just a functin to check to see if pawn is spawned in the game, and then sets him to Mystras Champion Pawn
function CheckPawnFast()
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

state idle
{
	// Fixing a problem with auto PlayerWalking State on 3 entry, Spoofy
	// http://forums.epicgames.com/threads/865883-Why-s-Player-always-going-to-PlayerWalking-state-even-though-other-state-is-auto
}
// PlayerWalking is the main state (set by mouseinterface controller).
// Can we go to somewhere with the current AP checks, and the press to
// go there.
state PlayerWalking
{
	local MouseInterfaceHUD MouseInterfaceHUD;	
	local actor HitActor;			// What Tile we are looking at
	local PathNode PathNode;		// PathNode
	local MCTestActor SpawnActor;	// Spawning & destroying flags

	// function that will use find mouseover to find what location to go to
	// if we can use mouse over & out that would be better
	singular function PlayerTick(float DeltaTime)
	{
		local int i, j;
		local Actor DestActor;
		local array<MCTestActor> CheckTestActor;

		// Type cast to get our HUD
		MouseInterfaceHUD = MouseInterfaceHUD(myHUD);
		// What tile
		HitActor = MouseInterfaceHUD.HitActor2;

		if (HitActor.tag == 'MouseInterfaceKActor' || HitActor.tag == 'MCTile' )
		{

			for (i = 0; i < MCA.Tiles.Length; i++)
			{
				if (MCA.Tiles[i].name == HitActor.name)
				{
					//`log("Tile" @MCA.Tiles[i] @ "  and PathNode" @ MCA.Paths[i]);
					// sets PathNode to DestActor
					DestActor = MCA.Tiles[i];
				}
			}
		}

		// checks how many flags are up atm and add them to an array
		foreach AllActors(Class'MCTestActor', SpawnActor)
		{
			CheckTestActor.AddItem(SpawnActor);
			continue;
		}

		// if we found a valid destination
		if (DestActor != None)
		{
			ScriptedMoveTarget = DestActor;

			// finds the route target for all
			// MoveTarget is the first PathNode to go to
			MoveTarget = FindPathToward(ScriptedMoveTarget);
			if (MoveTarget != None)
			{
				//`log("RouteCache" @ RouteCache.Length);
				//if it's less then current AP
				if (RouteCache.Length <= MCP.APf)
				{
					// kill of all Actors if it's less then route
					if (CheckTestActor.Length <= RouteCache.Length)
					{
						// Spawn a flag if we can do there
						for (i = 0;i < RouteCache.Length; i++)
						{
							//`log("RouteCache" @ RouteCache[i]);	// how many pathnodes until destination
							SpawnActor = Spawn(class'MCTestActor', , , RouteCache[i].Location,);
						}
					}else
					{
						// removes array
						for (j = 0;j < CheckTestActor.Length ; j++)
						{
							CheckTestActor[j].destroy();
						}
					}
				}
			}
		}
	}

	exec function StartFire(optional byte FireModeNum)
	{
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
			if (RouteCache.length <= MCP.APf)
			{
					foreach AllActors(Class'PathNode', PathNode)
				{
					//`log("crap");
					if(HitActor.Location.X == PathNode.Location.X &&
					   HitActor.Location.Y == PathNode.Location.Y)
					{
						//`log("HitActor.Location :" @ HitActor.Location );
						//`log("HitActor :" @ HitActor );
						//`log("PathNode :" @ PathNode );
						//`log("PathNode.Location :" @ PathNode.Location );
						
						// sets PathNode to HitActor which we set later in calc path to that actor
						NewHitActor = PathNode;
						OnAIMoveToActor();
						break;
					}
				}	
			}
		}
	}

	Begin:
	`log("State -------------:" @GetStateName());
	Sleep(0.5);
	goto('Begin');
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Scripting hook to move this AI to a specific actor.
 */
singular function OnAIMoveToActor()
{
	local Actor DestActor;
//	local PathNode PathNode;
	local int i;
//	local MCTestActor SpawnActor;


	// sets PathNode to DestActor
	DestActor = NewHitActor;
	// if we found a valid destination
	if (DestActor != None)
	{

		ScriptedMoveTarget = DestActor;
		if (!IsInState('ScriptedMove'))
		{
			// RouteCache is 0
			PushState('ScriptedMove');
			`log("PushState('ScriptedMove')");
		}

		// finds the route target for all
		MoveTarget = FindPathToward(ScriptedMoveTarget);
		if (MoveTarget != None)
		{
			//`log("RouteCache" @ RouteCache.Length);

			for (i = 0;i < RouteCache.Length; i++)
			{
		//		SpawnActor = Spawn(class'MCTestActor', , , RouteCache[i].Location,);
		//		`log("RouteCache" @ RouteCache[i]);
			}

		}
	}
	else
	{
		`warn("Invalid destination for scripted move");
	}
}












state MovementState
{

Begin:
`log("test");
};




/**
 * Simple scripted movement state, attempts to pathfind to ScriptedMoveTarget and
 * returns execution to previous state upon either success/failure.
 */
state ScriptedMove
{
	local MCTestActor SpawnActor;
	local int i;

	event PoppedState()
	{
		if (ScriptedRoute == None)
		{
			// if we still have the move target, then finish the latent move
			// otherwise consider it aborted
			ClearLatentAction(class'SeqAct_AIMoveToActor', (ScriptedMoveTarget == None));
		}
		// and clear the scripted move target
		ScriptedMoveTarget = None;
	}

	event PushedState()
	{
		if (Pawn != None)
		{
			// make sure the pawn physics are initialized
			Pawn.SetMovementPhysics();
		}
	}

	singular function PlayerMove(float DeltaTime)
	{
		local vector AltAccel;	// where we want to go
		local vector PlayerPosition, Destination;	// rotation
		local rotator newRotation;	// set previous vectors as new location

		// Starts the movement calculation
		if (Pawn != None && ScriptedMoveTarget != None && !Pawn.ReachedDestination(ScriptedMoveTarget))
		{
			//update our location locally with our pawns location
			PlayerPosition.X = Pawn.Location.X;
			PlayerPosition.Y = Pawn.Location.Y;

			Destination.X = ScriptedMoveTarget.Location.X;
			Destination.Y = ScriptedMoveTarget.Location.Y;

			newRotation = Rotator(Destination - PlayerPosition);
			Pawn.SetRotation(newRotation);

			// This is the END DESTINATION, if it's only one pathnode then yes go there otherwise no find a path before.
			if (ActorReachable(ScriptedMoveTarget))
			{
				// Move towards the Last Location
				AltAccel -= normal(Pawn.Location - ScriptedMoveTarget.Location);
			}
			else
			{
				// attempt to find a path to the target
				MoveTarget = FindPathToward(ScriptedMoveTarget);
				// take next Path and go there
				if (MoveTarget != None)
				{
					// Move towards the next PathNode Location
					AltAccel -= normal(Pawn.Location - MoveTarget.Location);
				}
				else
				{
					// abort the move
					`warn("Failed to find path to"@ ScriptedMoveTarget);
					ScriptedMoveTarget = None;
				}
			}
			
		}

		// when he has reached the destination then go back.
		if (Pawn.ReachedDestination(ScriptedMoveTarget))
		{
			// returns to previous state
			PopState();
		}

		// ROLE_Authority is used for the server or the machine which is controlling the actor.
		if (Role < ROLE_Authority)
		{
			ReplicateMove(DeltaTime, AltAccel, DCLICK_None, newRotation);
		}
		else
		{
			ProcessMove(DeltaTime, AltAccel, DCLICK_None, newRotation );
		}
	}
Begin:

	// finds the route target for all
	// and also spawns the Test actor firstly to see where we are heading
	MoveTarget = FindPathToward(ScriptedMoveTarget);
	if (MoveTarget != None)
	{
		`log("RouteCache" @ RouteCache.Length);

		for (i = 0;i < RouteCache.Length; i++)
		{
			SpawnActor = Spawn(class'MCTestActor', , , RouteCache[i].Location,);
			//`log("RouteCache" @ RouteCache[i]);
		}
	}

/*
	// while we have a valid pawn and move target, and
	// we haven't reached the target yet
	//while (Pawn != None && ScriptedMoveTarget != None && !Pawn.ReachedDestination(ScriptedMoveTarget))
	if (Pawn != None && ScriptedMoveTarget != None && !Pawn.ReachedDestination(ScriptedMoveTarget))
	{
	//	`log("TOP DIR:" @ FindPathToward(ScriptedMoveTarget));
	//	`log("-------------------------------------");
//		SpawnActor = Spawn(class'MCTestActor', , , FindPathToward(ScriptedMoveTarget).Location,);
//		SpawnActor.SetLocation(FindPathToward(ScriptedMoveTarget).Location);
//		`log("PathNode.prevOrdered" @ SuperPath.prevOrdered);
//		`log("PathNode.previousPath" @ SuperPath.previousPath);
//		`log("PathNode.GetReachSpecTo(PathNode)" @ PathNode.GetReachSpecTo(PathNode));
		
		//SuperPath.GetNearestNavToActor(ScriptedMoveTarget,ScriptedMoveTarget.Location);
	
		// finds the location from start to end
		
	//	for (i = 0;i < RouteCache.Length; i++)
	//	{
	//		SpawnActor = Spawn(class'MCTestActor', , , RouteCache[i].Location,);
	//		`log("RouteCache" @ RouteCache[i]);
	//	}
		

		

		DrawDebugLine(Pawn.Location,FindPathToward(ScriptedMoveTarget).Location,255,0,0,true);
		
*/
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//	Camera Functions for the game 
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

exec function MCZoomIn()
{
	CameraProperties.MovementPlane.Z -= CameraProperties.ZoomSpeed;
	//`log("Zooming IN NOW!!!!");
	`log(CameraProperties.MovementPlane.Z);
}

exec function MCZoomOut()
{
	CameraProperties.MovementPlane.Z += CameraProperties.ZoomSpeed;
	//`log("Zooming OUT NOW!!!!");
	`log(CameraProperties.MovementPlane.Z);
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
}