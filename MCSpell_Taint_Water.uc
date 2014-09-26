//----------------------------------------------------------------------------
// MCSpell_Taint_Water
//
// Taint Water Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Taint_Water extends MCSpell;

/*
// The Activator for all spells
// @param	Caster			Who Casts the Spell
// @param	Enemy			Who the Caster is Aiming for
// @param	Opt_PathNode	What PathNode we would like to change
// @param	Opt_Tile		What Tile we would like to change
*/
simulated function Activate(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	// This does AP Check first so we can check if we can do the spell 
	super.Activate(Caster, Enemy, PathNode, Tile);

	// Look for a Water Element
	TargetTile = Caster.PC.GetElementTile(e_Water, 230.0f);	//e_Water

	if (TargetTile != none)
	{
		if (TargetTile.bSpellTileMode)
		{
			// Sets from where we search AP distanec from
			TargetLocation = TargetTile.Location;

			ActivateArea(Caster, Enemy, PathNode, Tile);
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

simulated function ActivateArea(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	local int i, j, ii;
	local MCPlayerController PC;
	local array<MCTile> MySpellTiles;
	local array<MCTile> MySpellTilesCopy;
	local array<MCTile> MyCrossRoads;
	local MCTile next;
	local MCGameReplication MCGR;
	local float MyRange;
	local bool bFirstOnlyDone;
	MCGR = MCGameReplication(WorldInfo.GRI);

	if (Caster == none || Enemy == none || !bCanActivate)
	{
	//	`log(self @ " - Failed so Destroy() && return;");
		Destroy();
		return;
	}

	// Cast nesscesary Classes
	PC = Caster.PC;

	// Turn Off All active tiles
	for (i = 0;i < PC.TilesWeCanMoveOn.length ; i++)
		PC.TilesWeCanMoveOn[i].ResetTileToNormal();

	// Spell mode active
	PC.bIsSpellActive = true;
	// Turn of Tiles
	Caster.PC.TurnOffTiles();

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

	// Remove non water Tiles
	for (i = 0; i < MySpellTiles.length ; i++)
	{
		if (MySpellTiles[i].RandomElement == e_Lava ||
			MySpellTiles[i].RandomElement == e_Metal ||
			MySpellTiles[i].RandomElement == e_Acid ||
			MySpellTiles[i].bFireFountain ||
			MySpellTiles[i].bTaintWater
			)
		{
		//	`log("- REMOVE =" @ MySpellTiles[i].RandomElement @ MySpellTiles[i]);
			MySpellTiles.Remove(i,1);
			i = 0;
		}else
		{
		//	`log("- Save" @ MySpellTiles[i].RandomElement @ MySpellTiles[i]);
		}
	}

	// Sort Tiles according to Distance from Caster @FIX Sort according to current target instead
	MySpellTiles.Sort(SortTiles);
	// Set Copied version
	MySpellTilesCopy = MySpellTiles;


	for (i = 0; i < MySpellTilesCopy.Length ; i++)
	{
//		`log("* -" @ MySpellTilesCopy[i]);
	}

	MyRange = 230.0f;

	for (i = 0; i < MySpellTiles.length ; i++)
	{
		if (MyCrossRoads.length > 0)
		{
			// Remove all MySpellTiles after this MySpellTiles.Remove( (i+1), (MySpellTiles.length-i) )
			MySpellTiles.Remove( (i+1), ( (MySpellTiles.Length-1)-i ) );
		//	`log("Remove Crossroads");

			// Crossroads start
			for (ii = 0; ii < MyCrossRoads.length ; ii++)
			{
		//		`log("Do Crossroads" @ ii @ "of" @ MyCrossRoads.length);
				for (j = 0; j < MySpellTilesCopy.length ; j++)
				{
					if (VSize(MyCrossRoads[ii].Location - MySpellTilesCopy[j].Location) < MyRange)
					{
						// explode
						MyCrossRoads.AddItem(MySpellTilesCopy[j]);
						MySpellTilesCopy = ForLoopStartSpell(MySpellTilesCopy, j, Caster);
						j=0;
					}
				}
				// Remove current crossroads
				MyCrossRoads.Remove(ii,1);
				ii=0;
			}
		}
		// If no crossroads, do this
		else
		{	
			// if we don't have a next target to search for, do first main loop
			if (next == none && !bFirstOnlyDone)
			{
			//	`log("First wawe");
				for (j = 0; j < MySpellTilesCopy.length ; j++)
				{
					if (VSize(MySpellTiles[i].Location - MySpellTilesCopy[j].Location) < MyRange)
					{
						// If same name, don't add to crossroads, mainly for first Tile we itterate threw
						if (MySpellTiles[i].name == MySpellTilesCopy[j].name)
						{
							// explode
							MyCrossRoads.AddItem(MySpellTilesCopy[j]);
							MySpellTilesCopy = ForLoopStartSpell(MySpellTilesCopy, j, Caster);
							j=0;
						}
					}
				}

				// loop over, if we have more than 1 in crossroads, got here, otherwise, remove list
				if (MyCrossRoads.Length > 1)
				{
					// go crossroads
				}else
				{
					// Set this one to be the next one we search for
					next = MyCrossRoads[0];
					// Remove List
					MyCrossRoads.Remove(0,MyCrossRoads.length);
					bFirstOnlyDone=true;
				}
			}
			// We have no next
			else
			{
			//	`log("NEXT=" @ next @ "-" @ i);
				for (j = 0; j < MySpellTilesCopy.length ; j++)
				{
					if (VSize(next.Location - MySpellTilesCopy[j].Location) < MyRange)
					{
						// 02
						// add crossroads
						// and when list is over, this won't run because we have crossroads
						MyCrossRoads.AddItem(MySpellTilesCopy[j]);
						MySpellTilesCopy = ForLoopStartSpell(MySpellTilesCopy, j, Caster);
						j=0;
					}
				}
				// loop over, if we have more than 1 in crossroads, got here, otherwise, remove list
				if (MyCrossRoads.Length > 1)
				{
					// go crossroads
			//		`log("Go crossroads" @ MyCrossRoads.Length);
				}else
				{
					// Set this one to be the next one we search for
					next = MyCrossRoads[0];
					// Remove List
					MyCrossRoads.Remove(0,MyCrossRoads.length);
				}
			}
		}
	}

	// Reset
	Caster.PC.CheckAPTimer(1.0f);
}


/*
// Sort Closest Tile to the furthest one away
*/
function int SortTiles(MCTile A, MCTile B)
{
	return ( VSize(TargetTile.Location - A.Location) > VSize(TargetTile.Location - B.Location) ) ? -1 : 0;
}

function array<MCTile> ForLoopStartSpell(array<MCTile> AffectTile, int index, MCPawn Caster)
{
	// Reset Tile
	AffectTile[index].ActivateDissolveElement(false, false);
	// Remove Water image
	AffectTile[index].ResetTileForAllClient(AffectTile[index]);

	// Shoot Spell, Make sure it's only on the server
	if ( (WorldInfo.NetMode == NM_DedicatedServer) || (WorldInfo.NetMode == NM_ListenServer) )
	{
		// Add Tiles to Spell
		CastArea(Caster, AffectTile[index].Location, AffectTile[index]);
	}else
	{
		// Activate Client's settings
		AffectTile[index].ActivateTaintWater(damage);
	}

	// Remove Spawned copy
	AffectTile.Remove(index,1);
//	index=0;
	return AffectTile;
}

/*
// Starts Casting a ActivateArea spell that will Spawn an Actor, not Tile changing
// @param	caster			Who Casts the Spell
// @param	target			Where we do it
// @param	Opt_WhatTile	If we need a Tile to perform something specific
*/
function CastArea(MCPawn caster, Vector target, optional MCTile WhatTile)
{
//	ExtraSpawnSpace.Z = -12;
	ActorClass = class'MCActor_Acid';

//	WhatTile.ActivateDissolveElement(false, false);
	// Activate
	WhatTile.ActivateTaintWater(damage);

	super.CastArea(caster, target, WhatTile);
}

DefaultProperties
{

}