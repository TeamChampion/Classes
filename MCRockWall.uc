class MCRockWall extends MCSpell;

function Cast(MCPawn caster, Vector target)
{
	//local MCRock rock;
	//Spawn(ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_Dust_Secondary', caster, , target);
	Spawn(class'MCRock', caster, ,target);
	//rock.Initialize();	
}

DefaultProperties
{
	name="Rock Wall"
	bEarth=true
	AP=6
}