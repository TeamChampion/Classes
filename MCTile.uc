class MCTile extends MouseInterfaceKActor
	hidecategories(Display, Attachment, Physics, Advanced, Debug, Mobile);
/*
Main variables
*/
var StaticMeshComponent MyKActorComponent;	// For Setting static mesh on the KActor
var MaterialInstanceConstant MatInst;

var Texture2d WhiteCorner01;
var Texture2D WhiteCorner02;
var Texture2d WhiteCorner03;
var MCPathNode PathNode;

/*
testing variables
*/
var float addFloat;

replication
{
	if(bNetDirty)
		MyKActorComponent, MatInst, WhiteCorner01, WhiteCorner02, WhiteCorner03;
}


simulated event PostBeginPlay()
{
	foreach AllActors(Class'MCPathNode', PathNode)
	{
		if (Location.X == PathNode.Location.X && Location.Y == PathNode.Location.Y)
		{
			//`log("PathNode" @ PathNode @ "at" @ Location);
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
	
	MatInst = new class'MaterialInstanceConstant';
	MatInst.SetParent(MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST');
	MyKActorComponent.SetMaterial(1, MatInst);

	switch (PathNode.APValue)
	{
		case 1:
			MatColor = MakeLinearColor(0.0f, 0.8125f, 0.007688f, 1.0f);
			MatInst.SetVectorParameterValue('SetColor', MatColor);
			MatInst.SetTextureParameterValue('SetNumber', WhiteCorner01);
			break;
		case 2:
			MatColor = MakeLinearColor(1.0f, 1.0f, 0.0f, 1.0f);
			MatInst.SetVectorParameterValue('SetColor', MatColor);
			MatInst.SetTextureParameterValue('SetNumber', WhiteCorner02);
			break;
		case 3:
			MatColor = MakeLinearColor(1.0f, 0.0f, 0.0f, 1.0f);
			MatInst.SetVectorParameterValue('SetColor', MatColor);
			MatInst.SetTextureParameterValue('SetNumber', WhiteCorner03);
			break;
		default:
			`log("nothing");
	}
}


simulated function TurnTileOff()
{	
	MyKActorComponent.SetMaterial(1,MyKActorComponent.default.Materials[1]);
}





///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////








simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
//	local LinearColor MatColor;
/*
	MatInst = new class'MaterialInstanceConstant';
//	MatInst.SetParent(MyKActorComponent.GetMaterial(1));
	MatInst.SetParent(MaterialInstanceConstant'mystraschampionsettings.Materials.Green_INST');
	MyKActorComponent.SetMaterial(1, MatInst);

	MatColor = MakeLinearColor(0.0f, 1.0f, 0.0f, 1.0f);
	MatInst.SetVectorParameterValue('SetColor', MatColor);
	MatInst.SetTextureParameterValue('SetNumber', WhiteCorner01);
*/

	super.Touch(Other,OtherComp,HitLocation,HitNormal);
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

simulated event UnTouch (Actor Other)
{
	/*
	TurnTileOff();
	if( Role < ROLE_Authority ) // then save this move and replicate it
	{
		SetTimer(0.4f, false, 'TurnTileOff');
	}
	else
	{
		SetTimer(0.4f, false, 'TurnTileOff');
	}
	*/



//	MyKActorComponent.SetMaterial(1,MyKActorComponent.default.Materials[1]);
//	addFloat = 0.0f;
//	`log( "Return to sender UNTOUCH!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
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


	WhiteCorner01 = Texture2D'mystraschampionsettings.Texture.WhiteCorner01'
	WhiteCorner02 = Texture2D'mystraschampionsettings.Texture.WhiteCorner02'
	WhiteCorner03 = Texture2D'mystraschampionsettings.Texture.WhiteCorner03'
}