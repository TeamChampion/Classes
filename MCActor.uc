//----------------------------------------------------------------------------
// MCActor
//
// Base Actor used for All other actors
// Also used for searching for a specific actor and then destroy it
//
// Gustav 2014-07-29
//----------------------------------------------------------------------------
class MCActor extends Actor;

// Move Speed
var float MovementSpeed;
// Do we have a Smoke or not when Spawning or Destroying
var ParticleSystem smoke;

// Things For Firefist
var Vector StartDestination;
var Vector EndDestination;		// Where we are suppose to Stop movement towards
var float MiddlePoint;			// Where we should start going the other way
var MCTile WhatTile;			// What Tile we are affecting (landing on)
var int SetDamage;				// How much Damage we are setting

// Set Pawn
var MCPawn Caster;
// Set Sleep Timer
var float SleepTimer;

// Cloud rounds
var int CloudRounds;
var int EndCloudRounds;

// Set spellNumber for Status adding
var int spellNumber;
var int Damage;

// Status Information
var archetype MCStatus Status;
// Spell Information
var archetype MCSpell Spell;

Replication
{
	if (bNetDirty)
		smoke, Caster;

	// For Fire Fist
	if (bNetDirty)
		EndDestination, MiddlePoint, WhatTile, SetDamage, EndCloudRounds;
}

auto simulated state Moving
{
Begin:
	Sleep(SleepTimer);
	GotoState('Idle');
}

simulated state Idle
{
	ignores Tick;
	
	function BeginState(Name PreviousStateName)
	{
		// Reset Spells here and do a AP Check to see if we can continue
		if(Caster != none)
		{
			Caster.PC.CheckCurrentAPCalculation();
			Caster.PC.InstantiateSpell = none;
		}
			
		Super.BeginState(PreviousStateName);
	}
}


// Spawn Smoke at start
simulated function PostBeginPlay()
{
	local Vector newLocation;

	super.PostBeginPlay();

	StartDestination = Location;

	newLocation = Location + vect(0,0,60);
	if (smoke != none)
	{
		if (Role != ROLE_Authority || (WorldInfo.NetMode == NM_ListenServer) )
			WorldInfo.MyEmitterPool.SpawnEmitter(smoke, newLocation);
	}
}

// When We Destroy This Element It set's off an Explosion
simulated event Destroyed()
{
	local Vector newLocation;

	newLocation = Location + vect(0,0,60);
	if (smoke != none)
	{
		if (Role != ROLE_Authority || (WorldInfo.NetMode == NM_ListenServer) )
			WorldInfo.MyEmitterPool.SpawnEmitter(smoke, newLocation);	
	}
	super.Destroyed();
}

// Used In FireFist
simulated function SetMiddlePoint(){}

DefaultProperties
{

}