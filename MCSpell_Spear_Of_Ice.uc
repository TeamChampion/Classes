//----------------------------------------------------------------------------
// MCSpell_Spear_Of_Ice
//
// Spear Ice Spell Activator
// 
// @STATUS 	@Frost 		AP-1
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Spear_Of_Ice extends MCSpell;

function Cast(MCPawn caster, MCPawn enemy)
{
	local MCProjectile cSpearOfIce;	//	local UDKProjectile cSpearOfIce;
	local Vector modifiedStart;

	`log(name @ "- Activate Cast");

	if (Role == Role_Authority)
	{
		modifiedStart = caster.Location;
		modifiedStart.Z += 128;

		cSpearOfIce = Spawn(class'MCProjectileSpearOfIce', caster, , modifiedStart);
		// Set Caster in MCProjectile so we can when Destroyed set movement back ON
		cSpearOfIce.PawnThatShoots = caster;
		// Add the damage
		cSpearOfIce.Damage = damage;
		// Fire the Spell
		cSpearOfIce.Init(enemy.Location - modifiedStart);
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

	// Check Distance First, if good we can cast spell otherwise stop it
	if (VSize(Caster.Location - Enemy.Location) < fMaxSpellDistance)
	{
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
	}else
	{
		// Exit Spell
		`log(name @ "Can't Be Casted");
		Destroy();
	}
}

DefaultProperties
{
}