//----------------------------------------------------------------------------
// MCSpell_Spark_Bolt
//
// Spark Bolt Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Spark_Bolt extends MCSpell;

function Cast(MCPawn caster, MCPawn enemy)
{
	local MCProjectile sparkbolt;

	if (Role == Role_Authority)
	{
		sparkbolt = Spawn(class'MCProjectileSparkBolt', caster, , caster.Location);
		// Set Caster in MCProjectile so we can when Destroyed set movement back ON
		sparkbolt.PawnThatShoots = caster;
		// Add the damage
		sparkbolt.Damage = damage;
		// Fire the Spell
		sparkbolt.Init(enemy.Location - caster.Location);
		// Remove this Class from server
		Destroy();
	}
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
	local MCPlayerReplication MCPRep;

	`log(name @ "- Activate Spell");
	// Update Casters AP Cost
	foreach DynamicActors(Class'MCPlayerReplication', MCPRep)
	{
		if (Caster.PlayerUniqueID == MCPRep.PlayerUniqueID)
		{
			Caster.APf -= AP;
			MCPRep.APf = Caster.APf;
		}
	}

	// Spell mode active
	Caster.PC.bIsSpellActive = true;
	// Turn of Tiles
	Caster.PC.TurnOffTiles();

	// Shoot Spell, Make sure it's only on the server
	if ( (WorldInfo.NetMode == NM_DedicatedServer) || (WorldInfo.NetMode == NM_ListenServer) )
	{
		Cast(Caster, Enemy);
	}else
	{
		// Remove from Client
		Destroy();
	}

	// Reset Everything and check if we still have AP
	caster.PC.bIsSpellActive = false;
	caster.PC.CheckCurrentAPCalculation();
}

DefaultProperties
{
}