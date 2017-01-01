#pragma once

#include "MMH7Mods.h"


///
/// Base class to 
///
class HookBase
{
public:
	/// ctor
	HookBase(const char* hookName) : _Name(hookName){}

	///
	/// Get name of hook
	///
	const std::string& GetName() const { return _Name;}
private:
	std::string _Name;
};

typedef std::shared_ptr<HookBase> HookBasePtr;

//
// Declares hook function holder
//
class HookFunction
{
public :
	HookFunction(const char* name);
	virtual ~HookFunction() {};

	virtual int Func(__int64 This, __int64 Stack_frame, void* pResult) = 0;
};

class HookFunctionToCallback: public HookFunction {
public:
	HookFunctionToCallback(const char* name, int (*callback)(__int64 This, __int64 Stack_frame, void* pResult));
	~HookFunctionToCallback(){};
	int Func(__int64 This, __int64 Stack_frame, void* pResult);
private:
	int (*_callback)(__int64 This, __int64 Stack_frame, void* pResult);
};

///
/// Class for function hooks list  
///
class ProcessInternalHooks
{
public:

	void Add(const char* name, HookFunction* func) { _hooks[std::string(name)] = func; };

	///
	/// Get hook function pointer 
	///
	HookFunction* Get(const std::string& func_name) const
	{ 
		std::map<std::string, HookFunction*>::const_iterator it = _hooks.find(func_name);
		return (_hooks.end() == it)? NULL: it->second;
	}

	int GetSize() const {return (int) _hooks.size(); }

private:

	std::map<std::string, HookFunction* > _hooks;
};

///
/// Holder for all hooked clases  
///
class HooksHolder
{
	friend class HookFunction;
public:
	HooksHolder(){}

	//
	// Call function
	//
	bool CallFunc(const std::string& funcName,
	              __int64 This, __int64 Stack_frame, void* pResult,
	              int& result);

	static HooksHolder& GetHolder();

private:
	ProcessInternalHooks __hook_func_list;
};

typedef std::shared_ptr<HooksHolder> HooksHolderPtr;

extern HooksHolderPtr __hooksHolder;


