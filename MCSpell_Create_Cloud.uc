//----------------------------------------------------------------------------
// MCSpell_Create_Cloud
//
// Create Cloud Spell Activator
//
// Gustav Knutsson 2014-09-01
//----------------------------------------------------------------------------
class MCSpell_Create_Cloud extends MCSpell;

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

	// 09 - Create Cloud
	// When clicking, Search for a Tile in the middle
	//	- 	If Click is Source, Spawn there
	//	- 	If Click is 1 from Source
	//	- 	if we have 3 tiles in a row, the one inbetween the Source and Click will be



//	ActivateAreaCloud(Caster, Enemy, PathNode, Tile);
}

/*
// Starts Casting a ActivateArea spell that will Spawn an Actor, not Tile changing
// @param	caster			Who Casts the Spell
// @param	target			Where we do it
// @param	Opt_WhatTile	If we need a Tile to perform something specific
*/
function CastArea(MCPawn caster, Vector target, optional MCTile WhatTile)
{
//	ExtraSpawnSpace.Z = 512.0f;

	super.CastArea(caster, target, WhatTile);

	SpawnMCActor.EndCloudRounds = (MCGameReplication(WorldInfo.GRI).GameRound + SpawnMCActor.CloudRounds);
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
	//	Caster.APf += 6;
	//	MCPlayerReplication(Caster.PC.PlayerReplicationInfo).APf = Caster.APf;

		CastArea(Caster, WhatTile.Location);
		TargetTile.ActivateDissolveElement(false, true);
		Destroy();
	}
}

DefaultProperties
{
	ActorClass = class'MCActor_Cloud_CreateCloud'
}