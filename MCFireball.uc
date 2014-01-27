class MCFireball extends MCSpell;

function Cast(Actor owner)
{
	local UDKProjectile fireball;
	fireball = Spawn(class'MCProjectileFireBall', owner, , vect(0, 128, 128));
	fireball.Init(vect(0, 256, 128));
}

DefaultProperties
{
	name="Fireball"
	AP=6
	
}