//----------------------------------------------------------------------------
// MCActor_Rock
//
// For MCSpell_StoneWall, spawn this actor and do the simulation
//
// Xanthos 2014-01-01
//----------------------------------------------------------------------------
class MCActor_Rock extends MCActor;

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
	smoke = ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_Dust_Secondary';

	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true

	Begin Object class=StaticMeshComponent name=RockMesh
		StaticMesh=StaticMesh'mystrasmain.StaticMesh.RockBlocker'
		Scale=1.7
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