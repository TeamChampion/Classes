//----------------------------------------------------------------------------
// MCItem_Enchantments
//
// Attach to a weapon at Wizzards Tower
//
// Gustav Knutsson 2014-06-25
//----------------------------------------------------------------------------
class MCItem_Enchantments extends MCItem;

// the actual object's mesh
var(MCItem, Accessory) SkeletalMeshComponent AccessoriesMesh;
// ID of the enchanted item
var(MCItem, Accessory) const int AttachedID;
// Ability the enchantment bestows on the weapon
var(MCItem, Accessory) const ItemStats Stats;

DefaultProperties
{
	//defaults
}