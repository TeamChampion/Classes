//----------------------------------------------------------------------------
// MCActor_AcidRain
//
// For MCSpell_AcidRain, spawn this actor and check if we touch anyone
//
// Gustav 2014-09-07
//----------------------------------------------------------------------------
class MCActor_AcidRain extends MCActor;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}


/*
// When arrive here, Check for AP and then destroy
*/
simulated state Idle
{
	ignores Tick;
	
	function BeginState(Name PreviousStateName)
	{
		if(Caster != none)
			Caster.PC.CheckCurrentAPCalculation();
		Super.BeginState(PreviousStateName);
		Destroy();
	}
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

		if (Role == ROLE_Authority)
		{		
			// Do damage
			MCPawn(Other).TakeDamage(Spell.damage, none, MCPawn(Other).Location, vect(0,0,0), class'DamageType');
			// Add Status
			MyStatus = Spawn(Status.class,,, SpawnLocation,,);

			MyStatus.StatusName = 	  Status.StatusName;
			MyStatus.StatusDamage =   Status.StatusDamage;
			MyStatus.StatusDuration = Status.StatusDuration;
			MyStatus.bStartNextTurn = Status.bStartNextTurn;
			MyStatus.StatusArchetype = Status.StatusArchetype;

			MyStatus.SetLocation(MCPawn(Other).Location);
		}
	}
}

/*
// When We Destroy This Element It set's off an Explosion
*/
simulated event Destroyed()
{
	super.Destroyed();
}

DefaultProperties
{
	SleepTimer=3.0f
	MovementSpeed=10
//	smoke = ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_Dust_Secondary';
	Spell=MCSpell_Acid_Rain'MystrasChampionSpells.Spells.AcidRain'
	Status=MCStatus_AcidBurn'MystrasChampionSpells.Status.Acid_AcidRain'

	// Spawn Invisible Wall
	Begin Object class=StaticMeshComponent name=RockMesh
		StaticMesh=StaticMesh'MystrasChampionSpells.StaticMesh.CloudBase'
		Materials(0)=Material'mystraschampionsettings.Materials.Invisible'
		Scale=1
		CollideActors=true
		BlockActors = false
		BlockZeroExtent = true
		BlockNonZeroExtent = true
		bNotifyRigidBodyCollision=true
	End Object
	Components.Add(RockMesh)
	CollisionComponent=RockMesh

	// Basic Settings for Touching
	bCollideActors = true
	bCollideWorld = true
	CollisionType=COLLIDE_TouchAll
	bNoEncroachCheck=false
	Physics=Phys_None
}