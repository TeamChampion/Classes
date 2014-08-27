//----------------------------------------------------------------------------
// MCSpell
//
// Main Spell class that contains all Spell information and base functions for
// activating a spell for both clients & server
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell extends Actor
	HideCategories(Display, Attachment, Physics, Advanced, Debug, Object, Movement, Collision, Mobile)
	abstract;

enum SpellType
{
	eNotSetYet,
	eProjectile,
	eArea,
	eStatus
};

// Spell Number ID
var(MCSpell) int spellNumber;
// Name of Spell
var localized string spellName[44];
// Name of Texture name we link into Flash (english only)
var(MCSpell) string spellTextureName;
// Name Description of spell
var localized string Description[44];
// How much does the spell Cost
var(MCSpell) int AP;
// What kind of spell is it
var(MCSpell) bool bFire, bEarth, bThunder, bAcid, bIce;
// base damage it does
var(MCSpell) float damage;
// What Type of spell is it
var(MCSpell) SpellType Type;
// Max Distance you can cast a spell from your Character
var(MCSpell, Placement) float fMaxSpellDistance;
// Character Distance we use to calculate tiles Player & Enemy are not suppose to light up
var(MCSpell, Placement) float fCharacterDistance;
// Is Spell Ready to be used
var(MCSpell) bool bIsEnabled;
// What status you can afflict
var(MCSpell, StatusSection) MCStatus Status;
// Is this an area value we destroy something with
var(MCSpell, AreaSection) bool bAreaDestroy;

// Spell Specific Settings
var bool bKaleidoscopeExtra;		// If we have Kaleidoscope active
var bool bToungeTwisterExtra;		// If we have Tounge Twister active
var float APCost;					// What AP cost it will end up costing

// Replication block
replication
{
	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		damage, bIsEnabled;
}

