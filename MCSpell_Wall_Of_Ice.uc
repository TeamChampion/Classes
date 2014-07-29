//----------------------------------------------------------------------------
// MCSpell_Wall_Of_Ice
//
// Wall Of Ice Spell Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Wall_Of_Ice extends MCSpell;

function Cast(MCPawn caster, Vector target)
{
	local Vector CorrectionVector;

	CorrectionVector = target + Vect(48,0,0);

	Spawn(class'MCActor_WallOfIce', caster, ,CorrectionVector);
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
	local int i;
	local MCPlayerController PC;

	`log(name @ "- Activate Spell");
	// Cast nesscesary Classes
	PC = Caster.PC;

	// Turn Off All active tiles
	for (i = 0;i < PC.CanUseTiles.length ; i++)
		PC.CanUseTiles[i].ResetTileToNormal();

	// Spell mode active
	PC.bIsSpellActive = true;

	// Check where we shoudl light up the selecting spell Tiles
	PC.CheckDistanceNearPlayer();

	// Shoot Spell, Make sure it's only on the server
	if ( (WorldInfo.NetMode == NM_DedicatedServer) || (WorldInfo.NetMode == NM_ListenServer) )
	{
	//	Cast(Caster, Enemy);
	}else
	{
		// Remove from Client
	//	Destroy();
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
		// Activate Server
		Cast(Caster, WhatTile.Location);
		PathNode.bBlocked = true;
		WhatTile.ActivateWallOfIce();
		// Activate on clients
		CastClickSpellClient(,WhatTile,);
		Destroy();
	}
}

reliable client function CastClickSpellClient(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode)
{
	WhatTile.ActivateWallOfIce();
	Destroy();
}

DefaultProperties
{
}