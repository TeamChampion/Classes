//----------------------------------------------------------------------------
// MCSpell_Ride_The_Lightning
//
// Ride The Lightning Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Ride_The_Lightning extends MCSpell;

var ParticleSystem LightningParticle;
var MCPawn MyCastLoc;

// Replication block
replication
{
	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		LightningParticle;
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
	// This does AP Check first so we can check if we can do the spell 
	super.Activate(Caster, Enemy, PathNode, Tile);

	// AP Distanec value
	APDistanceValue = 4.0f;
	// Sets from where we search AP distanec from
	TargetLocation = Caster.Location;

	ActivateArea(Caster, Enemy, PathNode, Tile);

	// Teleport Location
	MyCastLoc = Caster;
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
		// Spawn Particle
		WorldInfo.MyEmitterPool.SpawnEmitter(LightningParticle, WhatTile.PathNode.Location);

		// Teleports to a certain Tile
		Caster.SetLocation(WhatTile.PathNode.Location);
		// Check AP Calculation
		Caster.PC.CheckAPTimer(1.0f);

		// Turn off spell here so that we can replicate teleport
		if (Caster.PC.bIsSpellActive)
			Caster.PC.bIsSpellActive = false;
	}
}

reliable client function CastClickSpellClient(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode)
{
	WorldInfo.MyEmitterPool.SpawnEmitter(LightningParticle, WhatTile.PathNode.Location);
}

DefaultProperties
{
	LightningParticle = ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Ball_Impact'
}