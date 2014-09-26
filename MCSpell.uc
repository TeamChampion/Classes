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
//var localized string spellName[44];
var(MCSpell) string spellName;
// Name of Texture name we link into Flash (english only)
var(MCSpell) string spellTextureName;
// Name Description of spell
//var localized string Description[44];
var(MCSpell) string Description;
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
// Where we should Spawn
var(MCSpell, Placement) Vector ExtraSpawnSpace;
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

// Projectie Extra things
var class<MCProjectile> ProjectileClass;	// What Projectile we Spawn
var class<MCActor> ActorClass;				// What MCActor we Spawn
var class<MCStatus> StatusClass;			// What Status we Spawn
var bool bCanSendSpellNumber;				// Do we send Spell Id to Spell for MCStatus Acid Burn dufferent stats
var bool bCanActivate;						// After checking AP, decide if we can Activate the spell or not

// Check AP Distance Spell
var float APDistanceValue;			// How many Tiles Away we can check this
var Vector TargetLocation;			// Where we can do a search from, Player or Tile
var MCTile TargetTile;				// What Tile we use for Fire fist or Neural Network etc
var MCActor TargetCloud;			// What Tile we will get and use
var MCActor SpawnMCActor;			// What Actor we want to manipulate

// Make Mud FireTilesuse
var array<MCTile> MyFireTiles;

