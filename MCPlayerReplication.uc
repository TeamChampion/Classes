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
//var ProtectedWrite RepNotify MCPawn HeroArchetype;
var RepNotify MCPawn HeroArchetype;
var Repnotify int setCharacterSelect;



var int NumberRecheck;

// Replication block
replication
{
	// I am the Server, send these variables to all Clients
	if (bNetDirty && Role == Role_Authority)
		PlayerUniqueID, APf, Health, bHaveAp;

	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		setCharacterSelect, HeroArchetype, PawnName;

	if (bNetDirty)
		currentSpells01, currentSpells02, currentSpells03, currentSpells04;

	if(bNetInitial)
		APfMax;
}

simulated event ReplicatedEvent(name VarName)
{
	local PlayerController PC;
	local MCPlayerController cMCPC;

	if (VarName == 'APf')
	{
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
				cMCPC.Craps2(PlayerUniqueID);
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


function SendWinAndLoseMessage()
{
	local PlayerController PC;
	local MCPlayerController cMCPC;

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		cMCPC = MCPlayerController(PC);

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
			`log(HeroArchetype.Controller);
			`log(HeroArchetype.Controller);
			`log(HeroArchetype.Controller);
			`log(HeroArchetype.Controller);
			`log(HeroArchetype.Controller);
			`log(HeroArchetype.Controller);
			`log(HeroArchetype.Controller);
			`log(HeroArchetype.Controller);
			`log(HeroArchetype.Controller);
			`log(HeroArchetype.Controller);
			`log(HeroArchetype.Controller);
			MCGI.SpawnDefaultPawnFor(HeroArchetype.Controller, MyStartSpot);
		}
	}
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