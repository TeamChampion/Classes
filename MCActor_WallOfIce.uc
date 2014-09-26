//----------------------------------------------------------------------------
// MCActor_WallOfIce
//
// For MCSpell_Wall_Of_Ice, spawn this actor and do the simulation
//
// Gustav Knutsson 2014-07-17
//----------------------------------------------------------------------------
class MCActor_WallOfIce extends MCActor;

simulated event Tick(float DeltaTime)
{
	local float delta_distance;
	local vector d;

	delta_distance = (DeltaTime) * MovementSpeed;

	d.Z = delta_distance;
	Move(d);
}

DefaultProperties
{
	SleepTimer=2.5f
	MovementSpeed=30
	smoke = ParticleSystem'MystrasChampionSpells.Particles.WhiteSmokeParticle'

	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true

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
}