//----------------------------------------------------------------------------
// MCPlayerReplication
//
// Control Players Replication to server, Sets his ID & updates Health
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCPlayerReplication extends PlayerReplicationInfo;

// What ID this Character has
var int PlayerUniqueID;
// Current Float this Char is using
var RepNotify float APf;
// Current Max APf we set this Character to, base start value is 6.0f
var float APfMax;
// Character Name
var string PawnName;
// Health We have
var int Health;
// Max Health we have
var int HealthMax;
// Check if this Guy has AP over 1.0f
var bool bHaveAp;
// Current Spells replicate, @CHANGE subject to change into an array instead
var int currentSpells01, currentSpells02, currentSpells03, currentSpells04;

// Current hero that this player has selected
var RepNotify MCPawn HeroArchetype;
var Repnotify int setCharacterSelect;



struct MCStatusRep
{
	// Activated
	var bool bActivated;
	// If it's suppose to start for next turn, we set it from MCStatus
	var bool bStartNextTurn;
	// Status Name
	var string StatusName;
	// Gain or Loose AP
	var int AP;
	// Percentage damage increase
	var float DamagePercent;
	// Damage it will do
	var float Damage;
	// Durration
	var int StatusDuration;
};
//var MCStatus MyStatus[10];
// How many we can have at max
//const int MaxCount;
// What Status we have on ous
var MCStatusRep MyStatus[10];

// Resistance Numbers
// Fire		0
// Ice		1
// Earth	2
// Acid		3
// Thunder	4
var int ResistanceValues[5];



//////////////////////////////////////
// @NOTUSING Setting Tiles & Pathnodes function
var int NumberRecheck;

// Replication block
replication
{
	// I am the Server, send these variables to all Clients
	if (bNetDirty && Role == Role_Authority)
		PlayerUniqueID, APf, Health, bHaveAp;

	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		setCharacterSelect, HeroArchetype, PawnName, MyStatus;

	if (bNetDirty)
		currentSpells01, currentSpells02, currentSpells03, currentSpells04;

	if(bNetInitial)
		APfMax;

	if(bNetDirty)
		ResistanceValues;

//	if(bNetDirty && Role == ROLE_Authority)
//		MyStatus;
}

