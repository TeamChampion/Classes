//----------------------------------------------------------------------------
// MCSpell_Wormhole
//
// Wormhole Spell Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Wormhole extends MCSpell;

/*
// The Activator for all spells
// @param	Caster			Who Casts the Spell
// @param	Enemy			Who the Caster is Aiming for
// @param	Opt_PathNode	What PathNode we would like to change
// @param	Opt_Tile		What Tile we would like to change
*/
simulated function Activate(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	super.Activate(Caster, Enemy, PathNode, Tile);

	ActivateArea(Caster, Enemy, PathNode, Tile);
}

/*
// Starts Casting a ActivateArea spell that will Spawn an Actor, not Tile changing
// @param	caster			Who Casts the Spell
// @param	target			Where we do it
// @param	Opt_WhatTile	If we need a Tile to perform something specific
*/
function CastArea(MCPawn caster, Vector target, optional MCTile WhatTile)
{
	ExtraSpawnSpace.Z = -72.0f;
	super.CastArea(caster, target);
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
		// Activate Server
		CastArea(Caster, WhatTile.Location);
		// Activate server
		WhatTile.ActivateWormHole(damage);
		// Activate on clients
		Destroy();
	}
}

DefaultProperties
{
	ActorClass = class'MCActor_WormHole'
}