class MCCamera extends Camera;

// Reference to the camera properties
var const MCCameraProperties CameraProperties;
// Desired camera location
var ProtectedWrite Vector DesiredCameraLocation;
// If true, then the camera should track the hero pawn until the player attempts to adjust the camera location
var bool IsTrackingHeroPawn;
// bool that just resets Camera Location & Rotation
var bool bStartPosition;
// bool that controls if we can not use the camera
var bool bSetToMatch;
/**
 * Sets the desired location for the camera
 *
 * @param		NewDesiredCameraLocation		New desired location of the camera
 * @network										Client
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
	local Vector CameraDirectionX, CameraDirectionY, CameraDirectionZ, CameraMoveDirection, CameraIntersectionPoint;
	local LocalPlayer LocalPlayer;	// Used for Mouse tracking
	local Vector2D MousePosition;	// Used for Mouse Tracking

	// Return the default update camera target
	if (CameraProperties == None)
	{
		Super.UpdateViewTarget(OutVT, DeltaTime);
		return;
	}

	// if this bool is false then we can't use the player camera
	if (!bSetToMatch)
	{
		Super.UpdateViewTarget(OutVT, DeltaTime);
		return;
	}

	if (PCOwner != None && bSetToMatch)
	{

		// Grab the mouse coordinates and check if they are on the egde of the screen
		if (PCOwner.MyHUD != None)
		{
			LocalPlayer = LocalPlayer(PCOwner.Player);
			if (LocalPlayer != None && LocalPlayer.ViewportClient != None)
			{
				MousePosition = LocalPlayer.ViewportClient.GetMousePosition();
				// Left
				if (MousePosition.X >= 0 && MousePosition.X < 8)
				{
					CameraMoveDirection.X = -1.f;
				}
				// Right
				else if (MousePosition.X > PCOwner.MyHUD.SizeX - 8 && MousePosition.X <= PCOwner.MyHUD.SizeX)
				{
					CameraMoveDirection.X = 1.f;
				}
				else
				{
					CameraMoveDirection.X = 0.f;
				}

				// Top
				if (MousePosition.Y >= 0 && MousePosition.Y < 8)
				{
					CameraMoveDirection.Y = -1.f;
				}
				// Bottom
				else if (MousePosition.Y > PCOwner.MyHUD.SizeY - 8 && MousePosition.Y <= PCOwner.MyHUD.SizeY)
				{
					CameraMoveDirection.Y = 1.f;
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
//		CameraMoveDirection.X += PCOwner.PlayerInput.RawJoyRight;
//		CameraMoveDirection.Y += (PCOwner.PlayerInput.RawJoyUp * -1.f);
//		CameraMoveDirection = Normal(CameraMoveDirection);

		// Turn off hero tracking as soon as the player attempts to adjust the camera
		// IsZero, if that vector is not 0 then camera won't track
		if (!IsZero(CameraMoveDirection) && CameraProperties.IsTrackingHeroPawn)
		{
			CameraProperties.IsTrackingHeroPawn = false;
		}

		if (CameraProperties.IsTrackingHeroPawn)
		{
			
			MCPC = MCPlayerController(PCOwner);
			if (MCPC != None && MCPC.Pawn != None)
			{
				DesiredCameraLocation = MCPC.Pawn.Location;
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
		if (bStartPosition)
		{
			bStartPosition = false;
			CameraProperties.MovementPlane = CameraProperties.StartPlane;

			CameraProperties.Rotation = CameraProperties.StartRotation;
		}

		// Find the point on the camera movement plane where the camera should be. This ensures that the camera stays at a constant height
		class'UDKMOBAObject'.static.LinePlaneIntersection(DesiredCameraLocation, DesiredCameraLocation - Vector(CameraProperties.Rotation) * 16384.f, CameraProperties.MovementPlane, CameraProperties.MovementPlaneNormal, CameraIntersectionPoint);

		// Linearly interpolate to the desired camera location
		OutVT.POV.Location = VLerp(OutVT.POV.Location, CameraIntersectionPoint, CameraProperties.BlendSpeed * DeltaTime);
	}

	// Set the camera rotation
	OutVT.POV.Rotation = CameraProperties.Rotation;
	
}

defaultproperties
{
	//FreeCamDistance = 256
	CameraProperties=MCCameraProperties'mystraschampionsettings.Camera.CameraProperties'
	bStartPosition = true
	bSetToMatch = true
}