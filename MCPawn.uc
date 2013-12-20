class MCPawn extends UTPawn
    config(MystrasConfig);

var float APf;

// weapon array
var(Inventory) array<MCWeapon> OwnedWeapons; 
// config things for char creation
var config string PlayerName;
var config string PawnName;
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

simulated event PostBeginPlay()
{
    `log("Mystras Champion Pawn spawned");
    debugWeapon();
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
	APf=6.0f

  // sets what state the Pawn should start with
  // Locomotion
  WalkingPhysics=PHYS_Walking
  LandMovementState=PlayerWalking
  WaterMovementState=PlayerSwimming
}