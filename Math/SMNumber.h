//
//  SMNumber.h
//  Precision RPN
//
//  Created by Justin Buchanan on 8/16/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import <Foundation/NSObject.h>
#import <Foundation/NSString.h>
#import "JBAngleUnit.h"
#import <math.h>
#import "Decimal.h"


/******************************	Display Formats		******************************/

typedef enum {
	SMPrecisionTypeSigFigs,
	//SMPrecisionTypeUncertaintyTracking,	//	NIST
	SMPrecisionTypeNone
} SMPrecisionType;


/******************************	Display Formats		******************************/

typedef enum {
	SMNumberDisplayFormatScientificNotation,
	SMNumberDisplayFormatRegular
} SMNumberDisplayFormat;


/******************************	Operations	******************************/

typedef enum {
	/*	One Operand	*/
	SMNumberOperationSquare			= 0,
	SMNumberOperationCube,
	SMNumberOperationSquareRoot,
	SMNumberOperationAbsoluteValue,
	SMNumberOperationNegate,
	SMNumberOperationLog,
	SMNumberOperationNaturalLog,
	
	SMNumberOperationSine,
	SMNumberOperationCosine,
	SMNumberOperationTangent,
	SMNumberOperationArcSine,
	SMNumberOperationArcCosine,
	SMNumberOperationArcTangent,
	
	/*	Two Operands	*/
	SMNumberOperationAdd,
	SMNumberOperationSubtract,
	SMNumberOperationMultiply,
	SMNumberOperationDivide,
	SMNumberOperationRaiseToPower,	//	left operand is the base, right is the exponent
	SMNumberOperationTakeRoot	//	left operand is the number being rooted, right is the root
} SMNumberOperation;


static inline unsigned int SMNumberOperationCountOperands(SMNumberOperation operation)
{
	return ( operation < SMNumberOperationAdd ) ? 1 : 2;
}


/******************************	SMNumber	******************************/

@interface SMNumber : NSObject <NSCoding>
{
	Decimal _value;
}

- (id)initWithDecimal:(Decimal)value;
- (id)initWithString:(NSString *)string;
- (NSString *)stringValueWithDisplayFormat:(SMNumberDisplayFormat)format;

@property (readonly) Decimal decimalValue;

/********************	Class Methods	********************/

+ (void)setAngleUnit:(JBAngleUnit)angleUnit;
+ (JBAngleUnit)angleUnit;

+ (Class)numberClassForPrecisionType:(SMPrecisionType)precisionType;
+ (SMPrecisionType)precisionType;

+ (SMNumber *)numberByPerformingOperation:(SMNumberOperation)operation withNumber:(SMNumber *)x withNumber:(SMNumber *)y error:(NSError **)error;

@end


