class MCRockWall extends MCSpell;

function Cast(MCPawn caster, Actor target)
{
	Spawn(class'MCRock', caster, , target.Location, caster.Rotation);
}

DefaultProperties
{
	name="Rock Wall"
	bEarth=true
	AP=6
}
