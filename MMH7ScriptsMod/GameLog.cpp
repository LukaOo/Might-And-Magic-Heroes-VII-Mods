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

GameLog::GameLog() : 
                 _cfg(),
				 _clog(_cfg.filePath.c_str())
{

}


GameLog::~GameLog(void)
{
}

LogConfig::LogConfig() :
		   filePath(std::string("MMH7ScriptsMod.log")),
		   logLevel(LL_VERBOSE)
{
  
}
