class MCActor extends Actor
	placeable;

var archetype MCTile		ArcTile;
var archetype MCTrigger 	ArcTrigger;
var archetype MCPathNode 	ArcPathNode;

var vector TileLocation;
var vector TriggerLocation;
var vector PathNodeLocation;

function PostBeginPlay()
{
	`log("We are live!");
	AttachStuff();
	super.PostBeginPlay();
}

function AttachStuff()
{
	//WizardArhetype = spawn(class'Player01',,,MySpawnPoint.Location,,WizardArhetype);
//	ArcTile 	= Spawn(class'MCTile',,, 	TileLocation, 	 Rotation, ArcTile,);
//	ArcTrigger  = Spawn(class'MCTrigger',,, TriggerLocation, Rotation, ArcTrigger,);
//	ArcPathNode = Spawn(class'MCPathNode',,,TileLocation, 	 Rotation, ArcPathNode,);
}






defaultproperties
{
	// Spawn Locations
	TileLocation =	   (X=0.0f, Y=0.0f, Z=0.0f)
	TriggerLocation =  (X=0.0f, Y=0.0f, Z=0.0f)
	PathNodeLocation = (X=0.0f, Y=0.0f, Z=60.0f)

	// Archetypes
//	ArcTile=MCTile'mystraschampionsettings.Archetype.MCTile'
//	ArcTrigger=MCTrigger'mystraschampionsettings.Archetype.MCTrigger'
//	ArcPathNode=MCPathNode'mystraschampionsettings.Archetype.MCPathNode'


}