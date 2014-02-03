class MCRock extends KActor;

DefaultProperties
{
	RemoteRole=ROLE_SimulatedProxy
	//bOnlyDirtyReplication 	= false
	bAlwaysRelevant			= true
	
	Begin Object class=StaticMeshComponent name=RockMesh
		StaticMesh=StaticMesh'mystrasmain.StaticMesh.RockBlocker'
	End Object
	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
	End Object

	Components.Add(RockMesh)
	Components.Add(MyLightEnvironment)
}