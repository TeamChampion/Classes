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

var Vector PovLoc;
var Actor MyTouchedWall;
var Vector MyTouchedWallHitLocation;

var Vector MyTouchedWallHitNormal;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
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


	local float deltaRotation;
	local Rotator newRotation;


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
			MCPC = MCPlayerController(PCOwner);
			if (LocalPlayer != None && LocalPlayer.ViewportClient != None && CameraProperties.bSetMouseMovement && MyTouchedWall == none &&
				MCPC != none && MCPC.MCPlayer != none && MCPC.MCPlayer.MyDecal != none)
			{
				MousePosition = LocalPlayer.ViewportClient.GetMousePosition();
				// Left
				if (MousePosition.X >= 0 && MousePosition.X < 8)
				{
					newRotation = MCPC.MCPlayer.MyDecal.Rotation;
					deltaRotation = (-5000.0f) * DeltaTime; 
					newRotation.Yaw  += deltaRotation;

					MCPC.MCPlayer.MyDecal.SetRotation(newRotation);
				//	CameraMoveDirection.X = -CameraProperties.MouseSpeed;
				}
				// Right
				else if (MousePosition.X > PCOwner.MyHUD.SizeX - 8 && MousePosition.X <= PCOwner.MyHUD.SizeX)
				{
					newRotation = MCPC.MCPlayer.MyDecal.Rotation;
					deltaRotation = (5000.0f) * DeltaTime; 
					newRotation.Yaw  += deltaRotation;

					MCPC.MCPlayer.MyDecal.SetRotation(newRotation);
				//	CameraMoveDirection.X = CameraProperties.MouseSpeed;
				}
				else
				{
					CameraMoveDirection.X = 0.f;
				}

				// Top
				if (MousePosition.Y >= 0 && MousePosition.Y < 8)
				{
					// Max Pitch 19000
					if (MCPC.MCPlayer.MyDecal.Rotation.Pitch < 19000)
					{
						newRotation = MCPC.MCPlayer.MyDecal.Rotation;
						deltaRotation = (5000.0f) * DeltaTime; 
						newRotation.Pitch  += deltaRotation;

						MCPC.MCPlayer.MyDecal.SetRotation(newRotation);
					}
				//	CameraMoveDirection.Y = -CameraProperties.MouseSpeed;
				}
				// Bottom
				else if (MousePosition.Y > PCOwner.MyHUD.SizeY - 8 && MousePosition.Y <= PCOwner.MyHUD.SizeY)
				{
					// Max Pitch 19000
					if (MCPC.MCPlayer.MyDecal.Rotation.Pitch > -10)
						{
						newRotation = MCPC.MCPlayer.MyDecal.Rotation;
						deltaRotation = (-5000.0f) * DeltaTime; 
						newRotation.Pitch  += deltaRotation;

						MCPC.MCPlayer.MyDecal.SetRotation(newRotation);
					}
				//	CameraMoveDirection.Y = CameraProperties.MouseSpeed;
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

		// Tracking Hero if
		if(CameraProperties.IsTrackingHeroPawn)
		{
			
			MCPC = MCPlayerController(PCOwner);
			if (MCPC != None && MCPC.MCPlayer != None)
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
			MCPC = MCPlayerController(PCOwner);
			// Grab the camera rotation axes
			if (MCPC.MCPlayer != none && MCPC.MCPlayer.MyDecal != none)
			{
				GetAxes(CameraProperties.Rotation + MCPC.MCPlayer.MyDecal.Rotation, CameraDirectionX, CameraDirectionY, CameraDirectionZ);
			}

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

		// Set Current Camera Location for Blocking Walls
		PovLoc = OutVT.POV.Location;

		MCPC = MCPlayerController(PCOwner);
		if (MCPC != None && MCPC.Pawn != None)
		{
		//	DesiredCameraLocation = MCPC.Pawn.Location;
			if (MCPC.MCPlayer != none)
			{
				// Set the camera rotation
				if (MCPC.MCPlayer.MyDecal != none)
				{
				//	CameraProperties.Rotation.Roll += 500;	// snurrar runt
			//		CameraProperties.Rotation.Yaw += 300;	// snurrar runt
				//	CameraProperties.Rotation.Pitch += 500;	// snurrar front back men skumt
/*
					newRotation = MCPC.MCPlayer.MyDecal.Rotation;
					newRotation.Pitch  += 400;

					MCPC.MCPlayer.MyDecal.SetRotation(newRotation);
*/

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


event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	


	
	//	`log(VSize(self.Location - DesiredCameraLocation) @ self);

if ( self.name == 'MCCamera_0' )
{
	// If we have a Match ON && and if we Touched a Wall
	if (CameraProperties.bSetToMatch && MyTouchedWall != none)
	{
		// If Camera Loc and View Location is too far away then pull him back
		if ( VSize(self.Location - DesiredCameraLocation) < 30 )
		{
			// Close
			self.SetLocation(MyTouchedWallHitLocation);
		}
		else
		{
			// Too far
			self.SetLocation(PovLoc);
			CameraProperties.IsTrackingHeroPawn = true;
		//	`log("crap" @ CameraProperties.IsTrackingHeroPawn);
		}
	}
	// If we are not Touching anything, just update Camera Location
	else if (CameraProperties.bSetToMatch && MyTouchedWall == none)
	{
		// Set Camera Location
		self.SetLocation(PovLoc);
		CameraProperties.IsTrackingHeroPawn = false;
	}
}

/*
	if (MyTouchedWall != none)
	{
		// Right Touch Wall
		if (MyTouchedWallHit.Y < 0.0f)
			DesiredCameraLocation.Y -= (CameraProperties.MouseSpeed + 20);
		// Up Touch Wall
		else if (MyTouchedWallHit.X < 0.0f)
			DesiredCameraLocation.X -= (CameraProperties.MouseSpeed + 20);
		// Down Touch Wall
		else if (MyTouchedWallHit.X > 0.0f)
			DesiredCameraLocation.X += (CameraProperties.MouseSpeed + 20);
		// Left Touch Wall
		else if (MyTouchedWallHit.Y > 0.0f)
			DesiredCameraLocation.Y += (CameraProperties.MouseSpeed + 20);
	}
*/
}

event Touch(Actor Other,  PrimitiveComponent OtherComp,  vector HitLocation,  vector HitNormal)
{
	super.Touch(Other, OtherComp, HitLocation, HitNormal);

	if ( self.name == 'MCCamera_0' )
	{
		// If We Find The Special Blocking Volume
		if (Other.name == 'BlockingVolume_230')
		{
			`log("We Touched something" @ Other);
			// Store Actor
			MyTouchedWall = Other;
			// Store Camera HitLocation
			MyTouchedWallHitLocation = HitLocation;
			// Store Camera ViewPoint Location
			DesiredCameraLocation = HitLocation;
		}
	}

//	MyTouchedWall = Other;
//	MyTouchedWallHit = HitNormal;
}

event UnTouch(Actor Other)
{
	super.UnTouch(Other);

	if ( self.name == 'MCCamera_0' )
	{
		// Reset Everything
		if (MyTouchedWall == Other)
		{
			`log("UnTouched something" @ Other);
			MyTouchedWall = none;
			CameraProperties.IsTrackingHeroPawn = false;
		}
	}
}

defaultproperties
{
	CameraProperties=MCCameraProperties'mystraschampionsettings.Camera.CameraProperties'

	// Basic Settings for simulation
	bCollideActors = true
	CollisionType=COLLIDE_TouchAll

	// Add a Invisible Cyllinder
    Begin Object Class=CylinderComponent NAME=CollisionCylinder
		CollisionRadius=128.0f
		CollisionHeight=128.0f
		bAlwaysRenderIfSelected=true
		CollideActors=true
		BlockActors = true
		BlockZeroExtent = true
		BlockNonZeroExtent = false
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)
}
