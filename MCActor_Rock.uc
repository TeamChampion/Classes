class MCActor_Rock extends Actor;

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
	if (Role != ROLE_Authority)
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
	Begin Object class=DynamicLightEnvironmentComponent name=myLightEnvironment
		bEnabled=true
	End Object
	Begin Object class=StaticMeshComponent name=RockMesh
		StaticMesh=StaticMesh'mystrasmain.StaticMesh.RockBlocker'
		Scale=1.5
	End Object

	Components.Add(RockMesh)
	Components.Add(myLightEnvironment)
	//CollisionComponent=RockMesh
	bCollideActors=true 
	bBlockActors=true

	MovementSpeed=30
}