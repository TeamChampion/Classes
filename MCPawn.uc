//----------------------------------------------------------------------------
// MCPawn
//
// Main Character settings
// @TODO make abstract, add function that removes everything from character
// and set base back to him. So we can Spawn him more efficiently
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCPawn extends UTPawn
	config(MystrasConfig);


// Character Information
var repnotify config string PawnName;
var config string PawnName2;
var(MystStats) int MaxAP;
// His PlayerController
var MCPlayerController PC;
// Decal for showing something under a pawn
var DecalComponent MyDecal;
var MCTile TouchingTile;
// Spells
var(MystSpells) archetype array <MCSpell> MyArchetypeSpells;
// All Spells in a list
var archetype MCSpellArchetypeList MySpellList;
// Inventory
var(Inventory) array<MCItem_Weapon> OwnedWeapons;
var(Inventory) archetype MCInventory MyInventory;	// @TODO set it to something, like archetype
// Is Character created
var config bool bSetLevelLoadChar;

// Stats Character is using 
var config int FirePoints, IcePoints, EarthPoints, PosionPoints, ThunderPoints, currentSpells01, currentSpells02, currentSpells03, currentSpells04;
enum ESchool
{
	SCHOOL_Volcano,
	SCHOOL_FrozenLake,
	SCHOOL_IronTower,
	SCHOOL_HeavensGate,
	SCHOOL_CrystalMist,
	SCHOOL_None
};

// For Multiplayer replication
var repnotify float APf;
var repnotify int PlayerUniqueID;	// when this value changes ReplicatedEvent below is fired
var repnotify bool bHaveAp;
var float APfMax;					// set max AP
var int Level;
var repnotify bool bSetTiles;

// Replication block
replication
{
	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		PawnName, PlayerUniqueID, APf, bHaveAp, MyDecal, bSetTiles;

	// Replicate on first replication update
	if(bNetInitial)
		APfMax, Level;

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
	}
	if (varname == 'APf')
	{
		if (APf < 30 )
		{
			bHaveAp = true;
			MCPlayerReplication(PlayerReplicationInfo).bHaveAP = bHaveAp;
		}
		if (APf == 0)
		{
			bHaveAp = false;
			MCPlayerReplication(PlayerReplicationInfo).bHaveAP = bHaveAp;
		}
	//	MCPlayerReplication(PlayerReplicationInfo).APf = APf;
	}
	if (varname == 'PawnName')
	{
		`log("CHANGE IN NAME" @ PawnName);
	//	MCPlayerReplication(PlayerReplicationInfo).PawnName = PawnName;
	}
	if (varname == 'bHaveAp')
	{
	//	MCPlayerReplication(PlayerReplicationInfo).bHaveAP = bHaveAp;
	}
	if (VarName == 'bSetTiles')
	{
		if (bSetTiles)
		{
		//	MCPlayerReplication(PlayerReplicationInfo).SetTilesInsidePC(PlayerUniqueID);
			// Use function in PlayerReplication
			`log("bSetTiles="@bSetTiles@"- We Use a function Inside PlayerReplication" @ PC.PlayerUniqueID);	// Don't have this yet????
			`log("bSetTiles="@bSetTiles@"- We Use a function Inside PlayerReplication" @ PlayerUniqueID);
		//	MCPlayerReplication(PlayerReplicationInfo).SetTilesInsidePC(PlayerUniqueID);
			// Turn this off after Function Use
		//	bSetTiles = false;
		}else
		{
			// Do nothing
			`log("bSetTiles="@bSetTiles@"- We Use nothing "@ PC.PlayerUniqueID);
		}
		bSetTiles = false;
	}
}

simulated event PostBeginPlay()
{
	// @OUTOFBOUNDS
	/*
	// Adding arhetypes
	AddSpells(currentSpells01, 0);
	AddSpells(currentSpells02, 1);
	AddSpells(currentSpells03, 2);
	AddSpells(currentSpells04, 3);
	*/

//	PawnName = PawnName2;

	// Debug check weapons list
//	debugWeapon();
	super.PostBeginPlay();
}

simulated function AddSpells(int SpellNumber, int SpellSlot)
{
	local MCSpell SpellName;

	// Search for Spells in List we have in an Archetype
	foreach MySpellList.AllArchetypeSpells(SpellName)
	{
		// If searched result is the same as created spell, save it in the character
		if (SpellName.spellNumber == SpellNumber)
		{
			//  `log("found Spell" @ SpellName.spellNumber);
			MyArchetypeSpells[SpellSlot] = SpellName;
		}
	}
}

