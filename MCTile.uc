//----------------------------------------------------------------------------
// MCTile
//
// Each Tile lights up, and is able to set a spell on it.
//
// Rotation Image Base Values for SetRotation
// Rotate 90 to the left is = 6.280000
// Rotate 180 to the left is = 12.559999
// Rotate 270 to the left is = 18.840000
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCTile extends MouseInterfaceKActor
	hidecategories(Display, Attachment, Physics, Advanced, Debug, Mobile);

// For Setting static mesh on the KActor
var StaticMeshComponent MyKActorComponent;
// What material we want this to change into
var MaterialInstanceConstant MatInst;
// The PathNode in here
var MCPathNode PathNode;
// Setting colors for materials
var Texture2D Tex2DNoBorder;
var Texture2D Tex2DBorderWhite;

// ------------------------------ //
// Spells
// ------------------------------ //
// Is any spell active on this Tile
var bool bSpellTileMode;
// Spell - 05 - 
var bool bWormHole;
// Spell - 07 - FireFountain
var repnotify bool bFireFountain;
// Spell - 11 - Wall Of Ice
var bool bWallOfIce;
// Spell - 15 - GlassFloor
var repnotify bool bGlassFloor;
// Spell - 18 - MakeMud
var repnotify bool bMakeMud;
// Spell - 20 - StoneWall
var bool bStoneWall;
// Spell - 21 - UnearthMaterial
var repnotify bool bUnearthMaterial;
// Spell - 23 - Taint Water
var repnotify bool bTaintWater;
// Spell - 25 - DissolveElement
var bool bDissolveElement;
// Dissolve is scouring
var repnotify bool bDissolveElementScourge;
// Assign Damage to a Tile
var int damage;
// Other Testing
var bool bArrowActive;

// What Struct are we using
struct TileStruct
{
	var float r;
	var float g;
	var float b;
	var float a;
	var Texture2D Tex;
	var MaterialInstanceConstant MatInistConst;
};

// What Different Elements we can use
enum Elements
{
	e_Lava,
	e_Water,
//	e_Crystal,
	e_Metal,
	e_Acid
};

// Tile Information For color setting
var TileStruct AP1;
var TileStruct AP2;
var TileStruct AP3;
var TileStruct SpellTileMarkRed;
var TileStruct SpellTileMarkYellow;
var TileStruct SpellTileSurroundMain;
var TileStruct TileWormHole;
var TileStruct TileFireFountain;
var TileStruct TileGlassFloor;
var TileStruct TileMakeMud;
var TileStruct TileTaintWater;
var TileStruct TileDissolve;

// What Elements color settings
var TileStruct Water;
var TileStruct Metal;

var bool bCanPlaceCloud;

var bool bUnearthMaterialActive;
var int RandomElement;

// Certain Spells inside here
var archetype MCSpell FireFountainArchetype;
var archetype MCStatus AcidBurnArchetype;	// MCStatus_AcidBurn'MystrasChampionSpells.Status.Acid_TaintWater'


// @NOTUSING
// If DamageMode Is On This Tile, dont ever Light up this tile
var Texture2D DamageModeTile;
// Used for Lighting up Tiles by changing it's Alpha Level
var float addFloat;

// Replication block
replication
{
	// Variables the server should send ALL clients.
	if (bNetDirty && Role == ROLE_Authority)
		bSpellTileMode;

	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		PathNode, MatInst, damage, RandomElement, bCanPlaceCloud;

	// What Spells
	if (bNetDirty)
		bWormHole, bFireFountain, bWallOfIce, bGlassFloor, bMakeMud, bStoneWall, bUnearthMaterial, bTaintWater, bDissolveElement, bDissolveElementScourge;
	
	// What Structs
	if (bNetDirty)
		Water, Metal, TileTaintWater, TileFireFountain, TileGlassFloor, TileMakeMud, TileDissolve;

	if(bNetOwner)
		bArrowActive;
}

