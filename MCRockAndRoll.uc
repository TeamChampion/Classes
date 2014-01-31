class MCRockAndRoll extends MCSpell;

function Cast(MCPawn caster, MCPawn enemy)
{
	local UDKProjectile rockAndRoll;
	local Vector modifiedStart;
	modifiedStart = caster.Location;
	modifiedStart.Z += 120;
	rockAndRoll = Spawn(class'MCProjectileRockAndRoll', caster, , modifiedStart);
	rockAndRoll.Init(enemy.Location - modifiedStart);
}

DefaultProperties
{
	name="Rock & Roll"
	AP=3
	bEarth=true
}