//----------------------------------------------------------------------------
// MCStatus_Frost
//
// Frost Status
//
// Gustav Knutsson 2014-08-04
//----------------------------------------------------------------------------
class MCStatus_Frost extends MCStatus
	hidecategories(Movement, Display, Attachment, Collision, Physics, Advanced, Debug, Object, Mobile);

DefaultProperties
{
	// What Spell we assign after we Touched a Character
	StatusArchetype = MCStatus_Frost'MystrasChampionSpells.Status.Frost'

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