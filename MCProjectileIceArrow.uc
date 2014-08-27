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

/*
simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local MCPawn Target;
	local MCStatus_Frost AddStatus;

	// Find Attacked Person
	foreach DynamicActors(Class'MCPawn', Target)
	{
		if (Other == Target)
		{
		//	`log("This Person is the same" @ Other @ Target);
			break;
		}
	}


	if (Target != none && Status != none)
	{
		// Initialize it
		AddStatus = Spawn(Class'MCStatus_Frost');

		// Add the archetype inside here
		AddStatus.StatusName = Status.StatusName;
		AddStatus.StatusDamage = Status.StatusDamage;
		AddStatus.StatusDuration = Status.StatusDuration;

		// In here set the Status link, only on Server
		if ((WorldInfo.NetMode == NM_DedicatedServer) || (WorldInfo.NetMode == NM_ListenServer) )
		{


			AddingSpell(Target,AddStatus);
		}else
		{
			AddingSpell(Target,AddStatus);
		}
	}

	super.Touch(Other, OtherComp, HitLocation, HitNormal);
}
*/
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



/*
// Adding a certain status on inpact to both Server && Client
// @param 	TargetChar			
// @param 	MCStatus_Frost		
*/
/*
simulated function AddingSpell(MCPawn TargetChar, MCStatus_Frost WhatStatus)
{
	local int i;			

	// Add it
	for (i = 0;i < 10 ; i++)
	{
		if (TargetChar.MyStatus[i] == none)
		{
			TargetChar.AddStatus(WhatStatus,i);
			break;
		}else
		{
		//	`log(i @ "- WTF SOMETHING HERE in" @ name @ "This=" @ Target.MyStatus[i]);
		}
	}
	
}
*/

defaultproperties
{
	MCProjFlightTemplate=ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_DecoyFlare'
	MCProjExplosionTemplate=ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_Decoy_Explo'

	Speed=100
	MaxSpeed=900
	AccelRate=200

	Damage=30
	DamageRadius=50
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