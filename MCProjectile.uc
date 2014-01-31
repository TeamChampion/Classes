class MCProjectile extends UTProjectile;

/*
simulated event Touch (Actor Other, PrimitiveComponent OtherComp, Object.Vector HitLocation, Object.Vector HitNormal)
{
	`log( "touched" );
}
*/

// We had to rewrite these two variables and functions to get them to replicate for our custom projectile
var ParticleSystem MCProjFlightTemplate;
var ParticleSystem MCProjExplosionTemplate;

replication
{
  // Replicate only if the values are dirty, this replication info is owned by the player and from server to client
//  if (bNetDirty && bNetOwner)
//    APf;

  // Replicate only if the values are dirty and from server to client
  if (bNetDirty)
    MCProjFlightTemplate, MCProjExplosionTemplate;
}

simulated function SpawnFlightEffects()
{
	//`log("Hello from Spawn flight effects.");
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
	//`log("Hello from spawn explosion effects.");

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