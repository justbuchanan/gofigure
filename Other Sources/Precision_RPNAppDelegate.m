//
//  Precision_RPNAppDelegate.m
//  Precision RPN
//
//  Created by Justin Buchanan on 8/16/09.
//  Copyright JustBuchanan Software 2009. All rights reserved.
//

#import "Precision_RPNAppDelegate.h"
#import "Debug.h"
#import "SMCertainNumber.h"



#define SAVED_DATA_PATH @"/Documents/PrecisionRPN.plist"




@implementation Precision_RPNAppDelegate
@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	
	
	//NSLog(@"sinl(converted 1) = %Lf", sinl(JBAngleConvert(JBAngleUnitDegree, JBAngleUnitRadian, 1)));
	//NSLog(@"sinl(M_PI) = %Lf", sinl(M_PI));
	//NSLog(@"cosl(90 deg) = %Lf", JBAngleConvert(JBAngleUnitDegree, JBAngleUnitRadian, 90));
	
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	NSString *path = [NSHomeDirectory() stringByAppendingString:SAVED_DATA_PATH];
	NSData *precisionRPNData = [[NSData alloc] initWithContentsOfFile:path];
	
	SMRPNCalculator *calculator;
	
	if ( precisionRPNData )
	{
		NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:precisionRPNData];
		[SMNumber setAngleUnit:[unarchiver decodeIntForKey:@"AngleUnit"]];
		calculator = [unarchiver decodeObjectForKey:@"Calculator"];
		
		[precisionRPNData release];
		[unarchiver finishDecoding];
		[unarchiver release];
	}
	else	//	load default data
	{
		DebugLog(@"Precision RPN is launching for the first time and is loading default settings");
		[SMNumber setAngleUnit:JBAngleUnitDegree];
		calculator = [[[SMRPNCalculator alloc] initWithStack:nil numberClass:[SMCertainNumber class]] autorelease];
	}
	
	if ( !calculator )
	{
		calculator = [[[SMRPNCalculator alloc] initWithStack:nil numberClass:[SMCertainNumber class]] autorelease];
		NSLog(@"calc was nil at app launch");
	}
	
	_calculatorViewController = [[RPNCalculatorViewController alloc] initWithCalculator:calculator];
	_calculatorViewController.delegate = self;
	
	[window addSubview:_calculatorViewController.view];
	CGRect frame = _calculatorViewController.view.frame;
	frame.origin.y += 20;
	_calculatorViewController.view.frame = frame;
	
    [window makeKeyAndVisible];
	
	self.navigationController;	//	load nav controller
	
	DebugLog(@"Precision RPN finished launching");
	
	
	
	//[self performSelector:@selector(respond) withObject:nil afterDelay:1];	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
}






- (void)respond	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
{
	[_calculatorViewController.view becomeFirstResponder];
	[self performSelector:@selector(respond) withObject:nil afterDelay:5];
}








- (void)applicationWillTerminate:(UIApplication *)application
{
	DebugLog(@"Precision RPN is about to terminate and is saving state");
	
	NSMutableData *precisionRPNData = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:precisionRPNData];
	[archiver encodeInt:[SMNumber angleUnit] forKey:@"AngleUnit"];
	[archiver encodeObject:_calculatorViewController.calculator forKey:@"Calculator"];
	[archiver finishEncoding];
	[archiver release];
	
	NSString *path = [NSHomeDirectory() stringByAppendingString:SAVED_DATA_PATH];
	
	[precisionRPNData writeToFile:path atomically:YES];
	[precisionRPNData release];
}

- (void)didRecieveMemoryNotificationWarning:(NSNotification *)notif
{
	NSLog(@"Precision RPN App Delegate recieved memory warning");
	if ( !_settingsViewController.view.superview )
	{
		[_settingsViewController release];	//	release settings view if it doesn't have a superview
		_settingsViewController = nil;
		[_navController release];
		_navController = nil;
	}
}

- (void)dealloc
{
    [window release];
    [super dealloc];
}


#pragma mark RPNCalculatorViewControllerDelegate

- (void)rpnCalculatorViewControllerPressedSettingsButton:(RPNCalculatorViewController *)calcController
{
	[UIView beginAnimations:@"flip" context:NULL];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:YES];
	[UIView setAnimationDuration:1.0f];	//	.6
	
	[_calculatorViewController.view removeFromSuperview];
	[window addSubview:self.navigationController.view];
	
	[UIView commitAnimations];
}



#pragma mark SettingsViewControllerDelegate

- (void)settingsViewControllerPressedExitButton:(SettingsViewController *)settingsViewController
{
	DebugLog(@"settingsController flipped back to calcController");
	
	/*	Update app to reflect any changes in settings	*/
	
	DebugLog(@"oldPrecType = %d, new = %d", [_calculatorViewController.calculator.numberClass precisionType], _settingsViewController.precisionType);
	
	
	SMPrecisionType newPrecisionType = _settingsViewController.precisionType;
	if ( newPrecisionType != [_calculatorViewController.calculator.numberClass precisionType] )
	{
		DebugLog(@"precisionType changed to: %@", [SMNumber numberClassForPrecisionType:newPrecisionType]);
		_calculatorViewController.calculator.numberClass = [SMNumber numberClassForPrecisionType:newPrecisionType];
		[_calculatorViewController.stackViewController resetStack];
		
		NSLog(@"calculator = %@", _calculatorViewController.calculator);
	}
	[SMNumber setAngleUnit:_settingsViewController.angleUnit];
	
	/*	Flip view back over		*/
	[UIView beginAnimations:@"flipBack" context:NULL];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:window cache:YES];
	[UIView setAnimationDuration:1.0f];
	
	[self.navigationController.view removeFromSuperview];
	[window addSubview:_calculatorViewController.view];
	CGRect frame = _calculatorViewController.view.frame;
	frame.origin.y = 20;
	_calculatorViewController.view.frame = frame;
	
	[UIView commitAnimations];
}


#pragma mark Properties

- (UINavigationController *)navigationController
{
	if ( !_navController )
	{
		DebugLog(@"App Delegate created Nav Controller");
		_navController = [[UINavigationController alloc] initWithRootViewController:self.settingsViewController];
	}
	return _navController;
}

- (SettingsViewController *)settingsViewController
{
	if ( !_settingsViewController )
	{
		_settingsViewController = [[SettingsViewController alloc] initWithPrecisionType:[_calculatorViewController.calculator.numberClass precisionType] angleUnit:[SMNumber angleUnit]];
		_settingsViewController.delegate = self;
	}
	return _settingsViewController;
}


@end
