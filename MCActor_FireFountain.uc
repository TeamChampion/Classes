//----------------------------------------------------------------------------
// MCActor_FireFountain
//
// For MCSpell_UnearthMaterial and Fire Fountain, spawn this actor and do the simulation
//
// Gustav Knutsson 2014-08-29
//----------------------------------------------------------------------------
class MCActor_FireFountain extends MCActor;

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
	smoke = ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_Dust_Secondary';

	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true

	Begin Object class=StaticMeshComponent name=RockMesh
		StaticMesh=StaticMesh'UN_Rock.SM.Mesh.S_UN_Rock_SM_RockMesh05'
		Materials(0)=Material'MystrasChampionSpells.Materials.FireFountain_02'
		Scale3D=(X=2.5,Y=2.5,Z=2)

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