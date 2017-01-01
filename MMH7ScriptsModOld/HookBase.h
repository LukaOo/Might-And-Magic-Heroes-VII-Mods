#pragma once

#include "MMH7Mods.h"


//
// Declares hook function holder
//
class HookFunction
{
public :
	HookFunction(){};
	virtual ~HookFunction() {};

	virtual int Func(__int64 This, __int64 Stack_frame, void* pResult) = 0;
};

class PrefixMapper : public HookFunction {
	public :
		PrefixMapper(std::string *prefix, std::vector<std::string> *exceptions);
		int Func(__int64 This, __int64 Stack_frame, void* pResult);
	private:
		std::vector<std::string> *_exceptions;
		std::string *_prefix;
		std::string *_targetPrefix;
}

///
/// Class for function hooks list  
///
class ProcessInternalHooks
{
public:

	void Add(const char* name, HookFunction* func) { _hooks[std::string(name)] = func; };
	void AddPrefix(const char* prefix, HookFunction* func) { _prefixHooks[std::string(prefix)] = func; };

	///
	/// Get hook function pointer by prefix
	///
	HookFunction* GetByPrefix(const std::string& funcPrefix) const
	{ 
		for (std::map<std::string, HookFunction*>::const_iterator it=_prefixHooks.begin(); it!=_prefixHooks.end(); ++it) {
			auto res = std::mismatch(funcPrefix.begin(), funcPrefix.end(), it->first.begin());
			if (res.first == funcPrefix.end()) {
				return it->second;
			}
		}
		return NULL;
	}

	///
	/// Get hook function pointer by name
	///
	HookFunction* GetByName(const std::string& func_name) const
	{ 
		std::map<std::string, HookFunction*>::const_iterator it = _hooks.find(func_name);
		return (_hooks.end() == it)? NULL: it->second;
	}

	HookFunction* Get(const std::string& func_name) const
	{ 
		HookFunction* hookFunction = NULL;
		hookFunction = GetByPrefix(func_name);
		if(hookFunction) {
			return hookFunction;
		}
		return GetByName(func_name);
	}

private:

	std::map<std::string, HookFunction* > _hooks;
	std::map<std::string, HookFunction* > _prefixHooks;
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


