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

struct ItemSetting
{
	var config array<int> ItemNumber;
	var config array<int> Active;
};

// Reset Inventory
var ItemSetting ResetInventory;

// Inventory
var(Inventory) array<MCItem_Weapon> OwnedWeapons;
//var	config array<int> MyOwnedWeapons;
var config ItemSetting ConfigWeapons;

var(Inventory) array<MCItem_Accessories> OwnedAccessories;
//var	config array<int> MyOwnedAccessories;
var config ItemSetting ConfigAccessories;

var(Inventory) array<MCItem_Enchantments> OwnedEnchantments;
//var	config array<int> MyOwnedEnchantments;
var config ItemSetting ConfigEnchantments;

var(Inventory) array<MCItem_ResearchMaterial> OwnedResearchMaterial;
//var	config array<int> MyOwnedResearchMaterial;
var config ItemSetting ConfigResearchMaterial;

DefaultProperties
{
	//defaults
}