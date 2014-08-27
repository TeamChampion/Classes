//----------------------------------------------------------------------------
// MCStatusArchetypeList
//
// Get information from flash and takes this list of all Spells and adds them
// to the Selected Character.
// Used in GFxCreate & MCPawn to add spells from int array to arhcetype array
//
// Gustav Knutsson 2014-08-04
//----------------------------------------------------------------------------
class MCStatusArchetypeList extends Actor
	HideCategories(Display, Attachment, Physics, Advanced, Debug, Object, Movement, Collision, Mobile);

// What Archetype Spells we can Add to a Character
var() const archetype array <MCStatus> AllArchetypeStatuses;

DefaultProperties
{

}