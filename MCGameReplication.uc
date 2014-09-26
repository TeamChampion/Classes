//----------------------------------------------------------------------------
// MCGameReplication
//
// Replicated GameInfo for Players, Adds Players to The Main PRI array so
// we can find everyone in the game
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCGameReplication extends GameReplicationInfo;

// GameRound in game
var int GameRound;
// Camera Settings
var MCCameraProperties CameraProperties;
/** Array of all PlayerReplicationInfos, maintained on both server and clients (PRIs are always relevant) */
var	array<MCPlayerReplication> MCPRIArray;
/** This list mirrors the GameInfo's list of inactive PRI objects */
var	array<MCPlayerReplication> MCInactivePRIArray;

struct SpellTile
{
	var MCTile Tile;
};
var SpellTile SpellTiles[150];

// Replication block
replication
{
	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		 GameRound, SpellTiles;
}

simulated event PostBeginPlay()
{
	//local int i;

	super.PostBeginPlay();
	SetTimer(1.0f, true, 'AddPRIToMC');

}

simulated function SetTile(MCTile SendTile)
{
	local int i;
	// Send to Clients
	
	for (i = 0; i < ArrayCount(SpellTiles) ; i++)
	{
		if (SpellTiles[i].Tile == none)
		{
		//	`log("Adding=" @ i);
			SpellTiles[i].Tile = SendTile;
			break;
		}else
		{
		//	`log(i @ "Filled with=" @ SpellTiles[i].Tile);
		}
	}

}

simulated function RemoveTile(MCTile SendTile)
{
	local int i;
	local SpellTile ResetTile;

	// Remove Tiles
	for (i = 0; i < ArrayCount(SpellTiles) ; i++)
	{
		if (SpellTiles[i].Tile == SendTile)
		{
			SpellTiles[i].Tile = none;
			SpellTiles[i] = ResetTile;
		}
	}

	// Sort Tiles If needed
	for (i = 0; i < ArrayCount(SpellTiles) ; i++)
	{
		if (i > 0)
		{
			if (SpellTiles[i-1].Tile == none && SpellTiles[i].Tile != none)
			{
				SpellTiles[i-1] = SpellTiles[i];
				SpellTiles[i].Tile = none;
			}
		}
	}
}

simulated function RecieveMessage(int PlayerNumber)
{
	local int i;
	if (Role == Role_Authority)
	{
		`log("Server in GameRep=" @PlayerNumber);
	}
	else
	{
		`log("Client in GameRep=" @PlayerNumber);
	}

	for (i = 0;i < MCPRIArray.Length ; i++)
	{
		`log("Sending to" @MCPRIArray[i].PlayerUniqueID);
		MCPRIArray[i].RecieveMessage(PlayerNumber);
	}
}

reliable server function AddServer(byte WhatPlayer)
{
	local int i;

	// If server
	if (Role == Role_Authority)
	{
		for (i = 0;i < MCPRIArray.Length ; i++)
		{
			// If player we want to do a change
			if (MCPRIArray[i].PlayerUniqueID == WhatPlayer)
			{
				`log("Sending to" @MCPRIArray[i].PlayerUniqueID);
				MCPRIArray[i].RecieveMessage(WhatPlayer);
			}
		}
	}


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
	//	`log("--------------------------------------------------------------------------------------------------");
		for(i = 0; i < PRIArray.length ; i++)
		{
			MCPRIArray.InsertItem(i,PRIArray[i]);
	//		`log("Added to " @ MCPRIArray[i]);
		}
	//	`log("--------------------------------------------------------------------------------------------------");
		ClearTimer('AddPRIToMC');
	}
}
/*
// 
*/
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

/*
// Turn Camera Mode off for all Clients
// @Client
*/
simulated function SetMatchModeOff()
{
	CameraProperties.bSetToMatch = false;
}

/*
// Turn Camera Mode on for all Clients
// @Client
*/
simulated function SetMatchModeOn()
{
	CameraProperties.bSetToMatch = true;
}

defaultproperties
{
	CameraProperties=MCCameraProperties'mystraschampionsettings.Camera.CameraProperties'
}