class MCPathNode extends PathNode
	hidecategories(VehicleUsage, Display, Attachment, Collision, Physics, Advanced, Debug, Mobile);

var(MystrasPathNode) int APValue;

function PostBeginPlay()
{
	super.PostBeginPlay();
	///
}

defaultproperties
{
	// Setting the base value for a PathNode
	APValue = 1


	Role=Role_Authority
	RemoteRole=ROLE_SimulatedProxy
}