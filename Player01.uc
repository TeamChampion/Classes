class Player01 extends MCPawn;

simulated event PostBeginPlay()
{
  `log("Player 01 is active");
  `log(" --------------------------------------------------------- Player 01 is active");
/*
  `log("Player 01 Current stats"); 

  `log("PlayerName: "   @ PlayerName); 
  `log("PawnName: "     @ PawnName); 
  //`log("School: "       @ School); 
  `log("FirePoints: "   @ FirePoints); 
  `log("IcePoints: "    @ IcePoints); 
  `log("EarthPoints: "  @ EarthPoints); 
  `log("PosionPoints: " @ PosionPoints); 
  `log("ThunderPoints: " @ ThunderPoints); 

  `log("         -------------------          "); 

  `log("currentSpells01: " @ currentSpells01); 
  `log("currentSpells02: " @ currentSpells02); 
  `log("currentSpells03: " @ currentSpells03); 
  `log("currentSpells04: " @ currentSpells04); 
*/
}

defaultproperties
{
   Health=100 // Bots HP
   Name=Player01_Pawn


/*
  Begin Object Name=MyLightEnvironment
    bSynthesizeSHLight=TRUE
    bUseBooleanEnvironmentShadowing=FALSE
    ModShadowFadeoutTime=0.75f
    bIsCharacterLightEnvironment=TRUE
    bAllowDynamicShadowsOnTranslucency=true
  End Object
  Components.Add(MyLightEnvironment)
  // Links it with the Pawn up there
  LightEnvironment=MyLightEnvironment
*/
/*
  Begin Object Class=SkeletalMeshComponent Name=InitialSkeletalMesh
    CastShadow=true
    bCastDynamicShadow=true
    bOwnerNoSee=false
    LightEnvironment=MyLightEnvironment;
        BlockRigidBody=true;
        CollideActors=true;
        BlockZeroExtent=true;

        
    PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_C H_Corrupt_Male_Physics'
    AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman _AimOffset'
    AnimSets(1)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman _BaseMale'
    AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_ Human'
    SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_ CH_LIAM_Cathode'
      */
/*
    PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
    //AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman _AimOffset'
    AnimSets(1)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
    AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
    SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'

      Translation=(Z=8.0)
    //General Mesh Properties
    bCacheAnimSequenceNodes=FALSE
    AlwaysLoadOnClient=true
    AlwaysLoadOnServer=true
    bUpdateSkelWhenNotRendered=false
    bIgnoreControllersWhenNotRendered=TRUE
    bUpdateKinematicBonesFromAnimation=true
    RBChannel=RBCC_Untitled3
    RBCollideWithChannels=(Untitled3=true)
    bOverrideAttachmentOwnerVisibility=true
    bAcceptsDynamicDecals=FALSE
    bHasPhysicsAssetInstance=true
    TickGroup=TG_PreAsyncWork
    MinDistFactorForKinematicUpdate=0.2
    bChartDistanceFactor=true
    RBDominanceGroup=20
    bUseOnePassLightingOnTranslucency=TRUE
    bPerBoneMotionBlur=true
  End Object

  Mesh=InitialSkeletalMesh;
  Components.Add(InitialSkeletalMesh);
  
   IsoCamAngle=8000 //6420 = 35.264 degrees Change this number for the camera angle
   CamOffsetDistance=512 //change this number for camera distance.
   GroundSpeed=256
}
*/
/*
  Begin Object Name=WPawnSkeletalMeshComponent
      //Your Mesh Properties
    SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'
    AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
    PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
    AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
    Translation=(Z=-60.0)
    //General Mesh Properties

    bCacheAnimSequenceNodes=false
    AlwaysLoadOnClient=true
    AlwaysLoadOnServer=true
    CastShadow=true
    BlockRigidBody=true
    bUpdateSkelWhenNotRendered=true
    bIgnoreControllersWhenNotRendered=false
    bUpdateKinematicBonesFromAnimation=true
    bCastDynamicShadow=true
    RBChannel=RBCC_Untitled3
    RBCollideWithChannels=(Untitled3=true)
    LightEnvironment=MyLightEnvironment
    bAcceptsDynamicDecals=false
    bHasPhysicsAssetInstance=true
    TickGroup=TG_PreAsyncWork
    MinDistFactorForKinematicUpdate=0.2f
    bChartDistanceFactor=true
    RBDominanceGroup=20
    bUseOnePassLightingOnTranslucency=true
    bPerBoneMotionBlur=true
    
    bOwnerNoSee=false
    bUpdateSkelWhenNotRendered=false
    bIgnoreControllersWhenNotRendered=TRUE
    bUpdateKinematicBonesFromAnimation=true
    bCastDynamicShadow=true
    RBChannel=RBCC_Untitled3
    RBCollideWithChannels=(Untitled3=true)
    LightEnvironment=MyLightEnvironment
    bOverrideAttachmentOwnerVisibility=true
    bAcceptsDynamicDecals=FALSE
    bHasPhysicsAssetInstance=true
    TickGroup=TG_PreAsyncWork
    MinDistFactorForKinematicUpdate=0.2
    bChartDistanceFactor=true
    RBDominanceGroup=20
    bUseOnePassLightingOnTranslucency=TRUE
    bPerBoneMotionBlur=true
    
  End Object
  Mesh=WPawnSkeletalMeshComponent
  Components.Add(WPawnSkeletalMeshComponent)

  Begin Object Name=CollisionCylinder
    CollisionRadius=+0021.000000
    CollisionHeight=+0044.000000
  End Object
  CylinderComponent=CollisionCylinder
*/






  
  //ControllerClass=class'UTGame.UTBot'
  //PlayerControllerClass=class'MystrasChampion.MCPlayerController'
  //bCollideActors=true
}