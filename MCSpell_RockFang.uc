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
			SendAWorldMessageResist(spellName, true);	// spellName[spellNumber]
			// Add the damage
			enemy.TakeDamage(damage, none, enemy.Location, Momentum, class'DamageType');
		}else
		{
			SendAWorldMessageResist(spellName, false);	// spellName[spellNumber]
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
	// This does AP Check first so we can check if we can do the spell 
	super.Activate(Caster, Enemy, PathNode, Tile);

	ActivateProjectileClose(Caster, Enemy, PathNode, Tile);
}

DefaultProperties
{
}