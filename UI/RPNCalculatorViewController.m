//
//  RPNCalculatorViewController.m
//  Precision RPN
//
//  Created by Justin Buchanan on 8/20/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import "RPNCalculatorViewController.h"
#import "SMSigFigNumber.h"
#import "SMCertainNumber.h"
#import "SMUncertainNumber.h"
#import "Debug.h"
#import "Defines.h"




@interface RPNCalculatorViewController (Private)

- (BOOL)_pushValueBeingConstructed;
- (void)_showErrorWithTitle:(NSString *)title message:(NSString *)msg;

@end





@implementation RPNCalculatorViewController
@synthesize delegate = _delegate, valueBeingConstructedLabel = _valueBeingConstructedLabel, stackViewController = _stackViewController, calculator = _calculator;
@synthesize sineButton, cosineButton, tangentButton;

- (id)initWithCalculator:(SMRPNCalculator *)calculator
{
    if ( self = [super initWithNibName:@"RPNCalculatorView" bundle:[NSBundle mainBundle]] )
	{
		_calculator = [calculator retain];
		_calculator.delegate = self;
		
        _stackViewController = [[StackViewController alloc] initWithStack:_calculator.stack];
		_stackViewController.delegate = self;
		
		_valueBeingConstructed = [[NSMutableString alloc] init];
		
		_shiftIsOn = NO;
		
		DebugLog(@"At init of RPNCalculatorViewController, stack of calc = %@", calculator.stack);
		
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceShook:) name:@"DeviceDidShake" object:nil];	/////////////////////////////////////////////////////////////////////////////////////////////
		
    }
    return self;
}


- (void)deviceShook:(NSNotification *)notif
{
	DebugLog(@"before clearing, calc stack = %@", self.calculator.stack);
	[self.calculator clearAllNumbers];
	DebugLog(@"after clearing, calc stack = %@", self.calculator.stack);
	
	[self.stackViewController clearNumbersAnimated:YES];
}


- (void)dealloc
{
	[_calculator release];
	[_stackViewController release];
	[_valueBeingConstructed release];
    [super dealloc];
}

- (void)_showErrorWithTitle:(NSString *)title message:(NSString *)msg
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
	[alert show];
	[alert release];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIView *calculatorView = self.view;
	
	UIView *stackView = _stackViewController.view;
	stackView.frame = CGRectMake(10, 10, 300, 156);
	
	[calculatorView addSubview:stackView];
	[calculatorView addSubview:_valueBeingConstructedLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.view becomeFirstResponder];	//////////////////////////////////////////////////////////////////////////////////////////////
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}


- (BOOL)_animatesViews
{
	return self.view.superview != NULL;
}


#pragma mark SMRPNCalculator Delegate

- (void)rpnCalculator:(SMRPNCalculator *)calculator movedNumberInStackFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
	[_stackViewController moveNumberInStackFromIndex:fromIndex toIndex:toIndex animated:[self _animatesViews]];
}

- (void)rpnCalculatorDroppedNumberFromStack:(SMRPNCalculator *)calculator
{
	[_stackViewController dropNumberFromStackAnimated:[self _animatesViews]];
}

- (void)rpnCalculator:(SMRPNCalculator *)calculator addedNumberToStack:(SMNumber *)number
{
	[_stackViewController addNumberToStack:number animated:[self _animatesViews]];
}

- (void)rpnCalculator:(SMRPNCalculator *)calculator insertedNumber:(SMNumber *)number intoStackAtIndex:(NSUInteger)index
{
	[_stackViewController insertNumber:number intoStackAtIndex:index animated:[self _animatesViews]];
}

- (void)rpnCalculator:(SMRPNCalculator *)calculator deletedNumberInStackAtIndex:(NSUInteger)index
{
	[_stackViewController deleteNumberFromStackAtIndex:index animated:[self _animatesViews]];
}


#pragma mark StackViewController Delegate

