//
//  SMSigFigNumber.m
//  Precision RPN
//
//  Created by Justin Buchanan on 8/16/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import "SMSigFigNumber.h"
#import "NSString+FloatParsing.h"
#import "Debug.h"
#import "Defines.h"



#pragma mark Operation Functions

typedef SMSigFigNumber* (*SMSigFigNumberOperationFunction)(SMSigFigNumber*, SMSigFigNumber*);	//	pointer to a function that performs an operation


SMSigFigNumber *SMSigFigNumberOperationSquareFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = leftOperand.decimalValue;
	value *= value;	//	multiply it by itself
	int sigFigs = leftOperand.sigFigs;
	value = RoundDecimalToSigFigs(value, sigFigs);
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationCubeFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = powl(leftOperand.decimalValue, 3.0);
	int sigFigs = leftOperand.sigFigs;
	value = RoundDecimalToSigFigs(value, sigFigs);
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationSquareRootFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = sqrtl(leftOperand.decimalValue);
	int sigFigs = leftOperand.sigFigs;
	value = RoundDecimalToSigFigs(value, sigFigs);
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationAbsoluteValueFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = ABS(leftOperand.decimalValue);
	int sigFigs = leftOperand.sigFigs;
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationNegateFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = -(leftOperand.decimalValue);
	int sigFigs = leftOperand.sigFigs;
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationLogFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = log10l(leftOperand.decimalValue);
	int sigFigs = leftOperand.sigFigs;
	value = RoundDecimalToSigFigs(value, sigFigs);
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationNaturalLogFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = logl(leftOperand.decimalValue);
	int sigFigs = leftOperand.sigFigs;
	value = RoundDecimalToSigFigs(value, sigFigs);
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationSineFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = sinl( JBAngleConvert([SMNumber angleUnit], JBAngleUnitRadian, leftOperand.decimalValue) );
	int sigFigs = leftOperand.sigFigs;
	value = RoundDecimalToSigFigs(value, sigFigs);
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationCosineFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = cos( JBAngleConvert([SMNumber angleUnit], JBAngleUnitRadian, leftOperand.decimalValue) );
	int sigFigs = leftOperand.sigFigs;
	value = RoundDecimalToSigFigs(value, sigFigs);
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationTangentFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = tanl( JBAngleConvert([SMNumber angleUnit], JBAngleUnitRadian, leftOperand.decimalValue) );
	int sigFigs = leftOperand.sigFigs;
	value = RoundDecimalToSigFigs(value, sigFigs);
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationArcSineFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = JBAngleConvert(JBAngleUnitRadian, [SMNumber angleUnit], asinl(leftOperand.decimalValue));
	int sigFigs = leftOperand.sigFigs;
	value = RoundDecimalToSigFigs(value, sigFigs);
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationArcCosineFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = JBAngleConvert(JBAngleUnitRadian, [SMNumber angleUnit], acosl(leftOperand.decimalValue));
	int sigFigs = leftOperand.sigFigs;
	value = RoundDecimalToSigFigs(value, sigFigs);
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationArcTangentFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = JBAngleConvert(JBAngleUnitRadian, [SMNumber angleUnit], atanl(leftOperand.decimalValue));
	int sigFigs = leftOperand.sigFigs;
	value = RoundDecimalToSigFigs(value, sigFigs);
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationAddFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = leftOperand.decimalValue + rightOperand.decimalValue;
	int leastSignificantPlace = MAX(leftOperand.leastSignificantPlace, rightOperand.leastSignificantPlace);
	value = DecimalRoundToPlace(value, leastSignificantPlace);
	int mostSignificantPlace = DecimalGetMostSignificantPlace(value);
	int sigFigs = mostSignificantPlace - leastSignificantPlace;
	if ( mostSignificantPlace * leastSignificantPlace > 0 ) sigFigs += 1;	//	add one if the most and least are on the same side of the decimal
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationSubtractFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = leftOperand.decimalValue - rightOperand.decimalValue;
	int leastSignificantPlace = MAX(leftOperand.leastSignificantPlace, rightOperand.leastSignificantPlace);
	value = DecimalRoundToPlace(value, leastSignificantPlace);
	int mostSignificantPlace = DecimalGetMostSignificantPlace(value);
	int sigFigs = mostSignificantPlace - leastSignificantPlace;
	if ( mostSignificantPlace * leastSignificantPlace > 0 ) sigFigs += 1;	//	add one if the most and least are on the same side of the decimal
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationMultiplyFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = leftOperand.decimalValue * rightOperand.decimalValue;
	int sigFigs = MIN(leftOperand.sigFigs, rightOperand.sigFigs);
	value = RoundDecimalToSigFigs(value, sigFigs);
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationDivideFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = leftOperand.decimalValue / rightOperand.decimalValue;
	int sigFigs = MIN(leftOperand.sigFigs, rightOperand.sigFigs);
	value = RoundDecimalToSigFigs(value, sigFigs);
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationRaiseToPowerFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = powl(leftOperand.decimalValue, rightOperand.decimalValue);
	int sigFigs = MIN(leftOperand.sigFigs, rightOperand.sigFigs);
	value = RoundDecimalToSigFigs(value, sigFigs);
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}

