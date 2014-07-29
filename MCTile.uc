//----------------------------------------------------------------------------
// MCTile
//
// Each Tile lights up, and is able to set a spell on it.
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
// Spell - 25 - DissolveElement
var bool bDissolveElement;


// Assign Damage to a Tile
var int damage;

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
		PathNode, MatInst, damage;

	// What Spells
	if (bNetDirty)
		bFireFountain, bWallOfIce, bGlassFloor, bStoneWall, bDissolveElement;
}


simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	// Add Closest Pathnode to this Tile and Store it here
	foreach AllActors(Class'MCPathNode', PathNode)
	{
		if ( vsize(Location - PathNode.Location) < 70 )
		{
			break;
		}
	}
}

/*
// Turns tile in to a specific color when AP is different
*/
simulated function SetActiveTiles()
{
	local LinearColor MatColor;
	
	if (!bSpellTileMode)
	{
		MatInst = new class'MaterialInstanceConstant';
		MatInst.SetParent(MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST');
		MyKActorComponent.SetMaterial(1, MatInst);

		//Texture2D'mystraschampionsettings.Texture.BlackCornerNoBG'
		switch (PathNode.APValue)
		{
			// Green Color
			case 1:
				MatColor = MakeLinearColor(0.0f, 0.8125f, 0.007688f, 0.5f);
				MatInst.SetVectorParameterValue('SetColor', MatColor);
				MatInst.SetTextureParameterValue('SetNumber', Tex2DBorderWhite);
				break;
			// Yellow Color
			case 2:
				MatColor = MakeLinearColor(1.0f, 1.0f, 0.0f, 0.5f);
				MatInst.SetVectorParameterValue('SetColor', MatColor);
				MatInst.SetTextureParameterValue('SetNumber', Tex2DBorderWhite);
				break;
			// Red Color
			case 3:
				MatColor = MakeLinearColor(1.0f, 0.0f, 0.0f, 0.5f);
				MatInst.SetVectorParameterValue('SetColor', MatColor);
				MatInst.SetTextureParameterValue('SetNumber', Tex2DBorderWhite);
				break;
			default:
			//	`log("nothing");
		}
	}	
}

/*
// Lightup RED for what Tile we are hovering over for Placement Spells
*/
simulated function SpellMarkTileMain()
{
	local LinearColor MatColor;
	
	if (!bSpellTileMode)
	{
		MatInst = new class'MaterialInstanceConstant';
		MatInst.SetParent(MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST');
		MyKActorComponent.SetMaterial(1, MatInst);

		MatColor = MakeLinearColor(1.0f, 0.0f, 0.0f, 0.5f);
		MatInst.SetVectorParameterValue('SetColor', MatColor);
		MatInst.SetTextureParameterValue('SetNumber', Tex2DBorderWhite);
	}
	// If Spell is Dissolved Element, We set in PC.SpellTileTurnOn()
	else if (bDissolveElement)
	{
		MatInst = new class'MaterialInstanceConstant';
		MatInst.SetParent(MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST');
		MyKActorComponent.SetMaterial(1, MatInst);

		MatColor = MakeLinearColor(1.0f, 1.0f, 0.0f, 0.5f);
		MatInst.SetVectorParameterValue('SetColor', MatColor);
		MatInst.SetTextureParameterValue('SetNumber', Tex2DBorderWhite);
		bDissolveElement = false;
	}
}

/*
// Lightup where we can Select Tiles for Placement Spells
*/
simulated function SpellMarkTileArea()
{
	local LinearColor MatColor;
	
	if (!bSpellTileMode)
	{
		MatInst = new class'MaterialInstanceConstant';
		MatInst.SetParent(MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST');
		MyKActorComponent.SetMaterial(1, MatInst);

		MatColor = MakeLinearColor(0.0f, 0.3f, 1.0f, 0.5f);
		MatInst.SetVectorParameterValue('SetColor', MatColor);
		MatInst.SetTextureParameterValue('SetNumber', Tex2DBorderWhite);
	}
	// If nothing then we reset it to normal, Mostly used for  Dissolved Elements
	else
	{
		MyKActorComponent.SetMaterial(1,MyKActorComponent.default.Materials[1]);
	}
}

simulated function SpellMarkDissolveArea()
{
	local LinearColor MatColor;
	
	if (bSpellTileMode)
	{
		MatInst = new class'MaterialInstanceConstant';
		MatInst.SetParent(MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST');
		MyKActorComponent.SetMaterial(1, MatInst);

		MatColor = MakeLinearColor(1.0f, 0.0f, 0.0f, 0.5f);
		MatInst.SetVectorParameterValue('SetColor', MatColor);
		MatInst.SetTextureParameterValue('SetNumber', Tex2DBorderWhite);
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
	local LinearColor MatColor;

	bSpellTileMode = true;
//	TurnOfSpellBools();
	bFireFountain = true;

	if (bFireFountain)
	{
		MatInst = new class'MaterialInstanceConstant';
		MatInst.SetParent(MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST');
		MyKActorComponent.SetMaterial(1, MatInst);

		MatColor = MakeLinearColor(1.0f, 0.0f, 0.0f, 1.0f);
		MatInst.SetVectorParameterValue('SetColor', MatColor);
		MatInst.SetTextureParameterValue('SetNumber', Tex2DNoBorder);

		damage = SetDamage;
	}
}

/*
// Set Wall Of Ice Spell active for use
*/
simulated function ActivateWallOfIce()
{
	bSpellTileMode = true;
//	TurnOfSpellBools();
	bWallOfIce = true;

	if (bWallOfIce)
	{
		// nothing atm
	}
}

/*
// Set Glass Florr Spell active for use
*/
simulated function ActivateGlassFloor()
{
	local LinearColor MatColor;

	bSpellTileMode = true;
//	TurnOfSpellBools();
	bGlassFloor = true;

	if (bGlassFloor)
	{
		MatInst = new class'MaterialInstanceConstant';
		MatInst.SetParent(MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST');
		MyKActorComponent.SetMaterial(1, MatInst);

		MatColor = MakeLinearColor(0.0f, 0.0f, 1.0f, 1.0f);
		MatInst.SetVectorParameterValue('SetColor', MatColor);
		MatInst.SetTextureParameterValue('SetNumber', Tex2DNoBorder);

		// Change AP Cost
		PathNode.APValue = 2;
	}
}

/*
// Set StoneWall Spell active for use
*/
simulated function ActivateStoneWall()
{
	bSpellTileMode = true;
//	TurnOfSpellBools();
	bStoneWall = true;

	if (bStoneWall)
	{
		// nothing atm
	}
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
				if ( vsize(Location - FindActor.Location) < 128 )
				{
					FindActor.Destroy();
					break;
				}
			}
			PathNode.APValue = 1;
			bSpellTileMode = false;
			bDissolveElement = false;
		}
	}else
	{
		`log("Nothing to dissolve");
	}
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
	// reset damage
	damage = 0;
}

/*
// In PC.PlayerTick we show what Tiles we have active Spell
*/
simulated function ShowDisplayColor()
{
	local LinearColor MatColor;
	if (bSpellTileMode)
	{
		// FireFountain Spell
		if (bFireFountain)
		{
			MatInst = new class'MaterialInstanceConstant';
			MatInst.SetParent(MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST');
			MyKActorComponent.SetMaterial(1, MatInst);

			MatColor = MakeLinearColor(1.0f, 0.0f, 0.0f, 1.0f);
			MatInst.SetVectorParameterValue('SetColor', MatColor);
			MatInst.SetTextureParameterValue('SetNumber', Tex2DNoBorder);
		}
		// Wall Of Ice Spell
		else if(bWallOfIce)
		{

		}
		// Other Spell
		else if(bGlassFloor)
		{
			MatInst = new class'MaterialInstanceConstant';
			MatInst.SetParent(MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST');
			MyKActorComponent.SetMaterial(1, MatInst);

			MatColor = MakeLinearColor(0.0f, 0.0f, 1.0f, 1.0f);
			MatInst.SetVectorParameterValue('SetColor', MatColor);
			MatInst.SetTextureParameterValue('SetNumber', Tex2DNoBorder);
		}
		// Other Spell
		else if(bStoneWall)
		{

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Other functions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

/*
// Function that changes the alpha to go from 0 to 1 in 1 second.
// @NOTUSING
*/
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

/*
function SetItBackToNormal()
{
	MyKActorComponent.SetMaterial(1,MyKActorComponent.default.Materials[1]);
	`log( "ELSE!!!!!!!!!!!!!!!!!!!!!!!");
}

function SetMaterialSwitch()
{
		switch(MaterialCase)
	{
		// ---	Fire Spells --------------------------------------------------------------------
		case "LightUp":
		`log( "Light Up");
		MatInst = new class'MaterialInstanceConstant';
		MatInst.SetParent(MyKActorComponent.GetMaterial(1));
		MyKActorComponent.SetMaterial(1,MatInst);
		break;

		// ---	Default ------------------------------------------------------------------------
		default:
		`log( "Nothing touched" );
		break;
	}
}
*/

defaultproperties
{
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