simulated event ReplicatedEvent(name VarName)
{	
	super.ReplicatedEvent( VarName ); 

	// Updates client side replications
	if (varname == 'bFireFountain')
	{
		if (bFireFountain)
		{
			ResetTileForAllClient(self);
			ShowDisplayColor();
		}
	}
	if (varname == 'bGlassFloor')
	{
		if (bGlassFloor)
		{
			ResetTileForAllClient(self);
			ShowDisplayColor();
		}
	}

	if (varname == 'bMakeMud')
	{
		if (bMakeMud)
		{
			ResetTileForAllClient(self);
			ShowDisplayColor();
		}
	}
	if (varname == 'bUnearthMaterial')
	{
		if (bUnearthMaterial)
		{
			ResetTileForAllClient(self);
			ShowDisplayColor();
		}
	}

	if (varname == 'bTaintWater')
	{
		if (bTaintWater)
		{
			ResetTileForAllClient(self);
			ShowDisplayColor();
		}
	}

	if (varname == 'bDissolveElementScourge')
	{
		if (bDissolveElementScourge)
		{
		//	ResetTileForAllClient(self);
			ShowDisplayColor();
		}
	}


}

simulated event PostBeginPlay()
{
	// Add Closest Pathnode to this Tile and Store it here
	foreach AllActors(Class'MCPathNode', PathNode)
	{
		if ( vsize(Location - PathNode.Location) < 70 )
		{
		//	`log("Adding =" @ PathNode);
			break;
		}
	}
	super.PostBeginPlay();
}

simulated function int SetRandomElement()
{
	local int TempRandom;

	TempRandom = Rand(4);
//	TempRandom = 1;			// for debug

	// Set Random Element Number here
	if (!bSpellTileMode)
	{
		RandomElement = TempRandom;
		return TempRandom;
	}
}

/*
// PC.CheckDistanceNearPlayer, send number to server here
// @param	Number		What number we recieve
*/
reliable server function SetRandomElementServer(int Number)
{
	if (!bSpellTileMode)
		RandomElement = Number;
}

/*
// What Color we show the Tiles as
*/
simulated function SetElements()
{
	switch (RandomElement)
	{
		case e_Lava:
		
			break;
		case e_Water:
			SetTile(Water);
			break;
		case e_Metal:
			SetTile(Metal);
			break;
		case e_Acid:
			SetTile(TileTaintWater);
			break;
		default:
		//
	}
}






