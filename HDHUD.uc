/*******************************************************************************
	HDHUD
*******************************************************************************/

class HDHUD extends UDKHUD;


//Called after game loaded - initialise things
simulated function PostBeginPlay()
{
`Log("HDHUD::PostBeginPlay() Begin");
super.PostBeginPlay();
`Log("HDHUD::PostBeginPlay() End");
}


//Called every tick the HUD should be updated
event PostRender()
{
		//local instances of our camera and controller ready to cast
		local HDCamera PlayerCam;
        local HDPlayerController HDPlayerController;

		HDMouseCameraUpdate();

		HDPlayerController = HDPlayerController(PlayerOwner);
		HDPlayerController.PlayerMouse = GetMouseCoordinates();

		//from 2d mouse co-ordinates
		Canvas.DeProject(HDPlayerController.Playermouse, HDPlayerController.MousePositionWorldLocation, HDPlayerController.MousePositionWorldNormal);
		
		//get a type casted reference to custom camera
		Playercam = HDCamera(HDPlayerController.PlayerCamera);

		//calculate the various of the mouse curson position.

		//Set the ray direction as the mouseWorldnormal
		HDPlayerController.rayDir = HDPlayerController.MousePositionWorldNormal;

		//Start the trace at the player camera (isometric) + 100 unit z and a little offset in front of the camera (direction *10)
		HDPlayerController.StartTrace = (PlayerCam.ViewTarget.POV.Location + Vect(0,0,100)) + HDPlayerController.raydir * 10;

		//End this ray at start + the direction multiplied by given distance (5000 unit is far enough generally)
		HDPlayerController.endtrace = HDPlayerController.StartTrace + HDPlayerController.Raydir * 5000;
		
		//Trace MouseHitWorldLocation each frame to world location (here you can get from the trace the actors that are hit by the trace, for the sake of this
        //simple tutorial, we do noting with the result, but if you would filter clicks only on terrain, or if the player clicks on an npc, you would want to inspect
        //the object hit in the StartFire function
		HDPlayerController.TraceActor = trace(HDPlayerController.MouseHitWorldLocation, HDPlayerController.MouseHitWorldNormal, 
			HDPlayerController.EndTrace, HDPlayerController.StartTrace, true);

		//Calculate the pawn eye location for debug ray and for checking obstacles on click.
		HDPlayerController.PawnEyeLocation = Pawn(PlayerOwner.ViewTarget).Location + 
			Pawn(PlayerOwner.ViewTarget).EyeHeight * Vect(0,0,1);


		//draw our hud
		DrawHUD();

		super.PostRender();


}

function vector2D GetMouseCoordinates()
{
        local Vector2D mousePos;
		local string stringMessage;
		local HDPlayerInput LocalPlayerInput;

		// Ensure that we have a valid PlayerOwner and CursorTexture
		if (PlayerOwner != None)// && CursorTexture != None) 
		{
		// Cast to get the MouseInterfacePlayerInput
			LocalPlayerInput = HDPlayerInput(PlayerOwner.PlayerInput); 
			mousePos.X = LocalPlayerInput.MousePosition.X;
			mousePos.Y = LocalPlayerInput.MousePosition.Y;
                        
			stringMessage = mousePos.X@mousePos.Y;
		}

		Canvas.DrawColor = Makecolor(255,183,255,255);
		Canvas.SetPos(250,40);
		Canvas.DrawText(stringMessage, false,,,Textrenderinfo);

        return mousePos;
}

//return screen size
function vector2D getScreenSize()
{
		local Vector2D screenDimensions;		
		ScreenDimensions.X = Canvas.SizeX;
		ScreenDimensions.Y = Canvas.SizeY;

		return screenDimensions;
}