function AddInventory(array<string> MyInventoryThing)
{
	
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

//	newPlace.x = 0.0f;
//	newPlace.y = 0.0f;
//	newPlace.z = 0.0f;
											// 		1 			2 		3 			4 		 5 		6 		7			15
	// Spawn decal for 10 mins = 600.0f
	MyDecal = WorldInfo.MyDecalManager.SpawnDecal(MyDecalColor,newPlace,newRotation,200.0f, 200.0f,500.0f,false,,,,,,,,600.0f);
	MyDecal.bMovableDecal = true;

	MyDecalColor = MaterialInstanceConstant'mystraschampionsettings.Decals.CharacterDecal_INST';
	if (MyDecal != None)
	{
		if (MyDecal.GetDecalMaterial() != None)
		{
			MyDecalColor = new class'MaterialInstanceConstant';
			MyDecalColor.SetParent(MyDecal.GetDecalMaterial());

			if (PlayerUniqueID == 1)
			{
				MatColor = MakeLinearColor(0.0f, 0.0f, 1.0f, 1.0f);
			}else if (PlayerUniqueID == 2)
			{
				MatColor = MakeLinearColor(1.0f, 0.0f, 0.0f, 1.0f);
			}
			MyDecalColor.SetVectorParameterValue('SetColor', MatColor);
			MyDecal.SetDecalMaterial(MyDecalColor);
		}
	}
	AttachComponent(MyDecal);

}

/**
 * Called every time the pawn is updated
 *
 * @param		DeltaTime		Time since the last time the pawn was updated
 * @network						Server and client
 */
 
simulated function Tick(float DeltaTime)
{
	local MCPlayerReplication MCPRep;

	Super.Tick(DeltaTime);

	// Set extra name to Pawn Name
//	PawnName = PawnName2; 

	if (MyDecal != none)
	{
		// We set a new Decal when timer runs out, after 10 minutes
		if (MyDecal.Location.X == 0.0f && MyDecal.Location.Y == 0.0f && MyDecal.Location.Z == 0.0f)
		{
			MyDecal = none;
			SpawnDecal();
			`log("Reattach Decal!" @ MyDecal @ MyDecal.Location @ "MyPawnLoc=" @ Location);
		}
	}


	if (PC != none)
	{
		MCPRep = MCPlayerReplication(PC.PlayerReplicationInfo);	
	}else
	{
		return;
	}

	if (Role == Role_Authority)
	{
		// Update the health
		MCPRep.Health = Health;

		// Update AP variables
		MCPRep.bHaveAp = bHaveAp;
		MCPRep.APf = APf;

		// Update PawnName
//		MCPRep.PawnName = PawnName;
	}

}


/*
// Set a Special Color to the spawned character ID
*/
simulated function changePlayerColor()
{
	local materialinterface mainMat;

// We have no PC here yet it seems
//	PC.ClientMessage("ran with this id" @ PlayerUniqueID);

	//Show player pawn dying if it was sent a default playerID value
	//This indicates the YourUniqueID is NOT being replicated correctly.
	if (PlayerUniqueID == 0)
	{
		PlayDying(none, vect(0,0,0));
	}

	// red
	if (PlayerUniqueID == 1)
	{
		mainMat = Material'mystraschampionsettings.Materials.CharBlack';
	}
	// black
	else if (PlayerUniqueID == 2)
	{
		mainMat = Material'mystraschampionsettings.Materials.CharRed';
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

function debugWeapon()
{
	local int i;

	for (i = 0; i < OwnedWeapons.Length; i++)
	{
		`log("------------- itemName " @ OwnedWeapons[i].sItemName @ "    Prize " @ OwnedWeapons[i].Cost @ "    Description " @ OwnedWeapons[i].sDescription);
	}
}

/*
// Functions that says what PlayerController this Pawn is using
*/
simulated function setYourPC(MCPlayerController pci)
{
	PC = pci;
}

/*
// Take Damage from projectiles when being hit
// In MCTile also set Pawn to take damage when walking over a spell affected Tile
*/
event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

	`log("In MCPawn.uc - Current HP =" @ Health @ "   Current Damage =" @ Damage);

	// Only Works from PC PlayerReplication && Server atm
	if (PlayerReplicationInfo != none)
	{
		MCPlayerReplication(PlayerReplicationInfo).Health = Health;
	}

}


// Server only
simulated event Destroyed()
{
	// Because this guy in here dies before it replicates the health. Inside of PC update his health so it says 0
	MCPlayerReplication(PC.PlayerReplicationInfo).Health = 0;
	// Send Message
	PC.SendWinLoseToReplication();

	super.Destroyed();
	///
}

/*
simulated function SetMeshVisibility(bool bVisible)
{
	super.SetMeshVisibility(bVisible);
	Mesh.SetOwnerNoSee(false);
}

function GFxResetChar()
{
	PlayerName = "none";
	PawnName   = "none";;
	bSetLevelLoadChar = false;
	SaveConfig();
}

public function TouchedATileWithCost(float Cost)
{
	`log("Check AP");
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
}

simulated function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
}
*/
DefaultProperties
{
	// Spell List
	MySpellList = MCSpellArchetypeList'MystrasChampionSpells.SpellList.AllArchetypeSpells'

	WalkingPhysics=PHYS_Walking
//	LandMovementState=PlayerWalking
//	LandMovementState=Idle
//	WaterMovementState=PlayerSwimming
	Role = ROLE_Authority
	RemoteRole = ROLE_SimulatedProxy
}