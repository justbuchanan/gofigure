//
//  SMNumber.m
//  Precision RPN
//
//  Created by Justin Buchanan on 8/16/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import "SMNumber.h"
#import "SMSigFigNumber.h"
#import "SMUncertainNumber.h"
#import "SMCertainNumber.h"
#import "Debug.h"

#pragma mark SMNumber


static JBAngleUnit SMNumberAngleUnit = JBAngleUnitRadian;	//	global variable to track angle unit


@implementation SMNumber
@synthesize decimalValue = _value;

- (id)initWithDecimal:(Decimal)value
{
	if ( self = [super init] )
	{
		_value = value;
	}
	return self;
}

- (id)initWithString:(NSString *)string
{
	NSLog(@"BUG:  The initWithString: method of an SMNumber subclass is not implemented!!!");
	return nil;
}

- (NSString *)stringValueWithDisplayFormat:(SMNumberDisplayFormat)format;
{
	return [NSString stringWithFormat:@"%.6Lf", self.decimalValue];	//	crappy implementation
}


- (NSString *)descriptionWithLocale:(NSLocale *)locale
{
	return [NSString stringWithFormat:@"<SMNumber : Value=%Lf>", _value];
}



#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ( self = [super init] )
	{
		DebugLog(@"initWithCoder was called on an SMNumber");
		_value = (double)[aDecoder decodeDoubleForKey:@"Value"];
		DebugLog(@"%@ was inited", self);
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeDouble:(double)_value forKey:@"Value"];
}


#pragma mark Class Methods

+ (void)setAngleUnit:(JBAngleUnit)angleUnit
{
	SMNumberAngleUnit = angleUnit;
}

+ (JBAngleUnit)angleUnit
{
	return SMNumberAngleUnit;
}

+ (Class)numberClassForPrecisionType:(SMPrecisionType)precisionType
{
	switch ( precisionType )
	{
		case SMPrecisionTypeSigFigs:				return [SMSigFigNumber class];
		//case SMPrecisionTypeUncertaintyTracking:	return [SMUncertainNumber class];
		case SMPrecisionTypeNone:					return [SMCertainNumber class];
	}
	
	return Nil;
}

+ (SMPrecisionType)precisionType
{
	return SMPrecisionTypeNone;
}

+ (SMNumber *)numberByPerformingOperation:(SMNumberOperation)operation withNumber:(SMNumber *)x withNumber:(SMNumber *)y error:(NSError **)error
{
	NSLog(@"BUG:  The numberByPerformingOperation:withNumber:withNumber:error: method of an SMNumber subclass is not implemented!!!");
	return nil;
}


@end

