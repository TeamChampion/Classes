//----------------------------------------------------------------------------
// MCSpell_Paralytic_Touch
//
// Paralytic Touch Activator
//
// Gustav Knutsson 2014-08-06
//----------------------------------------------------------------------------
class MCSpell_Paralytic_Touch extends MCSpell;

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

	ActivateStatusEnemyClose(Caster, Enemy, PathNode, Tile);
}

DefaultProperties
{
	StatusClass = class'MCStatus_Paralysis'
}