/*
 *  Decimal.m
 *  Precision RPN
 *
 *  Created by Justin Buchanan on 9/20/09.
 *  Copyright 2009 JustBuchanan Software. All rights reserved.
 *
 */

#import "Decimal.h"
#import "Debug.h"


Decimal RoundDecimalToSigFigs(Decimal value, int sigFigs)
{
	if ( !value || isnan(value) || isinf(value) ) return value;	//	abort if it is invalid, zero, or inf
	
	int mostSignificantPlace = DecimalGetMostSignificantPlace(value);
	
	DebugLog(@"mostsigplace = %d", mostSignificantPlace);
	
	int placeToRound = mostSignificantPlace - sigFigs;
	if ( !(mostSignificantPlace > 0 && mostSignificantPlace - sigFigs < 0) ) placeToRound += 1;	//	add one if it isn't split by the decimal
	DebugLog(@"placetoround = %d", placeToRound);
	
	DebugLog(@"roundedvalue = %.20Lf", DecimalRoundToPlace(value, placeToRound));
	return DecimalRoundToPlace(value, placeToRound);
}


Decimal DecimalRoundToPlace(Decimal value, int place)
{
	Decimal multiplierExponent = ( place > 0 ) ? (place - 1) * -1 : place * -1;
	Decimal multiplier = powl(10.0, multiplierExponent);
	
	Decimal temp = ABS(value) * multiplier;
	
	Decimal tempRoundedDown = (Decimal)((long long)temp);	//	cast it to a long to remove part after decimal
	if (tempRoundedDown > temp) tempRoundedDown -= 1;	//	make sure it's rounded down
	
	Decimal roundDeterminer = temp - tempRoundedDown;
	if ( roundDeterminer > .5 || ( roundDeterminer == .5 && !NUMBER_IS_EVEN(tempRoundedDown) ) ) tempRoundedDown += 1;
	
	temp = tempRoundedDown / multiplier;
	return ( value > 0 ) ? temp : -temp;
}

int DecimalGetMostSignificantPlace(Decimal value)
{
	if ( !value || isinf(value) || isnan(value) ) return 0;	//	abort if value is zero or invalid
	
	DebugLog(@"at decimalGetMostSigPlace, value = %.20Lf", value);
	
	int mostSignificantPlace = 1;	//	the left-most nonzero digit
	Decimal tempValue = ABS(value);
	
	if ( tempValue >= 10 )
	{
		do {
			tempValue /= 10;
			++mostSignificantPlace;
		} while ( tempValue >= 10 );
	}
	else if ( tempValue < 1 )
	{
		mostSignificantPlace = 0;
		do {
			tempValue *= 10;
			--mostSignificantPlace;
		} while ( tempValue < 1 );
	}
	
	DebugLog(@"at end of DecimalGetMostSigPlace, mostSigPlace = %d", mostSignificantPlace);
	
	return mostSignificantPlace;
}



int DecimalGetDigitAtPlace(Decimal value, int place)
{
	Decimal multiplierExponent = ( place > 0 ) ? (place - 1) * -1 : place * -1;
	Decimal multiplier = powl(10.0, multiplierExponent);
	
	value = ABS(value) * multiplier;
	
	Decimal roundedDown = (Decimal)((long long)value);	//	cast it to a long to remove part after decimal
	if (roundedDown > value) roundedDown -= 1;	//	make sure it's rounded down
	
	return (int)(((long long)roundedDown) % 10);
}

