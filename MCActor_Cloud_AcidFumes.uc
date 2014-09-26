//----------------------------------------------------------------------------
// MCActor_Cloud_AcidFumes
//
// Creates poison cloud
//
// Gustav 2014-09-03
//----------------------------------------------------------------------------
class MCActor_Cloud_AcidFumes extends MCActor_CloudBase;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	MCPR = MCGameReplication(WorldInfo.GRI);
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local vector SpawnLocation;
	local MCStatus MyStatus;

	super.Touch(Other, OtherComp, HitLocation, HitNormal);

	if (MCPawn(Other) != none)
	{
		SpawnLocation = MCPawn(Other).Location;
		SpawnLocation.Z = -1024;

		// do stuff
		if (Role == Role_Authority)
		{
			MyStatus = Spawn(Status.class,,, SpawnLocation,,);
			MyStatus.SetLocation(MCPawn(Other).Location);
			MCPawn(Other).TakeDamage(Spell.damage, none, MCPawn(Other).Location, vect(0,0,0), class'DamageType');
		}
	}
}

// used to Remove Cloud after 10 rounds
simulated event Tick(float DeltaTime)
{
	if (MCPR.GameRound == EndCloudRounds)
	{
		Destroy();
	}
}

simulated function RemoveThisCloud(){}

DefaultProperties
{
	SleepTimer=1.5f
	MovementSpeed=0
	CloudAlpha=1.0f
	CloudBrightness=10.0f
	RemoteRole=ROLE_SimulatedProxy
	Status=MCStatus_AcidMist'MystrasChampionSpells.Status.AcidMist'
	Spell=MCSpell_Acid_Fumes'MystrasChampionSpells.Spells.AcidFumes'
	CloudRounds=2

	Color1=(r=0.0f,		g=1.0f,		b=0.0f);
	Color2=(r=0.0f,		g=1.0f,		b=0.0f);
}