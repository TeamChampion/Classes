class MCSpell_FireFountain extends MCSpell;


simulated function Activate(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	local int i;
	local MCPlayerController PC;

	// Cast nesscesary Classes
	PC = Caster.PC;

	// Turn Off All active tiles
	for (i = 0;i < PC.BlueTiles.length ; i++)
		PC.BlueTiles[i].TurnTileOff();

	// Spell mode active
	PC.bIsSpellActive = true;

	// Check where we should light up the selecting spell Tiles
	PC.CheckDistanceNearPlayer();


}

/*
* Function we use for click spells
*	WhatTile	Selected Tile we use
*	PathNode
*/
reliable server function CastClickSpell(MCPawn Caster, MCTile WhatTile, MCPathNode PathNode)
{
	// Do only on server
	if (Role == Role_Authority)
	{
		WhatTile.SetFireFountain();
	//	Cast(PC.MCPlayer, WhatTile.Location);
	}
	
	MeSpawn(WhatTile);
}

simulated function MeSpawn(MCTile WhatTile)
{
	WhatTile.SetFireFountain();
	`log("MCSpell_FireFountain -> MCTILE");
}
DefaultProperties
{
//	name="Fire Fountain"
//	AP=3
//	bfire=true
//	damage=15
}