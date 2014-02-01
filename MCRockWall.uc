class MCRockWall extends MCSpell;

function Cast(MCPawn caster, Vector target)
{
	Spawn(class'MCRock', caster, ,target);
}

DefaultProperties
{
	name="Rock Wall"
	bEarth=true
	AP=6
}
