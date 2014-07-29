//----------------------------------------------------------------------------
// GFxSetIconObject
//
// Sends icon name file to Flash so we know what bitmap to change
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class GFxSetIconObject extends GFxObject;

/*
// Calls the 'setSpellIconImage()' ActionScript function with 'NewIconName' as a string parameter
// @param	NewIconName		Name of the icon resource to use
*/
function ChangeIconImage(string NewIconName)
{
	ActionScriptVoid("setSpellIconImage");
}

// Default properties block
defaultproperties
{
}