//----------------------------------------------------------------------------
// MCSpell_Dissolve_Element
//
// Dissolve Element Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Dissolve_Element extends MCSpell;


/*
// The Activator for all spells
// @param	Caster			Who Casts the Spell
// @param	Enemy			Who the Caster is Aiming for
// @param	Opt_PathNode	What PathNode we would like to change
// @param	Opt_Tile		What Tile we would like to change
*/
simulated function Activate(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	local int i;
	local MCPlayerController PC;

	// Cast nesscesary Classes
	PC = Caster.PC;

	// Turn Off All active tiles
	for (i = 0;i < PC.CanUseTiles.length ; i++)
		PC.CanUseTiles[i].ResetTileToNormal();

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
reliable server function CastClickSpellServer(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode)
{
	// Do only on server
	if (Role == Role_Authority)
	{
		// Activate server
		WhatTile.ActivateDissolveElement();
		// Activate on clients
		CastClickSpellClient(,WhatTile,);
	}
}

reliable client function CastClickSpellClient(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode)
{
	WhatTile.ActivateDissolveElement();
}

DefaultProperties
{
}