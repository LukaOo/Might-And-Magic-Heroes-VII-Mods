//=============================================================================
// H7AiUtilityBase
//=============================================================================
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityBase extends Object
	dependson(H7StructsAndEnumsNative)
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display);


var(AiUtility) protected float              mInNorm<DisplayName=Input Normalization Factor>;
var(AiUtility) protected float              mInMin<DisplayName=Input Minimum Bound>;
var(AiUtility) protected float              mInMax<DisplayName=Input Maximum Bound>;
var(AiUtility) protected float              mOutWeight<DisplayName=Output Weight Factor>;
var(AiUtility) protected EUtilityFunction   mFunction<DisplayName=Function>;
var(AiUtility) protected array<Vector2D>    mFData<DisplayName=Function Sample Data>;
var(AiUtility) protected float              mFBias<DisplayName=Function Bias Value>;
var(AiUtility) protected float              mFMult<DisplayName=Function Multiplier Value>;



var protected array<float>                 mInValues;
var protected array<float>                 mOutValues;

function array<float> GetOutValues() { return mOutValues; }

/// overrides ...

function UpdateInput()
{
//	mInValues.Remove(0,mInValues.Length);
}

function UpdateOutput()
{
//	mOutValues.Remove(0,mOutValues.Length);
}

/// functions

function ApplyFunction()
{
	local int k;
	InputNormalize();

	mOutValues.Remove(0,mOutValues.Length);

	for(k=0;k<mInValues.Length;k++)
	{
		mOutValues.AddItem(0.0f);
		switch(mFunction)
		{
			case UF_BOOLEAN: 
				mOutValues[k] = FuncBoolean(mInValues[k]);
				break;
			case UF_INV_BOOLEAN:
				mOutValues[k] = 1.0f - FuncBoolean(mInValues[k]);
				break;
			case UF_LINEAR: 
				mOutValues[k] = FuncLinear(mInValues[k]);
				break;
			case UF_INV_LINEAR:
				mOutValues[k] = 1.0f - FuncLinear(mInValues[k]);
				break;
			case UF_SINUS:
				mOutValues[k] = FuncSinus(mInValues[k]);
				break;
			case UF_INV_SINUS:
				mOutValues[k] = 1.0f - FuncSinus(mInValues[k]);
				break;
			case UF_SQUARE:
				mOutValues[k] = FuncSquare(mInValues[k]);
				break;
			case UF_INV_SQUARE:
				mOutValues[k] = 1.0f - FuncSquare(mInValues[k]);
				break;
			case UF_CUBIC:
				mOutValues[k] = FuncCubic(mInValues[k]);
				break;
			case UF_INV_CUBIC:
				mOutValues[k] = 1.0f - FuncCubic(mInValues[k]);
				break;
			case UF_CUSTOM:
				mOutValues[k] = FuncSample(mInValues[k]);
				break;
			case UF_BIAS:
				mOutValues[k] = FuncBias(mInValues[k]);
				break;
			default:
				mOutValues[k]=mInValues[k];

		}
	}
}

protected function InputNormalize()
{
	local int k;
	for(k=0;k<mInValues.Length;k++)
	{
		mInValues[k] = FClamp(mInValues[k],mInMin,mInMax) * mInNorm;
	}
}

protected function ApplyOutputWeigth()
{
	local int k;
	for(k=0;k<mOutValues.Length;k++)
	{
		mOutValues[k] *= mOutWeight;
	}
}

protected function float FuncBoolean(float iv)
{
	if(iv<=0.5f) {
		return 0.0f;
	}
	return 1.0f;
}

protected function float FuncLinear(float iv)
{
	return FClamp(iv,0.0f,1.0f);
}

protected function float FuncSinus(float iv)
{
	return Sin(iv*1.570796f);
}

protected function float FuncSquare(float iv)
{
	return iv*iv;
}

protected function float FuncCubic(float iv)
{
	return iv*iv*iv;
}

protected function float FuncSample(float iv)
{
	local int i, i0, i1;
	local float l, h, d, a;
	if( mFData.Length == 0 ) return iv;
	if( mFData.Length == 1 ) return mFData[0].Y;

	i0 = 0;
	i1 = mFData.Length - 1;

	if( iv <= mFData[i0].X ) return mFData[i0].Y;
	if( iv >= mFData[i1].X ) return mFData[i1].Y;
	
	for( i=0; i<(mFData.Length-1); i++ ) {
		if(iv>=mFData[i].X) i0=i;
	}

	if( (i0+1) < i1 ) i1=i0+1;

	l = mFData[i0].Y;
	h = mFData[i1].Y;

	d = mFData[i1].X-mFData[i0].X;
	if(d>0.0f)
		a = (iv-mFData[i0].X) / d;
	else
		a = 0.0f;

	return Lerp(l,h,a);
}

protected function float FuncBias(float iv)
{
	local float intermediate;
	if(mFBias<=0.0f) mFBias=0.5f;
	if(mFBias>1.0f) mFBias=1.0f;
	intermediate = iv / ((((1.0f/mFBias)-2.0f)*(1.0f-iv))+1.0f);
	intermediate *= mFMult;
	return intermediate;
}

