//----------------------------------------------------------------------------
// MCActor_Fang
//
// For MCSpell_UnearthMaterial, spawn this actor and do the simulation
//
// Gustav 2014-08-29
//----------------------------------------------------------------------------
class MCActor_Water extends MCActor;

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
	SleepTimer=1.5f
	MovementSpeed=4
	smoke = ParticleSystem'MystrasChampionSpells.Particles.WhiteSmokeParticle'

	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true

	// Add a Invisible Cyllinder so that we can find it when destroying it
    Begin Object Class=CylinderComponent NAME=CollisionCylinder
		CollisionRadius=64.0f
		CollisionHeight=64.0f
		bAlwaysRenderIfSelected=true
		CollideActors=false
		BlockActors = false
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)
}