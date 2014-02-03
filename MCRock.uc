class MCRock extends Actor;

var() float MovementSpeed;
var() ParticleSystem smoke;

Replication
{
	if (bNetDirty)
		smoke;
}

simulated function PostBeginPlay()
{
	local Vector newLocation;
	super.PostBeginPlay();
	newLocation = Location + vect(0,0,60);
	WorldInfo.MyEmitterPool.SpawnEmitter(smoke, newLocation);
}

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
    Sleep(2.5);
    GotoState('Idle');
}

simulated state Idle
{
    ignores Tick;
}

DefaultProperties
{
	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true
	smoke = ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_Dust_Secondary';
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
	MovementSpeed=30
}