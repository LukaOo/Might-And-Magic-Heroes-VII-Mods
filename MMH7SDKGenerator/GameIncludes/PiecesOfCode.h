/*
#############################################################################################
# Game: Super Monday Night Combat															#
# Version: 1.0.8364.0																		#
# ========================================================================================= #
# File: PiecesOfCode.h																		#
#############################################################################################
*/

#define BASIC_STRUCTS "\
template< class T > struct TArray \n\
{ \n\
public: \n\
	T* Data; \n\
	int Count; \n\
	int Max; \n\
\n\
public: \n\
	TArray() \n\
	{ \n\
		Data = NULL; \n\
		Count = Max = 0; \n\
	}; \n\
\n\
public: \n\
	int Num() \n\
	{ \n\
		return this->Count; \n\
	}; \n\
\n\
	T& operator() ( int i ) \n\
	{ \n\
		return this->Data[ i ]; \n\
	}; \n\
\n\
	const T& operator() ( int i ) const \n\
	{ \n\
		return this->Data[ i ]; \n\
	}; \n\
\n\
	void Add ( T InputData ) \n\
	{ \n\
		Data = (T*) realloc ( Data, sizeof ( T ) * ( Count + 1 ) ); \n\
		Data[ Count++ ] = InputData; \n\
		Max = Count; \n\
	}; \n\
\n\
	void Clear() \n\
	{ \n\
		free ( Data ); \n\
		Count = Max = 0; \n\
	}; \n\
}; \n\
\n\
struct FNameEntry \n\
{ \n\
	unsigned char	UnknownData00[ 0x14 ]; \n\
	char			Name[ 0x14 ]; \n\
}; \n\
\n\
struct FName \n\
{ \n\
	int				Index; \n\
	unsigned char	unknownData00[ 0x4 ]; \n\
\n\
	FName() : Index ( 0 ) {}; \n\
\n\
	FName ( int i ) : Index ( i ) {}; \n\
\n\
	~FName() {}; \n\
\n\
	FName ( char* FindName ) \n\
	{ \n\
		static TArray< int > NameCache; \n\
\n\
		for ( int i = 0; i < NameCache.Count; ++i ) \n\
		{ \n\
		if ( ! strcmp ( this->Names()->Data[ NameCache ( i ) ]->Name, FindName ) ) \n\
			{ \n\
				Index = NameCache ( i ); \n\
				return; \n\
			} \n\
		} \n\
\n\
		for ( int i = 0; i < this->Names()->Count; ++i ) \n\
		{ \n\
			if ( this->Names()->Data[ i ] ) \n\
			{ \n\
				if ( ! strcmp ( this->Names()->Data[ i ]->Name, FindName ) ) \n\
				{ \n\
					NameCache.Add ( i ); \n\
					Index = i; \n\
				} \n\
			} \n\
		} \n\
	}; \n\
\n\
	static TArray< FNameEntry* >* Names() \n\
	{ \n\
		return (TArray< FNameEntry* >*) GNames; \n\
	}; \n\
\n\
	char* GetName() \n\
	{ \n\
		return this->Names()->Data[ Index ]->Name; \n\
	}; \n\
\n\
	bool operator == ( const FName& A ) const \n\
	{ \n\
		return ( Index == A.Index ); \n\
	}; \n\
}; \n\
\n\
struct FString : public TArray< wchar_t > \n\
{ \n\
	FString() {}; \n\
\n\
	FString ( wchar_t* Other ) \n\
	{ \n\
		this->Max = this->Count = *Other ? ( wcslen ( Other ) + 1 ) : 0; \n\
\n\
		if ( this->Count ) \n\
			this->Data = Other; \n\
	}; \n\
\n\
	~FString() {}; \n\
\n\
	FString operator = ( wchar_t* Other ) \n\
	{ \n\
		if ( this->Data != Other ) \n\
		{ \n\
			this->Max = this->Count = *Other ? ( wcslen ( Other ) + 1 ) : 0; \n\
\n\
			if ( this->Count ) \n\
				this->Data = Other; \n\
		} \n\
\n\
		return *this; \n\
	}; \n\
}; \n\
\n\
struct FScriptDelegate \n\
{ \n\
	unsigned char UnknownData00[ 0xC ]; \n\
}; \n"

#define BASIC_FUNCTIONS_DEC "\
	static TArray< UObject* >* GObjObjects(); \n\
\n\
	char* GetName(); \n\
	char* GetNameCPP(); \n\
	char* GetFullName(); \n\
