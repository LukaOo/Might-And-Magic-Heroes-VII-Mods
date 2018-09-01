#pragma once

#include <vector>

typedef float Feature;
typedef std::vector<Feature> FeatureVector;

///
/// Base class featurizer
///
class Featurizer
{
public:
	Featurizer(void);
	~Featurizer(void);

	class Fea
	{
	 public :

	  Fea();

	  template<class T>
	  inline Fea& operator =(const T& data)
	  {
		  Featurizer::_features[_idx] = (Feature)data;
		  return *this;
	  }

	  inline operator float() const { return Featurizer::_features[_idx]; }

	 private :
	  
      int _idx;
	  Feature* _pCell;
	};

	const FeatureVector& GetFeatures() const { return _features; }
    ///
	/// Reset all feature set
	///
	void ResetFeatures() { std::fill(_features.begin(), _features.end(), 0.f); };

	///
	/// init or calculate all features 
	///
	virtual void Init(void* params) {};
private:

    static FeatureVector _features;
};