// Replication block
replication
{
	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		damage, bIsEnabled, SpawnMCActor;
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

	// 01 - Calculate the Main Spell Resistance Percentage
	fPercentage = SumResistance(CasterRep.ResistanceValues, EnemyRep.ResistanceValues);
	fRandom = FRand();

	// 02 - Add Weapons, & Armor bonuses
//	`log(fRandom @ "<" @ fPercentage);

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
					TempDamage = MCPRep.MyStatus[i].DamagePercent;
					bKaleidoscopeExtra = true;
				}
			}

			// Tounge Twister && can only be used once
			else if (MCPRep.MyStatus[i].StatusName == "Twisted Tongue" && !bToungeTwisterExtra)
			{
				TempSpellCast = MCPRep.MyStatus[i].DamagePercent;
				bToungeTwisterExtra = true;
			}
		}
	}

	// sets spell bools true if we have and use them if needed
	// If Kaleidoscope, extra damage
	if (bKaleidoscopeExtra)
		damage *= TempDamage;

	// If Tounge Twister, increase AP Cost
	else if (bToungeTwisterExtra)
		APCost *= TempSpellCast;
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

	// Will we do any Extra specific spell inputs to this Spell
	CheckForExtraDamage(Caster);

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
					//	`log(i @ "- Reduce Duration:" @ MCPRepUpdate.MyStatus[i].StatusDuration);
						MCPRepUpdate.MyStatus[i].StatusDuration -= 1;
					}
				}
			}
		}

		// We activate Spell
		bCanActivate = true;
	}
	else
	{
		// If not enought AP, return and Destroy this
	//	`log("Not enought AP, missing" @ APCost - Caster.APf);
		bCanActivate = false;
		// Send Message that we failed
		if (Role == Role_Authority)
			SendAPrivateMessage(Caster, spellName, "Not Enought AP.");	// spellName[spellNumber]

		Destroy();
		return;
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
simulated function ActivateProjectile(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	local MCPlayerReplication MCPRep;
	
	if (Caster == none || Enemy == none || !bCanActivate)
	{
	//	`log(self @ " - Failed so Destroy() && return;");
		SendAPrivateMessage(Caster, spellName, "Failed so cancel spell.");	//spellName[spellNumber]
		Destroy();
		return;
	}

	`log(name @ "- Activate Spell");
	// Update Casters AP Cost
	foreach DynamicActors(Class'MCPlayerReplication', MCPRep)
	{
		if (Caster.PlayerUniqueID == MCPRep.PlayerUniqueID)
		{
			Caster.APf -= APCost;
			MCPRep.APf = Caster.APf;
		}
	}
	`log(name @ "- Activate Function");

	// Spell mode active so we can't move
	Caster.PC.bIsSpellActive = true;
	// Turn of Tiles
	Caster.PC.TurnOffTiles();

	// Shoot Spell, Make sure it's only on the server
	if ( (WorldInfo.NetMode == NM_DedicatedServer) || (WorldInfo.NetMode == NM_ListenServer) )
	{
		Cast(Caster, Enemy);
	}else
	{
		// Remove from Client
		Destroy();
	}

	// Reset Everything and check if we still have AP
//	caster.PC.bIsSpellActive = false;
//	caster.PC.CheckCurrentAPCalculation();
}
// Activate a Projectile Close Spell
simulated function ActivateProjectileClose(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	local MCPlayerReplication MCPRep;

	if (Caster == none || Enemy == none || !bCanActivate)
	{
	//	`log(self @ " - Failed so Destroy() && return;");
		SendAPrivateMessage(Caster, spellName, "Failed so cancel spell.");	//spellName[spellNumber]
		Destroy();
		return;
	}

	// Check Distance First, if good we can cast spell otherwise stop it
	if (VSize(Caster.Location - Enemy.Location) < fMaxSpellDistance)
	{
		`log(name @ "- Activate Spell");
		// Update Casters AP Cost
		foreach DynamicActors(Class'MCPlayerReplication', MCPRep)
		{
			if (Caster.PlayerUniqueID == MCPRep.PlayerUniqueID)
			{
				Caster.APf -= APCost;
				MCPRep.APf = Caster.APf;
			}
		}

		// Spell mode active
		Caster.PC.bIsSpellActive = true;
		// Turn of Tiles
		Caster.PC.TurnOffTiles();

		// Shoot Spell, Make sure it's only on the server
		if ( (WorldInfo.NetMode == NM_DedicatedServer) || (WorldInfo.NetMode == NM_ListenServer) )
		{
			Cast(Caster, Enemy);
		}else
		{
			// Remove from Client
			Destroy();
		}

		// Reset Everything and check if we still have AP
		caster.PC.bIsSpellActive = false;
		caster.PC.CheckCurrentAPCalculation();
	}else
	{
		// Exit Spell
		SendAPrivateMessage(Caster, spellName, "Target too far away.");	//spellName[spellNumber]
		Destroy();
	}
}
// Activate a Projectile Close Spell
simulated function ActivateArea(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	local int i;
	local MCPlayerController PC;

	if (Caster == none || Enemy == none || !bCanActivate)
	{
	//	`log(self @ " - Failed so Destroy() && return;");
		SendAPrivateMessage(Caster, spellName, "Failed so cancel spell.");	//spellName[spellNumber]
		Destroy();
		return;
	}

	`log(name @ "- Activate Spell");
	// Cast nesscesary Classes
	PC = Caster.PC;

	// Turn Off All active tiles
	for (i = 0;i < PC.TilesWeCanMoveOn.length ; i++)
		PC.TilesWeCanMoveOn[i].ResetTileToNormal();

	// Spell mode active
	PC.bIsSpellActive = true;
	// Turn of Tiles
//	Caster.PC.TurnOffTiles();

	// If it's not Ride The Lightning, we check for nearby settings
	if (spellNumber == 31 ) // || spellNumber == 6
	{
		PC.CheckTeleportArea(APDistanceValue);
	}else
	{
		PC.CheckDistanceNearPlayer();
	}
}
// Activate a Projectile Close Spell
simulated function ActivateStatusSelf(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	local MCPlayerReplication MCPRep;

	if (Caster == none || Enemy == none || !bCanActivate)
	{
	//	`log(self @ " - Failed so Destroy() && return;");
		SendAPrivateMessage(Caster, spellName, "Failed so cancel spell.");	//spellName[spellNumber]
		Destroy();
		return;
	}

	if (Status != none)
	{
		`log(name @ "- Activate Spell");
		// Update Casters AP Cost
		foreach DynamicActors(Class'MCPlayerReplication', MCPRep)
		{
			if (Caster.PlayerUniqueID == MCPRep.PlayerUniqueID)
			{
				Caster.APf -= APCost;
				MCPRep.APf = Caster.APf;
			}
		}

		// Spell mode active
		Caster.PC.bIsSpellActive = true;
		// Turn of Tiles
		Caster.PC.TurnOffTiles();

		`log(name @ "- Activate Cast");

		// In here set the Status link, only on Server
		if ((WorldInfo.NetMode == NM_DedicatedServer) || (WorldInfo.NetMode == NM_ListenServer) )
		{
			// Server
			CastStatus(Caster);
		}

		// Spell mode off
		Caster.PC.bIsSpellActive = false;
		// Check if we have AP to continue
		Caster.PC.CheckCurrentAPCalculation();
	}

	// Destroy Class
	Destroy();
}
// Activate a Projectile Close Spell
simulated function ActivateStatusEnemyClose(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	local MCPlayerReplication MCPRep;
	
	if (Caster == none || Enemy == none || !bCanActivate)
	{
	//	`log(self @ " - Failed so Destroy() && return;");
		SendAPrivateMessage(Caster, spellName, "Failed so cancel spell.");	//spellName[spellNumber]
		Destroy();
		return;
	}

	// Check Status
	if (Status != none)
	{
		// Check Distance First, if good we can cast spell otherwise stop it
		if (VSize(Caster.Location - Enemy.Location) < fMaxSpellDistance)
		{
			`log(name @ "- Activate Spell");

			// Update Casters AP Cost
			foreach DynamicActors(Class'MCPlayerReplication', MCPRep)
			{
				if (Caster.PlayerUniqueID == MCPRep.PlayerUniqueID)
				{
					Caster.APf -= APCost;
					MCPRep.APf = Caster.APf;
				}
			}

			// Spell mode active
			Caster.PC.bIsSpellActive = true;
			// Turn of Tiles
			Caster.PC.TurnOffTiles();

		// -------------------------------------------------------------------------------------------------------
			
			`log(name @ "- Activate Cast");

			// In here set the Status link, only on Server
			if ((WorldInfo.NetMode == NM_DedicatedServer) || (WorldInfo.NetMode == NM_ListenServer) )
			{
				// Resistance Check
				if (CheckResistance(caster, enemy))
				{
					// Send Message to all Clients
					if (Role == Role_Authority)
						SendAWorldMessageResist(spellName, true);	// spellName[spellNumber]

					// Server
					CastStatus(Enemy);
				}
				// If we resist than nothing
				else
				{
					if (Role == Role_Authority)
						SendAWorldMessageResist(spellName, false);	// spellName[spellNumber]
				}
			}

		// -------------------------------------------------------------------------------------------------------

			// Spell mode off
			Caster.PC.bIsSpellActive = false;
			// Check if we have AP to continue
			Caster.PC.CheckCurrentAPCalculation();
		}else
		{
			// Exit Spell
			SendAPrivateMessage(Caster, spellName, "Target too far away.");	// spellName[spellNumber]
			// Turn Off Spell
			Caster.PC.InstantiateSpell = none;
			Destroy();
		}
	}

	// Destroy Class
	Destroy();
}

