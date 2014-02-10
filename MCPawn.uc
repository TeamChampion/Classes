class MCPawn extends UTPawn
    config(MystrasConfig);




// weapon array
var(Inventory) array<MCWeapon> OwnedWeapons; 
// config things for char creation
var config bool bSetLevelLoadChar;
// Need to make another enum
//var(MystStats) config ESchool School;

var config int FirePoints;
var config int IcePoints;
var config int EarthPoints;
var config int PosionPoints;
var config int ThunderPoints;

var config int currentSpells01;
var config int currentSpells02;
var config int currentSpells03;
var config int currentSpells04;

enum ESchool
{
  SCHOOL_Volcano,
  SCHOOL_FrozenLake,
  SCHOOL_IronTower,
  SCHOOL_HeavensGate,
  SCHOOL_CrystalMist,
  SCHOOL_None
};

var float Modifier;

var(MystStats) array <Sequence> SpellList;
var(MystStats) int AP;
var(MystStats) int MaxAP;
var(MystSpells) string MySpells[4];
var(MystSpells) array <string> MyDynamicSpells;

///////////////////////////////////////////////////////////////////////////////////////////////

// His PlayerController
var MCPlayerController PC;
// Decal for showing something under a pawn
var DecalComponent MyDecal;
var MCTile TouchingTile;

var repnotify float APf;

var() config string PlayerName;
var() repnotify config string PawnName;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Understanding Replication

// copies/instances of this pawn exist on all clients

// and start with vars set to default values

// Only these variables will be constantly transferred

// for those copied versions
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//================
// Multiplayer
//================

//when this value changes ReplicatedEvent below is fired
var repnotify int PlayerUniqueID;
//when this value changes ReplicatedEvent below is fired
var repnotify bool bHaveAp;

///////////////////////////////////////////////////////////////////////////////////////////////

// Replication block
replication
{
  // Replicate only if the values are dirty, this replication info is owned by the player and from server to client
//  if (bNetDirty && bNetOwner)
//    APf;

  // Replicate only if the values are dirty and from server to client
  if (bNetDirty)
    PawnName, PlayerUniqueID, APf, bHaveAp, MyDecal;
}

simulated event ReplicatedEvent(name VarName)
{
  //very important line
  super.ReplicatedEvent( VarName ); 
        
  //update mesh color, as color is based on ID value
  if (varname == 'PlayerUniqueID')
  {
    changePlayerColor();
    SpawnDecal();
  //  MCPlayerReplication(PlayerReplicationInfo).Health = HealthMax;
  //  MCPlayerReplication(PlayerReplicationInfo).Health = Health;
  }
  if (varname == 'APf')
  {
    if (APf < 10 )
    {
      bHaveAp = true;
      MCPlayerReplication(PlayerReplicationInfo).bHaveAP = bHaveAp;
    }
    if (APf == 0)
    {
      bHaveAp = false;
      MCPlayerReplication(PlayerReplicationInfo).bHaveAP = bHaveAp;
    }
    MCPlayerReplication(PlayerReplicationInfo).APf = APf;
    //`log("Player" @ self.PawnName @ "just got" @ self.APf @ "AP");
  }
  if (varname == 'PawnName')
  {
    //MCPlayerReplication(PlayerReplicationInfo).PawnName = PawnName;
  }
  if (varname == 'bHaveAp')
  {
   // MCPlayerReplication(PlayerReplicationInfo).bHaveAP = bHaveAp;
  }
}

simulated event PostBeginPlay()
{
    `log("Mystras Champion Pawn spawned");
    debugWeapon();
    super.PostBeginPlay();
}

/*
// Spawn a Decal Under the Pawn to show where he is
*/
simulated function SpawnDecal()
{
  local Vector newPlace;
  local Rotator newRotation;
  local MaterialInstanceConstant MyDecalColor;
  local LinearColor MatColor;

  MyDecalColor = MaterialInstanceConstant'mystraschampionsettings.Decals.CharacterDecal_INST';

  newRotation.Roll = 0;
  newRotation.Yaw = 0;
  newRotation.Pitch = -16384;

  newPlace.x = 0.0f;
  newPlace.y = 0.0f;
  newPlace.z = 0.0f;

  MyDecal = WorldInfo.MyDecalManager.SpawnDecal(MyDecalColor,newPlace,newRotation,200.0f, 200.0f,500.0f,false);
  MyDecal.bMovableDecal = true;
  
  if (MyDecal != None)
  {      
    if (MyDecal.GetDecalMaterial() != None)
    {
        MyDecalColor = new class'MaterialInstanceConstant';
        MyDecalColor.SetParent(MyDecal.GetDecalMaterial());

        if (PlayerUniqueID == 1)
        {
            MatColor = MakeLinearColor(1.0f, 0.0f, 0.0f, 1.0f);
        }else if (PlayerUniqueID == 2)
        {
            MatColor = MakeLinearColor(0.0f, 0.0f, 1.0f, 1.0f);
        }
        MyDecalColor.SetVectorParameterValue('SetColor', MatColor);
        MyDecal.SetDecalMaterial(MyDecalColor);
    }
  }
  AttachComponent(MyDecal);
}

simulated function Tick(float DeltaTime)
{
  super.Tick(DeltaTime);

  ///
}

/*
Functions that says what PlayerController this Pawn is using
*/
simulated function setYourPC(MCPlayerController pci)
{
  PC = pci;
    
  `log("~~~~~~~~~~> PC was set for"@self.name@ "to" @ PC.name);
}

