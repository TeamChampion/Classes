//----------------------------------------------------------------------------
// MCActor_Cloud_Scourge
//
// Cloud for Scourge
//
// Gustav 2014-09-03
//----------------------------------------------------------------------------
class MCActor_Cloud_Scourge extends MCActor_CloudBase;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	ChangeCloud(Color1, Color2, CloudAlpha, CloudBrightness);

	// Destroy
	SetTimer(1.0f,false,'StartRemovingCloud');
}

// Do Damage
simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	super.Touch(Other, OtherComp, HitLocation, HitNormal);

	if (MCPawn(Other) != none)
	{
		// do stuff
		if (Role == Role_Authority)
		{
			// do damage
			MCPawn(Other).TakeDamage(Spell.damage, none, MCPawn(Other).Location, vect(0,0,0), class'DamageType');
		}
	}
}

simulated function StartRemovingCloud()
{
//	RemoveThisCloud();
	SetTimer((SleepTimer + 0.5f),false,'RemoveThisCloud');
//	`log("Start Timer");
//	SetTimer(0.2f,true,'RemovingClouds');
}

simulated function RemoveThisCloud()
{
	Destroy();
}

// Removes Clouds, @NOTUSING
simulated function RemovingClouds()
{
	CloudAlpha -= 0.1f;
	CloudBrightness -= 1.0f;
	ChangeCloud(Color1, Color2, CloudAlpha, CloudBrightness);

//	`log("CloudAlpha=" @ CloudAlpha @ "-" @ "CloudBrightness=" @ CloudBrightness);
	if (CloudAlpha <= 0.0f)
	{
		ClearTimer();
		RemoveThisCloud();
	}
}


DefaultProperties
{
	SleepTimer=2.0f
	MovementSpeed=0
	CloudAlpha=1.0f
	CloudBrightness=10.0f
	Spell=MCSpell_Scourge'MystrasChampionSpells.Spells.Scourge'
	Effects=ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Ball_Impact'

	Color1=(r=1.0f,		g=0.0f,		b=0.0f);
	Color2=(r=1.0f,		g=0.0f,		b=0.0f);
}