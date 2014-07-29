//----------------------------------------------------------------------------
// MCItem_ResearchMaterial
//
// Different Research Material we make archetypes
//
// Gustav Knutsson 2014-06-25
//----------------------------------------------------------------------------
class MCItem_ResearchMaterial extends MCItem;

// the actual object's mesh
var(MCItem, ResearchMaterial) SkeletalMeshComponent WeaponMesh;
// First spell necessary for the research
var(MCItem, ResearchMaterial) MCSpell AlphaComponent;
// Second spell necessary for the research
var(MCItem, ResearchMaterial) MCSpell BetaComponent;
// The steps necessary to complete the research
var(MCItem, ResearchMaterial) int ResearchProcessDays;
// The resulting spell of the research
var(MCItem, ResearchMaterial) MCSpell ResultingSpell;

DefaultProperties
{
	//defaults
}