\n\
	template< class T > static T* FindObject ( char* ObjectFullName ); \n\
	static UClass* FindClass ( char* ClassFullName ); \n\
\n\
	bool IsA ( UClass* pClass ); \n\n"

#define BASIC_FUNCTIONS_DEF "\
TArray< UObject* >* UObject::GObjObjects() \n\
{ \n\
	TArray< UObject* >* ObjectArray = (TArray< UObject* >*) GObjects; \n\
	return ObjectArray; \n\
} \n\
\n\
char* UObject::GetName() \n\
{ \n\
	static char cOutBuffer[ 256 ]; \n\
\n\
	sprintf_s ( cOutBuffer, \"%%s\", this->Name.GetName() ); \n\
\n\
	return cOutBuffer; \n\
} \n\
\n\
char* UObject::GetNameCPP() \n\
{ \n\
	static char cOutBuffer[ 256 ]; \n\
\n\
	if ( this->IsA ( UClass::StaticClass() ) ) \n\
	{ \n\
		UClass* pClass = (UClass*) this; \n\
		while ( pClass ) \n\
		{ \n\
			if ( ! strcmp ( pClass->GetName(), \"Actor\" ) ) \n\
			{ \n\
				strcpy_s ( cOutBuffer, \"A\" ); \n\
				break; \n\
			} \n\
			else if ( ! strcmp ( pClass->GetName(), \"Object\" ) ) \n\
			{ \n\
				strcpy_s ( cOutBuffer, \"U\" ); \n\
				break; \n\
			} \n\
\n\
			pClass = (UClass*) pClass->SuperField; \n\
		} \n\
	} \n\
	else \n\
	{ \n\
		strcpy_s ( cOutBuffer, \"F\" ); \n\
	} \n\
\n\
	strcat_s ( cOutBuffer, this->GetName() ); \n\
\n\
	return cOutBuffer; \n\
} \n\
\n\
char* UObject::GetFullName() \n\
{ \n\
	if ( this->Class && this->Outer ) \n\
	{ \n\
		static char cOutBuffer[ 256 ]; \n\
\n\
		if ( this->Outer->Outer ) \n\
		{ \n\
			strcpy_s ( cOutBuffer, this->Class->GetName() ); \n\
			strcat_s ( cOutBuffer, \" \" ); \n\
			strcat_s ( cOutBuffer, this->Outer->Outer->GetName() ); \n\
			strcat_s ( cOutBuffer, \".\" ); \n\
			strcat_s ( cOutBuffer, this->Outer->GetName() ); \n\
			strcat_s ( cOutBuffer, \".\" ); \n\
			strcat_s ( cOutBuffer, this->GetName() ); \n\
		} \n\
		else \n\
		{ \n\
			strcpy_s ( cOutBuffer, this->Class->GetName() ); \n\
			strcat_s ( cOutBuffer, \" \" ); \n\
			strcat_s ( cOutBuffer, this->Outer->GetName() ); \n\
			strcat_s ( cOutBuffer, \".\" ); \n\
			strcat_s ( cOutBuffer, this->GetName() ); \n\
		} \n\
\n\
		return cOutBuffer; \n\
	} \n\
\n\
	return \"(null)\"; \n\
} \n\
\n\
template< class T > T* UObject::FindObject ( char* ObjectFullName ) \n\
{ \n\
	while ( ! UObject::GObjObjects() ) \n\
		Sleep ( 100 ); \n\
\n\
	while ( ! FName::Names() ) \n\
		Sleep( 100 ); \n\
\n\
	for ( int i = 0; i < UObject::GObjObjects()->Count; ++i ) \n\
	{ \n\
		UObject* Object = UObject::GObjObjects()->Data[ i ]; \n\
\n\
		// skip no T class objects \n\
		if \n\
		( \n\
				! Object \n\
			||	! Object->IsA ( T::StaticClass() ) \n\
		) \n\
			continue; \n\
\n\
		// check \n\
		if ( ! _stricmp ( Object->GetFullName(), ObjectFullName ) ) \n\
			return (T*) Object; \n\
	} \n\
\n\
	return NULL; \n\
} \n\
\n\
UClass* UObject::FindClass ( char* ClassFullName ) \n\
{ \n\
	while ( ! UObject::GObjObjects() ) \n\
		Sleep ( 100 ); \n\
\n\
	while ( ! FName::Names() ) \n\
		Sleep ( 100 ); \n\
\n\
	for ( int i = 0; i < UObject::GObjObjects()->Count; ++i ) \n\
	{ \n\
		UObject* Object = UObject::GObjObjects()->Data[ i ]; \n\
\n\
		if ( ! Object ) \n\
			continue; \n\
\n\
		if ( ! _stricmp ( Object->GetFullName(), ClassFullName ) ) \n\
			return (UClass*) Object; \n\
	} \n\
\n\
	return NULL; \n\
} \n\
\n\
bool UObject::IsA ( UClass* pClass ) \n\
{ \n\
	for ( UClass* SuperClass = this->Class; SuperClass; SuperClass = ( UClass* ) SuperClass->SuperField ) \n\
	{ \n\
		if ( SuperClass == pClass ) \n\
			return true; \n\
	} \n\
\n\
	return false; \n\
} \n"

#define CLASS_PROPERTIES_UFIELD "\
	class UField*                                      Next;                                             		// NOT AUTO-GENERATED PROPERTY \n"

#define STRUCT_PROPERTIES_FPOINTER "\
	__int64                                            Dummy;                                             		// NOT AUTO-GENERATED PROPERTY \n"

#define CLASS_PROPERTIES_UFUNCTION "\
	unsigned long		FunctionFlags;								// 0x0090 (0x04)  // 0x00D0                // NOT AUTO-GENERATED PROPERTY \n\
	unsigned short		iNative;									// 0x0094 (0x02)  // 0x00D4                // NOT AUTO-GENERATED PROPERTY \n\
	unsigned short		RepOffset;									// 0x0096 (0x02)  // 0x00D6                // NOT AUTO-GENERATED PROPERTY \n\
	struct FName		FriendlyName;								// 0x0098 (0x08)  // 0x00D8                // NOT AUTO-GENERATED PROPERTY \n\
	unsigned char       UnkByte;                                     // 0x00A0 (0x02) // 0x00E0  (0x01)        // NOT AUTO-GENERATED PROPERTY \n\
	unsigned char		NumParms;								    //                // 0x00E1  (0x01)        // NOT AUTO-GENERATED PROPERTY \n\
	unsigned short		ParmsSize;									// 0x00A2 (0x02)  // 0x00E2                // NOT AUTO-GENERATED PROPERTY \n\
	unsigned long		ReturnValueOffset;							// 0x00A4 (0x04)  // 0x00E4                // NOT AUTO-GENERATED PROPERTY \n\
	unsigned char		UnknownData00[ 0x8 ];						// 0x00A8 (0x04)  // 0x00E8  (0x08)        // NOT AUTO-GENERATED PROPERTY \n\
	void*				Func;									    // 0x00AC (0x04)  // 0x00F0                // NOT AUTO-GENERATED PROPERTY \n"

#define CLASS_PROPERTIES_USTRUCT "\
	unsigned char                                      UnknownData00[ 0x10 ];                                    // NOT AUTO-GENERATED PROPERTY \n\
	class UField*                                      SuperField;                                              // NOT AUTO-GENERATED PROPERTY \n\
	class UField*                                      Children;                                                // NOT AUTO-GENERATED PROPERTY \n\
	unsigned long                                      PropertySize;                                            // NOT AUTO-GENERATED PROPERTY \n\
	unsigned char                                      UnknownData01[ 0x44 ];                                   // NOT AUTO-GENERATED PROPERTY \n"

#define CLASS_PROPERTIES_UPROPERTY "\
                                                                    // x32           // x64 \
   unsigned long		ArrayDim;									// 0x0040 (0x04) // 0x0068					// NOT AUTO-GENERATED PROPERTY \n\
   unsigned long		ElementSize;								// 0x0044 (0x04) // 0x006C                  // NOT AUTO-GENERATED PROPERTY \n\
   FQWord				PropertyFlags;								// 0x0048 (0x08) // 0x0070                  // NOT AUTO-GENERATED PROPERTY \n\
   unsigned char		UnknownData00[ 0x14 ];						// 0x0050 (0x10) // 0x0078  //0x14          // NOT AUTO-GENERATED PROPERTY \n\
   unsigned long		Offset;										// 0x0060 (0x04) // 0x008C                  // NOT AUTO-GENERATED PROPERTY \n\
   unsigned char		UnknownData01[ 0x18 ];						// 0x0064 (0x1C) // 0x0090 //0x18           // NOT AUTO-GENERATED PROPERTY \n\
"