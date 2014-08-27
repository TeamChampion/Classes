//----------------------------------------------------------------------------
// MCSpell_Acid_Touch
//
// Acid Touch Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Acid_Touch extends MCSpell;

function Cast(MCPawn caster, MCPawn enemy)
{
	local MCProjectileAcidTouch cAcidTouch;

	if (Role == Role_Authority)
	{
		cAcidTouch = Spawn(class'MCProjectileAcidTouch', caster, , caster.Location);
		
		// Set Caster in MCProjectile so we can when Destroyed set movement back ON
		cAcidTouch.PawnThatShoots = caster;

		// Resistance Check
		if (CheckResistance(caster, enemy))
		{
			// Add the damage
		//	`log(self @ " - SUCCESSFUL HIT!");
			SendAWorldMessage(spellName[spellNumber], true);
			cAcidTouch.Damage = damage;
			// Set Status
			cAcidTouch.Status = Status;

			//What spell we are using
			cAcidTouch.Status.spellNumber = 22;
		}else
		{
		//	`log(self @ " - RESISTED!");
			SendAWorldMessage(spellName[spellNumber], false);
			cAcidTouch.Damage = 0;
		}

		// Add SpellNumber
		cAcidTouch.spellNumber = spellNumber;
		// Fire the Spell
		cAcidTouch.Init(enemy.Location - caster.Location);
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
	
	// Check Distance First, if good we can cast spell otherwise stop it
	if (VSize(Caster.Location - Enemy.Location) < fMaxSpellDistance)
	{
		`log(name @ "- Activate Spell");
		// We can use Spell
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