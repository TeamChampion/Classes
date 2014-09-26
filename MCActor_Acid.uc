//----------------------------------------------------------------------------
// MCActor_Fang
//
// For MCSpell_UnearthMaterial, spawn this actor and do the simulation
//
// Gustav 2014-08-29
//----------------------------------------------------------------------------
class MCActor_Acid extends MCActor;

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
	MovementSpeed=4
	smoke = ParticleSystem'MystrasChampionSpells.Particles.WhiteSmokeParticle'

	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true

	Begin Object class=StaticMeshComponent name=RockMesh
		StaticMesh=StaticMesh'WP_BioRifle.Mesh.S_Bio_Blob_01'
		Scale3D=(X=1,Y=3.5,Z=3.5)
		Rotation=(Pitch=16384,Yaw=0,Roll=0)

	End Object

	Begin Object class=DynamicLightEnvironmentComponent name=myLightEnvironment
		bEnabled=true
	End Object

	Components.Add(RockMesh)
	Components.Add(myLightEnvironment)
}