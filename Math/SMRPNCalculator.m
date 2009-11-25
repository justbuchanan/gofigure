//
//  SMRPNCalculator.m
//  Precision RPN
//
//  Created by Justin Buchanan on 8/16/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import "SMRPNCalculator.h"
#import "Debug.h"


#define UNDO_LIMIT 20



@implementation SMRPNCalculator
@synthesize numberClass = _numberClass, delegate = _delegate, stack = _stack;

- (id)initWithStack:(NSArray *)stack numberClass:(Class)numberClass
{
	if ( self = [super init] )
	{
		_stack = [[NSMutableArray alloc] initWithArray:stack];
		_numberClass = numberClass;
		DebugLog(@"SMRPNCalculator inited with number class: %@", _numberClass);
	}
	return self;
}

- (void)dealloc
{
	[_stack release];
	[_undoManager release];
	[super dealloc];
}

- (void)resetStack
{
	[_stack removeAllObjects];
}

- (void)_initUndo
{
	_undoManager = [[NSUndoManager alloc] init];
	[_undoManager setLevelsOfUndo:UNDO_LIMIT];
	[_undoManager setGroupsByEvent:NO];
	_undoing = NO;
}


#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
	if ( self = [super init] )
	{
		_stack = [[decoder decodeObjectForKey:@"Stack"] retain];
		_numberClass = NSClassFromString([decoder decodeObjectForKey:@"NumberClass"]);
		[self _initUndo];
		DebugLog(@"SMRPNCalculator inited with number class: %@", _numberClass);
		DebugLog(@"SMRPNCalculator inited with number stack: %@", _stack);
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	DebugLog(@"encodeWithCoder was called on SMRPNCalculator");
	[encoder encodeObject:_stack forKey:@"Stack"];
	[encoder encodeObject:NSStringFromClass(_numberClass) forKey:@"NumberClass"];
}



#pragma mark Performing Operations

- (NSError *)performOperation:(SMNumberOperation)operation	///	this method crashed once, is there a flaw in it?????????????????????!///////////////////////////////////////////////////////////////////////////////
{
	DebugLog(@"before performing operation in calculator, stack = %@", _stack);
	
	int operandCount = SMNumberOperationCountOperands(operation);
	
	SMNumber *leftOperand, *rightOperand;
	if ( [_stack count] >= operandCount )	//	make sure there's enough operands in the stack to do the operation
	{
		if ( operandCount == 2 )
		{
			leftOperand = [_stack objectAtIndex:1];
			rightOperand = [_stack objectAtIndex:0];
		}
		else
		{
			leftOperand = [_stack objectAtIndex:0];
			rightOperand = nil;
		}
		
		[_undoManager beginUndoGrouping];
		[_undoManager registerUndoWithTarget:self selector:@selector(_undoPerformOperation:) object:[NSArray arrayWithObjects:[NSNumber numberWithInt:operation], leftOperand, rightOperand, nil]];	//	register the undo
		[_undoManager endUndoGrouping];
		
		NSError *error = nil;
		
		DebugLog(@"about to calculate result");
		
		SMNumber *result = [_numberClass numberByPerformingOperation:operation withNumber:leftOperand withNumber:rightOperand error:&error];	//	perform the operation
		
		DebugLog(@"result was returned");
		
		[_stack removeObjectsInRange:NSMakeRange(0, operandCount)];		//	pop the operand(s) off the stack
		
		[_delegate rpnCalculatorDroppedNumberFromStack:self];						//	notify delegate
		if ( rightOperand ) [_delegate rpnCalculatorDroppedNumberFromStack:self];	//
		
		[_stack insertObject:result atIndex:0];		//	push the result onto the stack
		
		[_delegate rpnCalculator:self addedNumberToStack:result];	//	notify delegate
		
		return	error;
	}
	else
	{
		return [NSError errorWithDomain:@"Precision RPN" code:0 userInfo:[NSDictionary dictionaryWithObject:NSLocalizedStringFromTable(@"ERROR_NOT_ENOUGH_OPERANDS", @"Errors", nil) forKey:NSLocalizedDescriptionKey]];
	}
	
	DebugLog(@"Calculator finished performing operation");
}

