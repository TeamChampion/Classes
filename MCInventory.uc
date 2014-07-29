//----------------------------------------------------------------------------
// MCInventory
//
// Inventory for each charachter
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCInventory extends Actor
	hidecategories(Movement, Display, Attachment, Collision, Physics, Advanced, Debug, Object, Mobile)
	abstract
	config(MystrasConfig);

// Inventory
var(Inventory) array<MCItem_Weapon> OwnedWeapons;
var	config array<int> MyOwnedWeapons;

var(Inventory) array<MCItem_Accessories> OwnedAccessories;
var	config array<int> MyOwnedAccessories;

var(Inventory) array<MCItem_Enchantments> OwnedEnchantments;
var	config array<int> MyOwnedEnchantments;

var(Inventory) array<MCItem_ResearchMaterial> OwnedResearchMaterial;
var	config array<int> MyOwnedResearchMaterial;

DefaultProperties
{
	//defaults
}