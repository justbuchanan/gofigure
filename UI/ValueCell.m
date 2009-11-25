//
//  ValueCell.m
//  Precision RPN
//
//  Created by Justin Buchanan on 8/29/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import "ValueCell.h"


@implementation ValueCell
@synthesize number = _number;


- (id)initWithNumber:(SMNumber *)number reuseIdentifier:(NSString *)reuseID
{
    if ( self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID] )
	{
		[self setNumber:number];
		self.backgroundColor = [UIColor clearColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.textLabel.textAlignment = UITextAlignmentRight;
    }
    return self;
}

- (void)setNumber:(SMNumber *)number
{
	[number retain];
	[_number release];
	_number = number;
	self.textLabel.text = [number stringValueWithDisplayFormat:SMNumberDisplayFormatRegular];
}

- (void)dealloc
{
	[_number release];
    [super dealloc];
}


@end