- (void)_undoPerformOperation:(NSArray *)args
{
	//	args = { NSNumber:SMNumberOperation SMNumber:leftOperand SMNumber:rightOperand }
	//	there may be no rightOperand depending on the # of args for the SMNumberOperation
	
	SMNumberOperation operation = [(NSNumber *)[args objectAtIndex:0] intValue];
	
	DebugLog(@"at undoPerformOperation, args = %@", args);
	
	DebugLog(@"before undoing op, undomanager = %@", _undoManager);
	
	[_stack removeObjectAtIndex:0];		//	drop the result of the operation that we're undoing
	[_delegate rpnCalculatorDroppedNumberFromStack:self];	//	tell delegate
	
	SMNumber *leftOperand = [args objectAtIndex:1];
	[_stack insertObject:leftOperand atIndex:0];									//	push the left operand onto the stack
	[_delegate rpnCalculator:self addedNumberToStack:leftOperand];	//	tell the delegate what was pushed onto the stack
	
	if ( SMNumberOperationCountOperands(operation) == 2 )
	{
		DebugLog(@"about to push right operand as part of an undo");
		
		SMNumber *rightOperand = [args objectAtIndex:2];
		[_stack insertObject:rightOperand atIndex:0];								//	push the right operand onto the stack if there is one
		[_delegate rpnCalculator:self addedNumberToStack:rightOperand];	//	tell the delegate what was pushed onto the stack	
	}
	
	DebugLog(@"after undoing op in RPNCalculator, stack = %@", _stack);
}


#pragma mark Stack Manipulation

- (SMNumber *)numberAtStackIndex:(NSInteger)index
{
	return [_stack objectAtIndex:index];
}

- (void)addNumberToStack:(SMNumber *)number
{
	[_undoManager beginUndoGrouping];
	[_undoManager registerUndoWithTarget:self selector:@selector(dropNumberFromStack) object:nil];	//	register the undo/redo
	[_undoManager endUndoGrouping];
	
	[_stack insertObject:number atIndex:0];																		//	push the number onto the stack
	if ( _undoing ) [_delegate rpnCalculator:self addedNumberToStack:number];						//	notify delegate if this was part of an undo/redo
}

- (void)dropNumberFromStack
{
	[_undoManager beginUndoGrouping];
	[_undoManager registerUndoWithTarget:self selector:@selector(addNumberToStack:) object:[_stack objectAtIndex:0]];	//	register the undo/redo
	[_undoManager endUndoGrouping];
	
	[_stack removeObjectAtIndex:0];																						//	pop the # off of the stack
	if ( _undoing ) [_delegate rpnCalculatorDroppedNumberFromStack:self];												//	tell the delegate if this was part of an undo/redo
}


- (void)deleteNumberFromStackAtIndex:(NSUInteger)index
{
	SMNumber *number = [_stack objectAtIndex:index];	//	get the number from the stack
	
	[_undoManager beginUndoGrouping];
	[_undoManager registerUndoWithTarget:self selector:@selector(_insertNumberAtIndex:) object:[NSArray arrayWithObjects:[NSNumber numberWithUnsignedInt:index], number, nil]];	//	register the undo
	[_undoManager endUndoGrouping];
	
	[_stack removeObjectAtIndex:index];	//	delete the number from the stack
	//	we don't nofify the delegate b/c we're not doing an undo
}

- (void)_deleteNumberAtStackIndex:(NSNumber *)index
{
	NSUInteger i = [index unsignedIntValue];
	SMNumber *number = [_stack objectAtIndex:i];	//	get the number from the stack
	
	[_undoManager beginUndoGrouping];
	[_undoManager registerUndoWithTarget:self selector:@selector(_insertNumberAtIndex:) object:[NSArray arrayWithObjects:index, number, nil]];	//	register the undo
	[_undoManager endUndoGrouping];
	
	[_stack removeObjectAtIndex:i];									//	delete the number from the stack
	[_delegate rpnCalculator:self deletedNumberInStackAtIndex:i];	//	notify the delegate
}

- (void)insertNumber:(SMNumber *)number intoStackAtIndex:(NSUInteger)index
{
	[_undoManager beginUndoGrouping];
	[_undoManager registerUndoWithTarget:self selector:@selector(_deleteNumberAtStackIndex:) object:[NSNumber numberWithUnsignedInt:index]];	//	register the undo
	[_undoManager endUndoGrouping];
	
	[_stack insertObject:number atIndex:index];		//	insert the number into the stack
}

