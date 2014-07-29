//----------------------------------------------------------------------------
// MCSpell_Fireball
//
// Fireball Spell Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Fireball extends MCSpell;

function Cast(MCPawn caster, MCPawn enemy)
{
	local MCProjectile fireball;	//	local UDKProjectile fireball;
	local Vector modifiedStart;

	`log(name @ "- Activate Cast");
//	MCProjectileSpearOfIce
//	MCProjectileFireball
	if (Role == Role_Authority)
	{
	//	MCProjectileSpearOfIce
	//	MCProjectileFireBall
		modifiedStart = caster.Location;
		modifiedStart.Z += 64+32;

		fireball = Spawn(class'MCProjectileFireball', caster, , modifiedStart);
		// Set Caster in MCProjectile so we can when Destroyed set movement back ON
		fireball.PawnThatShoots = caster;
		// Add the damage
		fireball.Damage = damage;
/*
		fireball.Damage = 10;
		fireball.AccelRate = 10;
		fireball.Speed = 1;
*/
		// Fire the Spell
		fireball.Init(enemy.Location - modifiedStart);
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
	`log(name @ "- Activate Function");

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