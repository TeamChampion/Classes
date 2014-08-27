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
	local MCProjectile cSparkBolt;

	if (Role == Role_Authority)
	{
		cSparkBolt = Spawn(class'MCProjectileSparkBolt', caster, , caster.Location);
		// Set Caster in MCProjectile so we can when Destroyed set movement back ON
		cSparkBolt.PawnThatShoots = caster;

		// Resistance Check
		if (CheckResistance(caster, enemy))
		{
			// Add the damage
		//	`log(self @ " - SUCCESSFUL HIT!");
			SendAWorldMessage(spellName[spellNumber], true);
			cSparkBolt.Damage = damage;
		}else
		{
		//	`log(self @ " - RESISTED!");
			SendAWorldMessage(spellName[spellNumber], false);
			cSparkBolt.Damage = 0;
		}

		// Fire the Spell
		cSparkBolt.Init(enemy.Location - caster.Location);
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
	
	// This does AP Check first so we can check if we can do the spell 
	super.Activate(Caster, Enemy, PathNode, Tile);

	if (Caster == none || Enemy == none)
	{
		`log(self @ " - Failed so Destroy() && return;");
		Destroy();
		return;
	}

	`log(name @ "- Activate Spell");
	// Update Casters AP Cost
	foreach DynamicActors(Class'MCPlayerReplication', MCPRep)
	{
		if (Caster.PlayerUniqueID == MCPRep.PlayerUniqueID)
		{
			Caster.APf -= APCost;
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
//	caster.PC.bIsSpellActive = false;
//	caster.PC.CheckCurrentAPCalculation();
}

DefaultProperties
{
}