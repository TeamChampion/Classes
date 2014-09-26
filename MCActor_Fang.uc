//----------------------------------------------------------------------------
// MCActor_Fang
//
// For MCSpell_RockFang, spawn this actor and do the simulation
//
// Xanthos 2014-01-01
//----------------------------------------------------------------------------
class MCActor_Fang extends MCActor;

simulated event Tick(float DeltaTime)
{
    local float delta_distance;
 	local vector d;
    delta_distance = (DeltaTime) * MovementSpeed;

 	d.Z = -delta_distance;
    Move(d);
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
Begin:
    self.Destroy();
}

// When We Destroy This Element It set's off an Explosion
simulated event Destroyed()
{

}

DefaultProperties
{
	SleepTimer=5.0f
	MovementSpeed=20
	smoke = ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_Dust_Secondary'

	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true

	Begin Object class=DynamicLightEnvironmentComponent name=myLightEnvironment
		bEnabled=true
	End Object
	Begin Object class=StaticMeshComponent name=FangMesh
		StaticMesh=StaticMesh'UN_Rock.SM.Mesh.S_UN_Rock_SM_Blackspire01'
	//	StaticMesh=StaticMesh'MystrasChampionSpells.StaticMesh.RockFang'
		Scale=0.5

	End Object

	Components.Add(myLightEnvironment)
	Components.Add(FangMesh)
}