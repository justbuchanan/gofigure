//
//  RPNCalculatorViewController.h
//  Precision RPN
//
//  Created by Justin Buchanan on 8/20/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackViewController.h"
#import "SMRPNCalculator.h"


@protocol RPNCalculatorViewControllerDelegate;


@interface RPNCalculatorViewController : UIViewController <StackViewControllerDelegate, SMRPNCalculatorDelegate>
{
	SMRPNCalculator *_calculator;
	StackViewController *_stackViewController;
	NSMutableString *_valueBeingConstructed;
	UILabel *_valueBeingConstructedLabel;
	id<RPNCalculatorViewControllerDelegate> _delegate;
	
	BOOL _shiftIsOn;
	
	UIButton *sineButton, *cosineButton, *tangentButton;
}

- (id)initWithCalculator:(SMRPNCalculator *)calculator;

@property (readwrite, assign)	id<RPNCalculatorViewControllerDelegate>	delegate;
@property (readonly, retain)	SMRPNCalculator							*calculator;
@property (readonly, retain)	StackViewController						*stackViewController;
@property (readonly, retain)	IBOutlet UILabel						*valueBeingConstructedLabel;
@property (readonly, assign)	IBOutlet UIButton						*sineButton, *cosineButton, *tangentButton;


- (void)buttonDecimalPressed:(id)sender;

- (void)button0Pressed:(id)sender;
- (void)button1Pressed:(id)sender;
- (void)button2Pressed:(id)sender;
- (void)button3Pressed:(id)sender;
- (void)button4Pressed:(id)sender;
- (void)button5Pressed:(id)sender;
- (void)button6Pressed:(id)sender;
- (void)button7Pressed:(id)sender;
- (void)button8Pressed:(id)sender;
- (void)button9Pressed:(id)sender;

- (void)buttonAddPressed:(id)sender;
- (void)buttonSubtractPressed:(id)sender;
- (void)buttonMultiplyPressed:(id)sender;
- (void)buttonDividePressed:(id)sender;

- (void)buttonEnterPressed:(id)sender;
- (void)buttonDeletePressed:(id)sender;
- (void)buttonUndoPressed:(id)sender;
- (void)buttonShiftPressed:(id)sender;

- (void)buttonEEXPressed:(id)sender;

- (void)buttonLog10Pressed:(id)sender;
- (void)buttonLogNaturalPressed:(id)sender;

- (void)buttonNegatePressed:(id)sender;

- (void)buttonSquareRootPressed:(id)sender;
- (void)buttonRootPressed:(id)sender;
- (void)buttonSquarePressed:(id)sender;
- (void)buttonCubePressed:(id)sender;
- (void)buttonRaiseToPowerPressed:(id)sender;

- (void)buttonPiPressed:(id)sender;
- (void)buttonEPressed:(id)sender;	//	euler's number

- (void)buttonSinePressed:(id)sender;
- (void)buttonCosinePressed:(id)sender;
- (void)buttonTangentPressed:(id)sender;

- (void)buttonInfoPressed:(id)sender;


@end






@protocol RPNCalculatorViewControllerDelegate

- (void)rpnCalculatorViewControllerPressedSettingsButton:(RPNCalculatorViewController *)calcController;

@end




