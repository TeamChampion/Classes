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
// Spell - 07 - FireFountain
var bool bFireFountain;
// Spell - 11 - Wall Of Ice
var bool bWallOfIce;
// Spell - 15 - GlassFloor
var bool bGlassFloor;
// Spell - 20 - StoneWall
var bool bStoneWall;
// Spell - 21 - UnearthMaterial
var bool bUnearthMaterial;
// Spell - 25 - DissolveElement
var bool bDissolveElement;
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
};

// What Different Elements we can use
enum Elements
{
	e_Lava,
	e_Water,
	e_Crystal,
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
var TileStruct TileFireFountain;
var TileStruct TileGlassFloor;

// What Elements color settings
var TileStruct Lava;
var TileStruct Water;
var TileStruct Crystal;
var TileStruct Metal;
var TileStruct Acid;

var bool bUnearthMaterialActive;
var int RandomElement;



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
		PathNode, MatInst, damage, RandomElement;

	// What Spells
	if (bNetDirty)
		bFireFountain, bWallOfIce, bGlassFloor, bStoneWall, bUnearthMaterial, bDissolveElement;

	if(bNetOwner)
		bArrowActive;
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

	TempRandom = Rand(5);
	// Set Random Element Number here
	if (!bSpellTileMode)
	{
		RandomElement = TempRandom;
		return TempRandom;
	}

}



reliable server function SetRandomElementServer(int Number)
{
	if (!bSpellTileMode)
		RandomElement = Number;
}

simulated function SetElements()
{
	switch (RandomElement)
	{
		case e_Lava:
			SetTile(Lava);
			break;
		case e_Water:
			SetTile(Water);
			break;
		case e_Crystal:
			SetTile(Crystal);
			break;
		case e_Metal:
			SetTile(Metal);
			break;
		case e_Acid:
			SetTile(Acid);
			break;
		default:
		//
	}
}



simulated function ActivateUnearthMaterial()
{
	// Reset Previous Tile Lightup if we had one
	ResetTileToNormal();

	bSpellTileMode = true;
	bUnearthMaterial = true;

	if (bUnearthMaterial)
	{
		SetElements();
	}
}


