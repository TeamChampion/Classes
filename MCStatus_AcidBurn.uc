//----------------------------------------------------------------------------
// MCStatus_AcidBurn
//
// Acid Burn Status
//
// Gustav Knutsson 2014-08-04
//----------------------------------------------------------------------------
class MCStatus_AcidBurn extends MCStatus
	hidecategories(Movement, Display, Attachment, Collision, Physics, Advanced, Debug, Object, Mobile);

/*
// Function that calculates AP Increase or Decrease
// @return 		Apf  -/+
*/
reliable server function float StatusCalculationAPCost(optional float PcCurrentAPf)
{
	local float APf;

	// Set Different Spell Number for Different Spell
//	SetDifferentSpellDamageAndAP();

	// If AP is not set to 0 as base
	if (StatusDamage.AP != 0)
		APf = StatusDamage.AP;
	
	return APf;
}

/*
// What Target will we inflict damage on
// @param 	Target		What Target will take damage
*/
reliable server function StatusCalculationDamage(MCPawn Target)
{
	local vector empty;

	`log("MCStatus - StatusCalculationDamage -" @ spellNumber @ "- damage=" @ StatusDamage.Damage);
	`log("MCStatus - StatusCalculationDamage -" @ spellNumber @ "- damage=" @ StatusDamage.Damage);
	`log("MCStatus - StatusCalculationDamage -" @ spellNumber @ "- damage=" @ StatusDamage.Damage);
	// Do damage
	Target.TakeDamage(StatusDamage.Damage, none, Target.Location, empty, class'DamageType');

	// Remove Spell class
//	cSpell.Destroy();
}

/*
// Set Spell Damage for Certain Acid spells
*/
simulated function SetDifferentSpellDamageAndAP()
{
	`log("MCStatus - SetDifferentSpellDamageAndAP = " @ spellNumber);
	`log("MCStatus - SetDifferentSpellDamageAndAP = " @ StatusName);
	`log("MCStatus - SetDifferentSpellDamageAndAP = " @ StatusName);
	`log("MCStatus - SetDifferentSpellDamageAndAP = " @ StatusName);

	
	switch (spellNumber)
	{
		case 2:
			// Alchemist's Bullet
			StatusDamage.Damage = 5;
			StatusDamage.AP = -1;
			break;
		case 22:
			// Acid Touch
			StatusDamage.Damage = 25;
			StatusDamage.AP = 0;
			break;
		case 30:
			// Acid Rain
			StatusDamage.Damage = 1;
			StatusDamage.AP = 0;
			break;
		case 23:
			// Taint Water
			StatusDamage.Damage = 7.5f;
			StatusDamage.AP = 0;

			break;
		default:
			//	
	}
}

DefaultProperties
{
	//defaults

	// What Spell we assign after we Touched a Character
//	StatusArchetype = MCStatus_AcidBurn'MystrasChampionSpells.Status.AcidBurn'

	// Basic Settings for simulation
	bCollideActors = true
	CollisionType=COLLIDE_TouchAll

	// Add a Invisible Cyllinder
    Begin Object Class=CylinderComponent NAME=CollisionCylinder
		CollisionRadius=+0040.000000
		CollisionHeight=+0040.000000
		bAlwaysRenderIfSelected=true
		CollideActors=true
		BlockActors = true
		BlockZeroExtent = true
		BlockNonZeroExtent = false
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)
}