//----------------------------------------------------------------------------
// MCSpell_Kaleidoscope
//
// Kaleidoscope Spell Activator
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCSpell_Kaleidoscope extends MCSpell;

function Cast(MCPawn caster, MCPawn enemy)
{
	local UDKProjectile fireball;
	fireball = Spawn(class'MCProjectileFireBall', caster, , caster.Location);
	fireball.Init(enemy.Location - caster.Location);
}

DefaultProperties
{
}