/*
 *  Decimal.h
 *  Precision RPN
 *
 *  Created by Justin Buchanan on 9/17/09.
 *  Copyright 2009 JustBuchanan Software. All rights reserved.
 *
 */

typedef long double Decimal;




int DecimalGetMostSignificantPlace(Decimal value);
Decimal RoundDecimalToSigFigs(Decimal value, int sigFigs);



#define NUMBER_IS_EVEN(number) ((BOOL)!((long long)number % 2))

int DecimalGetMostSignificantPlace(Decimal value);

/*	On a tie, it rounds to make the rounded digit even	*/
Decimal DecimalRoundToPlace(Decimal value, int place);

int DecimalGetDigitAtPlace(Decimal value, int place);


