//
//  SMRPNCalculator.h
//  Precision RPN
//
//  Created by Justin Buchanan on 8/16/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMNumber.h"


@protocol SMRPNCalculatorDelegate;

@interface SMRPNCalculator : NSObject <NSCoding>
{
	NSMutableArray *_stack;
	Class _numberClass;
	BOOL _undoing;
	NSUndoManager *_undoManager;
	id<SMRPNCalculatorDelegate> _delegate;
}

- (id)initWithStack:(NSArray *)stack numberClass:(Class)numberClass;

- (NSError *)performOperation:(SMNumberOperation)operation;

- (void)resetStack;	//	clears the stack and does NOT register an undo

@property (readonly, retain )	NSArray						*stack;
@property (readwrite)			Class						numberClass;
@property (readwrite, assign)	id<SMRPNCalculatorDelegate>	delegate;

/*	Manipulating the stack	*/
- (SMNumber *)numberAtStackIndex:(NSInteger)index;
- (void)addNumberToStack:(SMNumber *)number;
- (void)dropNumberFromStack;
- (void)deleteNumberFromStackAtIndex:(NSUInteger)index;
- (void)insertNumber:(SMNumber *)number intoStackAtIndex:(NSUInteger)index;
- (void)moveNumberInStackAtIndex:(NSInteger)src toIndex:(NSInteger)dest;
- (NSInteger)countNumbersInStack;
- (void)clearAllNumbers;

/*	Undo management	*/
- (void)undo;
- (void)redo;
- (BOOL)canUndo;
- (BOOL)canRedo;

@end



/*
 *	The following methods are only called on the delegate when the calculator is undoing or redoing.
 */
@protocol SMRPNCalculatorDelegate

- (void)rpnCalculator:(SMRPNCalculator *)calculator movedNumberInStackFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (void)rpnCalculatorDroppedNumberFromStack:(SMRPNCalculator *)calculator;
- (void)rpnCalculator:(SMRPNCalculator *)calculator addedNumberToStack:(SMNumber *)number;
- (void)rpnCalculator:(SMRPNCalculator *)calculator insertedNumber:(SMNumber *)number intoStackAtIndex:(NSUInteger)index;
- (void)rpnCalculator:(SMRPNCalculator *)calculator deletedNumberInStackAtIndex:(NSUInteger)index;

@end
