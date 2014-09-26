//----------------------------------------------------------------------------
// MCSpell_Neural_Network
//
// MCSpell Neural Network Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Neural_Network extends MCSpell;

var array<MCTile> SpellTiles;			// Main Order we do damage
var array<MCTile> FoundMetalTiles;		// All Metal Tiles we found
var MCTile CurrentTile;					// Current Tile we are searching for
var MCPawn MyDelegateCaster;

/*
// The Activator for all spells
// @param	Caster			Who Casts the Spell
// @param	Enemy			Who the Caster is Aiming for
// @param	Opt_PathNode	What PathNode we would like to change
// @param	Opt_Tile		What Tile we would like to change
*/
simulated function Activate(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	local int i, iFound;
	local MCGameReplication MCGR;
	local array<MCTile> MySpellTiles;
	MCGR = MCGameReplication(WorldInfo.GRI);

	// This does AP Check first so we can check if we can do the spell 
	super.Activate(Caster, Enemy, PathNode, Tile);

	// Look for a Fire Fountain Element
	TargetTile = Caster.PC.GetElementTile(e_Metal, 230.0f);

	if (TargetTile != none)
	{
		if (TargetTile.bSpellTileMode)
		{
			// Sets from where we search AP distanec from
			TargetLocation = TargetTile.Location;

			// Add First Tile
			SpellTiles.AddItem(TargetTile);
			CurrentTile = TargetTile;

			// Find Game Replication Spell Tiles and add here, if none return this function
			if (MCGR != none)
			{
				// Add Tiles in here
				for (i = 0; i < ArrayCount(MCGR.SpellTiles) ; i++)
				{
					if (MCGR.SpellTiles[i].Tile != none)
					{
						MySpellTiles.AddItem(MCGR.SpellTiles[i].Tile);
					}
				}
			}
			else
			{
				return;
			}


			// Find what Tiles we can bounce to
			for (i = 0; i < MySpellTiles.length ; i++)
			{
				// If not Originate Tile && if it has Metal 
				if (TargetTile.name != MySpellTiles[i].name && MySpellTiles[i].RandomElement == e_Metal)
				{
					iFound++;
					FoundMetalTiles.AddItem(MySpellTiles[i]);
					`log("Found Tile" @ iFound);
				}
			}

			iFound = 0;

			// Search Distance So that we can bounce
			for (i = 0; i < FoundMetalTiles.length ; i++)
			{
				iFound++;
			//	`log("FoundMetalTiles" @ iFound @ "and length" @ FoundMetalTiles.length);
				// If Tiles are within 5 Tiles away
				if( VSize(CurrentTile.Location - FoundMetalTiles[i].Location) < (128.0f * 5) ) //  && CurrentTile.name != FoundMetalTiles[i].name
				{
			//		`log(i @ " Add more");
					// Add Tile To the Main order
					SpellTiles.AddItem(FoundMetalTiles[i]);
					// Set New Current Tile
					CurrentTile = FoundMetalTiles[i];
				}else
				{
				//	`log(i @ " Fail=" @ VSize(CurrentTile.Location - FoundMetalTiles[i].Location) @ "<" @ (128.0f * 5));
				}
			}

			ActivateProjectile(Caster, Enemy, PathNode, Tile);
		}else
		{
			Destroy();
		}
	}
	else
	{
		Destroy();
	}
}

/*
// Sort Closest Tile to the furthest one away
*/
function int SortTiles(MCTile A, MCTile B)
{
	return ( VSize(MyDelegateCaster.Location - A.Location) > VSize(MyDelegateCaster.Location - B.Location) ) ? -1 : 0;
}

/*
// Starts Casting a ActivateProjectile or ActivateStatusSelf Spell on server
// @param	caster			Who Casts the Spell
// @param	enemy			Who the Caster is Aiming for
*/
function Cast(MCPawn caster, MCPawn enemy)
{
	local MCProjectile MyProjectile;	//	local UDKProjectile MyProjectile;
	local Vector ModifiedLocation;
	local int i;
	local bool bLastFail;

	`log("-------------------------------------------------------------------------");
	for (i = 0; i <SpellTiles.length; i++)
	{
		// If we are within 5 Tiles approx, we send a shot
		if (VSize(SpellTiles[i].Location - enemy.Location) < ( (128.0f + 0.0f) * 5))
		{
		//	`log(VSize(SpellTiles[i].Location - enemy.Location) @ "<" @ ( (128.0f + 0.0f) * 5) @ "we are withing");

			if (Role == Role_Authority && TargetTile != none)
			{
			//	`log("WhatSpellTile=" @ SpellTiles[i].name);
				ModifiedLocation = SpellTiles[i].Location;
				ModifiedLocation += ExtraSpawnSpace;

				MyProjectile = Spawn(ProjectileClass, caster, , ModifiedLocation);
				// Set Caster in MCProjectile so we can when Destroyed set movement back ON

				// Resistance Check
				if (CheckResistance(caster, enemy))
				{
					// Add the damage
					SendAWorldMessageResist(spellName, true);	// spellName[spellNumber]
					MyProjectile.Damage = damage;
				}else
				{
					SendAWorldMessageResist(spellName, false);	// spellName[spellNumber]
					MyProjectile.Damage = 0;
				}
			
				`log("DAMAGE OUTPUT for this" @ damage @ MyProjectile.Damage);
				// Fire the Spell
				MyProjectile.Init(enemy.Location - ModifiedLocation);

				if ( i == (SpellTiles.length - 1) )
				{
					bLastFail=true;
				}
			}
		}else
		{
		//	`log(VSize(SpellTiles[i].Location - enemy.Location) @ "<" @ ( (128.0f + 0.0f) * 5) @ "WE TOO FAR AWAY!!!");
			if ( i == (SpellTiles.length - 1) )
			{
				bLastFail=true;
			}
		}
	}

	`log("-------------------------------------------------------------------------");
	// Remove this Class from server

	if (bLastFail)
	{
		// Spell mode off
		Caster.PC.bIsSpellActive = false;
		// Check if we have AP to continue
		Caster.PC.CheckCurrentAPCalculation();
	}

	Destroy();
}

DefaultProperties
{
	ProjectileClass= class'MCProjectileSparkBolt'
}