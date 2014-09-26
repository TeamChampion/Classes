//----------------------------------------------------------------------------
// MCSpell_Zeus_Spear
//
// Zeus' Spear Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Zeus_Spear extends MCSpell;

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

	// Set Special Distance from a tile
//	fMaxSpellDistance = 384.0f;

	// Get a Cloud
	TargetCloud = Caster.PC.GetCloud(fMaxSpellDistance);

	// Activate Spell if we have a cloud
	if (TargetCloud != none && VSize(enemy.Location - TargetCloud.Location) < 600.0f)
	{
		ActivateProjectile(Caster, Enemy, PathNode, Tile);
		Destroy();
	}
	else
	{
		Destroy();
	}
}

/*
// Starts Casting a ActivateProjectile or ActivateStatusSelf Spell on server
// @param	caster			Who Casts the Spell
// @param	enemy			Who the Caster is Aiming for
*/
function Cast(MCPawn caster, MCPawn enemy)
{
	local MCProjectile MyProjectile;	//	local UDKProjectile MyProjectile;
	local Vector ModifiedLocation;

	if (Role == Role_Authority && TargetCloud != none)
	{
		ModifiedLocation = TargetCloud.Location;
		ModifiedLocation += ExtraSpawnSpace;

		MyProjectile = Spawn(ProjectileClass, caster, , ModifiedLocation);
		// Set Caster in MCProjectile so we can when Destroyed set movement back ON
		MyProjectile.PawnThatShoots = caster;

		// Resistance Check
		if (CheckResistance(caster, enemy))
		{
			// Add the damage
			SendAWorldMessageResist(spellName, true);	// spellName[spellNumber]
			MyProjectile.Damage = damage;
			// Set Status
			if (Status != none)
				MyProjectile.Status = Status;
			// Set SpellNumber
			if(bCanSendSpellNumber)
				MyProjectile.spellNumber = spellNumber;
		}else
		{
			SendAWorldMessageResist(spellName, false);	// spellName[spellNumber]
			MyProjectile.Damage = 0;
		}
		
		// Fire the Spell
		MyProjectile.Init(enemy.Location - ModifiedLocation);
		// Remove this Class from server
		Destroy();
	}
}

DefaultProperties
{
	ProjectileClass= class'MCProjectileZeusSpear'
}