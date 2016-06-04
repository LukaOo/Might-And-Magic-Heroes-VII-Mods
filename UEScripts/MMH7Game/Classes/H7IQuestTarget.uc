interface H7IQuestTarget
	dependson(H7StructsAndEnums)
	native;


function int                GetQuestTargetID()   {}
function H7AdventureMapCell GetCurrentPosition() {}
function bool               IsHidden()           {}
function bool               IsMovable()          {}
function                    ClearQuestFlag()     {}
function                    AddQuestFlag()       {}    
