#pragma once
#include <fstream>
#include <memory>
#include "ModsConfig.h"

enum LogLevel
{
	LL_NORMAL,
	LL_VERBOSE,
	LL_DEBUG
};

class LogConfig
{
public :

	 LogConfig(const ModsConfig& config);
public :
	const std::string sectionName;
	const std::string filePath;
	const LogLevel logLevel;
};

class Log
{
public :

	template < class T>
	Log& operator << (const T& val)
	{
		std::ostream* s = GetStream();
		if( s != NULL) *s << val;
		s->flush();
		return *this;
	}

	Log& LogTS();

protected :

	virtual std::ostream* GetStream(){ return NULL; }

};


///
/// Class for game log
///
class GameLog : Log
{
public:
	GameLog(const ModsConfig& config);
	~GameLog(void);
	
	inline LogLevel Level() const { return _cfg.logLevel; }

	inline Log& GetLog(LogLevel level) 
	{
		return  level <= _cfg.logLevel ?  *this : _stub; 
	}

protected :

	std::ostream* GetStream(){ return &_clog; }

private :
	LogConfig     _cfg;
	std::ofstream _clog;
	Log           _stub;
};



typedef std::shared_ptr<GameLog> GemeLogPtr;
extern GemeLogPtr __gLog;
#define LOG(LLevel)  (__gLog->GetLog(LLevel))
#define LOGTS(LLevel) (__gLog->GetLog(LLevel).LogTS())
