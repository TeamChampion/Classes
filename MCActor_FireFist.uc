//----------------------------------------------------------------------------
// MCActor_FireFist
//
// Fore Fire Fist spell, toss a Lava Rock
// @ADD, better movement, block on rigid bodies
//
// Gustav Knutsson 2014-08-29
//----------------------------------------------------------------------------
class MCActor_FireFist extends MCActor;

var Vector ExtraSpawnSpace;

simulated function Vector CalcRoute(float DeltaTime)
{
	local float delta_distance;
	local vector NewDestination;
	local vector normalVect;
	local float CurrentMiddlePoint;
	local Vector FlooredLocation;
	local Vector FlooredEndDestination;
	local Vector ModifiedLocation;

	// Set Floored Location so that we can check Current Middle Point
	FlooredLocation = Location;
	FlooredLocation.Z = 0.0f;
	FlooredEndDestination = EndDestination;
	FlooredEndDestination.Z = 0.0f;

	// Calculate Speed
	delta_distance = (DeltaTime) * MovementSpeed;

	// Get Current Middle Point Where we are at
	CurrentMiddlePoint = (VSize(FlooredLocation - FlooredEndDestination));

	// Get Direction
	normalVect = Normal( StartDestination - EndDestination );


	// Set Direction
	NewDestination.X = (-normalVect.X * delta_distance);
	NewDestination.Y = (-normalVect.Y * delta_distance);

	// 300					600
	if (MiddlePoint < CurrentMiddlePoint)
	{
/*
		if ( CurrentMiddlePoint >= ( (MiddlePoint * 0.75f) + MiddlePoint) )
		{
			NewDestination.Z += (delta_distance * 2.0f);
		}
		else if ( CurrentMiddlePoint >= ( (MiddlePoint * 0.50f) + MiddlePoint) )
		{
			NewDestination.Z += (delta_distance * 1.6f);
		}
		else if ( CurrentMiddlePoint >= ( (MiddlePoint * 0.20f) + MiddlePoint) )
		{
			NewDestination.Z += (delta_distance * 1.1f);
		}
*/
		NewDestination.Z += (delta_distance * 2.0f);
		
	}else
	{
/*
		if ( CurrentMiddlePoint >= (MiddlePoint * 0.80f) )
		{
			`log("120%" );
			NewDestination.Z -= (delta_distance * 1.1f);
		}
		else if ( CurrentMiddlePoint >= (MiddlePoint * 0.50f) )
		{
			`log("150%" );
			NewDestination.Z -= (delta_distance * 1.6f);
		}
		else if ( CurrentMiddlePoint >= (MiddlePoint * 0.25f) )
		{
			`log("175%" );
			NewDestination.Z -= (delta_distance * 2.0f);
		}
*/
		NewDestination.Z -= (delta_distance * 2.0f);

		if (CurrentMiddlePoint < 10.0f)
		{
			if (Role == ROLE_Authority)
			{
				ModifiedLocation = WhatTile.Location;
				ModifiedLocation += ExtraSpawnSpace;
				if (!WhatTile.bSpellTileMode)
				{
					WhatTile.ActivateFireFountain(SetDamage);
					Spawn(class'MCActor_FireFountain', , ,ModifiedLocation);	
				}
				Caster.PC.CheckCurrentAPCalculation();
			}
			Destroy();
		}
	}

	return NewDestination;
}

simulated event Tick(float DeltaTime)
{
	if (MiddlePoint > 0 && WhatTile != none && SetDamage != 0)
	{
		Move(CalcRoute(DeltaTime));
	}
}

simulated function SetMiddlePoint()
{
	MiddlePoint = (VSize(StartDestination - EndDestination) / 2);
}

// Leave empty here so we don't use previous one
auto simulated state Moving
{

}

DefaultProperties
{
	SleepTimer=10.0f
	MovementSpeed=200
	ExtraSpawnSpace=(	X=6,	Y=-12,	Z=-22 	)
	smoke = ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_Dust_Secondary';

	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true

	Begin Object class=StaticMeshComponent name=RockMesh
		StaticMesh=StaticMesh'mystrasmain.StaticMesh.RockBlocker'
		Materials(0)=Material'MystrasChampionSpells.Materials.FireFountain_02'
		Scale=1.7
		BlockActors = true	// Make so that it blocks shots
	End Object

	Begin Object class=DynamicLightEnvironmentComponent name=myLightEnvironment
		bEnabled=true
	End Object

	Components.Add(RockMesh)
	Components.Add(myLightEnvironment)
	//CollisionComponent=RockMesh
	bCollideActors=true 
	bBlockActors=true
}