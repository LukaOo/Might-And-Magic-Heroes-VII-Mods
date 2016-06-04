class H7SeqAct_OperateFogOfWar extends SequenceAction
	native;

//TODO: this action belongs to one of "for one/all player action". Refactor after implementing player action
var(Properties) EPlayerNumber mPlayerNumber<DisplayName="Target player"|ToolTip="The player that gets the fog of war changed">;

var(Properties) bool mIsCovered<DisplayName="Is Covered"|ToolTip="True = Fog is changed to hidden. False = Fog is revealed. [default: False]">;
var(Properties) bool mIsPermanent<DisplayName="Is Permanent"|ToolTip="True = The change is permanent. False = Fog can be re-explored/re-covered. [default: False] NOTE: Applies to all players!">;

var savegame bool mWasActivated;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

