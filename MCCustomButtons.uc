class MCCustomButtons extends MouseInterfacePlayerInput within MCPlayerController
    config(Input);

var bool bMyButton, bMyButtonPressed, bMyButtonHeld, bMyButtonWasHeld, bMyButtonReleased, bMyButtonDoubletapped, bOld_MyButton;
var float LastPressedMyButtonTime;

// The Camera Properties link
var const MCCameraProperties CameraProperties;
// Rotating buttons
var bool bCanRotateLeft;
var bool bCanRotateRight;

function MyButtonActions(float DeltaTime)
{
    bMyButtonPressed = bMyButton && !bOld_MyButton;
    bMyButtonDoubletapped = false;
    if (bMyButtonPressed)
    {
        if (WorldInfo.TimeSeconds - LastPressedMyButtonTime < DoubleClickTime)
            bMyButtonDoubletapped = true;
        else
            LastPressedMyButtonTime = WorldInfo.TimeSeconds;
    }

    bMyButtonWasHeld = bMyButtonHeld;
    if (bMyButton && bOld_MyButton && (WorldInfo.TimeSeconds - LastPressedMyButtonTime >= DoubleClickTime))
        bMyButtonHeld = true;
    else
        bMyButtonHeld = false;

    bMyButtonReleased = !bMyButton && bOld_MyButton;

    if (bMyButtonDoubletapped)
    {
            // do something special
    }
    else if (bMyButtonPressed)
    {
            // do something
    }
    else if (bMyButtonHeld)
    {
        // do alternate something
        RotateCamera();
    }
    else if (bMyButtonReleased)
    {        
        if (!bMyButtonWasHeld)
        {
            // do another something
        }
        else
        {
            // do another alternate something
        }
    }
   
    bOld_MyButton = bMyButton;
}

event PlayerInput( float DeltaTime )
{
    Super.PlayerInput(DeltaTime);
   
    // handle my custom button
    MyButtonActions(DeltaTime);
}

/*
simulated exec function MyButton()
{
    bMyButton = true;
}

// FIXME - stop using 'Un' as a prefix for momentary inputs being released
simulated exec function UnMyButton()
{
    bMyButton = false;
}
*/


/*
// Function that rotates the camera depending on button
*/
function RotateCamera()
{
    if(bCanRotateLeft)
    {
        MCRotationLeft();
    }else if(bCanRotateRight)
    {
        MCRotationRight();
    }
}


/*
// Rotate left functions
*/
function MCRotationLeft()
{
    CameraProperties.Rotation.Roll += CameraProperties.RoationSpeed;
}
exec function MCRotateLeftON(){
    bMyButton = true;
    bCanRotateLeft = true;
}
exec function MCRotateLeftOff(){
    bMyButton = false;
    bCanRotateLeft = false;
}




function MCRotationRight()
{
    CameraProperties.Rotation.Roll -= CameraProperties.RoationSpeed;
}
exec function MCRotateRightON(){
    bMyButton = true;
    bCanRotateRight = true;
}
exec function MCRotateRightOff(){
    bMyButton = false;
    bCanRotateRight = false;
}

defaultproperties
{
    CameraProperties=MCCameraProperties'mystraschampionsettings.Camera.CameraProperties'
}