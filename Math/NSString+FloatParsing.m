//
//  NSString+FloatParsing.m
//  Precision RPN
//
//  Created by Justin Buchanan on 8/28/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import "NSString+FloatParsing.h"
#import "Debug.h"


@interface NSString (DecimalParsingPrivate)

- (Decimal)_parseDecimalInRange:(NSRange)range;

@end




@implementation NSString (FloatParsing)


- (Decimal)parseDecimalInRange:(NSRange)range
{
	int i;
	
	int maxIndex = range.location + range.length - 1;	//	this is the max string index that we will parse to
	int eIndex = -1;
	for ( i = range.location; i <= maxIndex; ++i )	//	iterate through the string to look for an E
	{
		if ( [self characterAtIndex:i] == 'E' )
		{
			eIndex = i;	//	set E Index
			break;				//	and exit the loop
		}
	}
	
	Decimal value;
	
	if ( eIndex == -1 )
	{
		value = [self _parseDecimalInRange:range];
	}
	else
	{
		value = [self _parseDecimalInRange:NSMakeRange(range.location, eIndex - range.location)];	//	parse the chunk before the E
		value *= powl(10, [self _parseDecimalInRange:NSMakeRange(eIndex + 1, maxIndex - eIndex)]);
	}
	
	return value;
}




/*	This method doesn't handle "E" for scientific notation	*/
- (Decimal)_parseDecimalInRange:(NSRange)range
{
	int i;
	Decimal value = 0;
	
	int maxIndex = range.location + range.length - 1;	//	this is the max string index that we will parse to
	int decimalIndex = -1;
	for ( i = range.location; i <= maxIndex; ++i )	//	iterate through the string to look for a decimal point
	{
		if ( [self characterAtIndex:i] == '.' )
		{
			//DebugLog(@"NSString -parseFloatInRange: found a decimal at index: %d", i);
			decimalIndex = i;	//	set the decimal index
			break;				//	and exit the loop
		}
	}
	
	Decimal placeValue;	//	the tens place is 10, the hundreds place is 100, etc.
	
	if ( decimalIndex != -1 )	//	if there was a decimal, we parse after it (the 5678 in 1234.5678)
	{
		placeValue = 1;
		for ( i = decimalIndex + 1; i <= maxIndex; ++i )	//	start at the character right after the decimal
		{
			placeValue /= 10;	//	set placeValue to 1/10th its current value
			
			unichar character = [self characterAtIndex:i];	//	get the current character
			
			//DebugLog(@"NSString -parseFloatInRange: is parsing value after decimal point @ index: %d, character: %C", i, character);
			
			short numberValue = NumberFromCharacter(character);	//	get the numerical value of the character
			if ( numberValue == CHARACTER_NOT_VALID_NUMBER )
			{
				if ( character == '-' )
				{
					numberValue = 0;	//	ignore the '-' because we will deal with it at the end
				}
				else
				{
					NSLog(@"BUG:  [NSString parseFloatInRange:] was parsing a string with an invalid character: %@", self);
					return 0;
				}
			}
			
			value += (double)numberValue * placeValue;
		}
		//DebugLog(@"NSString -parseFloatInRange: finished parsing after decimal and value = %f", value);
	}
	
	placeValue = .1;
	i = ( decimalIndex == -1 ) ? maxIndex : decimalIndex - 1;	//	if there's a decimal, start in front of it, otherwise start @ end of string
	for ( ; i >= (int)range.location; --i )
	{
		//DebugLog(@"i >= range.location = %d", i >= range.location);
		//DebugLog(@"i = %d; range.location = %d", i, range.location);
		placeValue *= 10;	//	set the placeValue to 10x its current value
		
		unichar character = [self characterAtIndex:i];
		
		//DebugLog(@"NSString -parseFloatInRange: is parsing value before decimal point @ index: %d, character: %C", i, character);
		
		short numberValue = NumberFromCharacter(character);
		if ( numberValue == CHARACTER_NOT_VALID_NUMBER )
		{
			if ( character == '-' )
			{
				numberValue = 0;	//	ignore the '-' because we will deal with it at the end
			}
			else
			{
				NSLog(@"BUG:  [NSString parseFloatInRange:] was parsing a string with an invalid character: %@", self);
				return 0;
			}
		}
		
		value += (Decimal)numberValue * placeValue;
	}
	
	
	if ( [self characterAtIndex:range.location] == '-' ) value *= -1;	//	if the string starts with a minus sign, negate the value
	
	return value;
}

@end






static const unichar regularNumberCharacters[] = {
	'0',
	'1',
	'2',
	'3',
	'4',
	'5',
	'6',
	'7',
	'8',
	'9'
};


BOOL CharacterIsNumber(unichar character)
{
	return ( character  >= '0' ) && ( character <= '9' );
}

unichar CharacterFromNumber(short number)
{
	return ( -1 < number < 10 ) ? regularNumberCharacters[number] : '\0';
}

short NumberFromCharacter(unichar character)
{
	return ( CharacterIsNumber(character) ) ? character - '0' : CHARACTER_NOT_VALID_NUMBER;
}