simulated function SetArrows(string Direction)
{
	local LinearColor MatColor;
	
	if (!bSpellTileMode && !bArrowActive)
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
	// Show Red Color	
	if (!bSpellTileMode)
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
	// If nothing special just Light Up Light blue
	if (!bSpellTileMode)
	{
		if (bUnearthMaterialActive)
		{
			// Do Unearth function that ahs all elements
			SetElements();
		}
		else
		{
			// Show Other Spells
			SetTile(SpellTileSurroundMain);
		}
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
	else if (bUnearthMaterial)
	{
		SetElements();
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
	if (!bSpellTileMode)
	{	
		MyKActorComponent.SetMaterial(1,MyKActorComponent.default.Materials[1]);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// What Spells We Have
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
// Set FireFountain Spell active for use
*/
simulated function ActivateFireFountain(int SetDamage)
{
	// Reset Previous Tile Lightup if we had one
	ResetTileToNormal();

	bSpellTileMode = true;
	bFireFountain = true;

	if (bFireFountain)
	{
		SetTile(TileFireFountain);

		damage = SetDamage;
		if (Role == Role_Authority)
		{
			NewRoundDamage();
		}
	}
}

/*
// Set Wall Of Ice Spell active for use
*/
simulated function ActivateWallOfIce()
{
	// Reset Previous Tile Lightup if we had one
	ResetTileToNormal();

	bSpellTileMode = true;
	bWallOfIce = true;

	if (bWallOfIce){}
		// nothing atm
}

/*
// Set Glass Florr Spell active for use
*/
simulated function ActivateGlassFloor()
{
	// Reset Previous Tile Lightup if we had one
	ResetTileToNormal();

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
// Set StoneWall Spell active for use
*/
simulated function ActivateStoneWall()
{
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
simulated function ActivateDissolveElement()
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

		// If server we remove the certain tile in PC
		if (Role == ROLE_Authority)
			DissolveAllPc();
	}else
	{
		`log("Nothing to dissolve");
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
// Turn of All Spells
*/
simulated function TurnOfSpellBools()
{
	bFireFountain = false;
	bWallOfIce = false;
	bGlassFloor = false;
	bStoneWall = false;
	bUnearthMaterial = false;
	// reset damage
	damage = 0;
}

/*
// In PC.PlayerTick we show what Tiles we have active Spell
*/
simulated function ShowDisplayColor()
{
	if (bSpellTileMode)
	{
		// FireFountain Spell
		if (bFireFountain)
		{
			SetTile(TileFireFountain);
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
		// StoneWall Spell
		else if(bStoneWall)
		{
			
		}
		// Unearth Material Spell
		else if (bUnearthMaterial)
		{
			SetElements();
		}
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
		}
	}
	super.Touch(Other,OtherComp,HitLocation,HitNormal);
}

simulated function TileTouchDamage(Actor Other)
{
	local MCPawn MCPlayer;
	local vector empty;
	MCPlayer = MCPawn(Other);

	if (bFireFountain)
	{
		MCPlayer.TakeDamage(damage, none, MCPlayer.Location, empty, class'DamageType');
	}
}

/*
// When a new Round is on, check if we do damage if FireFountain is active
*/
simulated function NewRoundDamage()
{
	local MCPawn MCPlayers;
	local vector empty;

	`log("MCTile = NewRoundDamage() - We Are actually in here to see how many times we can find someone else cooming in here which isn't easy I would say but it has to be done");

	if (bSpellTileMode && bFireFountain)
	{
		if (Role == ROLE_Authority)
		{
			// Send to Clients
			foreach DynamicActors(Class'MCPawn', MCPlayers)
			{
				`log("-----------------------------");
				`log("-----------------------------");
				`log(MCPlayers);
				`log("-----------------------------");
				`log("-----------------------------");
				if (VSize(MCPlayers.Location - Location) < 64)
				{
					MCPlayers.TakeDamage(damage, none, MCPlayers.Location, empty, class'DamageType');
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
	MatInst.SetParent(MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST');
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
	AP1=( r=0.0f, g=0.0f, b=0.0f, a=0.0f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner' )
	AP2=( r=1.0f, g=1.0f, b=0.0f, a=0.5f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner' )
	AP3=( r=1.0f, g=0.0f, b=0.0f, a=0.5f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner' )

	// Spell Area Marker
	SpellTileMarkRed=	( r=1.0f, g=0.0f, b=0.0f, a=0.5f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner' )
	SpellTileMarkYellow=( r=1.0f, g=1.0f, b=0.0f, a=0.5f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner' )

	// Spell Area Other Tiles
	SpellTileSurroundMain=( r=0.0f, g=0.3f, b=1.0f, a=0.5f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner' )

	// Spell Colors
	TileFireFountain=( r=1.0f, g=0.0f, b=0.0f, a=1.0f, Tex=Texture2D'mystraschampionsettings.Texture.BlackCornerNoBG' )
	TileGlassFloor=  ( r=0.0f, g=0.0f, b=1.0f, a=1.0f, Tex=Texture2D'mystraschampionsettings.Texture.BlackCornerNoBG' )

	// Unearth Material Settings
	Lava=	( r=1.0f, g=0.0f, b=0.0f, a=0.5f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner' )
	Water=	( r=0.0f, g=0.0f, b=1.0f, a=0.5f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner' )
	Crystal=( r=1.0f, g=0.6f, b=0.0f, a=0.5f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner' )
	Metal=	( r=0.8f, g=0.8f, b=0.8f, a=0.5f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner' )
	Acid=	( r=0.6f, g=0.0f, b=0.8f, a=0.5f, Tex=Texture2D'mystraschampionsettings.Texture.WhiteCorner' )


/*
AP 1
AP 2
AP 3
SpellTileMark Red 						1.0f, 0.0f, 0.0f, 0.5f, Tex2DBorderWhite
SpellTileMark Yellow 					1.0f, 1.0f, 0.0f, 0.5f, Tex2DBorderWhite
SpellTileSurround LightBlue 			0.0f, 0.3f, 1.0f, 0.5f, Tex2DBorderWhite
SpellTileSurround Red FireFountain 		1.0f, 0.0f, 0.0f, 1.0f, Tex2DNoBorder
SpellTileSurround Blue GlassFloor 		0.0f, 0.0f, 1.0f, 1.0f, Tex2DNoBorder

ActivateSpell Red FireFountain 			1.0f, 0.0f, 0.0f, 1.0f, Tex2DNoBorder
ActivateSpell Blue GlassFloor 			0.0f, 0.0f, 1.0f, 1.0f, Tex2DNoBorder

ShowDisplayColor Red bFireFountain 		1.0f, 0.0f, 0.0f, 1.0f, Tex2DNoBorder
ShowDisplayColor Blue GlassFloor 		0.0f, 0.0f, 1.0f, 1.0f, Tex2DNoBorder
*/

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
}