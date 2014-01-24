class MCPlayerReplication extends GameReplicationInfo;

var int GameRound;


// Replication block
replication
{
	// Replicate only if the values are dirty, this replication info is owned by the player and from server to client
	if (bNetDirty && bNetOwner)
		 GameRound;

	// Replicate only if the values are dirty and from server to client
//	if (bNetDirty)
		
}


defaultproperties
{
	
}