#pragma once

class AH7AdventureController;
class AH7AiAdventureMap;
class AH7Unit;
#include <mutex>

///
/// Lock this thread
///
class Locker 
{
public :
	Locker(std::mutex& lock) :_lock(lock) {}
	~Locker() { _lock.unlock(); }

private :
	std::mutex& _lock;
};

///
/// Class to implement AI logic on adventure map
///
class AIAdventureMap
{
public:
	AIAdventureMap(AH7AdventureController* controller, AH7AiAdventureMap* aiAdvMap, AH7AdventureGridManager* gridManager);
	virtual ~AIAdventureMap();
	
	bool Think(AH7Unit* Unit, float DeltaTime);

private :
	AH7AdventureController* _controller; 
	AH7AiAdventureMap* _aiAdvMap;
	AH7AdventureGridManager* _gridManager;
	std::mutex _lock;
};

