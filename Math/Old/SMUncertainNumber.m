//
//  SMUncertainNumber.m
//  Precision RPN
//
//  Created by Justin Buchanan on 8/16/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import "SMUncertainNumber.h"
#import "NSString+FloatParsing.h"





#pragma mark Operation Functions

typedef SMUncertainNumber* (*SMUncertainNumberOperationFunction)(SMUncertainNumber*, SMUncertainNumber*);	//	pointer to a function that performs an operation
///////		none of these functions is correct	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SMUncertainNumber *SMUncertainNumberOperationSquareFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)///////////////////////////////////////////////////////////////////////////////////////////
{
	return [[[SMUncertainNumber alloc] initWithDoubleValue:leftOperand.doubleValue * leftOperand.doubleValue] autorelease];
}

SMUncertainNumber *SMUncertainNumberOperationSquareRootFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)///////////////////////////////////////////////////////////////////////////////////////////
{
	return [[[SMUncertainNumber alloc] initWithDoubleValue:sqrt(leftOperand.doubleValue)] autorelease];
}

SMUncertainNumber *SMUncertainNumberOperationAbsoluteValueFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)
{
	return [[[SMUncertainNumber alloc] initWithValue:ABS(leftOperand.doubleValue) uncertainty:leftOperand.uncertainty] autorelease];
}

SMUncertainNumber *SMUncertainNumberOperationNegateFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)
{
	return [[[SMUncertainNumber alloc] initWithValue:-(leftOperand.doubleValue) uncertainty:leftOperand.uncertainty] autorelease];
}

SMUncertainNumber *SMUncertainNumberOperationLogFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)///////////////////////////////////////////////////////////////////////////////////////////
{
	return [[[SMUncertainNumber alloc] initWithDoubleValue:log10(leftOperand.doubleValue)] autorelease];
}

SMUncertainNumber *SMUncertainNumberOperationNaturalLogFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)///////////////////////////////////////////////////////////////////////////////////////////
{
	return [[[SMUncertainNumber alloc] initWithDoubleValue:log(leftOperand.doubleValue)] autorelease];
}

SMUncertainNumber *SMUncertainNumberOperationSineFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)///////////////////////////////////////////////////////////////////////////////////////////
{
	double radianValue = JBAngleConvert([SMNumber angleUnit], JBAngleUnitRadian, leftOperand.doubleValue);
	return [[[SMUncertainNumber alloc] initWithDoubleValue:sin(radianValue)] autorelease];
}

SMUncertainNumber *SMUncertainNumberOperationCosineFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)///////////////////////////////////////////////////////////////////////////////////////////
{
	double radianValue = JBAngleConvert([SMNumber angleUnit], JBAngleUnitRadian, leftOperand.doubleValue);
	return [[[SMUncertainNumber alloc] initWithDoubleValue:cos(radianValue)] autorelease];
}

SMUncertainNumber *SMUncertainNumberOperationTangentFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)///////////////////////////////////////////////////////////////////////////////////////////
{
	double radianValue = JBAngleConvert([SMNumber angleUnit], JBAngleUnitRadian, leftOperand.doubleValue);
	return [[[SMUncertainNumber alloc] initWithDoubleValue:tan(radianValue)] autorelease];
}

SMUncertainNumber *SMUncertainNumberOperationArcSineFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)///////////////////////////////////////////////////////////////////////////////////////////
{
	double radianValue = JBAngleConvert(JBAngleUnitRadian, [SMNumber angleUnit], asin(leftOperand.doubleValue));
	return [[[SMUncertainNumber alloc] initWithDoubleValue:radianValue] autorelease];
}

SMUncertainNumber *SMUncertainNumberOperationArcCosineFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)///////////////////////////////////////////////////////////////////////////////////////////
{
	double radianValue = JBAngleConvert(JBAngleUnitRadian, [SMNumber angleUnit], acos(leftOperand.doubleValue));
	return [[[SMUncertainNumber alloc] initWithDoubleValue:radianValue] autorelease];
}

SMUncertainNumber *SMUncertainNumberOperationArcTangentFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)///////////////////////////////////////////////////////////////////////////////////////////
{
	double radianValue = JBAngleConvert(JBAngleUnitRadian, [SMNumber angleUnit], atan(leftOperand.doubleValue));
	return [[[SMUncertainNumber alloc] initWithDoubleValue:radianValue] autorelease];
}

