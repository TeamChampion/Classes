/*******************************************************************************
	HDPawn
*******************************************************************************/

class HDPawn extends UDKPawn;

var DynamicLightEnvironmentComponent LightEnvironment;

simulated event PreBeginPlay()
{
	super.PreBeginPlay();
}


//assign the camera
simulated function name GetDefaultCameraMode( PlayerController Requestedby )
{
return 'FreeCam_Default';
}

//play a footstep sound
simulated event playfootstepsound (int footdown)
{
	local SoundCue Footsound;
	Footsound = SoundCue'A_Character_Footsteps.Footsteps.A_Character_Footstep_StoneCue';
	PlaySound(Footsound, false, true,,, true);
}

defaultproperties
{

	Components.Remove(Sprite)

	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bSynthesizeSHLight=TRUE
		bIsCharacterLightEnvironment=TRUE
	End Object
	Components.Add(MyLightEnvironment)
	LightEnvironment = MyLightEnvironment

	Begin Object Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
		bCacheAnimSequenceNodes=FALSE
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		bOwnerNoSee=false
		CastShadow=true
		BlockRigidBody=false
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=TRUE
		bUpdateKinematicBonesFromAnimation=true
		bCastDynamicShadow=true
		Translation=(Z=8.0)
		RBChannel=RBCC_Untitled3
		RBCollideWithChannels=(Untitled3=true)
		LightEnvironment=MyLightEnvironment
		bOverrideAttachmentOwnerVisibility=true
		bAcceptsDynamicDecals=FALSE
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_AimOffset'
		AnimSets(1)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
		SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'
		
		bHasPhysicsAssetInstance=false
		bEnableFullAnimWeightBodies=true
		TickGroup=TG_PreAsyncWork
		MinDistFactorForKinematicUpdate=0.2
		bChartDistanceFactor=true
		RBDominanceGroup=20
		Scale=1
//		MotionBlurScale=0.0
		bAllowAmbientOcclusion=false
	End Object
	Mesh=SkeletalMeshComponent0
	Components.Add(SkeletalMeshComponent0)

	BaseTranslationOffset=0.0

	Begin Object Class=UTAmbientSoundComponent name=AmbientSoundComponent
	End Object
	PawnAmbientSound=AmbientSoundComponent
	Components.Add(AmbientSoundComponent)

	Begin Object Class=UTAmbientSoundComponent name=AmbientSoundComponent2
	End Object
	WeaponAmbientSound=AmbientSoundComponent2
	Components.Add(AmbientSoundComponent2)

	WalkingPct=+0.4
	CrouchedPct=+0.4
	BaseEyeHeight=38.0
	EyeHeight=38.0
//	GroundSpeed=440.0
	GroundSpeed = 150.0 // hassan
	AirSpeed=440.0
	WaterSpeed=220.0
	AccelRate=2048.0
	JumpZ=322.0
	CrouchHeight=29.0
	CrouchRadius=21.0
	WalkableFloorZ=0.78

	AlwaysRelevantDistanceSquared=+1960000.0
//	InventoryManagerClass=class'UTInventoryManager'
//	InventoryManagerClass=class'HDPointclick.EAInventory' // hassan
	MeleeRange=+20.0
	bMuffledHearing=true

	Buoyancy=+000.99000000
	UnderWaterTime=+00020.000000
	bCanStrafe=True
	bCanSwim=true
	RotationRate=(Pitch=20000,Yaw=20000,Roll=20000)
	MaxLeanRoll=2048
	AirControl=+0.35
	bCanCrouch=true
	bCanClimbLadders=True
	bCanPickupInventory=True
	bCanDoubleJump=true
	SightRadius=+12000.0

	MaxMultiJump=1
	MultiJumpRemaining=1
	MultiJumpBoost=-45.0

	MaxStepHeight=26.0
	MaxJumpHeight=49.0

	DamageParameterName=DamageOverlay
	SaturationParameterName=Char_DistSatRangeMultiplier

	TeamBeaconMaxDist=3000.f

	bPhysRigidBodyOutOfWorldCheck=TRUE
	bRunPhysicsWithNoController=true

//	ControllerClass=class'UTGame.UTBot'

	LeftFootControlName=LeftFootControl
	RightFootControlName=RightFootControl
	bEnableFootPlacement=true
	MaxFootPlacementDistSquared=56250000.0 // 7500 squared

	CustomGravityScaling=1.0
	SlopeBoostFriction=0.2
	FireRateMultiplier=1.0

	MaxFallSpeed=+1250.0
	AIMaxFallSpeedFactor=1.1 // so bots will accept a little falling damage for shorter routes

	bReplicateRigidBodyLocation=true

	FeignDeathPhysicsBlendOutSpeed=2.0
	TakeHitPhysicsBlendOutSpeed=0.5

	TorsoBoneName=b_Spine2
	FallImpactSound=SoundCue'A_Character_BodyImpacts.BodyImpacts.A_Character_BodyImpact_BodyFall_Cue'
	FallSpeedThreshold=125.0

	SwimmingZOffset=-30.0
	SwimmingZOffsetSpeed=45.0

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformFall
		Samples(0)=(LeftAmplitude=50,RightAmplitude=40,LeftFunction=WF_Sin90to180,RightFunction=WF_Sin90to180,Duration=0.200)
	End Object
	
	CollisionType=COLLIDE_BlockAll
	Begin Object Name=CollisionCylinder
	CollisionRadius=+21.000000
	CollisionHeight=+48.000000
	End Object
	CylinderComponent=CollisionCylinder



	}
