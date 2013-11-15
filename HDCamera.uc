/*******************************************************************************
	HDCamera
*******************************************************************************/

class HDCamera extends Camera;

var Vector cameraAdjust;
var Vector ScreenAdjust;
var float rotateAdjust;

var bool bResetCameraLoc;

simulated event preBeginPlay()
{
}

/**
 * Query ViewTarget and outputs Point Of View.
 *
 * @param	OutVT		ViewTarget to use.
 * @param	DeltaTime	Delta Time since last camera update (in seconds).
 */
function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
	local vector		Loc;
	//local Vector     	Pos, HitLocation, HitNormal;
	local rotator		Rot;
	//local Actor		HitActor;
	local CameraActor	CamActor;
	local bool		bDoNotApplyModifiers;
	local TPOV		OrigPOV;

	perspectiveAdjustment(); // This is where we adjust the perspective of our screen.

	

	// Don't update outgoing viewtarget during an interpolation 
	if( PendingViewTarget.Target != None && OutVT == ViewTarget && BlendParams.bLockOutgoing )
	{
		return;
	}

	// store previous POV, in case we need it later
	OrigPOV = OutVT.POV;

	// Default FOV on viewtarget
	OutVT.POV.FOV = DefaultFOV;

	// Viewing through a camera actor.
	CamActor = CameraActor(OutVT.Target);
	if( CamActor != None )
	{
		CamActor.GetCameraView(DeltaTime, OutVT.POV);

		// Grab aspect ratio from the CameraActor.
		bConstrainAspectRatio	= bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
		OutVT.AspectRatio		= CamActor.AspectRatio;

		// See if the CameraActor wants to override the PostProcess settings used.
		CamOverridePostProcessAlpha = CamActor.CamOverridePostProcessAlpha;
		CamPostProcessSettings = CamActor.CamOverridePostProcess;
	}
	else
	{
		// Give Pawn Viewtarget a chance to dictate the camera position.
		// If Pawn doesn't override the camera view, then we proceed with our own defaults
		if( Pawn(OutVT.Target) == None ||
			!Pawn(OutVT.Target).CalcCamera(DeltaTime, OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV) )
		{
			// don't apply modifiers when using these debug camera modes.
			bDoNotApplyModifiers = TRUE;

			switch( CameraStyle )
			{
				case 'Fixed'		:	// do not update, keep previous camera position by restoring
										// saved POV, in case CalcCamera changes it but still returns false
										OutVT.POV = OrigPOV;
										break;

				case 'ThirdPerson'	: // Simple third person view implementation
				case 'FreeCam'		:
				case 'FreeCam_Default':
							//cap the distance of our camera
							if(FreeCamDistance < 256){FreeCamDistance = 256;}
							if(FreeCamDistance > 1024){FreeCamDistance = 1024;}

							//make sure that our rotation is clamped within 0-360, but is still allowed to freely rotate.
							if(rotateAdjust > 360){rotateAdjust = 0;}
							if(rotateAdjust < 0){rotateAdjust = 360;}

						//OutVT.Target.GetActorEyesViewPoint(Loc, Rot);
						if( CameraStyle == 'FreeCam' || CameraStyle == 'FreeCam_Default' )
						{
							Rot.Pitch = (-80 *DegToRad) * RadToUnrRot;
							Rot.Yaw = (rotateAdjust *DegToRad) * RadToUnrRot;
							Rot.Roll = (0.0f *DegToRad) * RadToUnrRot;
						}
						Loc += FreeCamOffset >> Rot;

						//Pos = Loc - Vector(Rot) * FreeCamDistance;
						// @fixme, respect BlockingVolume.bBlockCamera=false
						//HitActor = Trace(HitLocation, HitNormal, Pos, Loc, FALSE, vect(12,12,12));
						//OutVT.POV.Location = (HitActor == None) ? Pos : HitLocation;
						OutVT.POV.Rotation = Rot;
						break;

				case 'FloatingCam'  :   
										//cap the distance of our camera
										if(FreeCamDistance < 256){FreeCamDistance = 256;}
										if(FreeCamDistance > 1024){FreeCamDistance = 1024;}

										//make sure that our rotation is clamped within 0-360, but is still allowed to freely rotate.
										if(rotateAdjust > 360){rotateAdjust = 0;}
										if(rotateAdjust < 0){rotateAdjust = 360;}

										// little routine for resetting camera. - debug only
										if(bResetCameraLoc == true)
										{
											ScreenAdjust = PCOwner.Pawn.Location;
											ScreenAdjust.X -= 184;
											ScreenAdjust.Y -= 0;
										//don't want to reset angle, just location.
											//rotateAdjust = 60.0f;
											//bResetCameraLoc = false;
										}

										//camera location
										loc.X += ScreenAdjust.X;
										loc.Y += ScreenAdjust.Y;
										loc.Z = FreeCamDistance;

										//camera rotation
										Rot = OutVT.Target.Rotation;
										Rot.Pitch = (-85 *DegToRad) * RadToUnrRot;
										Rot.Yaw = (rotateAdjust *DegToRad) * RadToUnrRot;
										Rot.Roll = (0.0f *DegToRad) * RadToUnrRot;
										//Pos = loc - Vector(Rot) * FreeCamDistance;
										OutVT.POV.Location = loc;
										OutVT.POV.Rotation = Rot;

										break;

				case 'FirstPerson'	: // Simple first person, view through viewtarget's 'eyes'
				default				:	OutVT.Target.GetActorEyesViewPoint(OutVT.POV.Location, OutVT.POV.Rotation);
										break;

			}
		}
	}


	if( !bDoNotApplyModifiers )
	{
		// Apply camera modifiers at the end (view shakes for example)
		ApplyCameraModifiers(DeltaTime, OutVT.POV);
	}
	//`log( WorldInfo.TimeSeconds  @ GetFuncName() @ OutVT.Target @ OutVT.POV.Location @ OutVT.POV.Rotation @ OutVT.POV.FOV );
}

function perspectiveAdjustment()
{
	ScreenAdjust.X += cameraAdjust.X;
	ScreenAdjust.Y += cameraAdjust.Y;
	ScreenAdjust.Z += cameraAdjust.Z;
}

defaultproperties
{
	bResetCameraLoc = true
	rotateAdjust = 2.0f
	FreeCamDistance = 256
}
