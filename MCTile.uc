class MCTile extends MouseInterfaceKActor
	hidecategories(Display, Attachment, Physics, Advanced, Debug, Mobile);

simulated event PostBeginPlay()
{
	//`log("Spawned the KActor");
}



event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	// Getting the object from another class
	//local MouseInterfacePlayerController PlayerConStuff;
	// calling function from Controller
	//PlayerConStuff.StuffIsTouched();

	super.Touch(Other,OtherComp,HitLocation,HitNormal);
	//MyKActorComponent.SetMaterial(1,TurnGreen);
//	`log( "Touched so GoGreen TOUCH!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

}

event UnTouch (Actor Other)
{
	// need 
	//MyKActorComponent.SetMaterial(1,MyKActorComponent.default.Materials[1]);	
//	`log( "Return to sender UNTOUCH!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
}

/*
event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
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
	
}
*/
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
        //StaticMesh=StaticMesh'Main.grass_field.box01'
		//Materials(0)=Material'Main.Materials.Dirt'
		//Materials(1)=Material'Main.Materials.blockTest'
		
		BlockActors=true
		CollideActors=true
		BlockRigidBody=true
		HiddenGame=false
		BlockZeroExtent=true
		BlockNonZeroExtent = false
		//bCastDynamicShadow=true
		//bUsePrecomputedShadows=true
		//bNotifyRigidBodyCollision=true
		//ScriptRigidBodyCollisionThreshold=0.001 
		//LightingChannels=(Dynamic=TRUE) 
	End Object 

	CollisionComponent = tile01
	//MyKActorComponent = tile01
	Components.Add(tile01)

	//TurnGreen=Material'Main.Materials.Brick'

	bNoEncroachCheck=false


	CollisionType=COLLIDE_BlockAll
	Physics=Phys_None

	//Components.Add(tile01)
	//CollisionComponent=tile01
	//bCollideWorld=False //false is for nonmoving objects
	//bWakeOnLevelStart=false
}