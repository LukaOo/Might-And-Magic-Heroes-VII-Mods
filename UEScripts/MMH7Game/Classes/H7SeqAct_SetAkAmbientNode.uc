class H7SeqAct_SetAkAmbientNode extends SequenceAction
	implements(H7IAliasable)
	native;

var (Properties) protected bool mEnableNode <DisplayName=Enables/Disables a H7AkAmbientNode>;
var (Properties) protected array <H7AkAmbientNode> mNodeReferences <DisplayName=The H7AkAmbientNode References>;

event activated()
{
	local H7AkAmbientNode node;

	foreach mNodeReferences(node)
	{
		if(mEnableNode)
		{
			node.EnableAkEvent();
		}
		else
		{
			node.DisableAkEvent();
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

