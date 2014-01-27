class MCProjectileFireFan extends MCProjectile;
// Fire Fan (burning hands)	: 1 SlotDamage Triangle from Fire Source

Simulated function PostBeginPlay()
{
	`log( "Fire Fan" );
	super.PostBeginPlay();
}


defaultproperties
{

// ------------------------------------------------------------------------------------------------------------------------ //
// Starting Point																											//
// ------------------------------------------------------------------------------------------------------------------------ //
	// The particle system used to visually represents the projectile.
	ProjFlightTemplate=ParticleSystem'udkrtsgamecontent.ParticleSystems.BuildingFire'

// ------------------------------------------------------------------------------------------------------------------------ //
// Hit/Explotion Point																										//
// ------------------------------------------------------------------------------------------------------------------------ //
	// The particle system that is played when the projectile explodes.
	ProjExplosionTemplate=ParticleSystem'udkrtsgamecontent.ParticleSystems.P_WP_RocketLauncher_RocketExplosion'

// ------------------------------------------------------------------------------------------------------------------------ //
// Travelling Point																											//
// ------------------------------------------------------------------------------------------------------------------------ //
	// time before Particle dies out
	LifeSpan=1
	Speed=200
	MaxSpeed=600
	//AccelRate=3000.0

// ------------------------------------------------------------------------------------------------------------------------ //
// Damage 																													//
// ------------------------------------------------------------------------------------------------------------------------ //
	Damage=50
	DamageRadius=0

// ------------------------------------------------------------------------------------------------------------------------ //
// Other 																													//
// ------------------------------------------------------------------------------------------------------------------------ //
	//ProjectileLightClass=class'UTGame.UTShockBallLight'
	//MyDamageType=class'UTDmgType_LinkPlasma'
}
