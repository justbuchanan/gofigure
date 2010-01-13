//
//  SMCertainNumber.m
//  Precision RPN
//
//  Created by Justin Buchanan on 8/30/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import "SMCertainNumber.h"
#import "Debug.h"
#import "Defines.h"
#import "SMNumber.h"
#import "NSString+FloatParsing.h"



#pragma mark Operation Functions

typedef SMCertainNumber* (*SMCertainNumberOperationFunction)(SMCertainNumber*, SMCertainNumber*);	//	pointer to a function that performs an operation


SMCertainNumber *SMCertainNumberOperationSquareFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:leftOperand.decimalValue * leftOperand.decimalValue] autorelease];
}

SMCertainNumber *SMCertainNumberOperationCubeFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:powl(leftOperand.decimalValue, 3.0)] autorelease];
}

SMCertainNumber *SMCertainNumberOperationSquareRootFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:sqrtl(leftOperand.decimalValue)] autorelease];
}

SMCertainNumber *SMCertainNumberOperationAbsoluteValueFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:ABS(leftOperand.decimalValue)] autorelease];
}

SMCertainNumber *SMCertainNumberOperationNegateFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:-(leftOperand.decimalValue)] autorelease];
}

SMCertainNumber *SMCertainNumberOperationLogFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:log10l(leftOperand.decimalValue)] autorelease];
}

SMCertainNumber *SMCertainNumberOperationNaturalLogFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:logl(leftOperand.decimalValue)] autorelease];
}

SMCertainNumber *SMCertainNumberOperationSineFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	Decimal radianValue = JBAngleConvert([SMNumber angleUnit], JBAngleUnitRadian, leftOperand.decimalValue);
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:sinl(radianValue)] autorelease];
}

SMCertainNumber *SMCertainNumberOperationCosineFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	Decimal radianValue = JBAngleConvert([SMNumber angleUnit], JBAngleUnitRadian, leftOperand.decimalValue);
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:cosl(radianValue)] autorelease];
}

SMCertainNumber *SMCertainNumberOperationTangentFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	Decimal radianValue = JBAngleConvert([SMNumber angleUnit], JBAngleUnitRadian, leftOperand.decimalValue);
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:tanl(radianValue)] autorelease];
}

SMCertainNumber *SMCertainNumberOperationArcSineFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	Decimal radianValue = JBAngleConvert(JBAngleUnitRadian, [SMNumber angleUnit], asinl(leftOperand.decimalValue));
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:radianValue] autorelease];
}

SMCertainNumber *SMCertainNumberOperationArcCosineFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	Decimal radianValue = JBAngleConvert(JBAngleUnitRadian, [SMNumber angleUnit], acosl(leftOperand.decimalValue));
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:radianValue] autorelease];
}

SMCertainNumber *SMCertainNumberOperationArcTangentFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	Decimal radianValue = JBAngleConvert(JBAngleUnitRadian, [SMNumber angleUnit], atanl(leftOperand.decimalValue));
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:radianValue] autorelease];
}

SMCertainNumber *SMCertainNumberOperationAddFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:leftOperand.decimalValue + rightOperand.decimalValue] autorelease];
}

SMCertainNumber *SMCertainNumberOperationSubtractFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:leftOperand.decimalValue - rightOperand.decimalValue] autorelease];
}

SMCertainNumber *SMCertainNumberOperationMultiplyFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:leftOperand.decimalValue * rightOperand.decimalValue] autorelease];
}

SMCertainNumber *SMCertainNumberOperationDivideFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:leftOperand.decimalValue / rightOperand.decimalValue] autorelease];
}

SMCertainNumber *SMCertainNumberOperationRaiseToPowerFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:powl(leftOperand.decimalValue, rightOperand.decimalValue)] autorelease];
}

SMCertainNumber *SMCertainNumberOperationTakeRootFunction(SMCertainNumber *leftOperand, SMCertainNumber *rightOperand)
{
	return [[(SMCertainNumber *)[SMCertainNumber alloc] initWithDecimal:powl(leftOperand.decimalValue, (1.0 / rightOperand.decimalValue))] autorelease];
}




/*	an arry of function pointers for easy lookup of the function that goes with an operation	*/
static SMCertainNumberOperationFunction operationFunctions[] = {
	SMCertainNumberOperationSquareFunction,
	SMCertainNumberOperationCubeFunction,
	SMCertainNumberOperationSquareRootFunction,
	SMCertainNumberOperationAbsoluteValueFunction,
	SMCertainNumberOperationNegateFunction,
	SMCertainNumberOperationLogFunction,
	SMCertainNumberOperationNaturalLogFunction,
	SMCertainNumberOperationSineFunction,
	SMCertainNumberOperationCosineFunction,
	SMCertainNumberOperationTangentFunction,
	SMCertainNumberOperationArcSineFunction,
	SMCertainNumberOperationArcCosineFunction,
	SMCertainNumberOperationArcTangentFunction,
	SMCertainNumberOperationAddFunction,
	SMCertainNumberOperationSubtractFunction,
	SMCertainNumberOperationMultiplyFunction,
	SMCertainNumberOperationDivideFunction,
	SMCertainNumberOperationRaiseToPowerFunction,
	SMCertainNumberOperationTakeRootFunction
};







