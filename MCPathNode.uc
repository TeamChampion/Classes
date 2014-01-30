class MCPathNode extends PathNode
	hidecategories(VehicleUsage, Display, Attachment, Collision, Physics, Advanced, Debug, Mobile);

var(MystrasPathNode) int APValue;
var MCTile Tile;

// Replication block
replication
{
	// Replicate only if the values are dirty, this replication info is owned by the player and from server to client
//	if (bNetDirty && bNetOwner)
//		 ;

	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		Tile, APValue;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	///
	
	foreach AllActors(Class'MCTile', Tile)
	{
		if (Location.X == Tile.Location.X && Location.Y == Tile.Location.Y)
		{
			//`log("MCTile" @ Tile @ "at" @ Location);
			break;
		}
	}
	APValueSetting();
}

simulated function APValueSetting()
{
	switch (APValue)
	{
		case 1:
		//	Cost = 0;
			ExtraCost = 0;
			break;
		case 2:
		//	Cost = 100;
			ExtraCost = 10;
			break;
		case 3:
		//	Cost = 100;
			ExtraCost = 20;
			break;
		default:
			
	}
}

simulated function bool TurnOfPathNode()
{
	
	return true;
}

/*
// If it's a certain APValue on the PathNode then also affect the RouteCache
// APValue = MCPawn.APf
*/
simulated function SetAPCost()
{
	
}

defaultproperties
{
	// Setting the base value for a PathNode
	APValue = 1
	//var() bool bBlocked;			// this node is currently unuseable
	//var bool		bBlockable;		// true if path can become blocked (used by pruning during path building)
	//var	bool	bMustTouchToReach;		// if true. reach tests are based on whether pawn can move to overlap this NavigationPoint (only valid if bCollideActors=true)
	/** whether walking on (being based on) this NavigationPoint counts as reaching it */
	//var bool bCanWalkOnToReach;
	//var int Cost;					// added cost to visit this pathnode
	//var() int ExtraCost;			// Extra weight added by level designer
/*
	struct CheckpointRecord
	{
	var bool bDisabled;
	var bool bBlocked;
	};
*/


	Role=Role_Authority
	RemoteRole=ROLE_SimulatedProxy
}