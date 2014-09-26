//----------------------------------------------------------------------------
// MCSpell_Make_Mud
//
// Make Mud Activator
//
// Gustav Knutsson 2014-09-08
//----------------------------------------------------------------------------
class MCSpell_Make_Mud extends MCSpell;


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

	// Set Special Distance from a tile
//	fMaxSpellDistance = 386 - 10;

	// Look for a Water Element
	TargetTile = Caster.PC.GetElementTile(e_Water, 230.0f);

	if (TargetTile != none)
	{
		if (TargetTile.bSpellTileMode)
		{
			// Sets from where we search AP distanec from
			TargetLocation = TargetTile.Location;

			ActivateAreaCloud(Caster, Enemy, PathNode, Tile);
		}else
		{
			Destroy();
		}
	}
	else
	{
		Destroy();
	}
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

		WhatTile.ActivateMakeMud();
		// Check AP Calculation because we spawn this like this
	//	Caster.PC.CheckAPTimer(1.0f);

		// Remove
		Destroy();
	}
}

DefaultProperties
{
}