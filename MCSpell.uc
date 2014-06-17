class MCSpell extends Actor
	HideCategories(Display, Attachment, Physics, Advanced, Debug, Object, Movement, Collision, Mobile)
	abstract;

// Name of Spell
var(MCSpell) string spellName;
// Name of Texture name we link into Flash
var(MCSpell) string spellTextureName;
// Name Description of spell
var(MCSpell) string Description;
// How much does the spell Cost
var(MCSpell) int AP;
// What kind of spell is it
var(MCSpell) bool bFire, bEarth, bThunder, bAcid, bIce;
// base damage it does
var(MCSpell) float damage;
// Is this a projectile
var(MCSpell) bool bIsProjectile;
// Max Distance you can cast a spell from your Character
var(MCSpell, Placement) float fMaxSpellDistance;
// Character Distance we use to calculate tiles Player & Enemy are not suppose to light up
var(MCSpell, Placement) float fCharacterDistance;



/*
* The Activator for all spells
*	Caster			Who Casts the Spell
*	Enemy			Who the Caster is Aiming for
*	Opt PathNode	What PathNode we would like to change
*	Opt Tile		What Tile we would like to change
*/
simulated function Activate(MCPawn Caster, MCPawn Enemy, optional MCPathNode PathNode, optional MCTile OneTile){}

/*
* Function we use for click spells
*	WhatTile	Selected Tile we use
*	PathNode
*/
reliable server function CastClickSpell(MCPawn Caster, MCTile WhatTile, MCPathNode PathNode);

simulated function MeSpawn(MCTile WhatTile){}
DefaultProperties
{
	bFire=false
	bEarth=false
	bThunder=false
	bAcid=false
	bIce=false
}