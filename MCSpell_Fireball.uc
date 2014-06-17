class MCSpell_Fireball extends MCSpell;

function Cast(MCPawn caster, MCPawn enemy)
{
	local MCProjectile fireball;	//	local UDKProjectile fireball;

	fireball = Spawn(class'MCProjectileFireBall', caster, , caster.Location);
	// Set Caster in MCProjectile so we can when Destroyed set movement back ON
	fireball.PawnThatShoots = caster;
	// Add the damage
	fireball.Damage = damage;
	// Fire the Spell
	fireball.Init(enemy.Location - caster.Location);
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
//	name="Fireball"
//	AP=6
//	bFire=true
}