- (void)stackViewController:(StackViewController *)stackViewController movedNumberAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
	[_calculator moveNumberInStackAtIndex:fromIndex toIndex:toIndex];
}

- (void)stackViewController:(StackViewController *)stackViewController deletedNumberAtIndex:(NSUInteger)index
{
	[_calculator deleteNumberFromStackAtIndex:index];
}



#pragma mark UI Updating

- (SMNumber *)_numberValueOfValueBeingConstructed
{
	return (SMNumber *)[[[[_calculator numberClass] alloc] initWithString:_valueBeingConstructed] autorelease];
}

- (void)_appendCharacterToValueBeingConstructed:(unichar)character
{
	NSString *string = [NSString stringWithFormat:@"%C", character];
	[_valueBeingConstructed appendString:string];
	_valueBeingConstructedLabel.text = _valueBeingConstructed;
}

- (void)_performOperation:(SMNumberOperation)op
{
	if ( [self _pushValueBeingConstructed] )
	{
		DebugLog(@"the calculator was told to perform op: %d", op);
		NSError *error = [_calculator performOperation:op];
		
		if ( error ) [self _showErrorWithTitle:NSLocalizedStringFromTable(@"ERROR", @"Errors", nil) message:[error localizedDescription]];
	}
	
	DebugLog(@"after performing operation, stack = %@", _calculator.stack);
	
}


/*	Returns NO if there was a value and it wasn't successfully pushed	*/
- (BOOL)_pushValueBeingConstructed
{
	DebugLog(@"_pushValueBeingConstructed was called. valueBeingConstructed = %@", _valueBeingConstructed);
	if ( [_valueBeingConstructed length] )
	{
		SMNumber *number = [self _numberValueOfValueBeingConstructed];
		DebugLog(@"numberValue of valueBeingConstructed = %@", number);
		DebugLog(@"numberClass = %@", _calculator.numberClass);
		if ( number )
		{
			[_calculator addNumberToStack:number];
			
			[_stackViewController addNumberToStack:number animated:[self _animatesViews]];
			[_valueBeingConstructed setString:@""];
			_valueBeingConstructedLabel.text = _valueBeingConstructed;
			
			
			DebugLog(@"after pushing valueBeingConstructed, stack = %@", _calculator.stack);
			
			return YES;
		}
		else
		{
			NSLog(@"BUG:  [RPNCalculatorViewController _pushValueBeingConstructed] was unsuccessful with string: %@", _valueBeingConstructed);
			return NO;
		}
	}
	else
	{
		return YES;
	}
}


#pragma mark Button Press Handlers

- (void)buttonDecimalPressed:(id)sender
{
	NSLog(@"decimal button pressed");
	
	NSRange decimalRange = [_valueBeingConstructed rangeOfString:@"."];
	
	NSInteger decimalCount = 0;
	const char *string = [_valueBeingConstructed UTF8String];
	for ( int i = 0; string[i] != '\0'; i++ )
	{
		if ( string[i] == '.' ) ++decimalCount;
	}
	
	NSRange eRange = [_valueBeingConstructed rangeOfString:@"E"];
	
	if ( decimalRange.location == NSNotFound )
	{
		[self _appendCharacterToValueBeingConstructed:'.'];
	}
	else if ( (decimalRange.location < eRange.location && eRange.location != NSNotFound ) && (decimalCount == 1) )
	{
		[self _appendCharacterToValueBeingConstructed:'.'];
	}
	
	NSLog(@"decimal location = %d", decimalRange.location);
	NSLog(@"e location = %d", [_valueBeingConstructed rangeOfString:@"E"].location);
	NSLog(@"decimal count = %d", decimalCount);
}

- (void)button0Pressed:(id)sender
{
	[self _appendCharacterToValueBeingConstructed:'0'];
}

- (void)button1Pressed:(id)sender
{
	[self _appendCharacterToValueBeingConstructed:'1'];
}

