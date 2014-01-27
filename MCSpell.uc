class MCSpell extends Actor
	abstract;

var() string spellName;
var() string Description;
var() int AP;
var() bool bFire, bEarth, bThunder, bAcid, bIce;
//var() int slots;


DefaultProperties
{
	bFire=false
	bEarth=false
	bThunder=false
	bAcid=false
	bIce=false
}