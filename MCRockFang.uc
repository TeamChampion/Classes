class MCRockFang extends MCSpell;

function Cast(MCPawn caster, Vector target)
{
	local Vector newLocation;
	newLocation = target + vect(0,0,-50);
	Spawn(class'MCFang', caster,, newLocation);
}

DefaultProperties
{
	name="Rock Fang"
	bEarth=true
	AP=3
	damage=50
}