SMSigFigNumber *SMSigFigNumberOperationTakeRootFunction(SMSigFigNumber *leftOperand, SMSigFigNumber *rightOperand)
{
	Decimal value = powl(leftOperand.decimalValue, (1.0 / rightOperand.decimalValue));
	int sigFigs = MIN(leftOperand.sigFigs, rightOperand.sigFigs);
	value = RoundDecimalToSigFigs(value, sigFigs);
	
	return [[[SMSigFigNumber alloc] initWithDecimal:value sigFigs:sigFigs] autorelease];
}




/*	an arry of function pointers for easy lookup of the function that goes with an operation	*/
static SMSigFigNumberOperationFunction operationFunctions[] = {
	SMSigFigNumberOperationSquareFunction,
	SMSigFigNumberOperationCubeFunction,
	SMSigFigNumberOperationSquareRootFunction,
	SMSigFigNumberOperationAbsoluteValueFunction,
	SMSigFigNumberOperationNegateFunction,
	SMSigFigNumberOperationLogFunction,
	SMSigFigNumberOperationNaturalLogFunction,
	SMSigFigNumberOperationSineFunction,
	SMSigFigNumberOperationCosineFunction,
	SMSigFigNumberOperationTangentFunction,
	SMSigFigNumberOperationArcSineFunction,
	SMSigFigNumberOperationArcCosineFunction,
	SMSigFigNumberOperationArcTangentFunction,
	SMSigFigNumberOperationAddFunction,
	SMSigFigNumberOperationSubtractFunction,
	SMSigFigNumberOperationMultiplyFunction,
	SMSigFigNumberOperationDivideFunction,
	SMSigFigNumberOperationRaiseToPowerFunction,
	SMSigFigNumberOperationTakeRootFunction
};









@implementation SMSigFigNumber
@synthesize sigFigs = _sigFigs;

- (id)initWithDecimal:(Decimal)value
{
	if ( self = [super initWithDecimal:value] )
	{
		_sigFigs = INFINITE_SIGFIGS;
	}
	return self;
}

- (id)initWithDecimal:(Decimal)value sigFigs:(int)sigFigs
{
	if ( self = [super initWithDecimal:value] )
	{
		_sigFigs = sigFigs;
	}
	return self;
}