simulated event ReplicatedEvent(name VarName)
{
	local PlayerController PC;
//	local MCPlayerController cMCPC;

	if (VarName == 'APf')
	{
	/*
		return;
		if (APf == APfMax)
		{
			// Send this Information to PC
			foreach LocalPlayerControllers(Class'PlayerController', PC)
			{
				if (PC.PlayerReplicationInfo == self)
				{
					cMCPC = MCPlayerController(PC);

					cMCPC.Craps();
				}
			}
		}
		*/
	}
	

	if (VarName == 'HeroArchetype')
	{
		// client does this

		foreach LocalPlayerControllers(Class'PlayerController', PC)
		{
			if (PC.PlayerReplicationInfo == self)
			{
				// Goes in and set stuff
			//	MCPlayerController(PC).HeroPawn = HeroArchetype;
			//	MCPlayerController(PC).SetHeroServer(HeroArchetype);
				SetHeroArchetype(HeroArchetype);
			}
		}
	}
	if (VarName == 'setCharacterSelect')
	{


		foreach LocalPlayerControllers(Class'PlayerController', PC)
		{
			if (PC.PlayerReplicationInfo == self)
			{
				//MCPlayerController(PC).optimize("ID set to " @ PlayerUniqueID);
				MCPlayerController(PC).setCharacterSelect = setCharacterSelect;
				`log("Send Back Stuff To PC - setCharacterSelect" @ setCharacterSelect);
			//	if(!MCPlayerController(PC).SearchMe)
			//	{
					MCPlayerController(PC).SetHeroNumberServer(setCharacterSelect);


			//	}
			}
		}
	}

	super.ReplicatedEvent(VarName);
}

simulated function RecieveMessage(int PlayerNumber)
{
	`log("-------------------------------------------------------------------------");
	if (Role == Role_Authority)
	{
		`log("Inside" @ PlayerUniqueID);
		`log("RecieveMessage - Server in PlayerReplication=" @PlayerNumber);
		RecieveMessageClient(PlayerNumber);
	}
	`log("-------------------------------------------------------------------------");
}

reliable client function RecieveMessageClient(int PlayerNumber)
{
	if (Role == Role_Authority)
	{
		`log("RecieveMessageClient - Server in PlayerReplication=" @PlayerNumber);
	}else
	{
		`log("RecieveMessageClient - client in PlayerReplication=" @PlayerNumber);
	}
}

// Used for  Adding Tiles and Pathnodes in MCPawn && PlayerReplication
simulated function SetTilesInsidePC(int WhatID)
{
	local PlayerController PC;
	local MCPlayerController cMCPC;

	if (WhatID == 0)
	{
		WhatID = NumberRecheck;
	}
	else
	{
		NumberRecheck = WhatID;
	}

	`log("SetTilesInsidePC - Send this to PC so that we can add stuff" @ APf @PlayerUniqueID @ WhatID);
	if (APf != 0 && PlayerUniqueID == WhatID)
	{
		`log("AP IS CURRENTLY" @ APf @ PlayerUniqueID @ WhatID);
		`log("AP IS CURRENTLY" @ APf @ PlayerUniqueID @ WhatID);
		`log("AP IS CURRENTLY" @ APf @ PlayerUniqueID @ WhatID);
		// Send this Information to PC


		foreach WorldInfo.AllControllers(class'PlayerController', PC)
		{
			cMCPC = MCPlayerController(PC);


			if (cMCPC.PlayerUniqueID == PlayerUniqueID)
			{
			//	cMCPC.Craps2(PlayerUniqueID);
			}
		}
		/*
		foreach LocalPlayerControllers(Class'PlayerController', PC)
		{
			if (PC.PlayerReplicationInfo == self)
			{
				cMCPC = MCPlayerController(PC);

				cMCPC.Craps2(PlayerUniqueID);
			}
		}
		*/
		`log("SetTilesInsidePC - Send Complete");
		ClearTimer('SetTilesInsidePC');
		NumberRecheck = 0;
	}else
	{
		// Set Timer to do this function until we get this done
		SetTimer(0.3f,true,'SetTilesInsidePC');

	}
}


simulated function SendWinAndLoseMessage(bool bOptions)
{
	local PlayerController PC;
	local MCPlayerController cMCPC;

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		cMCPC = MCPlayerController(PC);

		// Shows Win loss message
		if (!bOptions)
		{
			// If we have no Pawn, because it's dead
			if (cMCPC.Pawn == none)
			{
				// Lose
				cMCPC.SendLossMessage();
			}else
			{
				// Win
				cMCPC.SendWinMessage();
			}
		}
		// Shows Option
		else
		{
			cMCPC.ShowOptionTimer();
		}

	}
}

/*
// Update Player Health
*/
simulated function GetPlayerHealth(int NewHealth)
{
	Health = NewHealth;
}


simulated function SetHeroArchetype(MCPawn NewHeroArchetype)
{
	// Sync with the server if this is the client
	if (Role < Role_Authority)
	{
		ServerSetHeroArchetype(NewHeroArchetype);
	}

	// Simulate setting the hero archetype on the client for instant response, or actually set the hero archetype on the server
	AssignHeroArchetype(NewHeroArchetype);
}

reliable server function ServerSetHeroArchetype(MCPawn NewHeroArchetype)
{
	// Never run on this function on the client
	// Return if NewHeroArchetype is none
	// Return if the hero has already been set
	if (Role < Role_Authority || NewHeroArchetype == None || HeroArchetype != None)
	{
		return;
	}

	// Actually set the hero archetype on the server
	AssignHeroArchetype(NewHeroArchetype);
}

simulated function AssignHeroArchetype(MCPawn NewHeroArchetype)
{
	local MCGameInfo MCGI;
	local NavigationPoint MyStartSpot;
	// Return if NewHeroArchetype is none
	// Return if the hero has already been set
	if (NewHeroArchetype == None || HeroArchetype != None)
	{
		return;
	}

	HeroArchetype = NewHeroArchetype;


	// If a start spot wasn't found
	if (MyStartSpot == None)
	{
		// Check for a previously assigned spot
		if (HeroArchetype.Controller.StartSpot != None)
		{
			MyStartSpot = HeroArchetype.Controller.StartSpot;
		}
		else
		{
			// Otherwise abort
			return;
		}
	}


	if (Role == Role_Authority)
	{
		// Notify the game info that a player has picked his/her hero
		MCGI = MCGameInfo(WorldInfo.Game);
		if (MCGI != None)
		{
			// Spawn a Character
			`log(HeroArchetype.Controller);
			MCGI.SpawnDefaultPawnFor(HeroArchetype.Controller, MyStartSpot);
		}
	}
}

/*
// Adding a Status to a Person
// @Client @Server
*/
simulated function AddStatus(MCStatus NewStatus, int Index)
{
	// If we don't have a Status then return this
	if (NewStatus == none)
		return;

	// Add me
	MyStatus[Index].bActivated		= true;
	MyStatus[Index].bStartNextTurn	= NewStatus.bStartNextTurn;
	MyStatus[Index].StatusName 		= NewStatus.StatusName;
	MyStatus[Index].AP 				= NewStatus.StatusDamage.AP;
	MyStatus[Index].DamagePercent 	= NewStatus.StatusDamage.DamagePercent;
	MyStatus[Index].Damage 			= NewStatus.StatusDamage.Damage;
	MyStatus[Index].StatusDuration 	= NewStatus.StatusDuration;
}


/*
// Removing Status when We have 0 AP
// @Client @Server 		
*/
simulated function RemoveStatus()
{
	local int i;
	local MCStatusRep ResetStatus;

	`log("--------------------------------------");
	`log("Current ID=" @ PlayerUniqueID);

	// For Loop for each Status
	for (i = 0; i < ArrayCount(MyStatus) ; i++)
	{
		// If we have nothing then just continue in the loop
		if (!MyStatus[i].bActivated)
		{
			continue;
		}
		// If we have something start reducing the Duration
		else
		{
			// If we will start next Turn then we set it here
			if (MyStatus[i].bStartNextTurn)
			{
				MyStatus[i].bStartNextTurn = false;
				continue;
			}

			// Reduces the Duration by 1
			if (MyStatus[i].StatusDuration > 0 && !MyStatus[i].bStartNextTurn)
			{
				`log(i @ "- Reduce Duration:" @ MyStatus[i].StatusDuration);
				MyStatus[i].StatusDuration -= 1;
			}

			// If The Duration goes down to 0 we remove it from the array && reduce the i by -1 so that we get to reduce the next one
			if (MyStatus[i].StatusDuration <= 0)
			{
				`log(i @ "- Remove:" @ MyStatus[i].StatusDuration);
				MyStatus[i] 		= ResetStatus;
			}
		}
	}

	`log("Finished Removing!");
	`log("--------------------------------------");
}

simulated function float DoBuffCalculation(MCPawn Player, float StartAP)
{
	local int i;
	local MCStatus newStatus;
	local float StoreAPf;

	for (i = 0; i < ArrayCount(MyStatus) ; i++)
	{
		if (MyStatus[i].bActivated)
		{
			`log("-----------------------------------------------------");
			`log("" @ MyStatus[i].StatusName );
			`log("" @ MyStatus[i].AP );
			`log("" @ MyStatus[i].DamagePercent );
			`log("" @ MyStatus[i].Damage );
			`log("" @ MyStatus[i].StatusDuration );

			// Spawn a class for it depending on Status, @ADD maybe do a for loop with a list of archetype instead.
			if (MyStatus[i].StatusName == "Acid Burn")
				newStatus = Spawn(class'MCStatus_AcidBurn');
			else if (MyStatus[i].StatusName == "Frostbite")
				newStatus = Spawn(class'MCStatus_AcidBurn');
			else if (MyStatus[i].StatusName == "Acid Mist")
				newStatus = Spawn(class'MCStatus_AcidMist');
			else if (MyStatus[i].StatusName == "Frost")
				newStatus = Spawn(class'MCStatus_Frost');
			else if (MyStatus[i].StatusName == "Paralysis")
				newStatus = Spawn(class'MCStatus_Paralysis');
			else if (MyStatus[i].StatusName == "Speed Chemistry")
				newStatus = Spawn(class'MCStatus_SpeedChemistry');
			else if (MyStatus[i].StatusName == "Spell Amplification")
				newStatus = Spawn(class'MCStatus_SpellAmplification');
			else if (MyStatus[i].StatusName == "Twisted Tongue")
				newStatus = Spawn(class'MCStatus_TwistedTongue');
			else if (MyStatus[i].StatusName == "In the worm's mouth")
				newStatus = Spawn(class'MCStatus_WormsMouth');


				`log("We Found a Status???" @ newStatus);
				`log("We Found a Status???" @ newStatus);
				`log("We Found a Status???" @ newStatus);
				`log("We Found a Status???" @ newStatus);
				`log("We Found a Status???" @ newStatus);
				`log("We Found a Status???" @ newStatus);
			if (newStatus != none)
			{
				`log("New Status Found" @ newStatus);

				// Add stats to it
				newStatus.StatusDamage.AP			=	MyStatus[i].AP;
				newStatus.StatusDamage.DamagePercent=	MyStatus[i].DamagePercent;
				newStatus.StatusDamage.Damage		=	MyStatus[i].Damage;

				// Return AP Cost
				StoreAPf += newStatus.StatusCalculationAPCost(StartAP);
				// Do damage if we have
				newStatus.StatusCalculationDamage(Player);
				// Remove it

				`log("Added AP =" @ StoreAPf);

				newStatus.Destroy();
			}

			//
		}
	}

	return StoreAPf;
}

/*
ReplicationInfo classes have bAlwaysRelevant set to true. 
Server performance can be improved by setting 
a low NetUpdateFrequency. Whenever a replicated property 
changes, explicitly change NetUpdateTime to force replication.
Server performance can also be improved by 
setting 

bSkipActorPropertyReplication 

and 

bOnlyDirtyReplication to true.
*/

defaultproperties
{
	bOnlyDirtyReplication = true
	bAlwaysRelevant = true
	//NetUpdateFrequency = 3
}