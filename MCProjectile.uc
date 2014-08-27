//----------------------------------------------------------------------------
// MCProjectile
//
// Projectiles we use for our game, replicate the effects for spells also
// manually set.
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCProjectile extends UTProjectile;

// turn of basic information in Destroyed function
var MCPawn PawnThatShoots;
// We had to rewrite these two variables and functions to get them to replicate for our custom projectile
var ParticleSystem MCProjFlightTemplate;
var ParticleSystem MCProjExplosionTemplate;
// Status we can give to the Enemy
var MCStatus Status;
// Set Spell ID in here so we can send it to MCStatus
var int spellNumber;

replication
{
  // Replicate only if the values are dirty and from server to client
  if (bNetDirty)
    MCProjFlightTemplate, MCProjExplosionTemplate, Status, spellNumber;
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local MCPawn Target;
	local MCStatus AddStatus;

	// who, cylinder compnent, loc, 

	// If we have a Status that we are using
	if (Status != none)
	{
		// Find Attacked Person
		foreach DynamicActors(Class'MCPawn', Target)
		{
			if (Other == Target)
			{
			//	`log("This Person is the same" @ Other @ Target);
				break;
			}
		}

		if (Target != none)
		{
			// Initialize it, the certain class of the Status.
			AddStatus = Spawn(Status.class);

			// Add the archetype inside here
			AddStatus.StatusName = Status.StatusName;
			AddStatus.StatusDamage = Status.StatusDamage;
			AddStatus.StatusDuration = Status.StatusDuration;
			// If we have a Specific Spell Number than add that
			if (spellNumber != 0)
			{
				AddStatus.spellNumber = spellNumber;
				AddStatus.SetDifferentSpellDamageAndAP();
			}

			// In here set the Status link, only on Server
			if ((WorldInfo.NetMode == NM_DedicatedServer) || (WorldInfo.NetMode == NM_ListenServer) )
			{
				// Server
				AddSpellServer(Target,AddStatus);
			}
		}
		AddStatus.Destroy();
	}

	super.Touch(Other, OtherComp, HitLocation, HitNormal);
}
/*
`log("---------------------------------------------");
`log("Find PlayerReplication=" @ Target.PlayerReplicationInfo);
`log("Find PlayerController =" @ Target.PC);
`log("Find AP =" @ Target.APf);
`log("---------------------------------------------");
`log("Do we have a MCStatus" @ Status);
`log("StatusName =" @ Status.StatusName);
`log("StatusDamage.AP =" @ Status.StatusDamage.AP);
`log("StatusDamage.DamagePercent =" @ Status.StatusDamage.DamagePercent);
`log("StatusDamage.Damage =" @ Status.StatusDamage.Damage);
`log("StatusDurration =" @ Status.StatusDuration);
`log("---------------------------------------------");
*/

/*
// Adding a certain status on inpact to both Server && Client
// @param 	TargetChar		Who we target
// @param 	MCStatus		What Status we are using
*/
reliable server function AddSpellServer(MCPawn TargetChar, MCStatus WhatStatus)
{
	local int i;	
	local MCPlayerReplication MCPrep;

	MCPrep = MCPlayerReplication(TargetChar.PlayerReplicationInfo);

	// Add it
	for (i = 0;i < ArrayCount(MCPrep.MyStatus) ; i++)
	{
		// If we have a Playerreplication
		if (MCPrep != none)
		{
			if (MCPrep.MyStatus[i].StatusName == "")
			{
				MCPrep.AddStatus(WhatStatus,i);
				break;
			}
			else
			{
			//	`log(i @ "- WTF SOMETHING HERE in" @ name @ "This=" @ Target.MyStatus[i]);
			}
		}
	}
}

/*
// Destroy projectile if it hits something and check if we can continue to play or change character.
*/
simulated function Destroyed()
{
	// If a projectile is on, when being Destroyed, turn of Spellmode && check for remaining APs
	if(PawnThatShoots != none)
	{

		// Only run this on Server
		if (Role > Role_Authority)
		{
			//
		}else
		{
		//	`log("We do this on Server" @ PawnThatShoots);
			PawnThatShoots.PC.bIsSpellActive = false;
			PawnThatShoots.PC.CheckCurrentAPCalculation();
		}
		PawnThatShoots = none;
	}
	super.Destroyed();
}

