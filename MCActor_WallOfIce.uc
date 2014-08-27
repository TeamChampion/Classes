//----------------------------------------------------------------------------
// MCActor_WallOfIce
//
// For MCSpell_Wall_Of_Ice, spawn this actor and do the simulation
//
// Gustav Knutsson 2014-07-17
//----------------------------------------------------------------------------
class MCActor_WallOfIce extends MCActor;

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
	if (Role != ROLE_Authority || (WorldInfo.NetMode == NM_ListenServer) )
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
	
	function BeginState(Name PreviousStateName)
	{
		
		Super.BeginState(PreviousStateName);
	}
}

/*
// When We Destroy This Element It set's off an Explosion
*/
simulated event Destroyed()
{
	local Vector newLocation;

	newLocation = Location + vect(0,0,60);
	if (Role != ROLE_Authority || (WorldInfo.NetMode == NM_ListenServer) )
		WorldInfo.MyEmitterPool.SpawnEmitter(smoke, newLocation);	

	super.Destroyed();
}

DefaultProperties
{
	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true

	smoke = ParticleSystem'MystrasChampionSpells.Particles.WhiteSmokeParticle'


	Begin Object class=StaticMeshComponent name=RockMesh
		StaticMesh=StaticMesh'MystrasChampionSpells.StaticMesh.IceWall'
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