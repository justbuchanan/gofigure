//
//  ValueCell.h
//  Precision RPN
//
//  Created by Justin Buchanan on 8/29/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMNumber.h"


@interface ValueCell : UITableViewCell
{
	SMNumber *_number;
}

- (id)initWithNumber:(SMNumber *)number reuseIdentifier:(NSString *)reuseID;

@property (readwrite, retain) SMNumber *number;

@end
