class MCSpell_StoneWall extends MCSpell;

simulated function Cast(MCPawn caster, Vector target)
{
	//local ParticleSystem smoke;
	//smoke = ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_Dust_Secondary';
	//WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_Dust_Secondary', target);
	Spawn(class'MCActor_Rock', caster, ,target);
}

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

	// Check where we shoudl light up the selecting spell Tiles
	PC.CheckDistanceNearPlayer();

	// Instructions for the StoneWall
	// 
	// 1 Check AP
	// 2 Turn of All tiles around you in PC  // BlueTiles[i].TurnTileOff();
	// 3 Set Spell Mode active	// bIsSpellActive = true;
	// 4 Set StoneWall active 	// instansiate a non local file and check if that things are on to active PlayerTick function
	// 4.1 if bIsSpellActive && StoneWall aka InstansiateSpell != null, we can use tick
	// 5 Check What tiles are near us 	// CheckDistanceNearPlayer(), make it according to stats we have in the MCSpell, MaxDistance && Me & Enemy distance

	// Inside Click function
	// 6  Set what tiles we click so we know where to spawn
	// 7  Instansiate the MCSpell_StoneWall the Stone 	// already done that since we are in this function
	// 8  Reduce AP && replicate it
	// 9  Do the server function to Spawn it 	// Cast in this place
	// 10 Set Timer that we can move again 	// check this with bool inside MCSpell, do this before destroy
	// 11 Set Timer so we check if we have AP to move 	// check this with bool inside MCSpell, do this before destroy
	// 12 Destroy the MCSpell_StoneWall
}

/*
* Function we use for click spells
*	WhatTile	Selected Tile we use
*	PathNode
*/
reliable server function CastClickSpell(MCPawn Caster, MCTile WhatTile, MCPathNode PathNode)
{
	local MCPlayerController PC;

	// Cast nesscesary Classes
	PC = Caster.PC;

	// Do only on server
	if (Role == Role_Authority)
	{
		Cast(PC.MCPlayer, WhatTile.Location);
		PathNode.bBlocked = true;
	}
}

DefaultProperties
{
//	name="Stone Wall"
//	bEarth=true
//	AP=6
}