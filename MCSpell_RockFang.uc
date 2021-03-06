//----------------------------------------------------------------------------
// MCSpell_RockFang
//
// Rockfang Spell Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_RockFang extends MCSpell;

function Cast(MCPawn caster, MCPawn enemy)
{
	local Vector newLocation;	// Where we want it to spawn
	local vector Momentum;		// Momentum force caused by this hit

	if (Role == Role_Authority)
	{
		newLocation = enemy.Location + vect(0,0,-50);
		Spawn(class'MCActor_Fang', caster,, newLocation);

		// Resistance Check
		if (CheckResistance(caster, enemy))
		{
		//	`log(self @ " - SUCCESSFUL HIT!");
			SendAWorldMessage(spellName[spellNumber], true);
			// Add the damage
			enemy.TakeDamage(damage, none, enemy.Location, Momentum, class'DamageType');
		}else
		{
		//	`log(self @ " - RESISTED!");
			SendAWorldMessage(spellName[spellNumber], false);
		//	enemy.TakeDamage(damage, none, enemy.Location, Momentum, class'DamageType');
		}

		//
		caster.PC.bIsSpellActive = false;
		caster.PC.CheckCurrentAPCalculation();

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