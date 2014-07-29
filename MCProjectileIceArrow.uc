//----------------------------------------------------------------------------
// MCProjectileIceArrow
//
// Ice Arrow Projectile base settings
//
// Gustav Knutsson 2014-07-17
//----------------------------------------------------------------------------
class MCProjectileIceArrow extends MCProjectile;

Simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local MCPawn Target;

	// Find Attacked Person
	foreach DynamicActors(Class'MCPawn', Target)
	{
		if (Other == Target)
		{
		//	`log("This Person is the same" @ Other @ Target);
			break;
		}
	}

	// In here set the Status link, only on Server
	if (Target != none && (WorldInfo.NetMode == NM_DedicatedServer) || (WorldInfo.NetMode == NM_ListenServer) )
	{
		/*
		`log("---------------------------------------------");
		`log("Find PlayerReplication=" @ Target.PlayerReplicationInfo);
		`log("Find PlayerController =" @ Target.PC);
		`log("Find AP =" @ Target.APf);
		`log("---------------------------------------------");
		`log("Do we have a MCStatus" @ Status);
		`log("StatusName =" @ Status.StatusName);
		`log("StatusDamage.AP =" @ Status.StatusDamage.AP);
		`log("StatusDamage.DamagePercent =" @ Status.StatusDamage.DamagePercent);
		`log("StatusDamage.Damage =" @ Status.StatusDamage.Damage);
		`log("StatusDurration =" @ Status.StatusDuration);
		`log("---------------------------------------------");
		*/


	//	Target.APf = 15;
	}

	super.Touch(Other, OtherComp, HitLocation, HitNormal);
}

defaultproperties
{
	MCProjFlightTemplate=ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_DecoyFlare'
	MCProjExplosionTemplate=ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_Decoy_Explo'

	Speed=2
	MaxSpeed=500
	AccelRate=200

	Damage=30
	DamageRadius=16
	MomentumTransfer=0
	CheckRadius=36.0

//	LifeSpan=1
	NetCullDistanceSquared=+144000000.0
	MaxEffectDistance=7000.0
	bCollideWorld=true
	DrawScale=1.0
	Physics=PHYS_Projectile


	// Light Source
	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=TRUE
	End Object
	Components.Add(MyLightEnvironment)

	// Static Mesh
	Begin object class=StaticMeshComponent Name=BaseMesh
		StaticMesh(0)=StaticMesh'MystrasChampionSpells.StaticMesh.IceSpikeMesh'
		Scale=1.5
		Rotation=(Pitch=-20000,Yaw=0,Roll=0)
		LightEnvironment=MyLightEnvironment
	End object
	Components.Add(BaseMesh)

//	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
}