SMUncertainNumber *SMUncertainNumberOperationAddFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)
{
	return [[[SMUncertainNumber alloc] initWithValue:(leftOperand.doubleValue + rightOperand.doubleValue) uncertainty:(leftOperand.uncertainty + rightOperand.uncertainty)] autorelease];
}

SMUncertainNumber *SMUncertainNumberOperationSubtractFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)
{
	return [[[SMUncertainNumber alloc] initWithValue:(leftOperand.doubleValue - rightOperand.doubleValue) uncertainty:(leftOperand.uncertainty + rightOperand.uncertainty)] autorelease];
}

SMUncertainNumber *SMUncertainNumberOperationMultiplyFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)///////////////////////////////////////////////////////////////////////////////////////////
{
	return [[[SMUncertainNumber alloc] initWithDoubleValue:leftOperand.doubleValue * rightOperand.doubleValue] autorelease];
}

SMUncertainNumber *SMUncertainNumberOperationDivideFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)///////////////////////////////////////////////////////////////////////////////////////////
{
	NSLog(@"SMUncertainNumber about to divide: %@ by %@", leftOperand, rightOperand);
	return [[[SMUncertainNumber alloc] initWithDoubleValue:leftOperand.doubleValue / rightOperand.doubleValue] autorelease];
}

SMUncertainNumber *SMUncertainNumberOperationRaiseToPowerFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)	/////??????????????????????????????????????????????????
{
	return [[[SMUncertainNumber alloc] initWithDoubleValue:pow(leftOperand.doubleValue, rightOperand.doubleValue)] autorelease];		/////////////////////////////////////////////////////////////////////////////////////////////
}

SMUncertainNumber *SMUncertainNumberOperationTakeRootFunction(SMUncertainNumber *leftOperand, SMUncertainNumber *rightOperand)///////////////////////////////////////////////////////////////////////////////////////////
{
	//return [[[SMUncertainNumber alloc] initWithDoubleValue:sqrt(leftOperand.doubleValue)] autorelease];
	return nil;		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}




/*	an arry of function pointers for easy lookup of the function that goes with an operation	*/
static SMUncertainNumberOperationFunction operationFunctions[] = {
	SMUncertainNumberOperationSquareFunction,
	SMUncertainNumberOperationSquareRootFunction,
	SMUncertainNumberOperationAbsoluteValueFunction,
	SMUncertainNumberOperationNegateFunction,
	SMUncertainNumberOperationLogFunction,
	SMUncertainNumberOperationNaturalLogFunction,
	SMUncertainNumberOperationSineFunction,
	SMUncertainNumberOperationCosineFunction,
	SMUncertainNumberOperationTangentFunction,
	SMUncertainNumberOperationArcSineFunction,
	SMUncertainNumberOperationArcCosineFunction,
	SMUncertainNumberOperationArcTangentFunction,
	SMUncertainNumberOperationAddFunction,
	SMUncertainNumberOperationSubtractFunction,
	SMUncertainNumberOperationMultiplyFunction,
	SMUncertainNumberOperationDivideFunction,
	SMUncertainNumberOperationRaiseToPowerFunction,
	SMUncertainNumberOperationTakeRootFunction
};











@implementation SMUncertainNumber
@synthesize uncertainty = _uncertainty;

- (id)initWithValue:(double)value uncertainty:(double)uncertainty
{
	if ( self = [super initWithDoubleValue:value] )
	{
		_uncertainty = uncertainty;
	}
	return self;
}

- (id)initWithString:(NSString *)string
{
	if ( self = [super init] )
	{
		//_value = [string parseFloatInRange:NSMakeRange(0, [string length])];
	}
	return self;
}


- (NSString *)descriptionWithLocale:(NSLocale *)locale
{
	return [NSString stringWithFormat:@"<SMUncertainNumber : Value=%Lf, Uncertainty=%Lf>", _value, _uncertainty];
}


#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ( self = [super initWithCoder:aDecoder] )
	{
		_uncertainty = [aDecoder decodeDoubleForKey:@"Uncertainty"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeDouble:_uncertainty forKey:@"Uncertainty"];
}



#pragma mark Class Methods

+ (SMPrecisionType)precisionType
{
	return SMPrecisionTypeUncertaintyTracking;
}

+ (SMNumber *)numberByPerformingOperation:(SMNumberOperation)operation withNumber:(SMNumber *)x withNumber:(SMNumber *)y error:(NSError **)error
{
	SMUncertainNumberOperationFunction function = operationFunctions[operation];
	SMUncertainNumber *result = function((SMUncertainNumber *)x, (SMUncertainNumber *)y);
	
	return result;
}

@end
