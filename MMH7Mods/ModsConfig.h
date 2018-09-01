#pragma once

#include <iostream>

#include "libconfig++\libconfig.h++"

///
/// Mods configuration
///
class ModsConfig
{
public:
	ModsConfig(void);
	~ModsConfig(void);
	
	template<class T>
	T GetValue(const char* name, const T& def) const
	{
		T val = def;
		try
		{
			if(!_cfg.lookupValue(name, val) )
			{
				val = def;
			}
		 }
		 catch(const libconfig::SettingNotFoundException &/*nfex*/)
		 {
			std::cerr << "No 'name' setting in configuration file." << std::endl;
		 }

       return val;
	}

	const std::string& GetLogName() const {return _logFileName; } 

	const libconfig::Config& GetConfig() const { return _cfg; };

	const bool IsConfigured() const { return _isConfigured;  }

private :
	std::string _logFileName;
private :
	libconfig::Config _cfg;
	bool _isConfigured;
	std::string _processName;
};

