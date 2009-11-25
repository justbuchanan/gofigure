/*
 *  JBAngleUnit.c
 *
 *  Created by Justin Buchanan on 11/24/08.
 *  Copyright 2008 JustBuchanan Software. All rights reserved.
 *
 */

#import "JBAngleUnit.h"


Decimal JBAngleConvert( JBAngleUnit fromUnit, JBAngleUnit toUnit, Decimal angle )
{
	Decimal value;
	
	switch ( fromUnit )
	{
		case JBAngleUnitRadian:
		{
			//	No conversion required
			value = angle;
			break;
		}
		case JBAngleUnitDegree:
		{
			value = ( PI * angle ) / 180.0;
			break;
		}
		case JBAngleUnitGradian:
		{
			value = ( PI * angle ) / 200.0;
			break;
		}
	}
	
	switch ( toUnit )
	{
		case JBAngleUnitRadian:
		{
			//	No conversion required
			break;
		}
		case JBAngleUnitDegree:
		{
			value = ( 180.0 * value ) / PI;
			break;
		}
		case JBAngleUnitGradian:
		{
			value = ( 200.0 * value ) / PI;
			break;
		}
	}
	
	return value;
}