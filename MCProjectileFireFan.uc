//----------------------------------------------------------------------------
// MCProjectileFireFan
//
// Fire Fan Projectile base settings
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCProjectileFireFan extends MCProjectile;

Simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}

defaultproperties
{
// ------------------------------------------------------------------------------------------------------------------------ //
// Starting Point																											//
// ------------------------------------------------------------------------------------------------------------------------ //
	// The particle system used to visually represents the projectile.
	MCProjFlightTemplate=ParticleSystem'UDKRTSGameContent.ParticleSystems.BuildingFire'
	//MCProjFlightTemplate=ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_DecoyFlare'

// ------------------------------------------------------------------------------------------------------------------------ //
// Hit/Explotion Point																										//
// ------------------------------------------------------------------------------------------------------------------------ //
	// The particle system that is played when the projectile explodes.
	MCProjExplosionTemplate=ParticleSystem'UDKRTSGameContent.ParticleSystems.P_WP_RocketLauncher_RocketExplosion'

// ------------------------------------------------------------------------------------------------------------------------ //
// Travelling Point																											//
// ------------------------------------------------------------------------------------------------------------------------ //
	MaxEffectDistance=700.0

	Speed=1
	MaxSpeed=100
	AccelRate=2

	Damage=50
	DamageRadius=0
	MomentumTransfer=0
	CheckRadius=0.1

	//Physics=PHYS_Projectile
	//MyDamageType=class'UTDmgType_LinkPlasma'
	LifeSpan=6.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	//DrawScale=1.4

	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
}