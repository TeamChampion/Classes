//----------------------------------------------------------------------------
// MCSpell_Glass_Floor
//
// Glass Floor Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Glass_Floor extends MCSpell;

/*
// The Activator for all spells
// @param	Caster			Who Casts the Spell
// @param	Enemy			Who the Caster is Aiming for
// @param	Opt_PathNode	What PathNode we would like to change
// @param	Opt_Tile		What Tile we would like to change
*/
simulated function Activate(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	// This does AP Check first so we can check if we can do the spell 
	super.Activate(Caster, Enemy, PathNode, Tile);

	// Sets from where we search AP distanec from
	TargetLocation = Caster.Location;

	ActivateAreaCloud(Caster, Enemy, PathNode, Tile);


//	ActivateArea(Caster, Enemy, PathNode, Tile);
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
		WhatTile.ActivateGlassFloor();
		// Check AP Calculation because we spawn this like this
		Caster.PC.CheckAPTimer(1.0f);
	//	Destroy();
	}
}

DefaultProperties
{
}