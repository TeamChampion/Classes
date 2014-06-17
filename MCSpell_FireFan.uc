class MCSpell_FireFan extends MCSpell;

function Cast(MCPawn caster, MCPawn enemy)
{
//	local MCProjectileFireFan firefan;
	local MCProjectile firefan;

	firefan = Spawn(class'MCProjectileFireFan', caster, , caster.Location);
	// Set Caster in MCProjectile so we can when Destroyed set movement back ON
	firefan.PawnThatShoots = caster;
	// Add the damage
	firefan.Damage = damage;
	// Fire the Spell
	firefan.Init(enemy.Location - caster.Location);

/*
	firefan = Spawn(class'MCProjectileFireFan', caster, , caster.Location);
	// Set Caster in MCProjectile so we can when Destroyed set movement back ON
	fireball.PawnThatShoots = caster;
	// Add the damage
	fireball.Damage = damage;
	// Fire the Spell
	fireball.Init(enemy.Location - caster.Location);
*/
}

/*
* Start the spell
*/
simulated function Activate(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	local MCPlayerReplication MCPRep;

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
	// Shoot Spell
	Cast(Caster, Enemy);
}

DefaultProperties
{
//	name="Fire Fan"
//	AP=3
//	bFire=true
}