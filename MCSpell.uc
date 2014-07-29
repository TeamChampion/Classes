//----------------------------------------------------------------------------
// MCSpell
//
// Main Spell class that contains all Spell information and base functions for
// activating a spell for both clients & server
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell extends Actor
	HideCategories(Display, Attachment, Physics, Advanced, Debug, Object, Movement, Collision, Mobile)
	abstract;

enum SpellType
{
	eNotSetYet,
	eProjectile,
	eArea,
	eStatus
};

// Spell Number ID
var(MCSpell) int spellNumber;
// Name of Spell
var localized string spellName[44];
// Name of Texture name we link into Flash (english only)
var(MCSpell) string spellTextureName;
// Name Description of spell
var localized string Description[44];
// How much does the spell Cost
var(MCSpell) int AP;
// What kind of spell is it
var(MCSpell) bool bFire, bEarth, bThunder, bAcid, bIce;
// base damage it does
var(MCSpell) float damage;
// What Type of spell is it
var(MCSpell) SpellType Type;
// Max Distance you can cast a spell from your Character
var(MCSpell, Placement) float fMaxSpellDistance;
// Character Distance we use to calculate tiles Player & Enemy are not suppose to light up
var(MCSpell, Placement) float fCharacterDistance;
// Is Spell Ready to be used
var(MCSpell) bool bIsEnabled;
// What status you can afflict
var(MCSpell) MCStatus Status;

// Replication block
replication
{
	// Replicate only if the values are dirty and from server to client
	if (bNetDirty)
		damage, bIsEnabled;
}

/*
// The Activator for all spells
// @param	Caster			Who Casts the Spell
// @param	Enemy			Who the Caster is Aiming for
// @param	Opt_PathNode	What PathNode we would like to change
// @param	Opt_Tile		What Tile we would like to change
*/
simulated function Activate(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile OneTile){}

/*
* Function we use for click spells
// @param	Opt_Caster			Who Casts the Spell
// @param	Opt_WhatTile			Who the Caster is Aiming for
// @param	Opt_PathNode	What PathNode we would like to change
*/
reliable server function CastClickSpellServer(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode){}
				function CastClickSpell(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode){}
reliable client function CastClickSpellClient(optional MCPawn Caster, optional MCTile WhatTile, optional MCPathNode PathNode){}

DefaultProperties
{
	bFire=false
	bEarth=false
	bThunder=false
	bAcid=false
	bIce=false
}