simulated function SetArrows(string Direction)
{
	local LinearColor MatColor;
	
	if (!bSpellTileMode && !bArrowActive && !bDissolveElementScourge)
	{
		MatInst = new class'MaterialInstanceConstant';
		MatInst.SetParent(MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST');
		MyKActorComponent.SetMaterial(1, MatInst);

		MatColor = MakeLinearColor(0.0f, 0.0f, 1.0f, 0.5f);
		MatInst.SetVectorParameterValue('SetColor', MatColor);
		switch (Direction)
		{
			case "DirUp":
				MatInst.SetTextureParameterValue('SetNumber', Texture2D'mystraschampionsettings.Texture.arrowTest');
				MatInst.SetScalarParameterValue('SetRotation', 18.840000f);
				break;
			case "DirDown":
				MatInst.SetTextureParameterValue('SetNumber', Texture2D'mystraschampionsettings.Texture.arrowTest');
				MatInst.SetScalarParameterValue('SetRotation', 6.280000f);
				break;
			case "DirRight":
				MatInst.SetTextureParameterValue('SetNumber', Texture2D'mystraschampionsettings.Texture.arrowTest');
				MatInst.SetScalarParameterValue('SetRotation', 12.559999f);
				break;
			case "DirLeft":
				MatInst.SetTextureParameterValue('SetNumber', Texture2D'mystraschampionsettings.Texture.arrowTest');
				MatInst.SetScalarParameterValue('SetRotation', 0.0f);
				break;

			default:
			//	

	// Rotate 90 to the left is = 6.280000
	// Rotate 180 to the left is = 12.559999
	// Rotate 270 to the left is = 18.840000 UP

		}

		bArrowActive= true;
	}
}

simulated function SetArrowOFF()
{
	if (bArrowActive)
	{
		bArrowActive= false;
		SetActiveTiles();	
	}
}

/*
// Turns tile in to a specific color when AP is different
*/
simulated function SetActiveTiles()
{
	if (!bSpellTileMode)
	{
		switch (PathNode.APValue)
		{
			// Green Color
			case 1:
				SetTile(AP1);
				break;
			// Yellow Color
			case 2:
				SetTile(AP2);
				break;
			// Red Color
			case 3:
				SetTile(AP3);
				break;
			default:
			//	`log("nothing");
		}
	}
}


/*
// Lightup RED for what Tile we are hovering over for Placement Spells in PC.PlayerTick
*/
simulated function SpellMarkTileCurrentlySelected()
{
	if (bDissolveElementScourge)
	{
		SetTile(TileDissolve);
	}
	// Show Red Color	
	else if(!bSpellTileMode)
	{
		SetTile(SpellTileMarkRed);
	}
	// If Spell is Dissolved Element, We set in PC.SpellTileTurnOn()
	else if (bDissolveElement)
	{
		SetTile(SpellTileMarkYellow);
	}
}

/*
// Lightup Light Blue where we can Select Tiles for Placement Spells
*/
simulated function SpellMarkTileArea()
{	
	// We can not place spell lightup
	if (bDissolveElementScourge)
	{
		SetTile(TileDissolve);
	}
	// If nothing special just Light Up Light blue
	else if (!bSpellTileMode)
	{
		// Show Other Spells
		SetTile(SpellTileSurroundMain);

	}
	else if (bSpellTileMode && bWormHole)
	{
		
	}
	// If fire fountain
	else if (bSpellTileMode && bFireFountain)
	{
		SetTile(TileFireFountain);
	}
	// If glass floor
	else if (bSpellTileMode && bGlassFloor)
	{
		SetTile(TileGlassFloor);
	}
	// If Make Mud
	else if (bSpellTileMode && bMakeMud)
	{
		SetTile(TileMakeMud);
	}
	// If Unearth Material
	else if (bSpellTileMode && bUnearthMaterial)
	{
		SetElements();
	}
	// If Taint Water
	else if (bSpellTileMode && bTaintWater)
	{
		SetTile(TileTaintWater);
	}
	// If Dissolve Area is being lit up for certain spells
	else if (bSpellTileMode && bDissolveElement)
	{
		MyKActorComponent.SetMaterial(1,MyKActorComponent.default.Materials[1]);
		bDissolveElement = false;
	}
	// If nothing then we reset it to normal, Mostly used for  Dissolved Elements
	else
	{
		
	}

	// Just a double check that turns of Dissolve Elements
	if (bDissolveElement)
		bDissolveElement = false;
	
}

// @NOTUSING
simulated function SpellMarkDissolveArea()
{	
	if (bSpellTileMode)
	{
		// 1.0f, 0.0f, 0.0f, 0.5f, Tex2DBorderWhite
	//	SetTile()
	}
}

/*
// Used in PC & Spells to reset Tiles to it's original state
*/
simulated function ResetTileToNormal()
{	
	if (!bSpellTileMode || !bDissolveElementScourge)
	{	
		MyKActorComponent.SetMaterial(1,MyKActorComponent.default.Materials[1]);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// What Spells We Have
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
// Set WormHole Spell active for use
*/
simulated function ActivateWormHole(int SetDamage)
{
	if (bDissolveElementScourge)
		return;

	// Reset Previous Tile Lightup if we had one
	ResetTileToNormal();

	bSpellTileMode = true;
	bWormHole = true;

	if (bWormHole)
	{
		SetTile(TileWormHole);

		if (Role == Role_Authority)
		{
			// Set Damage
			damage = SetDamage;
		}
	}
}

/*
// Set FireFountain Spell active for use
*/
simulated function ActivateFireFountain(int SetDamage)
{
	if (bDissolveElementScourge)
		return;

	// Reset Previous Tile Lightup if we had one
	ResetTileToNormal();

	bSpellTileMode = true;
	bFireFountain = true;

	if (bFireFountain)
	{
		// Set Element here
		RandomElement = e_Lava;
		// Set Damage
		damage = SetDamage;
		// Do Damage if on the Tile
		if (Role == Role_Authority)
			NewRoundDamage();
	}
}

/*
// We Taint Water
*/
simulated function ActivateTaintWater(int SetDamage)
{
	if (bDissolveElementScourge)
		return;

	bSpellTileMode = true;
	bTaintWater = true;
	bUnearthMaterial = false;

	if (bTaintWater)
	{
		// Set Element here
		RandomElement = e_Acid;
		// Set Damage
		damage = SetDamage;
		// Do Damage if on the Tile
		if (Role == Role_Authority)
			NewRoundDamage();
	}
}

/*
// Send To all PC Clients so that we can remove it from the Spell Affected Tile Array
*/
simulated function ResetTileForAllClient(MCTile MyTile)
{	

	MyTile.MyKActorComponent.SetMaterial(1,MyKActorComponent.default.Materials[1]);
	/*
	local MCPawn WhatPeople;
	local int i;

	foreach DynamicActors(Class'MCPawn', WhatPeople)
	{
		for (i = 0; i < WhatPeople.PC.SpellTiles.length ; i++)
		{
			if (WhatPeople.PC.SpellTiles[i] == MyTile)
			{
				WhatPeople.PC.SpellTiles[i].MyKActorComponent.SetMaterial(1,MyKActorComponent.default.Materials[1]);
			}
		}
	}
	*/
}


/*
// Set Wall Of Ice Spell active for use
*/
simulated function ActivateWallOfIce()
{
	if (bDissolveElementScourge)
		return;

	// Reset Previous Tile Lightup if we had one
	ResetTileToNormal();

	bSpellTileMode = true;
	bWallOfIce = true;

	if (bWallOfIce){}
		// nothing atm
}

/*
// Set Glass Floor Spell active for use
*/
simulated function ActivateGlassFloor()
{
	if (bDissolveElementScourge)
		return;

	// Reset Previous Tile Lightup if we had one
	ResetTileToNormal();

	if (bWormHole || bFireFountain || bWallOfIce || bGlassFloor || bStoneWall || bTaintWater || RandomElement == e_Metal)
		return;

	bSpellTileMode = true;
	bGlassFloor = true;

	if (bGlassFloor)
	{
		SetTile(TileGlassFloor);

		// Change AP Cost
		PathNode.APValue = 2;
	}
}

/*
// Set Make Mud Spell active for use
*/
simulated function ActivateMakeMud()
{
	if (bDissolveElementScourge)
		return;

	// Reset Previous Tile Lightup if we had one
	ResetTileToNormal();

	if (bWormHole || bFireFountain || bWallOfIce || bGlassFloor || bStoneWall || bTaintWater || RandomElement == e_Metal)
		return;

	// Reset Previous Tile Lightup if we had one
	ResetTileToNormal();

	bSpellTileMode = true;
	bMakeMud = true;

	bUnearthMaterial = false;
	RandomElement = 0;

	if (bMakeMud)
	{
		SetTile(TileMakeMud);

		// Change AP Cost
		PathNode.APValue = 3;
	}
}

/*
// Set StoneWall Spell active for use
*/
simulated function ActivateStoneWall()
{
	if (bDissolveElementScourge)
		return;

	// Reset Previous Tile Lightup if we had one
	ResetTileToNormal();

	bSpellTileMode = true;
	bStoneWall = true;

	if (bStoneWall){}
		// nothing atm
}

/*
// Set Dissolve Element Spell active for use
*/
simulated function ActivateDissolveElement(bool bShouldWeScourge, bool bShouldWeRemoveTile)
{
	local MCActor FindActor;

	// If Something is here then continue to run this function
	if (bSpellTileMode)
	{
	//	`log("We Start Dissolving it");
		TurnOfSpellBools();
		PathNode.bBlocked = false;
		bDissolveElement = true;

		if (bDissolveElement)
		{
			// Destroy previous Elements
			foreach AllActors(Class'MCActor', FindActor)
			{
				if ( vsize(Location - FindActor.Location) < 96 )
				{
					FindActor.Destroy();
					break;
				}
			}
			PathNode.APValue = 1;
			bSpellTileMode = false;
			bDissolveElement = false;
		}

		if (bShouldWeScourge)
		{
			bDissolveElementScourge = true;
			SetTile(TileDissolve);
			// We Can never use Tile again
		}

		// If server we remove the certain tile in PC
		if (bShouldWeRemoveTile)
		{
			if (Role == ROLE_Authority && !bDissolveElementScourge)
			{
				DissolveAllPc();
			}
			

//			`log("REMOVE!!!!!");
		}else
		{
//			`log("we good :D!!!!!");
		}
		
	}else
	{
//		`log("Nothing to dissolve");
	}
}

/*
// Send To all PC Clients so that we can remove it from the Spell Affected Tile Array
*/
reliable server function DissolveAllPc()
{
	local MCPawn WhatPeople;

	foreach DynamicActors(Class'MCPawn', WhatPeople)
		WhatPeople.PC.RemoveTileSpellAreaClient(self);
}


/*
// Set Unearth Material things
*/
simulated function ActivateUnearthMaterial()
{
	if (bDissolveElementScourge)
		return;
	
	// Reset Previous Tile Lightup if we had one
	ResetTileToNormal();

	bSpellTileMode = true;

	switch (RandomElement)
	{
		case e_Lava:
			ActivateFireFountain(FireFountainArchetype.damage);
			break;

		case e_Water:
			bUnearthMaterial = true;
			if (bUnearthMaterial)
				SetElements();
			break;

		case e_Metal:
			bUnearthMaterial = true;
			if (bUnearthMaterial)
				SetElements();
			break;

		case e_Acid:
			ActivateTaintWater(FireFountainArchetype.damage);	// Has same damage as FireFountain, luckely
			if (bUnearthMaterial)
				SetElements();
			break;

		default:
		//
	}
}


/*
// Turn of All Spells
*/
simulated function TurnOfSpellBools()
{
	bWormHole = false;
	bFireFountain = false;
	bWallOfIce = false;
	bGlassFloor = false;
	bMakeMud = false;
	bStoneWall = false;
	bUnearthMaterial = false;
	bTaintWater = false;
	// reset damage
	damage = 0;
	RandomElement = 0;
}

/*
// In PC.PlayerTick we show what Tiles we have active Spell
*/
simulated function ShowDisplayColor()
{
	if (bSpellTileMode)
	{
		if (bWormHole)
		{
			
		}
		// FireFountain Spell
		else if (bFireFountain)
		{
		//	SetTile(TileFireFountain);
		}
		// Wall Of Ice Spell
		else if(bWallOfIce)
		{
			
		}
		// Glass Floor Spell
		else if(bGlassFloor)
		{
			SetTile(TileGlassFloor);
		}
		// Make Mud Spell
		else if(bMakeMud)
		{
			SetTile(TileMakeMud);
		}
		// StoneWall Spell
		else if(bStoneWall)
		{
			
		}
		// Unearth Material Spell
		else if (bUnearthMaterial)
		{
			SetElements();
		}
		// Taint Water Spell
		else if (bTaintWater)
		{
		//	SetTile(Acid);
		}
	}else if (!bSpellTileMode && bDissolveElementScourge)
	{
		SetTile(TileDissolve);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Touch Events inside MCTile
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
// When we Touch this Tile we do damage if Spells are active
*/
simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	// If We got a spell on, then go in a do damage
	if (bSpellTileMode)
	{
		if (Role == ROLE_Authority)
		{
			// Do Damage
			TileTouchDamage(Other);
			// Add Status if we have
			TileTouchStatus(Other);
		}
	}
	super.Touch(Other,OtherComp,HitLocation,HitNormal);
}

/*
// Do Damage when Touching a Tile
// @param 		Other 	What Character is touching
*/
simulated function TileTouchDamage(Actor Other)
{
	local MCPawn MCPlayer;
	local vector empty;
	MCPlayer = MCPawn(Other);

	if (MCPlayer != none)
	{
		if (bWormHole)
		{
			MCPlayer.TakeDamage(damage, none, MCPlayer.Location, empty, class'DamageType');
		}
		else if (bFireFountain)
		{
			MCPlayer.TakeDamage(damage, none, MCPlayer.Location, empty, class'DamageType');
		}
		else if(bTaintWater)
		{
			MCPlayer.TakeDamage(damage, none, MCPlayer.Location, empty, class'DamageType');
		}
	}
}

/*
// Add Status when Touching a Tile
// @param 		Other 	What Character is touching
*/
simulated function TileTouchStatus(Actor Other)
{
	local MCPawn Target;
	local MCPlayerReplication MCPRep;
	Local MCStatus MyStatusClass;
	local vector SpawnLocation;

	Target = MCPawn(Other);

	if (Target != none)
	{
		MCPRep = MCPlayerReplication(Target.PC.PlayerReplicationInfo);
		if (MCPRep != none)
		{
			if (bWormHole)
			{
				SpawnLocation = Target.Location;
				SpawnLocation.Z = -1024;

				if (Role == Role_Authority)
				{
					MyStatusClass = Spawn(class'MCStatus_WormsMouth',,, SpawnLocation,,);
					MyStatusClass.SetLocation(Target.Location);
					ActivateDissolveElement(false, true);
				}
			}
			else if (bTaintWater)
			{
				SpawnLocation = Target.Location;
				SpawnLocation.Z = -1024;

				if (Role == Role_Authority)
				{
					MyStatusClass = Spawn(AcidBurnArchetype.class,,, SpawnLocation,,);
					// Add Status
					MyStatusClass.StatusArchetype	= AcidBurnArchetype;
					MyStatusClass.SetLocation(Target.Location);
				}
			}
		}
	}
}

/*
// When a new Round is on, check if we do damage if FireFountain is active
*/
simulated function NewRoundDamage(optional int ID)
{
	local MCPawn MCPlayers;
	local vector empty;

	if (bSpellTileMode && bFireFountain)
	{
		if (Role == ROLE_Authority)
		{
			// Send to Clients
			foreach DynamicActors(Class'MCPawn', MCPlayers)
			{
				if (VSize(MCPlayers.Location - Location) < 64 && ID == MCPlayers.PlayerUniqueID)
				{
					MCPlayers.TakeDamage(damage, none, MCPlayers.Location, empty, class'DamageType');
				}
			}
		}
	}
	if (bSpellTileMode && bTaintWater)
	{
		if (Role == ROLE_Authority)
		{
			// Send to Clients
			foreach DynamicActors(Class'MCPawn', MCPlayers)
			{
				if (VSize(MCPlayers.Location - Location) < 64 && ID == MCPlayers.PlayerUniqueID)
				{
					MCPlayers.TakeDamage(damage, none, MCPlayers.Location, empty, class'DamageType');
					// Add status
					TileTouchStatus(MCPlayers);
				}
			}
		}
	}
}



function MouseLeftPressed(Vector MouseWorldOrigin, Vector MouseWorldDirection, Vector HitLocation, Vector HitNormal)
{
	super.MouseLeftPressed(MouseWorldOrigin, MouseWorldDirection, HitLocation, HitNormal);
//	`log("Pressed");
}

function MouseOver(Vector MouseWorldOrigin, Vector MouseWorldDirection)
{
	super.MouseOver(MouseWorldOrigin, MouseWorldDirection);
//	`log("MouseOver!" @ RandomElement);
}

function MouseOut(Vector MouseWorldOrigin, Vector MouseWorldDirection)
{
	super.MouseOut(MouseWorldOrigin, MouseWorldDirection);
//	`log("Out!");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Other functions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
// Setting Tile color and texture to a certain Tile
// @param 	MyTileInfo		What struct we are using for information
*/
simulated function SetTile(TileStruct MyTileInfo)
{
	local LinearColor MatColor;

	MatInst = new class'MaterialInstanceConstant';
	MatInst.SetParent(MyTileInfo.MatInistConst);
//	MatInst.SetParent(MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST');
	MyKActorComponent.SetMaterial(1, MatInst);

	MatColor = MakeLinearColor(MyTileInfo.r, MyTileInfo.g, MyTileInfo.b, MyTileInfo.a);
	MatInst.SetVectorParameterValue('SetColor', MatColor);
	MatInst.SetTextureParameterValue('SetNumber', MyTileInfo.Tex);
}

/*
// @NOTUSING
simulated event UnTouch (Actor Other)
{
//	ClearTimer('SetBlockedONTimer');
	//PathNode.bBlocked = false;
	super.UnTouch(Other);
}

// @NOTUSING
simulated function SetBlockedONTimer()
{
	PathNode.bBlocked = true;
	`log("WE ARE BLOCKED!!!!");
}
*/

/*
// Function that changes the alpha to go from 0 to 1 in 1 second.
// @NOTUSING
*/
/*
simulated function ChangeAlphaUp()
{
	local LinearColor MatColor;

//	`log("Alpha Being changed");
		if (addFloat <= 1.0f)
		{
			addFloat += 0.5f;
			// Sets a color to the InstantConstant
			MatColor = MakeLinearColor(0.0f, 1.0f, 0.0f, addFloat);
			MatInst.SetVectorParameterValue('SetColor', MatColor);
		}
		if (addFloat == 1.0f)
		{
			ClearTimer('ChangeAlphaUp');
		}
}
*/

defaultproperties
{
	// Normal Lightup
	AP1=( r=0.0f, g=0.0f, b=0.0f, a=0.0f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner', MatInistConst=MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST' )
	AP2=( r=1.0f, g=1.0f, b=0.0f, a=0.5f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner', MatInistConst=MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST' )
	AP3=( r=1.0f, g=0.0f, b=0.0f, a=0.5f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner', MatInistConst=MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST' )

	// Spell Area Marker
	SpellTileMarkRed=	( r=1.0f, g=0.0f, b=0.0f, a=0.5f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner', MatInistConst=MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST' )
	SpellTileMarkYellow=( r=1.0f, g=1.0f, b=0.0f, a=0.5f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner', MatInistConst=MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST' )

	// Spell Area Other Tiles
	SpellTileSurroundMain=( r=0.0f, g=0.3f, b=1.0f, a=0.5f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner', MatInistConst=MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST' )

	// Spell Colors
	TileWormHole=		( r=0.6f, g=0.4f, b=0.0f, a=0.0f, Tex=Texture2D'mystraschampionsettings.Texture.BlackCornerNoBG', MatInistConst=MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST' )
	TileFireFountain=	( r=1.0f, g=0.0f, b=0.0f, a=0.0f, Tex=Texture2D'mystraschampionsettings.Texture.BlackCornerNoBG', MatInistConst=MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST' )
	TileGlassFloor=		( r=0.0f, g=0.0f, b=1.0f, a=0.0f, Tex=Texture2D'mystraschampionsettings.Texture.BlackCornerNoBG', MatInistConst=MaterialInstanceConstant'MystrasChampionSpells.Materials.window_Glassbroken_Mat_INST' )
	TileMakeMud=		( r=0.0f, g=0.0f, b=0.0f, a=1.0f, Tex=Texture2D'UN_Terrain.Dirt.T_UN_Terrain_Dirt_Muddy_01_D', MatInistConst=MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST' )
	TileTaintWater=	( r=0.6f, g=0.0f, b=0.8f, a=0.0f, Tex=Texture2D'mystraschampionsettings.Texture.BlackCornerNoBG', MatInistConst=MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST' )
	TileDissolve=	( r=0.0f, g=0.0f, b=0.0f, a=1.0f, Tex=Texture2D'VH_All.Materials.T_VH_All_Necris_Burn_D', MatInistConst=MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST' )

	// Unearth Material Settings
//	Lava=	( r=1.0f, g=0.0f, b=0.0f, a=0.0f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner', MatInistConst=MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST' )
	Water=	( r=0.0f, g=0.0f, b=1.0f, a=0.0f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner', MatInistConst=MaterialInstanceConstant'MystrasChampionSpells.Materials.RipplingWater_INST' )
	Metal=	( r=0.8f, g=0.8f, b=0.8f, a=0.0f, Tex=Texture2D'mystraschampionsettings.Texture.BlackCornerNoBG', MatInistConst=MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST' )

	// Spells & Status
	FireFountainArchetype=MCSpell_FireFountain'MystrasChampionSpells.Spells.FireFountain'
	AcidBurnArchetype=MCStatus_AcidBurn'MystrasChampionSpells.Status.Acid_TaintWater'










	Begin Object Class=StaticMeshComponent Name=tile01
		StaticMesh=StaticMesh'mystraschampionsettings.StaticMesh.TileMesh'
		Materials(0)=Material'mystraschampionsettings.Materials.Invisible'
		Materials(1)=MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST'

		BlockActors=false
		CollideActors=true
		BlockRigidBody=false
		HiddenGame=false
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		//bCastDynamicShadow=true
		//bUsePrecomputedShadows=true
		bNotifyRigidBodyCollision=true
		//ScriptRigidBodyCollisionThreshold=0.001 
		//LightingChannels=(Dynamic=TRUE)
		bAcceptsStaticDecals=false
		bAcceptsDecals=false
	End Object 

	MyKActorComponent = tile01

	Components.Add(tile01)
	CollisionComponent = tile01

	bNoEncroachCheck=false
	//BlockRigidBody=true
	bCollideActors=true
	//bBlockActors=true
	CollisionType=COLLIDE_TouchAll
	Physics=Phys_None

	//bUsedWithStaticLightning=true;
	//bCollideWorld=False //false is for nonmoving objects
	//bWakeOnLevelStart=false

	Tex2DNoBorder = Texture2D'mystraschampionsettings.Texture.BlackCornerNoBG'
	Tex2DBorderWhite = Texture2D'mystraschampionsettings.Texture.WhiteCorner'

//	AcceptStaticDecals = false
//	AcceptsDynamicDecals = false
}