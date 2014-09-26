//----------------------------------------------------------------------------
// MCProjectileFireball
//
// Fireball Projectile base settings
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCProjectileFireball extends MCProjectile;

Simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}

defaultproperties
{
	MCProjFlightTemplate=ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_DecoyFlare'
	MCProjExplosionTemplate=ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Ball_Impact'
//	MCProjExplosionTemplate=ParticleSystem'FX_VehicleExplosions.Effects.P_FX_VehicleDeathExplosion'
	MaxEffectDistance=7000.0

	Speed=10
	MaxSpeed=2000
	AccelRate=500

	Damage=5
	DamageRadius=0
	MomentumTransfer=0
	CheckRadius=26.0
	
	Physics=PHYS_Projectile
	//MyDamageType=class'UTDmgType_LinkPlasma'
	//LifeSpan=3.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=1.4

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
}