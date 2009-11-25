//
//  SMUncertainNumber.h
//  Precision RPN
//
//  Created by Justin Buchanan on 8/16/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import "SMNumber.h"


@interface SMUncertainNumber : SMNumber
{
	double _uncertainty;
}

- (id)initWithValue:(double)value uncertainty:(double)uncertainty;

@property (readonly) double uncertainty;

@end
