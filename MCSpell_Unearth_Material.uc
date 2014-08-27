//----------------------------------------------------------------------------
// MCSpell_Unearth_Material
//
// Unearth Material Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Unearth_Material extends MCSpell;

function Cast(MCPawn caster, MCPawn enemy)
{

}

/*
// The Activator for all spells
// @param	Caster			Who Casts the Spell
// @param	Enemy			Who the Caster is Aiming for
// @param	Opt_PathNode	What PathNode we would like to change
// @param	Opt_Tile		What Tile we would like to change
*/
simulated function Activate(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	// If spell is 21 like this is, we can set all tiles to Unearth Material in CheckDistanceNearPlayer(), will lightup Elemental Tiles
	// Do a Spell that also adds a random tile in CheckDistanceNearPlayer()




	local int i;
	local MCPlayerController PC;
	
	// This does AP Check first so we can check if we can do the spell 
	super.Activate(Caster, Enemy, PathNode, Tile);

	if (Caster == none || Enemy == none)
	{
		`log(self @ " - Failed so Destroy() && return;");
		Destroy();
		return;
	}

	// Cast nesscesary Classes
	PC = Caster.PC;

	// Turn Off All active tiles
	for (i = 0;i < PC.TilesWeCanMoveOn.length ; i++)
		PC.TilesWeCanMoveOn[i].ResetTileToNormal();

	// Spell mode active
	PC.bIsSpellActive = true;


	`log(name @ "- Activate - We in here" );
	// Check where we should light up the selecting spell Tiles
	PC.CheckDistanceNearPlayer();
}

/*
* Function we use for click spells
// @param	Opt_Caster			Who Casts the Spell
// @param	Opt_WhatTile			Who the Caster is Aiming for
// @param	Opt_PathNode	What PathNode we would like to change
*/
reliable server function CastClickSpellServer(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode)
{
	// Do only on server
	if (Role == Role_Authority)
	{
		// Activate server
		WhatTile.ActivateUnearthMaterial();

		// Use this to turn of the Active Unearth Material Tiles
		CastClickSpellClient(Caster, WhatTile,PathNode);
	}
}

reliable client function CastClickSpellClient(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode)
{
	local int i;

	`log("Client has RandomElement=" @ WhatTile.RandomElement);
	`log("Client has RandomElement=" @ WhatTile.RandomElement);
	`log("Client has RandomElement=" @ WhatTile.RandomElement);

	for (i = 0; i  < Caster.PC.FireTiles.length; i++)
		Caster.PC.FireTiles[i].bUnearthMaterialActive = false;
}



DefaultProperties
{
}