//
//  ShakeView.m
//  Go Figure
//
//  Created by Justin Buchanan on 10/30/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import "ShakeView.h"
#import "Debug.h"


@implementation ShakeView


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [ super initWithCoder:aDecoder] )
	{
		DebugLog(@"shakeview inited");
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
	return YES;
}


- (void)drawRect:(CGRect)rect
{
	[self becomeFirstResponder];
}


- (void)dealloc
{
    [super dealloc];
}



#pragma mark Event Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	DebugLog(@"touches began: %@", touches);
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	DebugLog(@"motion began with event: %@", event);
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	DebugLog(@"motion cancelled");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	DebugLog(@"motion ended with event: %@", event);
	if ( motion == UIEventSubtypeMotionShake )
	{
		DebugLog(@"event was motion shake!!!");
		NSNotification *notification = [NSNotification notificationWithName:@"DeviceDidShake" object:nil];
		[[NSNotificationCenter defaultCenter] postNotification:notification];
	}
}


@end





