//----------------------------------------------------------------------------
// MCSpell_Unearth_Material
//
// Unearth Material Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Unearth_Material extends MCSpell;

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
	if (WhatTile.RandomElement == e_Lava)
	{
		ExtraSpawnSpace.X =  6 ;
		ExtraSpawnSpace.Y = -12;
		ExtraSpawnSpace.Z = -22;
		ActorClass = class'MCActor_FireFountain';
	}
	else if (WhatTile.RandomElement == e_Water)
	{
		ActorClass = class'MCActor_Water';
		WhatTile.PathNode.APValue = 3;
	}
	else if (WhatTile.RandomElement == e_Metal)
	{
		ExtraSpawnSpace.X =  36;
		ExtraSpawnSpace.Y = -56;
		ExtraSpawnSpace.Z = -170;
		ActorClass = class'MCActor_MetalWire';
		WhatTile.PathNode.bBlocked = true;
	}
	else if (WhatTile.RandomElement == e_Acid)
	{
		ExtraSpawnSpace.X =  0;
		ExtraSpawnSpace.Y =  0;
		ExtraSpawnSpace.Z = -12;
		ActorClass = class'MCActor_Acid';
	}

	super.CastArea(caster, target);
}

/*
* Function we use for click spells
// @param	Opt_Caster			Who Casts the Spell
// @param	Opt_WhatTile		Who the Caster is Aiming for
// @param	Opt_PathNode		What PathNode we would like to change
*/
reliable server function CastClickSpellServer(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode)
{
	// Do only on server
	if (Role == Role_Authority)
	{
		// Activate server
		CastArea(Caster, WhatTile.Location, WhatTile);
		WhatTile.ActivateUnearthMaterial();

		// Use this to turn of the Active Unearth Material Tiles
	//	CastClickSpellClient(Caster, WhatTile,PathNode);
	}

	Destroy();
}

reliable client function CastClickSpellClient(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode)
{
	local int i;

	for (i = 0; i  < Caster.PC.FireTiles.length; i++)
		Caster.PC.FireTiles[i].bUnearthMaterialActive = false;
}



DefaultProperties
{
}