/**
* This updates the screen adjuster
*
*/
function HDMouseCameraUpdate()
{
	local string stringMessage;
	local Vector2D mouseCoOrdinates;
	local Vector2D screenSize;
	local Vector cameraAdjustVector;
	local HDCamera playerCam;
	local HDPlayerController playerCont;
	local float adjustAmountY;
	local float adjustAmountX;
	local float moduloAmount;
	local float moduloSign;
	local float rotateAngleLocal;

	adjustAmountX = 0;
	adjustAmountY = 0;

	playerCont = HDPlayerController(PlayerOwner);
	playerCam = HDCamera(playerCont.PlayerCamera);
	rotateAngleLocal = playerCam.rotateAdjust;
	
	mouseCoOrdinates = GetMouseCoordinates();
	screenSize = getScreenSize();
	cameraAdjustVector *= 0; // make sure we zero the vector.

	moduloSign = (((playerCam.rotateAdjust % 180) -90 ) / 90);//as a percentange
	moduloAmount = (((playerCam.rotateAdjust % 180) -90 ) / 90);//as a percentange
	moduloAmount = sqrt(moduloSign * moduloSign);// do this to remove the sign
	moduloAmount = (1 - moduloAmount); // reverses for calculations
	moduloSign = (0 - moduloSign);

	//is the player in a 'camera movement zone'
	
	//THERE ARE FAR BETTER WAYS OF DOING THIS, IT'S HACKISH I KNOW!!!
	//calculate up/down movement.
	if (mousecoordinates.y <= 20 && mousecoordinates.y >=0) //screen up
	{
		adjustAmountY = 10 * (1 - moduloAmount);
		adjustAmountX = 10 * moduloAmount;
		
		if((rotateAngleLocal >270 && rotateAngleLocal <= 360) || (rotateAngleLocal >=0 && rotateAngleLocal < 90))
		{
			cameraAdjustVector.X = adjustAmountY;

			if(moduloSign < 0)
			{
				cameraAdjustVector.Y = 0 - adjustAmountX;
			}
			else if(moduloSign > 0)
			{
				cameraAdjustVector.Y = adjustAmountX;
			}

		}
		else if(rotateanglelocal >=90 && rotateanglelocal < 270)
		{
			cameraAdjustVector.X = 0 - adjustAmountY;

			if(moduloSign < 0)
			{
				cameraAdjustVector.Y = adjustAmountX;
			}
			else if(moduloSign > 0)
			{
				cameraAdjustVector.Y = 0 - adjustAmountX;
			}
		}
	}
	else if (mousecoordinates.y >= (screensize.y - 20) && mousecoordinates.y <= screensize.y) //screendown
	{
		adjustAmountY = 10 * (1 - moduloAmount);
		adjustAmountX = 10 * moduloAmount;
		
		if((rotateAngleLocal >270 && rotateAngleLocal <= 360) || (rotateAngleLocal >=0 && rotateAngleLocal < 90))
		{
			cameraAdjustVector.X = 0 - adjustAmountY;

			if(moduloSign < 0)
			{
				cameraAdjustVector.Y = adjustAmountX;
			}
			else if(moduloSign > 0)
			{
				cameraAdjustVector.Y = 0 - adjustAmountX;
			}

		}
		else if(rotateanglelocal >=90 && rotateanglelocal < 270)
		{
			cameraAdjustVector.X = adjustAmountY;

			if(moduloSign < 0)
			{
				cameraAdjustVector.Y = 0 - adjustAmountX;
			}
			else if(moduloSign > 0)
			{
				cameraAdjustVector.Y = adjustAmountX;
			}
		}
	}

	//calculate left/right movement.
	if (mousecoordinates.x <= 20 && mousecoordinates.x >=0 ) //sreenleft
	{
		adjustAmountY = 10 * (1 - moduloAmount);
		adjustAmountX = 10 * moduloAmount;

		if(rotateanglelocal >=0 && rotateanglelocal < 180)
		{
			cameraAdjustVector.X = adjustAmountX;

			if(moduloSign < 0)
			{
				cameraAdjustVector.Y = adjustAmountY;
			}
			else if(moduloSign > 0)
			{
				cameraAdjustVector.Y = 0 - adjustAmountY;
			}

		}
		else if(rotateanglelocal >=180 && rotateanglelocal <= 360)
		{
			cameraAdjustVector.X = 0 - adjustAmountX;

			if(moduloSign < 0)
			{
				cameraAdjustVector.Y = 0 - adjustAmountY;
			}
			else if(moduloSign > 0)
			{
				cameraAdjustVector.Y = adjustAmountY;
			}
		}
	}
	else if (mousecoordinates.x >= (screensize.x - 20) && mousecoordinates.x <= screensize.x) //screenright
	{
		adjustAmountY = 10 * (1 - moduloAmount);
		adjustAmountX = 10 * moduloAmount;

		if(rotateanglelocal >180 && rotateanglelocal < 360)
		{
			cameraAdjustVector.X = adjustAmountX;

			if(moduloSign < 0)
			{
				cameraAdjustVector.Y = adjustAmountY;
			}
			else if(moduloSign > 0)
			{
				cameraAdjustVector.Y = 0 - adjustAmountY;
			}

		}
		else if(rotateanglelocal >=0 && rotateanglelocal <= 180)
		{
			cameraAdjustVector.X = 0 - adjustAmountX;

			if(moduloSign < 0)
			{
				cameraAdjustVector.Y = 0 - adjustAmountY;
			}
			else if(moduloSign > 0)
			{
				cameraAdjustVector.Y = adjustAmountY;
			}
		}
	}

	cameraAdjustVector *= 2;
	playercam.cameraAdjust = cameraAdjustVector;

	stringMessage = adjustAmountX@adjustAmountY@(rotateAngleLocal)@moduloAmount@moduloSign;

	Canvas.DrawColor = Makecolor(255,183,11,255);
	Canvas.SetPos(250,20);
	Canvas.DrawText(stringMessage, false,,,Textrenderinfo);

}


function DrawHud()
{
	local string StringMessage;

	//check and see if our trace actor exists, the actor below our mouse cursor!
	if(HDPlayerController(PlayerOwner).TraceActor != none)
	{
		//tell us what it is on the screen!
		StringMessage = "ActorSelected:"@HDPlayerController(PlayerOwner).TraceActor.Class;
	}

	Canvas.DrawColor = Makecolor(255,183,11,255);
	Canvas.SetPos(250,60);
	Canvas.DrawText(stringMessage, false,,,Textrenderinfo);

}



function EADrawMessage( string writerString)
{
	//add a funtion to draw messages on the screen.
}
DefaultProperties
{
}