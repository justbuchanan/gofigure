//
//  SettingsViewController.h
//  Precision RPN
//
//  Created by Justin Buchanan on 9/7/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMNumber.h"
#import "JBAngleUnit.h"
#import "SwitchCell.h"


@protocol SettingsViewControllerDelegate;



@interface SettingsViewController : UITableViewController <SwitchCellDelegate>
{
	SMPrecisionType _precisionType;
	JBAngleUnit _angleUnit;
	id<SettingsViewControllerDelegate> _delegate;
}

- (id)initWithPrecisionType:(SMPrecisionType)type angleUnit:(JBAngleUnit)angleUnit;

@property (readwrite, assign) id<SettingsViewControllerDelegate> delegate;

@property (readonly) SMPrecisionType	precisionType;
@property (readonly) JBAngleUnit		angleUnit;

@end



@protocol SettingsViewControllerDelegate

- (void)settingsViewControllerPressedExitButton:(SettingsViewController *)settingsViewController;

@end


