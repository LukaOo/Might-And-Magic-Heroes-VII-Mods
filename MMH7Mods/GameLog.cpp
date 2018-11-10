#include "StdAfx.h"
#include "GameLog.h"
#include <time.h>

GemeLogPtr __gLog;

Log& Log::LogTS()
{
	time_t t = time(NULL);
	struct tm *tm = localtime(&t);
	char date[20];
	strftime(date, sizeof(date), "%Y-%m-%d %H:%M:%S", tm);
	*this << date << " ";
	return *this;
}

GameLog::GameLog(const ModsConfig& config) : 
                 _cfg(config),
				 _clog(_cfg.filePath.c_str())
{
}


GameLog::~GameLog(void)
{
}

LogConfig::LogConfig(const ModsConfig& config) : 
           sectionName("Log"),
		   filePath(config.GetValue((sectionName+"/FilePath").c_str(), std::string("") ) ),
		   logLevel((LogLevel)config.GetValue((sectionName+"/Level").c_str(), (int)LL_NORMAL ))
{
  
}
