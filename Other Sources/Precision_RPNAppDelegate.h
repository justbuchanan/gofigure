//
//  Precision_RPNAppDelegate.h
//  Precision RPN
//
//  Created by Justin Buchanan on 8/16/09.
//  Copyright JustBuchanan Software 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPNCalculatorViewController.h"
#import "SettingsViewController.h"


@interface Precision_RPNAppDelegate : NSObject <UIApplicationDelegate, RPNCalculatorViewControllerDelegate, SettingsViewControllerDelegate>
{
    UIWindow *window;
	RPNCalculatorViewController *_calculatorViewController;
	SettingsViewController *_settingsViewController;
	UINavigationController *_navController;
}

@property (nonatomic, retain)	IBOutlet UIWindow *window;
@property (readonly, retain)	SettingsViewController *settingsViewController;
@property (readonly, retain)	UINavigationController *navigationController;

@end

