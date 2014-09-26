//----------------------------------------------------------------------------
// MCStatus_AcidMist
//
// Acid Mist Status
//
// Gustav Knutsson 2014-08-01
//----------------------------------------------------------------------------
class MCStatus_AcidMist extends MCStatus
	hidecategories(Movement, Display, Attachment, Collision, Physics, Advanced, Debug, Object, Mobile);

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
	StatusArchetype = MCStatus_AcidMist'MystrasChampionSpells.Status.AcidMist'

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