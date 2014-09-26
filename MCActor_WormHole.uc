//----------------------------------------------------------------------------
// MCActor_WallOfIce
//
// For MCSpell_Wormhole, spawn this actor and do the simulation
//
// Gustav Knutsson 2014-08-31
//----------------------------------------------------------------------------
class MCActor_WormHole extends MCActor;

/*
simulated function PostBeginPlay()
{
	local Vector newLocation;
	super.PostBeginPlay();
	newLocation = Location + vect(0,0,60);
	if (Role != ROLE_Authority || (WorldInfo.NetMode == NM_ListenServer) )
		WorldInfo.MyEmitterPool.SpawnEmitter(smoke, newLocation);	
}
*/
simulated event Tick(float DeltaTime)
{
	local float delta_distance;
	local vector d;

	delta_distance = (DeltaTime) * MovementSpeed;

	d.Z = delta_distance;
	Move(d);
}
/*
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
		if(Caster != none)
			Caster.PC.CheckCurrentAPCalculation();
		Super.BeginState(PreviousStateName);
	}
}


// When We Destroy This Element It set's off an Explosion
simulated event Destroyed()
{
	local Vector newLocation;

	newLocation = Location + vect(0,0,60);
	if (Role != ROLE_Authority || (WorldInfo.NetMode == NM_ListenServer) )
		WorldInfo.MyEmitterPool.SpawnEmitter(smoke, newLocation);	

	super.Destroyed();
}
*/
DefaultProperties
{
	SleepTimer=2.5f
	MovementSpeed=30
	smoke = ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_Dust_Secondary';

	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true

	Begin Object class=StaticMeshComponent name=RockMesh
		StaticMesh=StaticMesh'MystrasChampionSpells.StaticMesh.Wormhole'
		Scale=1.0
		BlockActors = false	// Make so that it blocks shots
	End Object

	Begin Object class=DynamicLightEnvironmentComponent name=myLightEnvironment
		bEnabled=true
	End Object

	Components.Add(RockMesh)
	Components.Add(myLightEnvironment)
	//CollisionComponent=RockMesh
	bCollideActors=false 
	bBlockActors=false
}