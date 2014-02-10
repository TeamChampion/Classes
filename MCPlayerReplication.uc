class MCPlayerReplication extends PlayerReplicationInfo;

var int PlayerUniqueID;
var float APf;
var string PawnName;

var int Health;
var int HealthMax;
var bool bHaveAp;
// Replication block
replication
{
	// I am the Server, send these variables to all Clients
	if (bNetDirty && Role == Role_Authority)
		PlayerUniqueID, APf, PawnName, Health, bHaveAp;
	// Replicate only if the values are dirty, this replication info is owned by the player and from server to client
//	if (bNetDirty && bNetOwner)
//		 GameRound;

	// Replicate only if the values are dirty and from server to client
//	if (bNetDirty)
//		APf, PawnName;
}

simulated event ReplicatedEvent(name VarName)
{
	local PlayerController PC;

	if (VarName == 'PlayerUniqueID')
	{
		foreach LocalPlayerControllers(Class'PlayerController', PC)
		{
			if (PC.PlayerReplicationInfo == self)
			{
				//MCPlayerController(PC).optimize("ID set to " @ PlayerUniqueID);
				MCPlayerController(PC).optimize(PlayerUniqueID);
				`log("ID set to " @ PlayerUniqueID);
				`log("hhahahaahahahahhahahahahha");
			}
		}
	}

	if (VarName == 'APf')
	{

	}
	if (VarName == 'PawnName')
	{

	}
	if (VarName == 'Health')
	{

	}
	if (VarName == 'bHaveAp')
	{

	}

	super.ReplicatedEvent(VarName);
}


simulated function GetPlayerHealth(int NewHealth)
{
	/*
	local MCPlayerController PlayerOwner;

	foreach LocalPlayerControllers(Class'MCPlayerController', PlayerOwner)
	{
		if (PlayerOwner != none && PlayerUniqueID == PlayerOwner.MCPawn.PlayerUniqueID)
		{
			//Health = PlayerOwner.MCPawn.Health;
			break;
		}
	}
	*/
	Health = NewHealth;
}

/*
ReplicationInfo classes have bAlwaysRelevant set to true. 
Server performance can be improved by setting 
a low NetUpdateFrequency. Whenever a replicated property 
changes, explicitly change NetUpdateTime to force replication.
Server performance can also be improved by 
setting 

bSkipActorPropertyReplication 

and 

bOnlyDirtyReplication to true.
*/

defaultproperties
{
	bOnlyDirtyReplication = true
	bAlwaysRelevant = true
	//NetUpdateFrequency = 3
}