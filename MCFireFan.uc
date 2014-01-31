class MCFireFan extends MCSpell;

function Cast(MCPawn caster, MCPawn enemy)
{
	local MCProjectileFireFan firefan;
	firefan = Spawn(class'MCProjectileFireFan', caster, , caster.Location);
	firefan.Init(enemy.Location - caster.Location);
}

DefaultProperties
{
	name="Fire Fan"
	AP=3
	bFire=true
}