- (void)button2Pressed:(id)sender
{
	[self _appendCharacterToValueBeingConstructed:'2'];
}

- (void)button3Pressed:(id)sender
{
	[self _appendCharacterToValueBeingConstructed:'3'];
}

- (void)button4Pressed:(id)sender
{
	[self _appendCharacterToValueBeingConstructed:'4'];
}

- (void)button5Pressed:(id)sender
{
	[self _appendCharacterToValueBeingConstructed:'5'];
}

- (void)button6Pressed:(id)sender
{
	[self _appendCharacterToValueBeingConstructed:'6'];
}

- (void)button7Pressed:(id)sender
{
	[self _appendCharacterToValueBeingConstructed:'7'];
}

- (void)button8Pressed:(id)sender
{
	[self _appendCharacterToValueBeingConstructed:'8'];
}

- (void)button9Pressed:(id)sender
{
	[self _appendCharacterToValueBeingConstructed:'9'];
}


- (void)buttonAddPressed:(id)sender
{
	[self _performOperation:SMNumberOperationAdd];
}

- (void)buttonSubtractPressed:(id)sender
{
	[self _performOperation:SMNumberOperationSubtract];
}

- (void)buttonMultiplyPressed:(id)sender
{
	[self _performOperation:SMNumberOperationMultiply];
}

- (void)buttonDividePressed:(id)sender
{
	[self _performOperation:SMNumberOperationDivide];
}


- (void)buttonEnterPressed:(id)sender
{
	if ( [_valueBeingConstructed length] )
	{
		[self _pushValueBeingConstructed];
	}
	else if ( [_calculator.stack count] )
	{
		SMNumber *number = [_calculator.stack objectAtIndex:0];
		[_calculator addNumberToStack:number];
		[_stackViewController addNumberToStack:number animated:[self _animatesViews]];
	}
}

- (void)buttonDeletePressed:(id)sender
{
	NSUInteger length = [_valueBeingConstructed length];
	if ( length )
	{
		[_valueBeingConstructed deleteCharactersInRange:NSMakeRange(length - 1, 1)];	//	delete a char from the string
		_valueBeingConstructedLabel.text = _valueBeingConstructed;
	}
	else if ( [_calculator.stack count] )
	{
		DebugLog(@"Before deleting, _calculator.stack = %@", _calculator.stack);
		[_calculator dropNumberFromStack];
		[_stackViewController dropNumberFromStackAnimated:[self _animatesViews]];
		
		DebugLog(@"After deleting, _calculator.stack = %@", _calculator.stack);
	}
}

- (void)buttonUndoPressed:(id)sender
{
	DebugLog(@"before undo, stack = %@", _calculator.stack);
	[_calculator undo];
	DebugLog(@"after undo, stack = %@", _calculator.stack);
}

- (void)buttonShiftPressed:(id)sender
{
	_shiftIsOn = !_shiftIsOn;
	((UIButton *)sender).selected = _shiftIsOn;
	
	if ( _shiftIsOn )
	{
		[sineButton setTitle:NSLocalizedString(@"ARC_SINE_BUTTON", nil) forState:UIControlStateNormal];
		[cosineButton setTitle:NSLocalizedString(@"ARC_COSINE_BUTTON", nil) forState:UIControlStateNormal];
		[tangentButton setTitle:NSLocalizedString(@"ARC_TANGENT_BUTTON", nil) forState:UIControlStateNormal];
	}
	else
	{
		[sineButton setTitle:NSLocalizedString(@"SINE_BUTTON", nil) forState:UIControlStateNormal];
		[cosineButton setTitle:NSLocalizedString(@"COSINE_BUTTON", nil) forState:UIControlStateNormal];
		[tangentButton setTitle:NSLocalizedString(@"TANGENT_BUTTON", nil) forState:UIControlStateNormal];
	}
}


