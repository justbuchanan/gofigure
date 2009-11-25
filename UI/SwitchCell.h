//
//  SwitchCell.h
//
//  Created by Justin Buchanan on 9/26/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SwitchCellDelegate;

@interface SwitchCell : UITableViewCell
{
	UISwitch				*_toggleSwitch;
	id<SwitchCellDelegate>	_delegate;
}

- (id)initWithTitle:(NSString *)title state:(BOOL)on reuseID:(NSString *)reuseID;

@property (readonly)			BOOL					on;
@property (readwrite, assign)	id<SwitchCellDelegate>	delegate;

@end





@protocol SwitchCellDelegate

- (void)switchCell:(SwitchCell *)switchCell changedState:(BOOL)on;

@end
