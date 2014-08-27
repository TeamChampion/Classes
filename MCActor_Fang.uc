//----------------------------------------------------------------------------
// MCActor_Fang
//
// For MCSpell_RockFang, spawn this actor and do the simulation
//
// Xanthos 2014-01-01
//----------------------------------------------------------------------------
class MCActor_Fang extends MCActor;

var() float MovementSpeed;
var() ParticleSystem smoke;

Replication
{
	if (bNetDirty)
		smoke;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	if (Role != ROLE_Authority || (WorldInfo.NetMode == NM_ListenServer) )
		WorldInfo.MyEmitterPool.SpawnEmitter(smoke, Location);
	//`log(""@Components.FangMesh);
}

simulated event Tick(float DeltaTime)
{
    local float delta_distance;
 	local vector d;
    delta_distance = (DeltaTime) * MovementSpeed;

 	d.Z = -delta_distance;
    Move(d);
}

auto simulated state Moving
{
Begin:
    Sleep(5.0);
    GotoState('Idle');
}

simulated state Idle
{
    ignores Tick;
Begin:
    self.Destroy();
}

DefaultProperties
{
	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true

	smoke = ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_Dust_Secondary'
	Begin Object class=DynamicLightEnvironmentComponent name=myLightEnvironment
		bEnabled=true
	End Object
	Begin Object class=StaticMeshComponent name=FangMesh
		StaticMesh=StaticMesh'MystrasChampionSpells.StaticMesh.RockFang'
		Scale=0.5

	End Object

	Components.Add(myLightEnvironment)
	Components.Add(FangMesh)
	//CollisionComponent=RockMesh
	//bCollideActors=true 
	//bBlockActors=true

	MovementSpeed=20
}