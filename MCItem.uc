//----------------------------------------------------------------------------
// MCItem
//
// Basic Item settings, make them into archetypes and put all items in a shop
//
// Gustav Knutsson 2014-06-25
//----------------------------------------------------------------------------
class MCItem extends Actor
	hidecategories(Movement, Display, Attachment, Collision, Physics, Advanced, Debug, Object, Mobile)
	abstract;

// What Damage It can do
enum SelectDamage
{
	Nothing,
	FireDamage,
	IceDamage,
	EarthDamage,
	AcidDamage,
	ThunderDamage
};

// What resistance it has
enum SelectResistance
{
	Nothing,
	FireResistance,
	IceResistance,
	EarthResistance,
	AcidResistance,
	ThunderResistance
};

// Basic stats for it to use
struct ItemStats
{
	// Select an Element we want to add a percent damage to
	var() SelectDamage eSelectDamage;
	// Select an Element we want to add a percent resistance to
	var() SelectResistance eSelectResistance;
	// Add Percent damage to selected Element, 0.2 = 20%, -0.1 = -10%
	var() float fPercentDamage;

};

// ID of the weapon
var() const int ID;
// Name of the Item
var() const string sItemName;
// Character level at which this item is equippable
var() const int Level;
// Price of the item in gold
var() const int Cost;
// Flavor text of the weapon
var() const string sDescription;

DefaultProperties
{
	//defaults
}