//----------------------------------------------------------------------------
// MCSpell_Tongue_Twister
//
// Tongue Twister Spell Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Tongue_Twister extends MCSpell;

function Cast(MCPawn caster, MCPawn enemy)
{

}

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
						SendAWorldMessage(spellName[spellNumber], true);

					// Server
					CastBuff(Enemy);
				}
				// If we resist than nothing
				else
				{
					if (Role == Role_Authority)
						SendAWorldMessage(spellName[spellNumber], false);
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
			`log(name @ "Can't Be Casted");
			// Turn Off Spell
			Caster.PC.InstantiateSpell = none;
			Destroy();
		}
	}

	// Destroy Class
	Destroy();
}


function CastBuff(MCPawn Target)
{
	Local MCStatus cTwistedTongue;
	local vector SpawnPlace;

	SpawnPlace = Target.Location;
	SpawnPlace.Z = -1024;

	cTwistedTongue = Spawn(class'MCStatus_TwistedTongue',,, SpawnPlace,,);

	cTwistedTongue.SetLocation(Target.Location);
}

DefaultProperties
{
}