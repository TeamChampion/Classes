class MCFireball extends MCSpell;

function Cast(MCPawn caster, MCPawn enemy)
{
	local UDKProjectile fireball;
	fireball = Spawn(class'MCProjectileFireBall', caster, , caster.Location);
	fireball.Init(enemy.Location - caster.Location);
}

DefaultProperties
{
	name="Fireball"
	AP=6
	bFire=true
}