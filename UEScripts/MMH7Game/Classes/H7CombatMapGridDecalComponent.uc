class H7CombatMapGridDecalComponent extends DecalComponent
	native(Core);

var transient const H7EditorCombatGrid mOwnerGrid; // assigned on PostLoad of combat grid

var protected const Material mOriginalMaterial; // used to store the original material that mDynamicMaterialInstance will be parented with
var protected transient MaterialInstanceConstant mDynamicMaterialInstance; // created on init
var protected transient Texture2DDynamic mDynamicGridDataTexture; // created on init
var protected native array<byte> mDynamicGridDataTexMip;

native function UpdateGridDataRendering(); // EXPENSIVE FUNCTION !
native function ManualReattach();

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