- (id)initWithString:(NSString *)string
{
	if ( self = [super init] )
	{
		int firstSignificantDigitIndex = -1, lastNonzeroDigitIndex = -1, decimalIndex = -1, eIndex = -1, overlineIndex = -1;
		
		int stringLength = [string length];
		for ( int i = 0; i < stringLength; ++i )
		{
			unichar character = [string characterAtIndex:i];
			
			if ( CharacterIsNumber(character) )
			{
				DebugLog(@"char: %C isNumber", character);
				if ( ( firstSignificantDigitIndex == -1 ) && ( NumberFromCharacter(character) > 0 ) ) firstSignificantDigitIndex = i;
				if ( character != '0' && eIndex == -1 ) lastNonzeroDigitIndex = i;	//	don't count it if it's after E
			}
			else if ( character == '.' )
			{
				if ( decimalIndex == -1 )
				{
					decimalIndex = i;
				}
				else	//	we hit a second period so we abort parsing
				{
					NSLog(@"SMSigFigNumber -initWithString: had two period characters");
					[super dealloc];
					return nil;
				}
			}
			else if ( character == 'E' )
			{
				if ( eIndex == -1 )
				{
					eIndex = i;
				}
				else	//	we hit a second "E" so we abort  parsing
				{
					NSLog(@"SMSigFigNumber -initWithString: had two 'E' characters");
					[super dealloc];
					return nil;
				}
			}
			/*
			else if ( character == COMBINING_OVERLINE )
			{
				if ( overlineIndex == -1 )
				{
					overlineIndex = i;
				}
				else	//	we hit a second overline so we abort parsing
				{
					NSLog(@"SMSigFigNumber -initWithString: had two overline characters");
					[super dealloc];
					return nil;
				}
			}
			*/
			else if ( character == '-' ) {}//	ignore it
			else
			{
				NSLog(@"SMSigFigNumber -initWithString: had invalid character: %C", character);
				[super dealloc];
				return nil;
			}
		}
		
		DebugLog(@"decimalIndex = %d, eIndex = %d, firstSigDigit = %d", decimalIndex, eIndex, firstSignificantDigitIndex);
		
		double value;
		NSScanner *scanner = [NSScanner scannerWithString:string];
		[scanner scanDouble:&value];
		_value = (Decimal)value;
		
		int lastSignificantDigit;
		
		if ( overlineIndex != -1 )
		{
			lastSignificantDigit = overlineIndex - 1;
		}
		else if ( decimalIndex != -1 )
		{
			int lastIndex = stringLength - 1;
			lastSignificantDigit = ( decimalIndex == lastIndex ) ? lastIndex - 1 : (( eIndex == -1 ) ? lastIndex : eIndex -1);
		}
		else
		{
			lastSignificantDigit = lastNonzeroDigitIndex;
		}
		
		DebugLog(@"lastSignificantDigit = %d", lastSignificantDigit);
		
		if ( ( firstSignificantDigitIndex < decimalIndex ) && ( decimalIndex < lastSignificantDigit ) )	//	checks to see if decimal is between first & last sig digits
		{
			_sigFigs = lastSignificantDigit - firstSignificantDigitIndex;
		}
		else
		{
			_sigFigs = lastSignificantDigit - firstSignificantDigitIndex + 1;
		}
	}
	return self;
}


- (NSString *)descriptionWithLocale:(NSLocale *)locale
{
	return [NSString stringWithFormat:@"<SMSigFigNumber : Value=%Lf, SigFigs=%d>", _value, _sigFigs];
}


