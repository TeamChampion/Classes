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

/*
// Character Information
*/
var repnotify config string PawnName;				// Character Name
var config string PawnName2;						// Other Character Name
var config bool bSetLevelLoadChar;					// Is Character created
var int MaxAP;										// MaxAP
var(Inventory) archetype MCInventory MyInventory;	// @TODO set it to something, like archetype, @TODO2 Put this in MCPlayerController
// Stats Character is using 
//var config int FirePoints, IcePoints, EarthPoints, AcidPoints, ThunderPoints, currentSpells01, currentSpells02, currentSpells03, currentSpells04;

/*
// Other
*/
var archetype MCSpellArchetypeList MySpellList;	// All Spells in a list
var MCPlayerController PC;						// His PlayerController
var DecalComponent MyDecal;						// Decal for showing something under a pawn

/*
// For Multiplayer replication
*/
var repnotify float APf;			// Current AP
var repnotify int PlayerUniqueID;	// when this value changes ReplicatedEvent below is fired
var float APfMax;					// set max AP

/*
// Don't Know yet. maybe remove
*/
var float CurrentStartAPf;		// Show What Current AP we have from PC.TurnBased()
var bool bHaveAp;				// used for seeing which player has AP to show Reset AP button in battlehud, @NOTBEING_USED
var int Level;					// Current Level for charachter @NOTBEING_USED
//enum ESchool{	SCHOOL_Volcano,	SCHOOL_FrozenLake,	SCHOOL_IronTower,	SCHOOL_HeavensGate,	SCHOOL_CrystalMist,	SCHOOL_None		}; //  @NOTBEING_USED
//var(MystSpells) archetype array <MCSpell> MyArchetypeSpells;


// Replication block
replication
{
	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		PawnName, PlayerUniqueID, APf, bHaveAp, MyDecal, CurrentStartAPf;

	// Replicate on first replication update
	if(bNetInitial)
		APfMax, Level;

}

simulated event ReplicatedEvent(name VarName)
{	
	super.ReplicatedEvent( VarName ); 

	//update mesh color, as color is based on ID value
	if (varname == 'PlayerUniqueID')
	{
		changePlayerColor();
		SpawnDecal();
	}
	// Handle AP calculation
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
	}
	if (varname == 'PawnName')
	{
		`log("CHANGE IN NAME" @ PawnName);
	//	MCPlayerReplication(PlayerReplicationInfo).PawnName = PawnName;
	}
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

	super.PostBeginPlay();
}
/*
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
*/


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

	// Spawn decal for 10 mins = 600.0f
	MyDecal = WorldInfo.MyDecalManager.SpawnDecal(MyDecalColor,newPlace,newRotation,200.0f, 200.0f,500.0f,false,,,,,,,,3600.0f);
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
simulated event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	
	if (Role == Role_Authority)
	{
		if (Health <= 0)
		{
			MCPlayerReplication(PC.PlayerReplicationInfo).Health = 0;
			MCPlayerReplication(PlayerReplicationInfo).Health = 0;
			Health = 0;
			PC.SendWinLoseToReplication(false);
		}
	}
}


// Server only
simulated event Destroyed()
{
	`log("=============================");
	`log("Not here Fucker");
	`log("=============================");
	/*
	// Because this guy in here dies before it replicates the health. Inside of PC update his health so it says 0
	MCPlayerReplication(PC.PlayerReplicationInfo).Health = 0;
	MCPlayerReplication(PlayerReplicationInfo).Health = 0;
	Health = 0;
	*/
	// Send Message
	PC.SendWinLoseToReplication(false);

	super.Destroyed();
	///
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	super.Touch(Other, OtherComp, HitLocation, HitNormal);
	//
	if(MCActor_CloudBase(Other) != none)
	{

		`log("-----------------------------------------------");
		`log("-" @ "We Touched" @ Other);
		`log("-" @ "We Touched" @ Other);
		`log("-" @ "We Touched" @ Other);
		`log("-----------------------------------------------");

	}
}


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