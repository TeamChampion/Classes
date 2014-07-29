//----------------------------------------------------------------------------
// MCProjectileFireFan
//
// Fire Fan Projectile base settings
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCProjectileSpearOfIce extends MCProjectile;

Simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	super.Touch(Other, OtherComp, HitLocation, HitNormal);
//	`log(self @"Touched" @ Other);
	///
}

defaultproperties
{
	// The particle system used to visually represents the projectile.
//	MCProjFlightTemplate=ParticleSystem'KismetGame_Assets.Projectile.P_BlasterProjectile_02'	// not working
	MCProjFlightTemplate=ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_DecoyFlare'
	// The particle system that is played when the projectile explodes.
	MCProjExplosionTemplate=ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_Decoy_Explo'
//	MCProjExplosionTemplate=ParticleSystem'FX_VehicleExplosions.Effects.P_FX_VehicleDeathExplosion'
	
	Speed=300
	MaxSpeed=1000
	AccelRate=2000

	Damage=30
	DamageRadius=16
	MomentumTransfer=0
	CheckRadius=36.0
	//0.19
	LifeSpan=0.19
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

	// Static Mesh
	Begin object class=StaticMeshComponent Name=BaseMesh
		StaticMesh(0)=StaticMesh'MystrasChampionSpells.StaticMesh.SpearOfIce'
	//	Scale3D=(X=1,Y=1,Z=1)
		Scale=1
	//	BlockActors = false
		LightEnvironment=MyLightEnvironment
	End object
	Components.Add(BaseMesh)



//	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
}