#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ( self = [super initWithCoder:aDecoder] )
	{
		_sigFigs = [aDecoder decodeIntForKey:@"SigFigs"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[super encodeWithCoder:aCoder];
	[aCoder encodeInt:_sigFigs forKey:@"SigFigs"];
}



#pragma mark Display

- (NSString *)scientificNotationString
{
	DebugLog(@"at scientificNotationString of sigfignumber, value = %Lf", _value);
	
	int sigFigsDecimalDigits = self.sigFigs - 1;
	if ( sigFigsDecimalDigits == -2 ) sigFigsDecimalDigits = 100;	//	there were inf sigFigs, so make sure sigFigs isn't the MIN in the following expression
	
	int decimalDigits = MIN(MAX_DISPLAYABLE_CHARACTERS - 5, sigFigsDecimalDigits);
	
	DebugLog(@"sigFigs = %d, decimalDigits = %d", self.sigFigs, decimalDigits);
	
	NSMutableString *string = [NSMutableString stringWithFormat:[NSString stringWithFormat:@"%%.%dLe", decimalDigits], self.decimalValue];	//	this makes it the right sig figs
	
	/*********	change 'e' to 'E'	*********/
	
	NSRange eRange = [string rangeOfString:@"e"];
	[string replaceCharactersInRange:eRange withString:@"E"];
	
	/*********	remove "+" after "E" if it's there	*********/
	
	int signIndex = eRange.location + 1;
	if ( [string characterAtIndex:signIndex] == '+' )
		[string replaceCharactersInRange:NSMakeRange(signIndex, 1) withString:@""];
	
	return string;
}

- (NSString *)regularString
{
	DebugLog(@"at regstring of sigfignumber, value = %.20Lf", _value);
	
	
	
	if ( isinf(_value) ) return [NSString stringWithFormat:@"%C", INFINITY_CHARACTER];
	
	Decimal abs = ABS(self.decimalValue);
	BOOL outOfRange = ( abs < MIN_VALUE_FOR_REGULAR_DISPLAY || abs > MAX_VALUE_FOR_REGULAR_DISPLAY );
	int leastSignificantPlace = (self.sigFigs != -1 ) ? self.leastSignificantPlace : -100;
	if ( outOfRange && abs != 0.0 ) return [self scientificNotationString];
	
	
	int mostSignificantPlace = DecimalGetMostSignificantPlace(self.decimalValue);
	
	DebugLog(@"leastSigPlace = %d, mostSigPlace = %d,", leastSignificantPlace, mostSignificantPlace);
	
	int charsBeforeFraction= mostSignificantPlace + ( self.decimalValue < 0 ) ? 1 : 0;	//	account for the minus sign if negative
	if ( leastSignificantPlace < 0 ) charsBeforeFraction += 1;							//	add one for the decimal
	int sigFigsAfterDecimal = (leastSignificantPlace < 0) ? ABS(leastSignificantPlace) : 0;
	
	int fractionDigits = MIN( (MAX_DISPLAYABLE_CHARACTERS - charsBeforeFraction), sigFigsAfterDecimal);
	
	DebugLog(@"fractionDigits = %d", fractionDigits);
	
	NSMutableString *string = [NSMutableString stringWithFormat:[NSString stringWithFormat:@"%%.%dLf", fractionDigits], self.decimalValue];
	
	if ( leastSignificantPlace > 0 && DecimalGetDigitAtPlace(self.decimalValue, leastSignificantPlace) == 0 )	//	if it's a zero before the decimal, we need an overline
	{
		DebugLog(@"leastSigPlace = %d, mostSigPlace = %d,", leastSignificantPlace, mostSignificantPlace);
		NSUInteger index = mostSignificantPlace - leastSignificantPlace + 1;
		[string insertString:[NSString stringWithFormat:@"%C", COMBINING_OVERLINE] atIndex:index];
	}
	
	return string;
}

- (NSString *)stringValueWithDisplayFormat:(SMNumberDisplayFormat)format
{
	return ( format == SMNumberDisplayFormatRegular ) ? [self regularString] : [self scientificNotationString];
}


#pragma mark Properties

- (int)mostSignificantPlace
{
	return DecimalGetMostSignificantPlace(self.decimalValue);
}

- (int)leastSignificantPlace
{
	int mostSignificantPlace = DecimalGetMostSignificantPlace(_value);
	
	int leastSignificantPlace = mostSignificantPlace - _sigFigs;
	if ( !(mostSignificantPlace > 0 && mostSignificantPlace - _sigFigs < 0) ) leastSignificantPlace += 1;	//	add one if it isn't split by the decimal
	
	return leastSignificantPlace;
}


#pragma mark Class Methods

+ (SMPrecisionType)precisionType
{
	return SMPrecisionTypeSigFigs;
}

+ (SMNumber *)numberByPerformingOperation:(SMNumberOperation)operation withNumber:(SMNumber *)x withNumber:(SMNumber *)y error:(NSError **)error
{
	SMSigFigNumberOperationFunction function = operationFunctions[operation];
	SMSigFigNumber *result = function((SMSigFigNumber *)x, (SMSigFigNumber *)y);
	
	return result;
}


@end



