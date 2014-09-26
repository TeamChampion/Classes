//----------------------------------------------------------------------------
// MCStatus
//
// Spell Status Section
//
// Gustav Knutsson 2014-07-18
//----------------------------------------------------------------------------
class MCStatus extends Actor
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
// Spell ID, we add this so that we can use it for Acid Burn to set Different Damage Scales
var int spellNumber;
// If we want it to Start the next turn and not the turn it was activated on yourself, set this to true
var(MCStatus) bool bStartNextTurn;
// Status Archetype we later add when a Pawn has been Touched for Buffing or Debuffing
var(MCStatus) archetype MCStatus StatusArchetype;


// Replication block
replication
{
	if (bNetDirty)
		StatusDuration, spellNumber;
}

/*
// Function that calculates AP Increase or Decrease
// @return 		Apf  -/+
*/
reliable server function float StatusCalculationAPCost(optional float PcCurrentAPf)
{
	local float APf;

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
//	local vector empty;
	
//	Target.TakeDamage(StatusDamage.Damage, none, Target.Location, empty, class'DamageType');
}

/*
// Set Spell Damage for Certain Acid spells
*/
function SetDifferentSpellDamageAndAP(){}





/*
// Touch event for Buff or cause a Debuff
*/
simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local MCPawn Target;

	// Initialize the Target
	Target = MCPawn(Other);

	// If we have a Target, and a Archetype
	if (Target == Other && StatusArchetype != none)
	{
		// Add the archetype inside here
		if (StatusArchetype != none)
		{
			StatusName = StatusArchetype.StatusName;
			StatusDamage = StatusArchetype.StatusDamage;
			StatusDuration = StatusArchetype.StatusDuration;
			bStartNextTurn = StatusArchetype.bStartNextTurn;

			/*
			`log("=====================================================");
			`log("=====================================================");
			`log("=====================================================");
			`log("StatusName=	" @ StatusName);
			`log("StatusDamage=	" @ StatusDamage.Damage);
			`log("StatusDuration=	" @ StatusDuration);
			`log("bStartNextTurn=	" @ bStartNextTurn);
			`log("=====================================================");
			`log("=====================================================");
			`log("=====================================================");
			*/
		}

		// In here set the Status link, only on Server
		if ((WorldInfo.NetMode == NM_DedicatedServer) || (WorldInfo.NetMode == NM_ListenServer) )
		{
			// Server
			AddSpellServer(Target,self);
		}else
		{
			// Client
		//	AddingSpell(Target,self);
		}

		Destroy();
	}

//	SetTimer(0.5,false,'DestroyALL');
	Super.Touch(Other, OtherComp, HitLocation, HitNormal);
}

simulated function DestroyALL()
{
	Destroy();
}

/*
// Adding a certain status on inpact to both Server && Client
// @param 	TargetChar		Who we target
// @param 	MCStatus		What Status we are using
*/
reliable server function AddSpellServer(MCPawn TargetChar, MCStatus WhatStatus)
{
	local int i;	
	local MCPlayerReplication MCPrep;

	MCPrep = MCPlayerReplication(TargetChar.PlayerReplicationInfo);


	// Add it
	for (i = 0; i < ArrayCount(MCPrep.MyStatus) ; i++)
	{
		// If we have a Playerreplication
		if (MCPrep != none)
		{
			if (MCPrep.MyStatus[i].StatusName == "")
			{
				`log("Send to server" @ WhatStatus.StatusName);
				`log("Send to server" @ WhatStatus.StatusName);
				`log("Send to server" @ WhatStatus.StatusDuration);
				`log("Send to server" @ WhatStatus.StatusDuration);
				MCPrep.AddStatus(WhatStatus,i);
				break;
			}
			else
			{
			//	`log(i @ "- WTF SOMETHING HERE in" @ name @ "This=" @ Target.MyStatus[i]);
			}
		}
	}
}
























/*
// Adding a certain status on inpact to both Server && Client
// @param 	TargetChar		Who we target
// @param 	MCStatus		What Status we are using
*/
simulated function AddingSpell(MCPawn TargetChar, MCStatus WhatStatus)
{
	/*
	local int i;			

	// Add it
	for (i = 0;i < 10 ; i++)
	{
		if (TargetChar.MyStatus[i] == none)
		{
			TargetChar.AddStatus(WhatStatus,i);
			break;
		}else
		{
		//	`log(i @ "- WTF SOMETHING HERE in" @ name @ "This=" @ Target.MyStatus[i]);
		}
	}
*/
	local int i;	
	local MCPlayerReplication MCPrep;

	MCPrep = MCPlayerReplication(TargetChar.PlayerReplicationInfo);

	// Add it
	for (i = 0;i < ArrayCount(MCPrep.MyStatus) ; i++)
	{
		// If we have a Playerreplication
		if (MCPrep != none)
		{
			if (MCPrep.MyStatus[i].StatusName == "")
			{
				MCPrep.AddStatus(WhatStatus,i);
				break;
			}
			else
			{
			//	`log(i @ "- WTF SOMETHING HERE in" @ name @ "This=" @ Target.MyStatus[i]);
			}
		}
	}



	// Remove The Class in here After a Few Seconds, because if we destroy it immediately, client won't get it
	// Server
	if (Role == Role_Authority)
		SetTimer(4.0f, false, 'DestroyTimer');
	// Client
	else
		SetTimer(4.0f, false, 'DestroyTimer');
}

/*
// Destroys the class when we are done with this Status after a few seconds.
*/
simulated function DestroyTimer()
{
	Destroy();
}


DefaultProperties
{
	//defaults
	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true
}