class MCRock extends KActor;

DefaultProperties
{
	Begin Object class=StaticMeshComponent name=RockMesh
		StaticMesh=StaticMesh'mystrasmain.StaticMesh.RockBlocker'
	End Object
	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
	End Object

	Components.Add(RockMesh)
	Components.Add(MyLightEnvironment)
}