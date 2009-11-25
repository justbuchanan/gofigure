//
//  SettingsViewController.m
//  Precision RPN
//
//  Created by Justin Buchanan on 9/7/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import "SettingsViewController.h"


static NSString *unlocalizedSectiontitles[2] = {
	@"SIG_FIGS",
	@"ANGLE_UNIT"
};

static NSString *unlocalizedCellTitles[2][3] = {
	{ @"SIG_FIGS", @"NONE", nil },
	{ @"RADIANS", @"DEGREES", @"GRADIANS" }
};



@interface SettingsViewController (Private)

- (void)setCellChecked:(BOOL)checked atRow:(NSUInteger)row inSection:(NSUInteger)section;

@end




@implementation SettingsViewController
@synthesize angleUnit = _angleUnit, precisionType = _precisionType, delegate = _delegate;

- (id)initWithPrecisionType:(SMPrecisionType)type angleUnit:(JBAngleUnit)angleUnit
{
    if ( self = [super initWithStyle:UITableViewStyleGrouped] )
	{
		_precisionType = type;
		_angleUnit = angleUnit;
		
		self.title = NSLocalizedString(@"SETTINGS", nil);
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_doneButtonPressed)];
		self.navigationItem.rightBarButtonItem = doneButton;
		[doneButton release];
    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ( interfaceOrientation == UIInterfaceOrientationPortrait );
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ( section == 0 ) ? 1 : 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row, section = indexPath.section;
    UITableViewCell *cell;
    if ( section == 1 )
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
    }
	else
	{
		cell = [[[SwitchCell alloc] initWithTitle:nil state:( _precisionType == SMPrecisionTypeSigFigs ) reuseID:nil] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		((SwitchCell *)cell).delegate = self;
	}
    
	
    cell.textLabel.text = NSLocalizedString(unlocalizedCellTitles[section][row], nil);
	
	if ( row == _angleUnit && section == 1 ) cell.accessoryType = UITableViewCellAccessoryCheckmark;
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return NSLocalizedString(unlocalizedSectiontitles[section], nil);
}


- (void)setCellChecked:(BOOL)checked atRow:(NSUInteger)row inSection:(NSUInteger)section
{
	UITableViewCellAccessoryType accessory = (checked) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]].accessoryType = accessory;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ( indexPath.section == 1 )
	{
		[self setCellChecked:NO atRow:_angleUnit inSection:1];
		_angleUnit = indexPath.row;
		[self setCellChecked:YES atRow:_angleUnit inSection:1];
	}
	
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}


- (void)_doneButtonPressed
{
	[_delegate settingsViewControllerPressedExitButton:self];
}

#pragma mark SwitchCellDelegate

- (void)switchCell:(SwitchCell *)switchCell changedState:(BOOL)on
{
	_precisionType = ( on ) ? SMPrecisionTypeSigFigs : SMPrecisionTypeNone;
}


@end







