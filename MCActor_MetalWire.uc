//----------------------------------------------------------------------------
// MCActor_MetalWire
//
// For MCSpell_UnearthMaterial, spawn this actor and do the simulation
//
// Gustav 2014-08-29
//----------------------------------------------------------------------------
class MCActor_MetalWire extends MCActor;

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
	MovementSpeed=45
	smoke = ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_Dust_Secondary';

	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true

	Begin Object class=StaticMeshComponent name=RockMesh
		StaticMesh=StaticMesh'NEC_Wires.SM.Mesh.S_NEC_Wires_SM_Thinwire13'
	//	Materials(0)=Material'MystrasChampionSpells.Materials.FireFountain_02'
		Scale3D=(X=1.5,Y=1.0,Z=1)

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