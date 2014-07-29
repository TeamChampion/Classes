//----------------------------------------------------------------------------
// MCItem_Accessories
//
// Base Accessory stats we can set in Archetype
// @Enchantments_number ???
//
// Gustav Knutsson 2014-06-25
//----------------------------------------------------------------------------
class MCItem_Accessories extends MCItem;

// Accessory Type
enum AccessoryTypes
{
	Earring,
	Necklace,
	Ring
};

// the actual object's mesh
var(MCItem, Accessory) SkeletalMeshComponent AccessoriesMesh;
// Accessory Type
var(MCItem, Accessory) AccessoryTypes Accessory;
// Shape of the Item, Weapon, Accessories
var(MCItem, Accessory) const string sType;
// Ability of the Item, used for Weapons and Accessories
var(MCItem, Accessory) const ItemStats Stats;
// Number of slots this accessory has open for enchanting
var(MCItem, Accessory) const int Slots;
// List of attached echantments
var(MCItem, Accessory) const MCItem_Enchantments Enchantments;	// @TODO make Enchantments class

DefaultProperties
{
	//defaults
}