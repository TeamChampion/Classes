//----------------------------------------------------------------------------
// MCStatus_SpellAmplification
//
// Spell Amplification Status
//
// Gustav Knutsson 2014-08-01
//----------------------------------------------------------------------------
class MCStatus_SpellAmplification extends MCStatus
	hidecategories(Movement, Display, Attachment, Collision, Physics, Advanced, Debug, Object, Mobile);

DefaultProperties
{
	// What Spell we assign after we Touched a Character
	StatusArchetype = MCStatus_SpellAmplification'MystrasChampionSpells.Status.SpellAmplification'

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