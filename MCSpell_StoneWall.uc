//----------------------------------------------------------------------------
// MCSpell_StoneWall
//
// Stone Wall Spell Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_StoneWall extends MCSpell;

function CastArea(MCPawn caster, Vector target)
{
	Spawn(class'MCActor_Rock', caster, ,target);
}

/*&
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
	
	// This does AP Check first so we can check if we can do the spell 
	super.Activate(Caster, Enemy, PathNode, Tile);

	if (Caster == none || Enemy == none)
	{
		`log(self @ " - Failed so Destroy() && return;");
		Destroy();
		return;
	}

	`log(name @ "- Activate Spell");
	// Cast nesscesary Classes
	PC = Caster.PC;

	// Turn Off All active tiles
	for (i = 0;i < PC.TilesWeCanMoveOn.length ; i++)
		PC.TilesWeCanMoveOn[i].ResetTileToNormal();

	// Spell mode active
	PC.bIsSpellActive = true;

	// Check where we shoudl light up the selecting spell Tiles
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
		// Activate Server
		CastArea(Caster, WhatTile.Location);
		PathNode.bBlocked = true;
		WhatTile.ActivateStoneWall();
		// Activate on clients
		CastClickSpellClient(,WhatTile,);
		Destroy();
	}
}

reliable client function CastClickSpellClient(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode)
{
	WhatTile.ActivateStoneWall();
	Destroy();
}

DefaultProperties
{
}