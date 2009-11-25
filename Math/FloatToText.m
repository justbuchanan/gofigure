/*
 *  FloatToText.c
 *  Precision RPN
 *
 *  Created by Justin Buchanan on 9/10/09.
 *  Copyright 2009 JustBuchanan Software. All rights reserved.
 *
 */

#include "FloatToText.h"
#import <Foundation/Foundation.h>
#import "Debug.h"



void ReverseString(char *string, int length)
{
	int i, j;
	char temp;
	for ( i = 0, j = length - 1; i < j; i++ )
	{
		temp = string[i];
		string[i] = string[j];
		string[j] = temp;
		j--;
	}
}


/*

void DoubleToTextOld(double value, char *stringOut)	//	stringOut must be able to contain __ characters	???????????????????????????????????????????????????????????????????????????
{
	
	
	sprintf(stringOut, "%.20lf", value);
	
	/*
	if ( value == 0 )
	{
		*stringOut++ = '0';
		*stringOut = '\0';
		return;
	}
	
	if ( value < 1 )
	{
		*stringOut++ = '-';	//	place a minus sign at the beginning of the string
		value = -value;		//	make it positive
	}
	
	int shiftFromOriginal = 0;
	
	///*	Multiply or divide the value by 10 so that 1 <= value < 10
	if ( value >= 10 )
	{
		do {
			value /= 10;
			shiftFromOriginal -= 1;	//	we shifted the decimal once to the left, so track it
		} while ( value >= 10 );
	}
	else
	{
		*stringOut++ = '.';	//	the value is below 1, so put a decimal in the string
		
		while ( value < 1 )
		{
			*stringOut++ = '0';	//	each time we shift, put a placeholder zero in the string
			
			value *= 10;
			shiftFromOriginal += 1;		//	we shifted the decimal once to the right, so track it
		}
	}
	
	while ( value )
	{
		if ( shiftFromOriginal == 1 ) *stringOut++ = '.';	//////////////	when shiftFromOriginal == 0???????????????????????????????????????????????????????????????????????????????????????????????????????
		
		int digit = floor(value);
		*stringOut++ = '0' + digit;	//	add the digit to the string
		value -= digit;
		value *= 10;
		
		shiftFromOriginal += 1;
	}
	
	*stringOut = '\0';
	
	*//*
}

*/






/*
void DoubleToText(double value, char *stringOut, int maxLength)
{
	int i = 0;
	
	if ( !value )	//	does this need a special block?????		can zero be handled by the main stuff???????????????????????????????????????????
	{
		stringOut[i++] = '0';
		stringOut[i] = '\0';
		return;
	}
	if ( isnan(value) || isinf(value) )
	{
		memcpy(stringOut, "undefined", 10);
		return;
	}
	
	int shift = 0;	//	tracks how many times we shifted the decimal to the right
	
	BOOL isNegative;
	if ( isNegative = value < 0 ) value *= -1;	//	make the value positive
	
	while ( floor(value) != value )	//	while there's something after the decimal...
	{
		value *= 10;	//	shift the decimal to the right
		shift++;		//	record the shift
	}
	
	
	DebugLog(@"At DoubleToText(), value about to be converted to long = %lf", value);
	long long longValue = (long long)value;
	DebugLog(@"At DoubleToText(), longValue = %ld", longValue);
	
	//	if ( shift ) value had some after decimal
	//	
	
	while ( longValue )	//	loop until we've written all of the digits
	{
		DebugLog(@"iterating... longValue before change = %ld", longValue);
		
		int digit = longValue % 10;	//	get the digit in the one's place
		stringOut[i++] = '0' + digit;	//	add digit to string
		
		longValue -= digit;		//	delete the digit
		longValue = longValue / 10;	//	shift the decimal left one	//	NOTE: 17 / 10 == 1!!!
		
		if ( --shift == 0 ) stringOut[i++] = '.';	//	appen decimal point
	}
	
	if ( isNegative ) stringOut[i++] = '-';
	
	ReverseString(stringOut, i);
	
	stringOut[i] = '\0';	//	append NULL character
}

*/
/*

void DoubleToText(double value, char *stringOut, int maxLength)	//	v3
{
	int i = 0;
	
	if ( !value )	//	does this need a special block?????		can zero be handled by the main stuff???????????????????????????????????????????
	{
		stringOut[i++] = '0';
		stringOut[i] = '\0';
		return;
	}
	if ( isnan(value) || isinf(value) )
	{
		memcpy(stringOut, "undefined", 10);
		return;
	}
	
	int shift = 0;	//	tracks how many times we shifted the decimal to the right
	
	BOOL isNegative;
	if ( isNegative = value < 0 ) value *= -1;	//	make the value positive
	
	while ( floor(value) != value )	//	while there's something after the decimal...
	{
		value *= 10;	//	shift the decimal to the right
		shift++;		//	record the shift
	}
	
	NSLog(@"value multiplied = %lf", value);
	
	//	if ( shift ) value had some after decimal
	//	
	
	while ( value )	//	loop until we've written all of the digits
	{
		int digit = fmod(value ,10.0f);	//	get the digit in the one's place
		stringOut[i++] = '0' + digit;	//	add digit to string
		
		value -= digit;		//	delete the digit
		value = floor(value / 10.0f);	//	shift the decimal left one	//	NOTE: 17 / 10 == 1!!!
		
		if ( --shift == 0 ) stringOut[i++] = '.';	//	appen decimal point
	}
	
	if ( isNegative ) stringOut[i++] = '-';
	
	ReverseString(stringOut, i);
	
	stringOut[i] = '\0';	//	append NULL character
}
*/


















