//
//  SMSigFigNumber.h
//  Precision RPN
//
//  Created by Justin Buchanan on 8/16/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import "SMNumber.h"


#define INFINITE_SIGFIGS -1
#define COMBINING_OVERLINE 0x0305


@interface SMSigFigNumber : SMNumber
{
	int _sigFigs;
}

- (id)initWithDecimal:(Decimal)decimal sigFigs:(int)sigFigs;

@property (readonly) int sigFigs;
@property (readonly) int mostSignificantPlace;	//	1 = 1s place, 2 = 10s place, etc.
@property (readonly) int leastSignificantPlace;	//	-1 = 10ths place, -2 = 100ths place, etc.

@end
