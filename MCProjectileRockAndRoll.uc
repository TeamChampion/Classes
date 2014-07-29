//----------------------------------------------------------------------------
// MCProjectileRockAndRoll
//
// Rock & Roll Projectile base settings
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCProjectileRockAndRoll extends MCProjectile
	placeable;

Simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}

defaultproperties
{
    MCProjFlightTemplate=ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_DecoyFlare'
    MCProjExplosionTemplate=ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_Dust_Secondary'
	MaxEffectDistance=7000.0
	
	Speed=600
	MaxSpeed=1000
	AccelRate=1000.0

	Damage=10
	DamageRadius=0
	MomentumTransfer=0
	CheckRadius=26.0

	//MyDamageType=class'UTDmgType_LinkPlasma'
	//LifeSpan=3.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true




	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bEnabled=TRUE
    End Object
    Components.Add(MyLightEnvironment)

    begin object class=StaticMeshComponent Name=BaseMesh
        StaticMesh(0)=StaticMesh'UN_Rock.SM.Mesh.S_UN_Rock_SM_Blackspire05e'
        Scale3D=(X=2,Y=2,Z=2)
        LightEnvironment=MyLightEnvironment
    End object
    Components.Add(BaseMesh)


    RotationRate=(Yaw=0,Roll=0,Pitch=-150000)
	//RotationRate=(Roll=100000)





	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
}