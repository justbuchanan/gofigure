/*
 *  JBAngleUnit.h
 *  TrigSolv
 *
 *  Created by Justin Buchanan on 11/23/08.
 *  Copyright 2008 JustBuchanan Software. All rights reserved.
 *
 */

#import <math.h>
#import <stdio.h>
#import "Decimal.h"
#import "Defines.h"


typedef enum {
	JBAngleUnitRadian,
	JBAngleUnitDegree,
	JBAngleUnitGradian,
} JBAngleUnit;

Decimal JBAngleConvert( JBAngleUnit fromUnit, JBAngleUnit toUnit, Decimal angle );