simulated function SpawnFlightEffects()
{
	if (WorldInfo.NetMode != NM_DedicatedServer && MCProjFlightTemplate != None)
	{
		ProjEffects = WorldInfo.MyEmitterPool.SpawnEmitterCustomLifetime(MCProjFlightTemplate);
		ProjEffects.SetAbsolute(false, false, false);
		ProjEffects.SetLODLevel(WorldInfo.bDropDetail ? 1 : 0);
		ProjEffects.OnSystemFinished = MyOnParticleSystemFinished;
		ProjEffects.bUpdateComponentInTick = true;
		AttachComponent(ProjEffects);
	}
}

simulated function SpawnExplosionEffects(vector HitLocation, vector HitNormal)
{
	local vector LightLoc, LightHitLocation, LightHitNormal;
	local vector Direction;
	local ParticleSystemComponent ProjExplosion;
	local Actor EffectAttachActor;
	local MaterialInstanceTimeVarying MITV_Decal;

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		if (ProjectileLight != None)
		{
			DetachComponent(ProjectileLight);
			ProjectileLight = None;
		}
		if (MCProjExplosionTemplate != None && EffectIsRelevant(Location, false, MaxEffectDistance))
		{
			// Disabling for the demo to prevent explosions from attaching to the pawn...
//			EffectAttachActor = (bAttachExplosionToVehicles || (UTVehicle(ImpactedActor) == None)) ? ImpactedActor : None;
			EffectAttachActor = None;
			if (!bAdvanceExplosionEffect)
			{
				ProjExplosion = WorldInfo.MyEmitterPool.SpawnEmitter(MCProjExplosionTemplate, HitLocation, rotator(HitNormal), EffectAttachActor);
			}
			else
			{
				Direction = normal(Velocity - 2.0 * HitNormal * (Velocity dot HitNormal)) * Vect(1,1,0);
				ProjExplosion = WorldInfo.MyEmitterPool.SpawnEmitter(MCProjExplosionTemplate, HitLocation, rotator(Direction), EffectAttachActor);
				ProjExplosion.SetVectorParameter('Velocity',Direction);
				ProjExplosion.SetVectorParameter('HitNormal',HitNormal);
			}
			SetExplosionEffectParameters(ProjExplosion);

			if ( !WorldInfo.bDropDetail && ((ExplosionLightClass != None) || (ExplosionDecal != none)) && ShouldSpawnExplosionLight(HitLocation, HitNormal) )
			{
				if ( ExplosionLightClass != None )
				{
					if (Trace(LightHitLocation, LightHitNormal, HitLocation + (0.25 * ExplosionLightClass.default.TimeShift[0].Radius * HitNormal), HitLocation, false) == None)
					{
						LightLoc = HitLocation + (0.25 * ExplosionLightClass.default.TimeShift[0].Radius * (vect(1,0,0) >> ProjExplosion.Rotation));
					}
					else
					{
						LightLoc = HitLocation + (0.5 * VSize(HitLocation - LightHitLocation) * (vect(1,0,0) >> ProjExplosion.Rotation));
					}

					UDKEmitterPool(WorldInfo.MyEmitterPool).SpawnExplosionLight(ExplosionLightClass, LightLoc, EffectAttachActor);
				}

				// this code is mostly duplicated in:  UTGib, UTProjectile, UTVehicle, UTWeaponAttachment be aware when updating
				if (ExplosionDecal != None && Pawn(ImpactedActor) == None )
				{
					if( MaterialInstanceTimeVarying(ExplosionDecal) != none )
					{
						// hack, since they don't show up on terrain anyway
						if ( Terrain(ImpactedActor) == None )
						{
							MITV_Decal = new(self) class'MaterialInstanceTimeVarying';
							MITV_Decal.SetParent( ExplosionDecal );

							WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, HitLocation, rotator(-HitNormal), DecalWidth, DecalHeight, 10.0, FALSE );
							//here we need to see if we are an MITV and then set the burn out times to occur
							MITV_Decal.SetScalarStartTime( DecalDissolveParamName, DurationOfDecal );
						}
					}
					else
					{
						WorldInfo.MyDecalManager.SpawnDecal( ExplosionDecal, HitLocation, rotator(-HitNormal), DecalWidth, DecalHeight, 10.0, true );
					}
				}
			}
		}

		if (ExplosionSound != None && !bSuppressSounds)
		{
			PlaySound(ExplosionSound, true);
		}

		bSuppressExplosionFX = true; // so we don't get called again
	}
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true
		
	MaxEffectDistance=7000.0
	bBlockedByInstigator=false
	NetCullDistanceSquared=+144000000.0
	bCollideWorld=true
}