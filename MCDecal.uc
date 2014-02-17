class MCDecal extends DecalComponent;

/*
	newRotation.Roll = 0;
	newRotation.Yaw = 0;
	newRotation.Pitch = -16384;

	newPlace.x = -128.0f;
	newPlace.y = -128.0f;
	newPlace.z = 0.0f;
*/



/*
class SimpleBlobShadowPawn extends UTPawn
  placeable;

// The spawned simple blob shadow.
var PrivateWrite DecalActorSpawnable SimpleBlobShadowDecal;
// A reference to the archetyped simple blob shadow simulated function PostBeginPlay()
{
  local MaterialInstanceConstant DecalMaterialInstanceConstant;

  Super.PostBeginPlay();

  // Dedicated servers do not need to spawn the simple blob shadow
  if (WorldInfo.NetMode == NM_DedicatedServer)
  {
    return;
  }

  // No blob shadow archetype
  // The archetype was not the correct class type
  if (SimpleBlobShadowDecalArchetype == None)
  {
    return;
  }

  // Spawn the simple blob shadow actor
  SimpleBlobShadowDecal = Spawn(SimpleBlobShadowDecalArchetype.Class, Self,, Location, Rot(49152, 0, 0), SimpleBlobShadowDecalArchetype);

  if (SimpleBlobShadowDecal != None)
  {      
    if (SimpleBlobShadowDecal.Decal != None && SimpleBlobShadowDecal.Decal.GetDecalMaterial() != None)
    {
      // Create a new material instance so that we can alter the parameters dynamically
      DecalMaterialInstanceConstant = new class'MaterialInstanceConstant';

      if (DecalMaterialInstanceConstant != None)
      {
        DecalMaterialInstanceConstant.SetParent(SimpleBlobShadowDecal.Decal.GetDecalMaterial());
        SimpleBlobShadowDecal.Decal.SetDecalMaterial(DecalMaterialInstanceConstant);
      }
    }

    // Attach the simple blob shadow to myself
    Attach(SimpleBlobShadowDecal);
  }
}

defaultproperties
{
}
*/




defaultproperties
{
/*
	Begin Object class=DecalComponent Name=NewDecalComponent
		//DecalMaterial=DecalMaterial'Dark_UI.Decal_Mat.Aim_V2'
		Translation=(X=50,Y=0,Z=0)
		DecalTransform = DecalTransform_OwnerRelative
    	ParentRelativeOrientation = (Pitch=-16384,Yaw=0,Roll=0)
	End Object

	// add new vcomponent
	Components.Add(NewDecalComponent)
*/
}
