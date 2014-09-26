//----------------------------------------------------------------------------
// MCSpell_Acid_Rain
//
// Acid Rain Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Acid_Rain extends MCSpell;

/*
// The Activator for all spells
// @param	Caster			Who Casts the Spell
// @param	Enemy			Who the Caster is Aiming for
// @param	Opt_PathNode	What PathNode we would like to change
// @param	Opt_Tile		What Tile we would like to change
*/
simulated function Activate(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile Tile)
{
	// This does AP Check first so we can check if we can do the spell 
	super.Activate(Caster, Enemy, PathNode, Tile);

	// Get a Cloud
	TargetCloud = Caster.PC.GetCloud(fMaxSpellDistance);

	bCanSendSpellNumber = true;

	// Activate Spell if we have a cloud
	if (TargetCloud != none)
	{
		ActivateCloud(Caster, Enemy, PathNode, Tile);
		Destroy();
	}
	else
	{
		Destroy();
	}
}

DefaultProperties
{
	ActorClass=class'MCActor_AcidRain'
}