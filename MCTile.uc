class MCTile extends MouseInterfaceKActor
	hidecategories(Display, Attachment, Physics, Advanced, Debug, Mobile);
/*
//Main variables
*/
var StaticMeshComponent MyKActorComponent;	// For Setting static mesh on the KActor
var MaterialInstanceConstant MatInst;
// The PathNode in here
var MCPathNode PathNode;
var MCPathNode Pathy;
// Setting colors
var Texture2D NoBorderBlack;
var Texture2D BorderWhite;
// If DamageMode Is On This Tile, dont ever Light up this tile
var Texture2D DamageModeTile;
var bool bFireFountain;
var bool bSpellTileMode;

var int damage;


/*
testing variables
*/
var float addFloat;

// Replication block
replication
{
	// Replicate only if the values are dirty, this replication info is owned by the player and from server to client
//	if (bNetDirty && bNetOwner)
//		 MatInst;

	// Variables the server should send ALL clients.
	if (bNetDirty && Role == ROLE_Authority)
		bSpellTileMode;

//	if (bNetInitial)
//		;

	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		PathNode, bFireFountain, MatInst, damage;
}


simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	foreach AllActors(Class'MCPathNode', PathNode)
	{
		if ( vsize(Location - PathNode.Location) < 70 )
		{
			break;
		}
	}
}

/*
Turns tile in to a specific color when AP is different
*/
simulated function TileTurnBlue()
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
			case 1:
				MatColor = MakeLinearColor(0.0f, 0.8125f, 0.007688f, 0.5f);
				MatInst.SetVectorParameterValue('SetColor', MatColor);
				MatInst.SetTextureParameterValue('SetNumber', BorderWhite);
				break;
			case 2:
				MatColor = MakeLinearColor(1.0f, 1.0f, 0.0f, 0.5f);
				MatInst.SetVectorParameterValue('SetColor', MatColor);
				MatInst.SetTextureParameterValue('SetNumber', BorderWhite);
				break;
			case 3:
				MatColor = MakeLinearColor(1.0f, 0.0f, 0.0f, 0.5f);
				MatInst.SetVectorParameterValue('SetColor', MatColor);
				MatInst.SetTextureParameterValue('SetNumber', BorderWhite);
				break;
			default:
				`log("nothing");
		}
	}	

}

simulated function SpellTileTurnRed()
{
	local LinearColor MatColor;
	
	if (!bSpellTileMode)
	{
		MatInst = new class'MaterialInstanceConstant';
		MatInst.SetParent(MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST');
		MyKActorComponent.SetMaterial(1, MatInst);

		MatColor = MakeLinearColor(1.0f, 0.0f, 0.0f, 0.5f);
		MatInst.SetVectorParameterValue('SetColor', MatColor);
		MatInst.SetTextureParameterValue('SetNumber', BorderWhite);
	}

}

simulated function SpellTileTurnGreen()
{
	local LinearColor MatColor;
	
	if (!bSpellTileMode)
	{
		MatInst = new class'MaterialInstanceConstant';
		MatInst.SetParent(MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST');
		MyKActorComponent.SetMaterial(1, MatInst);

		MatColor = MakeLinearColor(0.0f, 0.3f, 1.0f, 0.5f);
		MatInst.SetVectorParameterValue('SetColor', MatColor);
		MatInst.SetTextureParameterValue('SetNumber', BorderWhite);
	}

}


simulated function TurnTileOff()
{	
	if (!bSpellTileMode)
	{	
		MyKActorComponent.SetMaterial(1,MyKActorComponent.default.Materials[1]);
	}
}

// or reliable client works
simulated function SetFireFountain()
{
	local LinearColor MatColor;
	bSpellTileMode = true;
	bFireFountain = true;
	if (bFireFountain)
	{
		MatInst = new class'MaterialInstanceConstant';
		MatInst.SetParent(MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST');
		MyKActorComponent.SetMaterial(1, MatInst);

		MatColor = MakeLinearColor(1.0f, 0.0f, 0.0f, 1.0f);
		MatInst.SetVectorParameterValue('SetColor', MatColor);
		MatInst.SetTextureParameterValue('SetNumber', NoBorderBlack);

		damage = 5;
	}

//	`log("Arrived MCTile");
}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	`log("Touched" @ Other);
	if (bSpellTileMode)
	{
		if (bNetDirty && Role == ROLE_Authority)
		{
			`log(Other @ "Server" @ "damage" @damage);
		}else
		{
			`log(Other @ "Client" @ "damage" @damage);
		}
	}

	
	super.Touch(Other,OtherComp,HitLocation,HitNormal);
}

simulated event UnTouch (Actor Other)
{
	ClearTimer('SetBlockedONTimer');
	//PathNode.bBlocked = false;
	super.UnTouch(Other);
}







simulated function SetBlockedONTimer()
{
	PathNode.bBlocked = true;
	`log("WE ARE BLOCKED!!!!");
}

/*
Function that changes the alpha to go from 0 to 1 in 1 second.
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



simulated function TileTurnGreen()
{
	local LinearColor MatColor;

	MatInst = new class'MaterialInstanceConstant';
	MatInst.SetParent(MyKActorComponent.GetMaterial(1));
	MyKActorComponent.SetMaterial(1, MatInst);

	MatColor = MakeLinearColor(0.0f, 1.0f, 0.0f, 1.0f);
	MatInst.SetVectorParameterValue('SetColor', MatColor);
}

event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	`log( "numpzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
	/*
	if(Pawn(Other) != None)
	{
		MyKActorComponent.SetMaterial(1,TurnGreen);
		`log( "numpzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
	}
	else
	{
		MyKActorComponent.SetMaterial(1,MyKActorComponent.default.Materials[1]);
		`log( "ELSE!!!!!!!!!!!!!!!!!!!!!!!");
	}
	*/
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

	NoBorderBlack = Texture2D'mystraschampionsettings.Texture.BlackCornerNoBG'
	BorderWhite = Texture2D'mystraschampionsettings.Texture.WhiteCorner'
}