simulated function changePlayerColor()
{
  local materialinterface mainMat;

  PC.ClientMessage("ran with this id" @ PlayerUniqueID);

  //Show player pawn dying if it was sent a default playerID value
  //This indicates the YourUniqueID is NOT being replicated correctly.
  if (PlayerUniqueID == 0)
  {
    PlayDying(none, vect(0,0,0));
  }

  // red
  if (PlayerUniqueID == 1)
  {
    mainMat = Material'mystraschampionsettings.Materials.CharRed';
  }

  // black
  else if (PlayerUniqueID == 2)
  {
    mainMat = Material'mystraschampionsettings.Materials.CharBlack';
  }

  // gold
  else if (PlayerUniqueID == 3)
  {
    mainMat = Material'mystraschampionsettings.Materials.CharGold';
  }

  // silver
  else
  {
    mainMat = Material'mystraschampionsettings.Materials.CharSilver';
  }

  //in my skeletal mesh case these are the correct indicies
  //of the parts of skeletal mesh to change material for

  mesh.SetMaterial(0, mainMat);   //chest
  mesh.SetMaterial(1, mainMat);   //head
  mesh.SetMaterial(3, mainMat);   //boots
  mesh.SetMaterial(4, mainMat);   //legs
  mesh.SetMaterial(5, mainMat);   //arms
  mesh.SetMaterial(7, mainMat);   //arm guard
  mesh.SetMaterial(8, mainMat);   //hands

}

simulated function SetMeshVisibility(bool bVisible)
{
    super.SetMeshVisibility(bVisible);
    Mesh.SetOwnerNoSee(false);
}

function debugWeapon()
{
	local int i;

	for (i = 0; i < OwnedWeapons.Length; i++)
	{
		`log("------------- itemName " @ OwnedWeapons[i].itemName @ "    Prize " @ OwnedWeapons[i].Prize @ "    Description " @ OwnedWeapons[i].Description);
	}
}

public function TouchedATileWithCost(float Cost)
{
   `log("Check AP");
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GFxResetChar()
{
  PlayerName = "none";
  PawnName   = "none";;
  bSetLevelLoadChar = false;
  SaveConfig();
}

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
  if(MCTile(Other) != none && MCTile(Other).damage > 5)
  {
    //MCTile(Other).damage
    TouchingTile = MCTile(Other);
    TakeDamage(MCTile(Other).damage, none, Location,vect(0,0,0),class'UTDmgType_LinkPlasma');
//    `log("My HP" @ Health);
//    `log("Damage = " @ MCTile(Other).damage);
  }

  super.Touch(Other, OtherComp, HitLocation, HitNormal);
  //
}



event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
  super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
  // Damage
  Health -= Damage;

  MCPlayerReplication(PlayerReplicationInfo).Health = HealthMax;
  MCPlayerReplication(PlayerReplicationInfo).Health = Health;
  ///
}

// Is not using anymore since I removed big file
/*
function GfxGetSet(SeqAct_createGetSet GFxSG)
{
  PlayerName    = GFxSG.GfxName;
  PawnName      = GFxSG.GfxName;
  //School        = GFxSG.GfxAcademy;

  FirePoints    =   GFxSG.GfxFire;
  IcePoints     =   GFxSG.GfxIce;
  EarthPoints   =   GFxSG.GfxEarth;
  PosionPoints  =   GFxSG.GfxPoison;
  ThunderPoints =   GFxSG.GfxThunder;

  currentSpells01   = GFxSG.GfxSpell01;
  currentSpells02   = GFxSG.GfxSpell02;
  currentSpells03   = GFxSG.GfxSpell03;
  currentSpells04   = GFxSG.GfxSpell04;

  bSetLevelLoadChar = true; 

  `log("--------------------------------------------------"); 
  `log("--------------------------------------------------"); 
  `log("Player Set stats"); 

  `log("PlayerName: "   @ PlayerName); 
  `log("PawnName: "     @ PawnName); 
  `log("School: "       @ School); 
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


  `log("--------------------------------------------------"); 
  `log("--------------------------------------------------"); 

  SaveConfig();
}
*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////






defaultproperties
{

  // sets what state the Pawn should start with
  // Locomotion
  WalkingPhysics=PHYS_Walking
//  LandMovementState=PlayerWalking
//  LandMovementState=Idle
//  WaterMovementState=PlayerSwimming

  Role = ROLE_Authority
  RemoteRole = ROLE_SimulatedProxy
}