- (void)_insertNumberAtIndex:(NSArray *)args
{
	//	args = { NSNumber:index, SMNumber:number }
	NSUInteger index = [[args objectAtIndex:0] unsignedIntValue];
	SMNumber *number = [args objectAtIndex:1];
	
	[_undoManager beginUndoGrouping];
	[_undoManager registerUndoWithTarget:self selector:@selector(_deleteNumberAtStackIndex:) object:[args objectAtIndex:0]];	//	register the undo
	[_undoManager endUndoGrouping];
	
	[_stack insertObject:number atIndex:index];										//	insert the number into stack
	[_delegate rpnCalculator:self insertedNumber:number intoStackAtIndex:index];	//	notify the delegate
}

- (void)moveNumberInStackAtIndex:(NSInteger)src toIndex:(NSInteger)dest
{
	[_undoManager beginUndoGrouping];
	[_undoManager registerUndoWithTarget:self selector:@selector(_undoMoveNumberInStack:) object:[NSArray arrayWithObjects:[NSNumber numberWithInt:dest], [NSNumber numberWithInt:src], nil]];
	[_undoManager endUndoGrouping];
	
	SMNumber *number = [[_stack objectAtIndex:src] retain];
	[_stack removeObjectAtIndex:src];
	[_stack insertObject:number atIndex:dest];
	[number release];
}

- (void)_undoMoveNumberInStack:(NSArray *)args
{
	//	args = { NSNumber:fromIndex NSNumber:toIndex }	//	NOTE: fromIndex is the same as the toIndex when moveNumberInStackAtIndex:toIndex: was first called
	
	NSUInteger fromIndex, toIndex;
	fromIndex = [[args objectAtIndex:0] intValue];
	toIndex = [[args objectAtIndex:1] intValue];
	
	[_undoManager beginUndoGrouping];
	[_undoManager registerUndoWithTarget:self selector:@selector(_undoMoveNumberInStack:) object:[NSArray arrayWithObjects:[args objectAtIndex:1], [args objectAtIndex:0], nil]];	//	register the undo
	[_undoManager endUndoGrouping];
	
	SMNumber *number = [[_stack objectAtIndex:fromIndex] retain];
	[_stack removeObjectAtIndex:fromIndex];
	[_stack insertObject:number atIndex:toIndex];
	[number release];
	
	[_delegate rpnCalculator:self movedNumberInStackFromIndex:fromIndex toIndex:toIndex];	//	tell the delegate what happened since this was part of an undo/redo
}

- (NSInteger)countNumbersInStack
{
	return [_stack count];
}

- (void)clearAllNumbers
{
	[_undoManager beginUndoGrouping];
	[_undoManager registerUndoWithTarget:self selector:@selector(_undoClearAllNumbers:) object:[NSArray arrayWithArray:_stack]];	//	register the undo
	[_undoManager endUndoGrouping];
	
	[_stack removeAllObjects];
}

- (void)_undoClearAllNumbers:(NSArray *)stack
{
	int i = [stack count] - 1;
	for ( ; i >= 0; i-- )
	{
		SMNumber *number = [stack objectAtIndex:i];
		[_stack insertObject:number atIndex:0];						//	add # to stack
		[_delegate rpnCalculator:self addedNumberToStack:number];	//	notify delegate
	}
	
	[_undoManager beginUndoGrouping];
	[_undoManager registerUndoWithTarget:self selector:@selector(clearAllNumbers) object:nil];	//	register the undo
	[_undoManager endUndoGrouping];
}



#pragma mark Undo Management

/*	For true multithreading support, _undoing should not be a bool, but instead an atomic lock.  This way if someone tries to redo while undoing, the value for _undoing doesn't get #^(%@$ up.	*/

- (void)undo
{
	@synchronized(self)	//	synchronized to prevent multiple threads from trying to undo at the same time
	{
		_undoing = YES;
		[_undoManager undo];
		_undoing = NO;
	}
}

- (void)redo
{
	@synchronized(self)
	{
		_undoing = YES;
		[_undoManager redo];
		_undoing = NO;
	}
}

- (BOOL)canUndo
{
	return [_undoManager canUndo];
}

- (BOOL)canRedo
{
	return [_undoManager canRedo];
}


#pragma mark Properties

- (void)setNumberClass:(Class)aClass
{
	DebugLog(@"numberClass of RPNCalculator was set to: %@", aClass);
	[_undoManager removeAllActions];
	[self resetStack];
	_numberClass = aClass;
}


@end
