//----------------------------------------------------------------------------
// MCProjectileSparkBolt
//
// Spark Bolt Projectile base settings
//
// Gustav Knutsson 2014-07-29
//----------------------------------------------------------------------------
class MCProjectileSparkBolt extends MCProjectile;

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

  projExplosion.setScale(4);
}

defaultproperties
{
	// 
// ------------------------------------------------------------------------------------------------------------------------ //
// Starting Point																											//
// ------------------------------------------------------------------------------------------------------------------------ //
	// The particle system used to visually represents the projectile.
//	MCProjFlightTemplate=ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_DecoyFlare'
	MCProjFlightTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Beam_Impact'
//	ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Beam_Impact'

// ------------------------------------------------------------------------------------------------------------------------ //
// Hit/Explotion Point																										//
// ------------------------------------------------------------------------------------------------------------------------ //
	// The particle system that is played when the projectile explodes.
	MCProjExplosionTemplate=ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Ball_Impact'

// ------------------------------------------------------------------------------------------------------------------------ //
// Travelling Point																											//
// ------------------------------------------------------------------------------------------------------------------------ //
	MaxEffectDistance=7000.0

	Speed=100
	MaxSpeed=1000
	AccelRate=100

	Damage=1
	DamageRadius=0
	MomentumTransfer=0
	CheckRadius=26

	Physics=PHYS_Projectile
//	LifeSpan=6.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=3.0

//	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
}