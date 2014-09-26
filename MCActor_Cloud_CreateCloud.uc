//----------------------------------------------------------------------------
// MCActor_Cloud_CreateCloud
//
// Create Cloud
//
// Gustav 2014-09-03
//----------------------------------------------------------------------------
class MCActor_Cloud_CreateCloud extends MCActor_CloudBase;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	MCPR = MCGameReplication(WorldInfo.GRI);
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	super.Touch(Other, OtherComp, HitLocation, HitNormal);

	if (MCPawn(Other) != none)
	{
		// do stuff
		if (Role == Role_Authority)
		{

		}
	}
}

// used to Remove Cloud after 10 rounds
simulated event Tick(float DeltaTime)
{
	if (MCPR.GameRound == EndCloudRounds)
		Destroy();
}

simulated function RemoveThisCloud(){	Destroy();	}

DefaultProperties
{
	SleepTimer=1.5f
	MovementSpeed=0
	CloudAlpha=1.0f
	CloudBrightness=10.0f
	Spell=MCSpell_Scourge'MystrasChampionSpells.Spells.Scourge'
	CloudRounds=10

	Color1=(r=1.0f,		g=1.0f,		b=1.0f);
	Color2=(r=1.0f,		g=1.0f,		b=1.0f);
}