class MCGameReplication extends GameReplicationInfo;

var int GameRound;

/** Array of all PlayerReplicationInfos, maintained on both server and clients (PRIs are always relevant) */
var		array<MCPlayerReplication> MCPRIArray;

/** This list mirrors the GameInfo's list of inactive PRI objects */
var		array<MCPlayerReplication> MCInactivePRIArray;

// Replication block
replication
{
	// Replicate only if the values are dirty, this replication info is owned by the player and from server to client
//	if (bNetDirty && bNetOwner)
//		 GameRound;

	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		 GameRound;
}

simulated event PostBeginPlay()
{
	//local int i;

	super.PostBeginPlay();
	SetTimer(1.0f, true, 'AddPRIToMC');

}

/*
// Function That adds the PRIArray to our own Array to fetch them for HUD or Battle Flash HUD
*/
simulated function AddPRIToMC()
{
	local int i;

	if (PRIArray.length >= 2)
	{
		`log("--------------------------------------------------------------------------------------------------");
		for(i = 0; i < PRIArray.length ; i++)
		{
			MCPRIArray.InsertItem(i,PRIArray[i]);
			`log("Added to " @ MCPRIArray[i]);
		}
		`log("--------------------------------------------------------------------------------------------------");
		ClearTimer('AddPRIToMC');
	}
}

defaultproperties
{
	
}