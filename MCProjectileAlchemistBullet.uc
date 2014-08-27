//----------------------------------------------------------------------------
// MCProjectileAlchemistBullet
//
// Alchemist's Bullet Projectile base settings
//
// Gustav Knutsson 2014-07-29
//----------------------------------------------------------------------------
class MCProjectileAlchemistBullet extends MCProjectile;

Simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}

/*
// Changes The size of the explosion Particle
*/
simulated function setExplosionEffectParameters(ParticleSystemComponent projExplosion)
{
  super.setExplosionEffectParameters(projExplosion);

  projExplosion.setScale(5);
}

defaultproperties
{
	// 
// ------------------------------------------------------------------------------------------------------------------------ //
// Starting Point																											//
// ------------------------------------------------------------------------------------------------------------------------ //
	// The particle system used to visually represents the projectile.
//	MCProjFlightTemplate=ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_DecoyFlare'
	MCProjFlightTemplate=ParticleSystem'KismetGame_Assets.Projectile.P_Spit_01'

// ------------------------------------------------------------------------------------------------------------------------ //
// Hit/Explotion Point																										//
// ------------------------------------------------------------------------------------------------------------------------ //
	// The particle system that is played when the projectile explodes.
//	MCProjExplosionTemplate=ParticleSystem'FX_VehicleExplosions.Effects.P_FX_VehicleDeathExplosion'
	MCProjExplosionTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Impact'

// ------------------------------------------------------------------------------------------------------------------------ //
// Travelling Point																											//
// ------------------------------------------------------------------------------------------------------------------------ //
	MaxEffectDistance=7000.0

	Speed=100
	MaxSpeed=900
	AccelRate=100

	Damage=1
	DamageRadius=0
	MomentumTransfer=0
	CheckRadius=26

	Physics=PHYS_Projectile
//	LifeSpan=6.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true

	// Light Source
	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=TRUE
	End Object
	Components.Add(MyLightEnvironment)

	// Static Mesh
	Begin object class=StaticMeshComponent Name=BaseMesh
		StaticMesh(0)=StaticMesh'MystrasChampionSpells.StaticMesh.IceSpikeMesh'
		Materials(0)=Material'WP_BioRifle.Materials.M_Bio_Blob_02'
		Scale=1.5
		Rotation=(Pitch=-20000,Yaw=0,Roll=0)
		LightEnvironment=MyLightEnvironment
	End object
	Components.Add(BaseMesh)

//	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
}