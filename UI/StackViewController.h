//
//  StackViewController.h
//  Precision RPN
//
//  Created by Justin Buchanan on 8/20/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMNumber.h"
#import "ValueCell.h"

@protocol StackViewControllerDelegate;


@interface StackViewController : UITableViewController
{
	NSMutableArray *_stack;	//	array of SMNumber objects
	id<StackViewControllerDelegate> _delegate;
}

- (id)initWithStack:(NSArray *)stack;

- (void)resetStack;

/*	Manipulating the stack	*/
- (void)moveNumberInStackFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex animated:(BOOL)animated;
- (void)addNumberToStack:(SMNumber *)number animated:(BOOL)animated;
- (void)dropNumberFromStackAnimated:(BOOL)animated;
- (void)deleteNumberFromStackAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)insertNumber:(SMNumber *)number intoStackAtIndex:(NSUInteger)index animated:(BOOL)animated;

- (void)clearNumbersAnimated:(BOOL)animated;

@property (readonly)			NSMutableArray					*stack;
@property (readwrite, assign)	id<StackViewControllerDelegate>	delegate;

@end





@protocol StackViewControllerDelegate

- (void)stackViewController:(StackViewController *)stackViewController movedNumberAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (void)stackViewController:(StackViewController *)stackViewController deletedNumberAtIndex:(NSUInteger)index;

@end
