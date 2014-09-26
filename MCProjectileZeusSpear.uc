//----------------------------------------------------------------------------
// MCProjectileZeusSpear
//
// Fire Fan Projectile base settings
//
// Gustav Knutsson 2014-09-08
//----------------------------------------------------------------------------
class MCProjectileZeusSpear extends MCProjectile;

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
	// The particle system used to visually represents the projectile.
	MCProjFlightTemplate=ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_MF_Beam_Blue'
//	MCProjFlightTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Altbeam_Blue'
//	MCProjFlightTemplate=ParticleSystem'UDK_Rain.Particles.P_Lightening'


	// The particle system that is played when the projectile explodes.
	MCProjExplosionTemplate=ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Ball_Impact'
//	MCProjExplosionTemplate=ParticleSystem'FX_VehicleExplosions.Effects.P_FX_VehicleDeathExplosion'
	
	Speed=300			// 300
	MaxSpeed=800		// 1000
	AccelRate=1700		// 2000

	Damage=30
	DamageRadius=50
	MomentumTransfer=0
	CheckRadius=36.0
	//0.19
	LifeSpan=4
	NetCullDistanceSquared=+144000000.0
	MaxEffectDistance=7000.0
	bCollideWorld=true
	DrawScale=1.4
	Physics=PHYS_Projectile

	// Light Source
	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=TRUE
	End Object
	Components.Add(MyLightEnvironment)



//	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
}