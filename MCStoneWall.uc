class MCStoneWall extends MCSpell;

function Cast(MCPawn caster, Vector target)
{
	//local ParticleSystem smoke;
	//smoke = ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_Dust_Secondary';
	//WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_Dust_Secondary', target);
	Spawn(class'MCRock', caster, ,target);
}

DefaultProperties
{
	name="Stone Wall"
	bEarth=true
	AP=6
}