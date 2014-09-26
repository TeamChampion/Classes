//----------------------------------------------------------------------------
// MCActor_CloudBase
//
// The base settings for Clouds
// @ADD Cloud dispursion replication
//
// Gustav 2014-09-03
//----------------------------------------------------------------------------
class MCActor_CloudBase extends MCActor;

// Color struct we have
struct SetColor
{
	var float r, g, b;
};

// What Particle we are spawning
var ParticleSystemComponent MyCloud;
// What material we want this to change into
var MaterialInstanceConstant MatInst;
// Set Colors for Cloud
var SetColor Color1;
var SetColor Color2;
// Cloud Color Alpha
var float CloudAlpha;
// Cloud Brightness
var float CloudBrightness;
// Game Replication
var MCGameReplication MCPR;
// Show Effects
var ParticleSystem Effects;

// Replication block
replication
{
	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		MyCloud, MatInst, Color1, Color2, CloudAlpha, CloudBrightness;
}

simulated function PostBeginPlay()
{
	local Vector newLocation;

	newLocation = Location + vect(0,0,256);
	if (Role != ROLE_Authority || (WorldInfo.NetMode == NM_ListenServer) )
	{
		MyCloud = WorldInfo.MyEmitterPool.SpawnEmitter(smoke, newLocation);
		MyCloud.SetScale(0.3f);
		AttachComponent(MyCloud);
	}

	// Set Color
	ChangeCloud(Color1, Color2, CloudAlpha, CloudBrightness);
}

simulated function ChangeCloud(SetColor LocalColor1, SetColor LocalColor2, float alpha, float Brightness)
{
	local LinearColor MatColor1;
	local LinearColor MatColor2;

	if (MyCloud != none)
	{
		MatInst = new class'MaterialInstanceConstant';
		MatInst.SetParent(MaterialInstanceConstant'MystrasChampionSpells.Materials.MystCloudy_MASTER_INST');
		MyCloud.SetMaterialParameter('Cloud', MatInst);	// Cloud, GreenEx

		MatColor1 = MakeLinearColor(LocalColor1.r, LocalColor1.g, LocalColor1.b, alpha);
		MatColor2 = MakeLinearColor(LocalColor2.r, LocalColor2.g, LocalColor2.b, alpha);
		MatInst.SetVectorParameterValue('BrightColor', MatColor1);
		MatInst.SetVectorParameterValue('DarkColor', MatColor2);
		MatInst.SetScalarParameterValue('Brightness', Brightness);
	}
}

/*
// Controls basic states for Clouds, overrides previous MCActor states
*/
auto simulated state Moving
{
	local Vector newLocation;
	local int RandomValue;
	local ParticleSystemComponent MyEffects;

Begin:

	// If we have effets do them here
	if (Effects != none)
	{
		RandomValue = 256;

		Sleep(0.3);
		newLocation = Location;
		newLocation.X -= (RandomValue / 2);
		newLocation.Y -= (RandomValue / 2);
		newLocation.X += Rand(RandomValue);
		newLocation.Y += Rand(RandomValue);
		newLocation.Z += 128.0f;
		MyEffects = WorldInfo.MyEmitterPool.SpawnEmitter(Effects, newLocation);
		MyEffects.SetScale(2.0f);

		Sleep(0.3);
		newLocation = Location;
		newLocation.X -= (RandomValue / 2);
		newLocation.Y -= (RandomValue / 2);
		newLocation.X += Rand(RandomValue);
		newLocation.Y += Rand(RandomValue);
		newLocation.Z += 128.0f;
		MyEffects = WorldInfo.MyEmitterPool.SpawnEmitter(Effects, newLocation);
		MyEffects.SetScale(2.0f);

		Sleep(0.3);
		newLocation = Location;
		newLocation.X -= (RandomValue / 2);
		newLocation.Y -= (RandomValue / 2);
		newLocation.X += Rand(RandomValue);
		newLocation.Y += Rand(RandomValue);
		newLocation.Z += 128.0f;
		MyEffects = WorldInfo.MyEmitterPool.SpawnEmitter(Effects, newLocation);
		MyEffects.SetScale(2.0f);
	}
	Sleep(SleepTimer);
	GotoState('Waiting');
}

simulated state Waiting
{
	// Reset AP
	function BeginState(Name PreviousStateName)
	{			
		if (Caster != none)
		{
			Caster.PC.CheckCurrentAPCalculation();
			Caster.PC.InstantiateSpell = none;
		}
		Super.BeginState(PreviousStateName);
	}
}

/*
// Remove Cloud setup
*/
simulated function RemovingClouds(){}
/*
// When We Destroy This Element It set's off an Explosion
*/
simulated event Destroyed(){}

DefaultProperties
{
	SleepTimer=1.5f
	MovementSpeed=45
	smoke = ParticleSystem'MystrasChampionSpells.Particles.MystCloud'
	CloudAlpha=1.0f
	CloudBrightness=100.0f

	// Actor replication
	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true

	Begin Object class=StaticMeshComponent name=RockMesh
		StaticMesh=StaticMesh'MystrasChampionSpells.StaticMesh.CloudBase'
		Materials(0)=Material'mystraschampionsettings.Materials.Invisible'
	//	Scale3D=(X=1.0,Y=1.0,Z=1.0)

		CollideActors=true
		BlockActors = false
		BlockZeroExtent = true
		BlockNonZeroExtent = true		// People
	End Object
	Components.Add(RockMesh)
	CollisionComponent=RockMesh

	// Basic Settings for simulation
	bCollideActors = true
	bBlockActors=false
	bCollideWorld = true

	CollisionType=COLLIDE_TouchAll
	Physics=Phys_None
}