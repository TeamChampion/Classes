//----------------------------------------------------------------------------
// MCSpell_Kaleidoscope
//
// Kaleidoscope Spell Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Kaleidoscope extends MCSpell;

function Cast(MCPawn caster, MCPawn enemy)
{
	local UDKProjectile fireball;
	fireball = Spawn(class'MCProjectileFireBall', caster, , caster.Location);
	fireball.Init(enemy.Location - caster.Location);
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
	//	Round	||	AP		|| Do
	//-----------------------------------------------------------
	//	4			9			Use Kaleodoscope (Get Status 2)
	//	4			3			Use Ice Arrow (Do double damage reduce Status form 2 to 1)
	//	4			0 			No more AP
	//	3			9			Check Status calc, reduce all by 1, so 1 goes down to 0 and removes it

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
		//	SpawnAtTarget(Caster);
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
	local MCStatus cSpellAmplification;
	local vector ChangedLoc;

	ChangedLoc = TargetChar.Location;
	ChangedLoc.z -= 1000;

	cSpellAmplification = Spawn(class'MCStatus_SpellAmplification',,,ChangedLoc);

	cSpellAmplification.SetLocation(TargetChar.Location);

	Destroy();
}

DefaultProperties
{
}