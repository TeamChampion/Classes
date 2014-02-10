class MCGameReplication extends GameReplicationInfo;

var int GameRound;
var MCCameraProperties CameraProperties;

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

	MCPRIArray.Remove(0, MCPRIArray.length);

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

simulated function RemovePRI(PlayerReplicationInfo PRI)
{
	local int i;
	local MCPlayerReplication MCPRepli;

	MCPRepli = MCPlayerReplication(PRI);

    for (i=0; i<PRIArray.Length; i++)
    {
		if (PRIArray[i] == PRI && PRI.Name == MCPRepli.Name)
		{
			MCPRIArray.Remove(i,1);
		    PRIArray.Remove(i,1);
			return;
		}
    }

	super.RemovePRI(PRI);
}


simulated function SetMatchModeOff()
{
	`log("Not match mode");
	CameraProperties.bSetToMatch = false;
}

simulated function SetMatchModeOn()
{
	`log("match mode");
	CameraProperties.bSetToMatch = true;
}

simulated function FindBoth()
{
	`log("FindONBOTH!!!!!!!!!!!!");
}

defaultproperties
{
	CameraProperties=MCCameraProperties'mystraschampionsettings.Camera.CameraProperties'
}