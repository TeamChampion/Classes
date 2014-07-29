//----------------------------------------------------------------------------
// MCActor_Fang
//
// For MCSpell_StoneWall, spawn this actor and do the simulation
//
// Xanthos 2014-01-01
//----------------------------------------------------------------------------
class MCActor_CameraMover extends MCActor;

var() float MovementSpeed;
var MCPlayerController cMCPC;
var float velRotation;

simulated function PostBeginPlay()
{
//	local Rotator newRotation;

//	newRotation.Pitch = (49151);
//	SetRotation( newRotation );
	super.PostBeginPlay();
}

simulated event Tick(float DeltaTime)
{
	/*
//	local float delta_distance;
//	local vector d;
	local float deltaRotation;
	local Rotator newRotation;
   
	deltaRotation = velRotation * DeltaTime; 

	newRotation = Rotation;

//	newRotation.Pitch += deltaRotation;
	newRotation.Yaw  += deltaRotation;	// round
//	newRotation.Roll  += deltaRotation;	// rolling
//	delta_distance = (DeltaTime) * MovementSpeed;

//	d.Z = delta_distance;
	if (cMCPC != none)
	{
		SetLocation(cMCPC.MCPlayer.Location);
		SetRotation( newRotation );
	//	Move(cMCPC.Pawn.Location);
	}
	*/
}

auto simulated state Moving
{

}


DefaultProperties
{
	velRotation=5000


	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true


	Begin Object class=StaticMeshComponent name=RockMesh
		StaticMesh=StaticMesh'mystrasmain.StaticMesh.RockBlocker'
		Scale=1.0
		BlockActors = true	// Make so that it blocks shots
	End Object

	Begin Object class=DynamicLightEnvironmentComponent name=myLightEnvironment
		bEnabled=true
	End Object

	Components.Add(RockMesh)
	Components.Add(myLightEnvironment)
	//CollisionComponent=RockMesh
	bCollideActors=true 
	bBlockActors=true

	MovementSpeed=30
}