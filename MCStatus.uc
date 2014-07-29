//----------------------------------------------------------------------------
// MCStatus
//
// Spell Status Section
//
// Gustav Knutsson 2014-07-18
//----------------------------------------------------------------------------
class MCStatus extends Object
	hidecategories(Movement, Display, Attachment, Collision, Physics, Advanced, Debug, Object, Mobile);

struct StatusDamageStruct
{
	// Gain or Loose AP
	var() int AP;
	// Percentage damage increase
	var() float DamagePercent;
	// Damage it will do
	var() float Damage;
};

// Status Name
var(MCStatus) string StatusName;
// Status Damage, can do different things that we assign to different spells
var(MCStatus) StatusDamageStruct StatusDamage;
// Durration
var(MCStatus) int StatusDuration;


DefaultProperties
{
	//defaults
}