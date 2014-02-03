class MCRock extends Actor;

var() float MovementSpeed;

simulated event Tick(float DeltaTime)
{
    local float delta_distance;
 	local vector d;

    delta_distance = (DeltaTime) * MovementSpeed;

 	d.Z = delta_distance;
    Move(d);
}

auto simulated state Moving
{
Begin:
    Sleep(4.0);
    GotoState('Idle');
}

simulated state Idle
{
    ignores Tick;
	//simulated event Tick(float DeltaTime){};
Begin:
	
}

DefaultProperties
{
	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true
	
	Begin Object class=StaticMeshComponent name=RockMesh
		StaticMesh=StaticMesh'mystrasmain.StaticMesh.RockBlocker'
	End Object
	//Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
	//End Object

	Components.Add(RockMesh)
	//CollisionComponent=RockMesh
	bCollideActors=true 
	bBlockActors=true
	//Components.Add(MyLightEnvironment)
	MovementSpeed=16
}