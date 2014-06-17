class GFxSetIconObject extends GFxObject;

/**
 * Calls the 'setSpellIconImage()' ActionScript function with 'NewIconName' as a string parameter
 *
 * @param		NewIconName			Name of the icon resource to use
 * @network							Local client
 */
function ChangeIconImage(string NewIconName)
{
	ActionScriptVoid("setSpellIconImage");
}

// Default properties block
defaultproperties
{
}