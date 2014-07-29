//----------------------------------------------------------------------------
// MCCamera
//
// Camera We use for battle & for menues
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCCamera extends Camera;

// Reference to the camera properties
var const MCCameraProperties CameraProperties;
// Desired camera location
var ProtectedWrite Vector DesiredCameraLocation;
// Moving Camera with mouse cursor
var vector CameraMoveDirection;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
}


/*
// Sets the desired location for the camera
// @param		NewDesiredCameraLocation		New desired location of the camera
// @network										Client
*/
function SetDesiredCameraLocation(Vector NewDesiredCameraLocation)
{
	DesiredCameraLocation = NewDesiredCameraLocation;
}

/**
 * Query ViewTarget and outputs Point Of View.
 *
 * @param		OutVT			ViewTarget to use.
 * @param		DeltaTime		Delta Time since last camera update (in seconds).
 * @network						Server and client
 */
function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
	local MCPlayerController MCPC;
	local Vector CameraDirectionX, CameraDirectionY, CameraDirectionZ, CameraIntersectionPoint;
	local LocalPlayer LocalPlayer;	// Used for Mouse tracking
	local Vector2D MousePosition;	// Used for Mouse Tracking

	// Return the default update camera target
	if (CameraProperties == None)
	{
		Super.UpdateViewTarget(OutVT, DeltaTime);
		return;
	}

	// if this bool is false then we can't use the player camera
	if (!CameraProperties.bSetToMatch)
	{
		Super.UpdateViewTarget(OutVT, DeltaTime);
		return;
	}

	if (PCOwner != None && CameraProperties.bSetToMatch)
	{

		// Grab the mouse coordinates and check if they are on the egde of the screen
		if (PCOwner.MyHUD != None)
		{
			LocalPlayer = LocalPlayer(PCOwner.Player);
			if (LocalPlayer != None && LocalPlayer.ViewportClient != None && CameraProperties.bSetMouseMovement)
			{
				MousePosition = LocalPlayer.ViewportClient.GetMousePosition();
				// Left
				if (MousePosition.X >= 0 && MousePosition.X < 8)
				{
					CameraMoveDirection.X = -CameraProperties.MouseSpeed;
				}
				// Right
				else if (MousePosition.X > PCOwner.MyHUD.SizeX - 8 && MousePosition.X <= PCOwner.MyHUD.SizeX)
				{
					CameraMoveDirection.X = CameraProperties.MouseSpeed;
				}
				else
				{
					CameraMoveDirection.X = 0.f;
				}

				// Top
				if (MousePosition.Y >= 0 && MousePosition.Y < 8)
				{
					CameraMoveDirection.Y = -CameraProperties.MouseSpeed;
				}
				// Bottom
				else if (MousePosition.Y > PCOwner.MyHUD.SizeY - 8 && MousePosition.Y <= PCOwner.MyHUD.SizeY)
				{
					CameraMoveDirection.Y = CameraProperties.MouseSpeed;
				}
				else
				{
					CameraMoveDirection.Y = 0.f;
				}
			}
		}

		// Main Zoom Out Distance
		if (CameraProperties.MovementPlane.Z > CameraProperties.MaxZoom)
		{
			CameraProperties.MovementPlane.Z = CameraProperties.MaxZoom;
		}
		// Main Zoom In Distance
		if (CameraProperties.MovementPlane.Z < CameraProperties.MinZoom)
		{
			CameraProperties.MovementPlane.Z = CameraProperties.MinZoom;
		}

		// Normalize the camera move direction based on the player input
		if (CameraProperties.bSetKeyboardMovement)
		{
			CameraMoveDirection.X += PCOwner.PlayerInput.RawJoyRight;
			CameraMoveDirection.Y += (PCOwner.PlayerInput.RawJoyUp * -1.f);
			CameraMoveDirection = Normal(CameraMoveDirection);
		}

		// Turn off hero tracking as soon as the player attempts to adjust the camera
		// IsZero, if that vector is not 0 then camera won't track
		if (!IsZero(CameraMoveDirection) && CameraProperties.IsTrackingHeroPawn)
		{
			CameraProperties.IsTrackingHeroPawn = false;
		}

		// Tracking Hero Pawn
		if (CameraProperties.IsTrackingHeroPawn)
		{
			
			MCPC = MCPlayerController(PCOwner);
			if (MCPC != None && MCPC.Pawn != None)
			{
			//	DesiredCameraLocation = MCPC.Pawn.Location;
				if (MCPC.MCPlayer != none)
				{
					// If we have Decal follow that, otherwise Player
					if (MCPC.MCPlayer.MyDecal != none)
					{
						DesiredCameraLocation = MCPC.MCPlayer.MyDecal.Location;
					}else
					{
						DesiredCameraLocation = MCPC.MCPlayer.Location;
					}
				}
			}
		}
		// Tracking Enemy Pawn
		else if (CameraProperties.IsTrackingEnemyPawn)
		{
			MCPC = MCPlayerController(PCOwner);
			if (MCPC != None && MCPC.MCEnemy != None)
			{
				DesiredCameraLocation = MCPC.MCEnemy.Location;
			}
		}
		else
		{
			// Grab the camera rotation axes
			GetAxes(CameraProperties.Rotation, CameraDirectionX, CameraDirectionY, CameraDirectionZ);

			DesiredCameraLocation += Vector(Rotator(CameraDirectionY) + Rot(0, 16384, 0)) * CameraMoveDirection.Y * PCOwner.PlayerInput.MoveForwardSpeed * DeltaTime;
			DesiredCameraLocation += CameraDirectionY * CameraMoveDirection.X * PCOwner.PlayerInput.MoveStrafeSpeed * DeltaTime;
		}

		// When starting a new game resets Camera Zoom & Rotation
		if (CameraProperties.bStartPosition)
		{
			CameraProperties.bStartPosition = false;
			CameraProperties.MovementPlane = CameraProperties.StartPlane;

			CameraProperties.Rotation = CameraProperties.StartRotation;
		}

		// Find the point on the camera movement plane where the camera should be. This ensures that the camera stays at a constant height
		LinePlaneIntersection(DesiredCameraLocation, DesiredCameraLocation - Vector(CameraProperties.Rotation) * 16384.f, CameraProperties.MovementPlane, CameraProperties.MovementPlaneNormal, CameraIntersectionPoint);

		// Linearly interpolate to the desired camera location
		OutVT.POV.Location = VLerp(OutVT.POV.Location, CameraIntersectionPoint, (CameraProperties.BlendSpeed) * DeltaTime);


		if (MCPC != None && MCPC.Pawn != None)
		{
		//	DesiredCameraLocation = MCPC.Pawn.Location;
			if (MCPC.MCPlayer != none)
			{
				MCPC = MCPlayerController(PCOwner);
				// Set the camera rotation
				if (MCPC.MCPlayer.MyDecal != none)
				{
					OutVT.POV.Rotation = RLerp(OutVT.POV.Rotation, (CameraProperties.Rotation + MCPC.MCPlayer.MyDecal.Rotation) , CameraProperties.BlendSpeed * DeltaTime, true);
				}else
				{
					OutVT.POV.Rotation = RLerp(OutVT.POV.Rotation, (CameraProperties.Rotation) , CameraProperties.BlendSpeed * DeltaTime, true);
				}
			}
		}else
		{
			OutVT.POV.Rotation = RLerp(OutVT.POV.Rotation, (CameraProperties.Rotation) , CameraProperties.BlendSpeed * DeltaTime, true);
		}
	}else if (PCOwner != None && !CameraProperties.bSetToMatch)
	{
		`log("NO PAWM NOT bSetToMatch, NO PAWM NOT bSetToMatch, NO PAWM NOT bSetToMatch, NO PAWM NOT bSetToMatch, ");
	}

	
}

/**
 * Calculates the intersection point between a line and a plane.
 *
 * @param		LineA					Point A representing the start or end of the line
 * @param		LineB					Point B representing the start or end of the line
 * @param		PlanePoint				Point somewhere on the plane
 * @param		PlaneNormal				Normal of the plane
 * @param		IntersectionPoint		Intersection point where the line intersects with the plane
 * @return								Returns true if there was an interesection between the line and the plane
 * @network								All
 */
function bool LinePlaneIntersection(Vector LineA, Vector LineB, Vector PlanePoint, Vector PlaneNormal, out Vector IntersectionPoint)
{
	local Vector U, W;
	local float D, N, sI;

	U = LineB - LineA;
	W = LineA - PlanePoint;

    D = PlaneNormal dot U;
    N = (PlaneNormal dot W) * -1.f;

    if (Abs(D) < 0.000001f)
	{
		return false;
	}

	sI = N / D;
	if (sI < 0.f || sI > 1.f)
	{
		return false;
	}

	IntersectionPoint = LineA + sI * U;
	return true;
}

defaultproperties
{
	CameraProperties=MCCameraProperties'mystraschampionsettings.Camera.CameraProperties'
}
