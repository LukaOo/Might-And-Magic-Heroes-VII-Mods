#include "StdAfx.h"
#include "Featurizer.h"

FeatureVector Featurizer::_features;

Featurizer::Featurizer(void)
{
}


Featurizer::~Featurizer(void)
{
}

Featurizer::Fea::Fea() : 
                        _idx(int(Featurizer::_features.size()))
{
	Featurizer::_features.push_back(0);
}

