class MCTile extends MouseInterfaceKActor;

simulated event PostBeginPlay()
{
	`log("Spawned the KActor");
}


/*
function SpawnStuff(Vector HitLocation)
{
	local vector Location;
	local rotator Rotation;
	hejPath = Spawn(class'PathNode', , , Location,Rotation);
	hejPath.setLocation(HitLocation.Z + 60);
}
*/






event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	
	// Getting the object from another class
	//local MouseInterfacePlayerController PlayerConStuff;
	// calling function from Controller
	//PlayerConStuff.StuffIsTouched();
	


	// Using KActor in here

	super.Touch(Other,OtherComp,HitLocation,HitNormal);
	MyKActorComponent.SetMaterial(1,TurnGreen);
	`log( "Touched so GoGreen TOUCH!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

}

event UnTouch (Actor Other)
{
	MyKActorComponent.SetMaterial(1,MyKActorComponent.default.Materials[1]);	
	`log( "Return to sender UNTOUCH!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
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
	SupportedEvents(4)=class'SeqEvent_MouseInput'
	
	
	
	/*
	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=+0064.000000
		CollisionHeight=+0064.000000
		CylinderColor=(R=200,G=128,B=255,A=255)
		bAlwaysRenderIfSelected=True
		Hiddengame=true
		CollideActors=true
		BlockNonZeroExtent = true
	end object
	Components.Add(CollisionCylinder)
	bCollideActors=true
	Begin Object Class=StaticMeshComponent Name=tile01
	BlockActors=false
	CollideActors=true
	StaticMesh=StaticMesh'Main.grass_field.tile01'
		Materials(0)=Material'Main.Materials.Dirt'
		Materials(1)=Material'Main.Materials.blockTest'

	//	Scale3D=(X=1,Y=1,Z=1.0)
	//	Rotation=(Pitch=0,Yaw=0,Roll=0)
	end object
	CollisionComponent=tile01
	Components.Add(tile01)
*/

	Begin Object Class=StaticMeshComponent Name=tile01
        StaticMesh=StaticMesh'Main.grass_field.box01'
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
	MyKActorComponent = tile01
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