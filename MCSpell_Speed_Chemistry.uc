//----------------------------------------------------------------------------
// MCSpell_Speed_Chemistry
//
// Speed Chemistry Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Speed_Chemistry extends MCSpell;

/*
// The Activator for all spells
// @param	Caster			Who Casts the Spell
// @param	Enemy			Who the Caster is Aiming for
// @param	Opt_PathNode	What PathNode we would like to change
// @param	Opt_Tile		What Tile we would like to change
*/
simulated function Activate(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	local MCPlayerReplication MCPRep;
	
	// This does AP Check first so we can check if we can do the spell 
	super.Activate(Caster, Enemy, PathNode, Tile);

	if (Caster == none || Enemy == none)
	{
		`log(self @ " - Failed so Destroy() && return;");
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

	// -------------------------------------------------------------------------------------------------------
	// @BUG Only activates on Casting Client, but works as intended
	// -------------------------------------------------------------------------------------------------------
		
		`log(name @ "- Activate Cast");



		// In here set the Status link, only on Server
		if ((WorldInfo.NetMode == NM_DedicatedServer) || (WorldInfo.NetMode == NM_ListenServer) )
		{
			// Server
			SpawnAtTarget(Caster);
		}else
		{
			
		}

	// -------------------------------------------------------------------------------------------------------

		// Spell mode off
		Caster.PC.bIsSpellActive = false;
		// Check if we have AP to continue
		Caster.PC.CheckCurrentAPCalculation();
	}

	// Destroy Class
	Destroy();
}

simulated function SpawnAtTarget(MCPawn TargetChar)
{
	local MCStatus cSpeedChemistry;
	local vector ChangedLoc;

	ChangedLoc = TargetChar.Location;
	ChangedLoc.z -= 1000;

	cSpeedChemistry = Spawn(class'MCStatus_SpeedChemistry',,,ChangedLoc);

	cSpeedChemistry.SetLocation(TargetChar.Location);

	Destroy();
}




/*
// Adding a certain status on inpact to both Server && Client
// @param 	TargetChar		Who we target
// @param 	MCStatus		What Status we are using
*/
reliable server function AddingSpellServer(MCPawn TargetChar, MCStatus WhatStatus)
{
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
				`log("ADDED!!!!");
				break;
			}
			else
			{
			//	`log(i @ "- WTF SOMETHING HERE in" @ name @ "This=" @ Target.MyStatus[i]);
			}
		}
	}
}

DefaultProperties
{
}