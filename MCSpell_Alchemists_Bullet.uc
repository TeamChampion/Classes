//----------------------------------------------------------------------------
// MCSpell_Alchemists_Bullet
//
// Alchemist's Bullet Spell Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Alchemists_Bullet extends MCSpell;

function Cast(MCPawn caster, MCPawn enemy)
{
	local MCProjectile cAlchemistBullet;	//	local UDKProjectile cAlchemistBullet;
	local Vector modifiedStart;

	if (Role == Role_Authority)
	{
		modifiedStart = caster.Location;
		modifiedStart.Z += 128;

		cAlchemistBullet = Spawn(class'MCProjectileAlchemistBullet', caster, , modifiedStart);
		// Set Caster in MCProjectile so we can when Destroyed set movement back ON
		cAlchemistBullet.PawnThatShoots = caster;

		// Resistance Check
		if (CheckResistance(caster, enemy))
		{
			// Add the damage
		//	`log(self @ " - SUCCESSFUL HIT!");
			SendAWorldMessage(spellName[spellNumber], true);
			cAlchemistBullet.Damage = damage;
			// Set Status
			cAlchemistBullet.Status = Status;
		}else
		{
		//	`log(self @ " - RESISTED!");
			SendAWorldMessage(spellName[spellNumber], false);
			cAlchemistBullet.Damage = 0;
		}

		// Add SpellNumber
		cAlchemistBullet.spellNumber = spellNumber;
		// Fire the Spell
		cAlchemistBullet.Init(enemy.Location - modifiedStart);
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
	`log(name @ "- Activate Function");

	// Spell mode active
//	Caster.PC.bIsSpellActive = true;
	// Turn of Tiles
//	Caster.PC.TurnOffTiles();

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