- (void)buttonEEXPressed:(id)sender
{
	if ( [_valueBeingConstructed rangeOfString:@"E"].location == NSNotFound )
	{
		NSUInteger length = [_valueBeingConstructed length];
		if ( !length )
			[_valueBeingConstructed insertString:@"1E" atIndex:0];
		else
			[_valueBeingConstructed insertString:@"E" atIndex:length];
		
		_valueBeingConstructedLabel.text = _valueBeingConstructed;
	}
}


- (void)buttonLog10Pressed:(id)sender
{
	[self _performOperation:SMNumberOperationLog];
}

- (void)buttonLogNaturalPressed:(id)sender
{
	[self _performOperation:SMNumberOperationNaturalLog];
}


- (void)buttonNegatePressed:(id)sender
{
	if ( [_valueBeingConstructed length] )
	{
		NSUInteger eIndex = [_valueBeingConstructed rangeOfString:@"E"].location;
		
		if ( eIndex == NSNotFound )
		{
			if ( [_valueBeingConstructed characterAtIndex:0] == '-' )
			{
				[_valueBeingConstructed replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
			}
			else
			{
				[_valueBeingConstructed insertString:@"-" atIndex:0];
			}
		}
		else
		{
			if ( [_valueBeingConstructed length] >= eIndex + 2 && [_valueBeingConstructed characterAtIndex:eIndex + 1] == '-' )
			{
				[_valueBeingConstructed deleteCharactersInRange:NSMakeRange(eIndex + 1, 1)];
			}
			else
			{
				[_valueBeingConstructed insertString:@"-" atIndex:eIndex + 1];
			}
		}
		
		_valueBeingConstructedLabel.text = _valueBeingConstructed;
	}
	else
	{
		[self _performOperation:SMNumberOperationNegate];
	}
}


- (void)buttonSquareRootPressed:(id)sender
{
	[self _performOperation:SMNumberOperationSquareRoot];
}

- (void)buttonRootPressed:(id)sender
{
	[self _performOperation:SMNumberOperationTakeRoot];
}

- (void)buttonSquarePressed:(id)sender
{
	[self _performOperation:SMNumberOperationSquare];
}


- (void)buttonCubePressed:(id)sender
{
	[self _performOperation:SMNumberOperationCube];
}

- (void)buttonRaiseToPowerPressed:(id)sender
{
	[self _performOperation:SMNumberOperationRaiseToPower];
}


- (void)buttonPiPressed:(id)sender
{
	[self _pushValueBeingConstructed];
	
	SMNumber *number = [(SMNumber *)[_calculator.numberClass alloc] initWithDecimal:PI];
	
	[_calculator addNumberToStack:number];
	[_stackViewController addNumberToStack:number animated:[self _animatesViews]];
	
	[number release];
}

- (void)buttonEPressed:(id)sender	//	euler's number
{
	[self _pushValueBeingConstructed];
	
	SMNumber *number = [[(SMNumber *)[_calculator.numberClass alloc] initWithDecimal:M_E] autorelease];
	
	[_calculator addNumberToStack:number];
	[_stackViewController addNumberToStack:number animated:[self _animatesViews]];
}

- (void)buttonSinePressed:(id)sender
{
	SMNumberOperation op = (_shiftIsOn) ? SMNumberOperationArcSine : SMNumberOperationSine;
	[self _performOperation:op];
}

- (void)buttonCosinePressed:(id)sender
{
	SMNumberOperation op = (_shiftIsOn) ? SMNumberOperationArcCosine : SMNumberOperationCosine;
	[self _performOperation:op];
}

- (void)buttonTangentPressed:(id)sender
{
	SMNumberOperation op = (_shiftIsOn) ? SMNumberOperationArcTangent : SMNumberOperationTangent;
	[self _performOperation:op];
}

- (void)buttonInfoPressed:(id)sender
{
	[_delegate rpnCalculatorViewControllerPressedSettingsButton:self];
}


@end




