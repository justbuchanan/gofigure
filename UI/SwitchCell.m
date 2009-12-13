//
//  SwitchCell.m
//
//  Created by Justin Buchanan on 9/26/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import "SwitchCell.h"


@implementation SwitchCell
@synthesize delegate = _delegate;

- (id)initWithTitle:(NSString *)title state:(BOOL)on reuseID:(NSString *)reuseID;
{
	if ( self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID] )
	{
		_toggleSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:_toggleSwitch];
		[_toggleSwitch addTarget:self action:@selector(switchToggled) forControlEvents:UIControlEventValueChanged];
		self.textLabel.text = title;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		_toggleSwitch.on = on;
	}
	return self;
}

- (void)dealloc
{
	[_toggleSwitch release];
	[super dealloc];
}

- (void)switchToggled
{
	[_delegate switchCell:self changedState:self.on];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	[self.contentView bringSubviewToFront:_toggleSwitch];
	CGSize contentSize = self.contentView.bounds.size;
	CGRect frame = _toggleSwitch.frame;
	frame.origin.y = ( contentSize.height - frame.size.height ) / 2.0f;	//	center it vertically
	frame.origin.x = contentSize.width - ( frame.size.width + frame.origin.y );	//	make it so it's the same distance from the right edge as it is from the top & bottom
	_toggleSwitch.frame = frame;
}


- (BOOL)on
{
	return _toggleSwitch.on;
}

@end
