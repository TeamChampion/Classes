class MCProjectileFireball extends MCProjectile;
// Fire Fan (burning hands)	: 1 SlotDamage Triangle from Fire Source

Simulated function PostBeginPlay()
{
	`log( "FireBall" );
	super.PostBeginPlay();
}

defaultproperties
{
    MCProjFlightTemplate=ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_DecoyFlare'
    MCProjExplosionTemplate=ParticleSystem'FX_VehicleExplosions.Effects.P_FX_VehicleDeathExplosion'
	MaxEffectDistance=7000.0

	Speed=50
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