// Activate a Projectile Close Spell
simulated function ActivateAreaCloud(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	local int i;
	local MCPlayerController PC;

	if (Caster == none || Enemy == none || !bCanActivate)
	{
	//	`log(self @ " - Failed so Destroy() && return;");
		SendAPrivateMessage(Caster, spellName, "Failed so cancel spell.");	//spellName[spellNumber]
		Destroy();
		return;
	}

	`log(name @ "- Activate Spell");
	// Cast nesscesary Classes
	PC = Caster.PC;

	// Turn Off All active tiles
	for (i = 0;i < PC.TilesWeCanMoveOn.length ; i++)
		PC.TilesWeCanMoveOn[i].ResetTileToNormal();

	// Spell mode active
	PC.bIsSpellActive = true;
	
	// Turn of Tiles
	Caster.PC.TurnOffTiles();

	// 
	PC.CheckCloudArea(8, TargetLocation);
}

// Activate a Projectile Close Spell
simulated function ActivateCloud(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	local MCPlayerReplication MCPRep;

	if (Caster == none || Enemy == none || !bCanActivate)
	{
	//	`log(self @ " - Failed so Destroy() && return;");
		SendAPrivateMessage(Caster, spellName, "Failed so cancel spell.");	//spellName[spellNumber]
		Destroy();
		return;
	}

	`log(name @ "- Activate Spell");
	// Update Casters AP Cost
	foreach DynamicActors(Class'MCPlayerReplication', MCPRep)
	{
		if (Caster.PlayerUniqueID == MCPRep.PlayerUniqueID)
		{
			Caster.APf -= APCost;
			MCPRep.APf = Caster.APf;
		}
	}

	// Spell mode active
	Caster.PC.bIsSpellActive = true;
	// Turn of Tiles
	Caster.PC.TurnOffTiles();

	// Shoot Spell, Make sure it's only on the server
	if ( (WorldInfo.NetMode == NM_DedicatedServer) || (WorldInfo.NetMode == NM_ListenServer) )
	{
		CastRain(Caster, Enemy, TargetCloud);
	}else
	{
		// Remove from Client
		Destroy();
	}

	// Reset Everything and check if we still have AP
//	caster.PC.bIsSpellActive = false;
//	caster.PC.CheckCurrentAPCalculation();
}

/*
ActivateProjectile - Cast
	- 02 - Alchemist Bullet 	- Add Spellnumber
	- 43 - Fireball
	- 08 - Fire Fan
	- 13 - Ice Arrow
	- 19 - Rock & Roll
	- 27 - Spark Bolt
ActivateProjectileClose - Cast
	- 22 - Acid Touch 				- Add Spellnumber
	- 17 - Rock Fang 				(uses enemy as target, so keep this Cast function in it's class)
	- 12 - Spear Of Ice
ActivateArea - CastClickSpellServer
	- 25 - Dissolve Element 		PC.CheckDistanceNearPlayer();		 		Use all Tiles
	- 07 - Fire Fountain 			PC.CheckDistanceNearPlayer();	CastArea 		
	- 15 - Glass Floor 				PC.CheckDistanceNearPlayer();		 		
	- 31 - Ride The Lightning 		PC.CheckTeleportArea(5.0f);			 		Use All Tiles
	- 20 - Stone Wall 				PC.CheckDistanceNearPlayer();	CastArea 		
	- 21 - Unearth Material 		PC.CheckDistanceNearPlayer();	CastArea 		
	- 11 - Wall Of Ice 				PC.CheckDistanceNearPlayer();	CastArea 		
ActivateStatusSelf - SpawnAtTarget
	- 01 - Kaleidoscope
	- 24 - Speed Chemistry
ActivateStatusEnemyClose - SpawnAtTarget
	- 28 - Paralytic Touch
	- 04 - Tongue Twister
ActivateAreaCloud - CastCloud
	- 03 - Scourge
	- 09 - Create Cloud
	- 29 - Acid Fumes
ActivateCloud = CastRain
	- 14 - Crystal Rain
	- 30 - Acid Rain
*/

/*
// Starts Casting a ActivateProjectile or ActivateStatusSelf Spell on server
// @param	caster			Who Casts the Spell
// @param	enemy			Who the Caster is Aiming for
*/
function Cast(MCPawn caster, MCPawn enemy)
{
	local MCProjectile MyProjectile;	//	local UDKProjectile MyProjectile;
	local Vector ModifiedLocation;

	if (Role == Role_Authority)
	{
		ModifiedLocation = caster.Location;
		ModifiedLocation += ExtraSpawnSpace;

		MyProjectile = Spawn(ProjectileClass, caster, , ModifiedLocation);
		// Set Caster in MCProjectile so we can when Destroyed set movement back ON
		MyProjectile.PawnThatShoots = caster;

		// Resistance Check
		if (CheckResistance(caster, enemy))
		{
			// Add the damage
			SendAWorldMessageResist(spellName, true);	// spellName[spellNumber]
			MyProjectile.Damage = damage;
			// Set Status
			if (Status != none)
				MyProjectile.Status = Status;
			// Set SpellNumber
			if(bCanSendSpellNumber)
				MyProjectile.spellNumber = spellNumber;
		}else
		{
			SendAWorldMessageResist(spellName, false);	// spellName[spellNumber]
			MyProjectile.Damage = 0;
		}
		
		// Fire the Spell
		MyProjectile.Init(enemy.Location - ModifiedLocation);
		// Remove this Class from server
		Destroy();
	}
}

/*
// Starts Casting a ActivateArea spell that will Spawn an Actor, not Tile changing
// @param	caster			Who Casts the Spell
// @param	target			Where we do it
// @param	Opt_WhatTile	If we need a Tile to perform something specific
*/
function CastArea(MCPawn caster, Vector target, optional MCTile WhatTile)
{
	local Vector ModifiedLocation;

	ModifiedLocation = target;
	ModifiedLocation += ExtraSpawnSpace;

	SpawnMCActor = Spawn(ActorClass, none, ,ModifiedLocation);

	SpawnMCActor.Caster = caster;
}

function CastStatus(MCPawn Target)
{
	Local MCStatus MyStatusClass;
	local vector SpawnLocation;

	SpawnLocation = Target.Location;
	SpawnLocation.Z = -1024;

	MyStatusClass = Spawn(StatusClass,,, SpawnLocation,,);

	MyStatusClass.SetLocation(Target.Location);
}

/*
// Starts Casting a ActivateProjectile or ActivateStatusSelf Spell on server
// @param	caster			Who Casts the Spell
// @param	enemy			Who the Caster is Aiming for
*/
function CastRain(MCPawn caster, MCPawn enemy, MCActor WhatCloud)
{
	local MCActor MyRain;	//	local UDKProjectile MyProjectile;
	local Vector ModifiedLocation;

	if (Role == Role_Authority)
	{
		ModifiedLocation = WhatCloud.Location;
		ModifiedLocation += ExtraSpawnSpace;

		MyRain = Spawn(ActorClass, none, , ModifiedLocation);
		MyRain.Caster = caster;

/*
		// Resistance Check
		if (CheckResistance(caster, enemy))
		{
			// Add the damage
			SendAWorldMessageResist(spellName[spellNumber], true);
			MyRain.Damage = damage;
			// Set Status
			if (Status != none)
				MyRain.Status = Status;
			// Set SpellNumber
			if(bCanSendSpellNumber)
				MyRain.spellNumber = spellNumber;
		}else
		{
			SendAWorldMessageResist(spellName[spellNumber], false);
			MyRain.Damage = 0;
		}
*/
		// Remove this Class from server
		Destroy();
	}
}

/*
* Function we use for click spells
// @param	Opt_Caster			Who Casts the Spell
// @param	Opt_WhatTile			Who the Caster is Aiming for
// @param	Opt_PathNode	What PathNode we would like to change
*/
reliable server function CastClickSpellServer(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode){}
				function CastClickSpell(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode){}
reliable client function CastClickSpellClient(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode){}

/*
// Send a Debug Message to All Players when a Spell is Hit or not
// @param	SendSpellName		SpellName to add
// @param	bHit				If it hits or not
*/
function SendAWorldMessageResist(string SendSpellName, bool bHit)
{
	if (bHit)
	{
		WorldInfo.Game.Broadcast(self, "SUCCESSFUL HIT!");	
	}else
	{
		WorldInfo.Game.Broadcast(self, "RESISTED!");	
	}
}

function SendAPrivateMessage(MCPawn Caster, string SendSpellName, string Message)
{
	if (Caster.PC != none)
		WorldInfo.Game.BroadcastHandler.BroadcastText(Caster.PC.PlayerReplicationInfo, Caster.PC, Message);
}

DefaultProperties
{
	bFire=false
	bEarth=false
	bThunder=false
	bAcid=false
	bIce=false
}