//----------------------------------------------------------------------------
// MCShop
//
// Shop that contains all Items
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCShop extends Actor
	hidecategories(Movement, Display, Attachment, Collision, Physics, Advanced, Debug, Mobile, Object);

// Weapon Shop
var(WeaponShop) array<MCItem_Weapon> AllWeapons;
// Accessory Shop
var(AccessoryShop) array<MCItem_Accessories> AllAccessories;
// Enchantment Shop
var(EnchantmentShop) array<MCItem_Enchantments> AllEnchantments;
// Research Material Shop
var(ResearchMaterialShop) array<MCItem_ResearchMaterial> AllResearchMaterial;



DefaultProperties
{
	//defaults
}


