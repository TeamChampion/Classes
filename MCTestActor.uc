//----------------------------------------------------------------------------
// MCTestActor
//
// debug Flag we use in PlayerController
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
Class MCTestActor extends Actor
	placeable;

defaultproperties
{
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_NavP'
	End Object
	Components.Add(Sprite)
}