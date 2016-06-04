#include "stdafx.h"
#include "TFL_HT.h"

namespace TFLHACKT00LS
{
	//===========================================================================//
	//==== GetModuleInfo - Get Module Base, Module Size, Module Entry Point =====//
	//===========================================================================//

	MODULEINFO GetModuleInfo ( LPCTSTR lpModuleName )
	{
		MODULEINFO miInfos = { NULL };

		HMODULE hmModule = GetModuleHandle ( lpModuleName );

		if ( hmModule )
		{
			GetModuleInformation ( GetCurrentProcess(), hmModule, &miInfos, sizeof ( MODULEINFO ) );
		}

		return miInfos;
	}

	//===========================================================================//
	//==== FindPattern ==========================================================//
	//===========================================================================//

	DWORD64 FindPattern ( DWORD64 startAddres, DWORD64 fileSize, PBYTE pattern, char mask[] )
	{
		DWORD64 pos = 0;
		int searchLen = strlen ( mask ) - 1;

		for ( DWORD64 retAddress = startAddres; retAddress < startAddres + fileSize; retAddress++ )
		{
			if ( *(PBYTE) retAddress == pattern[ pos ] || mask[ pos ] == '?' )
			{
				if ( mask[ pos + 1 ] == '\0' )
				{
					return ( retAddress - searchLen );
				}
					
				pos++;
			} 
			else
			{
				pos = 0;
			}		
		}

		return NULL;
	}
}