@implementation SMCertainNumber

- (id)initWithString:(NSString *)string
{
	double mantissa;
	double exponent = 0;
	
	NSArray *parts = [string componentsSeparatedByString:@"E"];
	
	NSScanner *scanner = [NSScanner scannerWithString:[parts objectAtIndex:0]];
	[scanner scanDouble:&mantissa];
	
	if ( [parts count] == 2 )
	{
		scanner = [NSScanner scannerWithString:[parts objectAtIndex:1]];
		[scanner scanDouble:&exponent];
	}
	
	self = [super initWithDecimal:(Decimal)(mantissa * pow(10.0f, exponent))];
	
	
	return self;
}


- (NSString *)descriptionWithLocale:(NSLocale *)locale
{
	return [NSString stringWithFormat:@"<SMCertainNumber : Value=%Lf>", _value];
}



#pragma mark String Conversion

- (NSString *)scientificNotationString
{
	DebugLog(@"SMCertainNumber is formatting a scientific notation string");
	
	if ( isinf(_value) ) return [NSString stringWithFormat:@"%C", INFINITY_CHARACTER];
	
	NSMutableString *string = [NSMutableString stringWithFormat:@"%.10Le", self.decimalValue];
	
	int decimalIndex = [string rangeOfString:@"."].location;
	
	/*********	change 'e' to 'E'	*********/
	
	NSRange eRange = [string rangeOfString:@"e"];
	[string replaceCharactersInRange:eRange withString:@"E"];
	
	/*********	remove "+" after "E" if it's there	*********/
	
	int signIndex = eRange.location + 1;
	if ( [string characterAtIndex:signIndex] == '+' )
		[string replaceCharactersInRange:NSMakeRange(signIndex, 1) withString:@""];
	
	/*********	delete trailing zeroes && trim decimal digits to make string small enuff to disp	*********/
	
	if ( decimalIndex != NSNotFound )	//	check to see if there's a decimal
	{
		DebugLog(@"the number has a decimal");
		//for ( int i = eRange.location - 1; i >= decimalIndex || ( i >= decimalIndex && [string length] > MAX_DISPLAYABLE_CHARACTERS); i-- )
		for ( int i = eRange.location - 1; ; i-- )
		{
			unichar character = [string characterAtIndex:i];
			if ( character == '0' )
			{
				[string deleteCharactersInRange:NSMakeRange(i, 1)];	//	delete trailing zero
			}
			else if ( character == '.' )
			{
				[string deleteCharactersInRange:NSMakeRange(i, 1)];
				break;	//	we hit the decimal.  delete it since there's only zeros after it.  break the loop.
			}
			else	//	we hit a non-zero #
			{
				if ( !([string length] > MAX_DISPLAYABLE_CHARACTERS) ) break;	//	break if we're less than MAX_DISPLAYABLE_CHARACTERS
			}
		}
	}
	
	
	return string;
}

- (NSString *)regularString
{
	Decimal abs = ABS(self.decimalValue);
	if ( ( abs < MIN_VALUE_FOR_REGULAR_DISPLAY || abs > MAX_VALUE_FOR_REGULAR_DISPLAY ) && abs != 0.0)
	{
		DebugLog(@"the SMCertainNumber is out of range and will be displayed in E notation");
		return [self scientificNotationString];
	}
	
	NSMutableString *string = [NSMutableString stringWithFormat:@"%.10Lf", self.decimalValue];
	
	
	for ( int i = [string length] - 1; ; i-- )
	{
		unichar character = [string characterAtIndex:i];
		if ( character == '0' )
		{
			[string deleteCharactersInRange:NSMakeRange(i, 1)];	//	delete trailing zero
		}
		else if ( character == '.' )
		{
			[string deleteCharactersInRange:NSMakeRange(i, 1)];
			break;	//	we hit the decimal.  delete it since there's only zeros after it.  break the loop.
		}
		else	//	we hit a non-zero #
		{
			if ( !([string length] > MAX_DISPLAYABLE_CHARACTERS) ) break;	//	break if we're less than MAX_DISPLAYABLE_CHARACTERS
			[string deleteCharactersInRange:NSMakeRange(i, 1)];	//	delete the character
		}
	}
	
	
	return string;
}

- (NSString *)stringValueWithDisplayFormat:(SMNumberDisplayFormat)format
{
	return ( format == SMNumberDisplayFormatRegular ) ? [self regularString] : [self scientificNotationString];
}



#pragma mark Class Methods

+ (SMPrecisionType)precisionType
{
	return SMPrecisionTypeNone;
}

+ (SMNumber *)numberByPerformingOperation:(SMNumberOperation)operation withNumber:(SMNumber *)x withNumber:(SMNumber *)y error:(NSError **)error
{
	SMCertainNumberOperationFunction function = operationFunctions[operation];
	SMCertainNumber *result = function((SMCertainNumber *)x, (SMCertainNumber *)y);
	
	return result;
}


@end







