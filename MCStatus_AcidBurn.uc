//----------------------------------------------------------------------------
// MCStatus_AcidBurn
//
// Acid Burn Status
//
// Gustav Knutsson 2014-08-04
//----------------------------------------------------------------------------
class MCStatus_AcidBurn extends MCStatus
	hidecategories(Movement, Display, Attachment, Collision, Physics, Advanced, Debug, Object, Mobile);

/*
// Function that calculates AP Increase or Decrease
// @return 		Apf  -/+
*/
reliable server function float StatusCalculationAPCost(optional float PcCurrentAPf)
{
	local float APf;

	// Set Different Spell Number for Different Spell
	SetDifferentSpellDamageAndAP();

	// If AP is not set to 0 as base
	if (StatusDamage.AP != 0)
		APf = StatusDamage.AP;
	
	return APf;
}

/*
// What Target will we inflict damage on
// @param 	Target		What Target will take damage
*/
reliable server function StatusCalculationDamage(MCPawn Target)
{
	local vector empty;

	// If resistance, we need to add a link and do the calculation, atm we get an error because MCSpell is @Abstract
	/*
	local MCSpell cSpell;
	local MCPawn Enemy;
	
	// Initialize a spell class
	cSpell = Spawn(class'MCSpell');

	// Get Enemy Pawn
	foreach DynamicActors(Class'MCPawn', Enemy)
	{
		if(Target != Enemy)
			break;
	}

	// Add Resistance In here or not
	if (cSpell.CheckResistance(Target, Enemy))
	{	
		`log("SUCCESSFUL HIT!");
		StatusDamage.Damage = 7;
	}else
	{
		`log("WE RESISTED OH CRAPZ!");
		StatusDamage.Damage = 0;
	}
	*/
	// Do damage
	Target.TakeDamage(StatusDamage.Damage, none, Target.Location, empty, class'DamageType');

	// Remove Spell class
//	cSpell.Destroy();
}

/*
// Set Spell Damage for Certain Acid spells
*/
function SetDifferentSpellDamageAndAP()
{
	switch (spellNumber)
	{
		case 2:
			// Alchemist's Bullet
			StatusDamage.Damage = 5;
			StatusDamage.AP = -1;
			break;
		case 22:
			// Acid Touch
			StatusDamage.Damage = 25;
			StatusDamage.AP = 0;
			break;
		case 30:
			// Acid Rain
			StatusDamage.Damage = 10;
			StatusDamage.AP = 0;
			break;
		case 23:
			// Taint Water
			StatusDamage.Damage = 7.5f;
			StatusDamage.AP = 0;

			break;
		default:
			//	
	}
}

DefaultProperties
{
	//defaults
}