/*
// Checks if a The Target Resist The Spell
// @param	Caster 			Who Cast the Spell
// @param	Enemy			Who the Caster is Aiming for
// @return 					True = No Resist so use damage
//							False= Resist so no damage
*/
function bool CheckResistance(MCPawn Caster, MCPawn Enemy)
{
	local MCPlayerReplication CasterRep;
	local MCPlayerReplication EnemyRep;
	local float fPercentage;
	local float fRandom;

//	Resistance Numbers
//	Fire		0
//	Ice			1
//	Earth		2
//	Acid		3
//	Thunder		4

	// Instansiate PlayerReplication fr both
	CasterRep = MCPlayerReplication(Caster.PlayerReplicationInfo);
	EnemyRep = MCPlayerReplication(Enemy.PlayerReplicationInfo);

	`log("Found CasterRep=" @ CasterRep);
	`log("Found EnemyRep=" @ EnemyRep);

	// 01 - Calculate the Main Spell Resistance Percentage
	fPercentage = SumResistance(CasterRep.ResistanceValues, EnemyRep.ResistanceValues);
	fRandom = FRand();

	// 02 - Add Weapons, & Armor bonuses
	`log(fRandom @ "<" @ fPercentage);

	// 03 - check randomly if we hit or not
	if (fRandom < fPercentage)
	{
		// This Does hit the Target
		return true;
	}else
	{
		// This Doesn't hit the Target
		return false;
	}
}

/*
// Do the main Calculation For how much Percentage we use
// @param	CasterCalcRes 		Caster's Main Stats
// @param	EnemyCalcRes 		Enemy's Main Stats
//
// @Return 	Float in Percentage
*/
function float SumResistance(int CasterCalcRes[5], int EnemyCalcRes[5])
{
	local float Result;
	//	Fire		0
	//	Ice			1
	//	Earth		2
	//	Acid		3
	//	Thunder		4

	// 01 - Do each calculation here
	if (bFire)
		Result += DoResistanceCalculation( float(CasterCalcRes[0]), float(EnemyCalcRes[0]) );
	if (bIce)
		Result += DoResistanceCalculation( float(CasterCalcRes[1]), float(EnemyCalcRes[1]) );
	if (bEarth)
		Result += DoResistanceCalculation( float(CasterCalcRes[2]), float(EnemyCalcRes[2]) );
	if (bAcid)
		Result += DoResistanceCalculation( float(CasterCalcRes[3]), float(EnemyCalcRes[3]) );
	if (bThunder)
		Result += DoResistanceCalculation( float(CasterCalcRes[4]), float(EnemyCalcRes[4]) );

	// 02 - If Results is less than 5% then we use that 5% for a small Resistance chance
	if (Result < 0.05f)
		Result = 0.05f;

	// 03 - Return the Calculated number, for all the Elements we use
	return Result;
}
/*
//Do the Algorithm for doing spell damage on a specific element
// @param	CasterCalcRes 		Caster's specific stats
// @param	EnemyCalcRes 		Enemy's specific Stats
*/
function float DoResistanceCalculation(float CasterCalcRes, float EnemyCalcRes)
{
	local float Result;

	// If they both have 0 then do nothing just add 0%
	if (CasterCalcRes == 0.0f && EnemyCalcRes == 0.0f)
	{
		Result = 0.0f;
		return Result;
	}
	else
	{
		// Do main Calculation
		Result = ( CasterCalcRes / ( CasterCalcRes + EnemyCalcRes ) );

		// If we get under 0% then just set it to 0.0f
		if (Result < 0.0f)
			Result = 0.0f;

		return Result;
	}
}

/*
// Checks a Player's Buffs or Debuffs for extra damage output or input
// 2 - If Kaleidoscope, check damage Spells
// 4 - Tounge Twister, check to add Spell Cost
//@param	Target 		Player's Status Check
*/
simulated function CheckForExtraDamage(MCPawn Target)
{
	local MCPlayerReplication MCPRep;
	local int i;
	local float TempDamage;			// Kaleidoscope damage
	local float TempSpellCast;		// Tounge Twister AP extra cost

	MCPRep = MCPlayerReplication(Target.PC.PlayerReplicationInfo);

	// Start by setting Initial APCost
	APCost = AP;
	`log("Current Spell damage" @ damage);

	// Check for Status
	if (MCPRep != none)
	{
		for (i = 0; i < ArrayCount(MCPRep.MyStatus)  ; i++)
		{
			// Kaleidoscope && can only be used once
			if (MCPRep.MyStatus[i].StatusName == "Spell Amplification" && !bKaleidoscopeExtra)
			{
				// If We have a certain amount of durations left
				if (MCPRep.MyStatus[i].StatusDuration > 0 && !MCPRep.MyStatus[i].bStartNextTurn)
				{
					`log("Found A Kaleiodoscope");
					TempDamage = MCPRep.MyStatus[i].DamagePercent;
					bKaleidoscopeExtra = true;
				}
			}

			// Tounge Twister && can only be used once
			else if (MCPRep.MyStatus[i].StatusName == "Twisted Tongue" && !bToungeTwisterExtra)
			{
				`log("Found A Tounge Twister");
				TempSpellCast = MCPRep.MyStatus[i].DamagePercent;
				bToungeTwisterExtra = true;
			}
		}
	}

	// sets spell bools true if we have and use them if needed
	// If Kaleidoscope, extra damage
	if (bKaleidoscopeExtra)
	{
		damage *= TempDamage;
		`log("New SpellCost=" @ damage);
	}

	// If Tounge Twister, increase AP Cost
	else if (bToungeTwisterExtra)
	{
		APCost *= TempSpellCast;
		`log("New APCost=" @ APCost);
	}
}

/*
// The Activator for all spells
// @param	Caster			Who Casts the Spell
// @param	Enemy			Who the Caster is Aiming for
// @param	Opt_PathNode	What PathNode we would like to change
// @param	Opt_Tile		What Tile we would like to change
*/
simulated function Activate(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile OneTile)
{
	local MCPlayerReplication MCPRepUpdate;
	local int i;

	`log("====================================");
	`log("Enter And Check Spell Extra Damage");
	`log("====================================");
	// Will we do any Extra specific spell inputs to this Spell
	CheckForExtraDamage(Caster);
	`log("====================================");

	// check if we have enought AP to use the spell
	if (APCost <= Caster.APf)
	{
		MCPRepUpdate = MCPlayerReplication(Caster.PC.PlayerReplicationInfo);

		// If We have a Kaleidoscope Status we remove a round for this spell when it goes threw
		if (MCPRepUpdate != none && bKaleidoscopeExtra)
		{
			for (i = 0; i < ArrayCount(MCPRepUpdate.MyStatus)  ; i++)
			{
				// Kaleidoscope Status
				if (MCPRepUpdate.MyStatus[i].StatusName == "Spell Amplification")
				{
					// If it's not the initialized spells turn
					if (MCPRepUpdate.MyStatus[i].StatusDuration > 0 && !MCPRepUpdate.MyStatus[i].bStartNextTurn)
					{
						`log(i @ "- Reduce Duration:" @ MCPRepUpdate.MyStatus[i].StatusDuration);
						MCPRepUpdate.MyStatus[i].StatusDuration -= 1;
					}
				}
			}
		}

		// Do stuff In each Spell
		// leave empty
	}
	else
	{
		// If not enought AP, return and Destroy this
		`log("Not enought AP, missing" @ APCost - Caster.APf);
		Destroy();

		/*
		exec function MySpell(byte SpellIndex) in PC remove
		*/
		return;
	}
}

/*
// Send a Debug Message to All Players when a Spell is Hit or not
// @param	SendSpellName		SpellName to add
// @param	bHit				If it hits or not
*/
function SendAWorldMessage(string SendSpellName, bool bHit)
{
	if (bHit)
	{
		WorldInfo.Game.Broadcast(self, SendSpellName @ "- SUCCESSFUL HIT!");	
	}else
	{
		WorldInfo.Game.Broadcast(self, SendSpellName @ "- RESISTED!");	
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Different Spells
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
// Activate a Projectile Long Distance Spell
// @param	Caster			Who Casts the Spell
// @param	Enemy			Who the Caster is Aiming for
// @param	Opt_PathNode	What PathNode we would like to change
// @param	Opt_Tile		What Tile we would like to change
*/
simulated function ActivateProjectile(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile OneTile)
{
}
// Activate a Projectile Close Spell
simulated function ActivateProjectileClose(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile OneTile)
{
}
// Activate a Projectile Close Spell
simulated function ActivateArea(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile OneTile)
{
}
// Activate a Projectile Close Spell
simulated function ActivateStatusSelf(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile OneTile)
{
}
// Activate a Projectile Close Spell
simulated function ActivateStatusEnemyClose(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile OneTile)
{
}


/*
ActivateProjectile
	- Alchemist Bullet
	- Fireball
	- Fire Fan
	- Ice Arrow
	- Rock & Roll
	- Rock Fang (Spawn, similiar to Projectile)
	- Spark Bolt
ActivateProjectileClose
	- Acid Touch
	- Spear Of Ice
ActivateArea
	- Dissolve Element 		PC.CheckDistanceNearPlayer();
	- Fire Fountain 		PC.CheckDistanceNearPlayer();
	- Glass Floor 			PC.CheckDistanceNearPlayer();
	- Ride The Lightning 	PC.CheckTeleportArea(5.0f);
	- Stone Wall 			PC.CheckDistanceNearPlayer();
	- Unearth Material 		PC.CheckDistanceNearPlayer();
	- Wall Of Ice 			PC.CheckDistanceNearPlayer();
ActivateStatusSelf
	- Kaleidoscope
	- Speed Chemistry
ActivateStatusEnemyClose
	- Paralytic Touch
	- Tongue Twister
*/

/*
// Starts Casting a ActivateProjectile or ActivateStatusSelf Spell on server
// @param	caster			Who Casts the Spell
// @param	enemy			Who the Caster is Aiming for
*/

function Cast(MCPawn caster, MCPawn enemy){}
/*
// Starts Casting a ActivateArea spell that will Spawn an Actor, not Tile changing
// @param	caster			Who Casts the Spell
// @param	target			Where we do it
*/

function CastArea(MCPawn caster, Vector target){}

/*
* Function we use for click spells
// @param	Opt_Caster			Who Casts the Spell
// @param	Opt_WhatTile			Who the Caster is Aiming for
// @param	Opt_PathNode	What PathNode we would like to change
*/
reliable server function CastClickSpellServer(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode){}
				function CastClickSpell(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode){}
reliable client function CastClickSpellClient(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode){}

DefaultProperties
{
	bFire=false
	bEarth=false
	bThunder=false
	bAcid=false
	bIce=false
}