//----------------------------------------------------------------------------
// MCStatus_WormsMouth
//
// Worms Mouth Status
//
// Gustav Knutsson 2014-08-01
//----------------------------------------------------------------------------
class MCStatus_WormsMouth extends MCStatus
	hidecategories(Movement, Display, Attachment, Collision, Physics, Advanced, Debug, Object, Mobile);

/*
// Function that calculates AP Increase or Decrease
// @return 		Apf  -/+
*/
reliable server function float StatusCalculationAPCost(optional float PcCurrentAPf)
{
	// If DamagePercent is not set to 0 as base
	if (StatusDamage.DamagePercent != 0)
	{
		// Reduce it by half
		PcCurrentAPf *= StatusDamage.DamagePercent;
		// Make it in to a - value
		PcCurrentAPf = -PcCurrentAPf;
	}
	
	return PcCurrentAPf;
}

/*
// What Target will we inflict damage on
// @param 	Target		What Target will take damage
*/
reliable server function StatusCalculationDamage(MCPawn Target)
{
	local vector empty;

	// Do damage
	Target.TakeDamage(StatusDamage.Damage, none, Target.Location, empty, class'DamageType');
}

DefaultProperties
{
	// What Spell we assign after we Touched a Character
	StatusArchetype = MCStatus_WormsMouth'MystrasChampionSpells.Status.WormsMouth'

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