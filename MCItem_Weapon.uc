//----------------------------------------------------------------------------
// MCItem_Weapon
//
// Base Weapon stats we can set in Archetype
// @Abilities 3
// @Enchantments 2
//
// @TODO WeaponThemes, what are they
//
// Gustav Knutsson 2014-06-25
//----------------------------------------------------------------------------
class MCItem_Weapon extends MCItem;

// the actual object's mesh
var(MCItem, Weapon) SkeletalMeshComponent WeaponMesh;
// Shape of the Item, Weapon, Accessories
var(MCItem, Weapon) const string sType;
// Ability of the Item, used for Weapons and Accessories
var(MCItem, Weapon) const array<ItemStats> Stats;
// Number of slots this weapon has open for enchanting
var(MCItem, Weapon) const int Slots;
// List of attached echantments, we set theese in config file later on
var(MCItem, Weapon) const array<MCItem_Enchantments> Enchantments;

DefaultProperties
{
	//defaults
}