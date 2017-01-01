// MMH7ScriptsMod.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "stdafx.h"
#include "MMH7Mods.h"
#include <stdio.h>
#include <malloc.h>
#include <iomanip>
#include <Psapi.h>
#include "SdkHeaders.h"
#include "vmt.h"
#include <fstream>
#include <string>
#include <set>
#include <vector>
#include "HookBase.h"
#include "GameLog.h"

VMTManager::DetourPtr OriginalProcessInternal;

DWORD64 GObjects = 0;
DWORD64 GNames = 0;
DWORD64 ModuleBaseAddr = 0;


