//
//  StackViewController.m
//  Precision RPN
//
//  Created by Justin Buchanan on 8/20/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import "StackViewController.h"
#import "Debug.h"






#define ROW_HEIGHT 29




@interface StackViewController (Private)

- (NSUInteger)_stackIndexForTableIndexPath:(NSIndexPath *)indexPath;

@end





@implementation StackViewController
@synthesize stack = _stack, delegate = _delegate;

- (id)initWithStack:(NSArray *)stack
{
    if ( self = [super initWithStyle:UITableViewStyleGrouped] )
	{
		_stack = [[NSMutableArray alloc] initWithArray:stack];
    }
    return self;
}


- (void)dealloc
{
	[_stack release];
    [super dealloc];
}


- (void)resetStack
{
	[_stack removeAllObjects];
	[self.tableView reloadData];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.tableView.rowHeight = ROW_HEIGHT;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	[self.tableView setEditing:YES animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return ( [_stack count] ) ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_stack count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellReuseID = @"ValueCell";
    
    ValueCell *valueCell = (ValueCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseID];
	if ( !valueCell )
		valueCell = [[[ValueCell alloc] initWithNumber:[_stack objectAtIndex:[self _stackIndexForTableIndexPath:indexPath]] reuseIdentifier:cellReuseID] autorelease];
	else
		valueCell.number = [_stack objectAtIndex:[self _stackIndexForTableIndexPath:indexPath]];
	
    return valueCell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	NSUInteger fromIndex = [self _stackIndexForTableIndexPath:fromIndexPath];
	NSUInteger toIndex = [self _stackIndexForTableIndexPath:toIndexPath];
	SMNumber *number = (SMNumber *)[_stack objectAtIndex:fromIndex];
	[_stack removeObjectAtIndex:fromIndex];
	[_stack insertObject:number atIndex:toIndex];
	
	[_delegate stackViewController:self movedNumberAtIndex:fromIndex toIndex:toIndex];	//	notify delegate of the move
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



#pragma mark Manipulating the stack

- (NSIndexPath *)_indexPathForNumberAtIndex:(NSUInteger)index
{
	NSUInteger row = [_stack count] - (index + 1);
	return [NSIndexPath indexPathForRow:row inSection:0];
}

- (NSUInteger)_stackIndexForTableIndexPath:(NSIndexPath *)indexPath
{
	return [_stack count] - (indexPath.row + 1);
}

- (void)moveNumberInStackFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex animated:(BOOL)animated
{
	DebugLog(@"StackViewController was told to move number from index %u to index %u", fromIndex, toIndex);
	
	SMNumber *number = [_stack objectAtIndex:fromIndex];
	[_stack removeObjectAtIndex:fromIndex];
	[_stack insertObject:number atIndex:toIndex];
	
	UITableView *tableView = self.tableView;
	[tableView beginUpdates];
	NSIndexPath *from = [self _indexPathForNumberAtIndex:fromIndex];
	NSIndexPath *to = [self _indexPathForNumberAtIndex:toIndex];
	
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:from] withRowAnimation:(animated) ? UITableViewRowAnimationRight : UITableViewRowAnimationNone];
	[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:to] withRowAnimation:(animated) ? UITableViewRowAnimationRight : UITableViewRowAnimationNone];
	[tableView endUpdates];
}

- (void)addNumberToStack:(SMNumber *)number animated:(BOOL)animated
{
	[self insertNumber:number intoStackAtIndex:0 animated:animated];
}

- (void)dropNumberFromStackAnimated:(BOOL)animated
{
	DebugLog(@"StackViewController was told to drop number");
	if ( [_stack count] )	//	make sure there's still something in the stack to drop
	{
		[self deleteNumberFromStackAtIndex:0 animated:animated];
	}
}


- (void)deleteNumberFromStackAtIndex:(NSUInteger)index animated:(BOOL)animated
{
	DebugLog(@"StackViewController was told to delete @ index: %u", index);
	
	UITableView *tableView = self.tableView;
	/*	update the view		*/
	UITableViewRowAnimation animation = (animated) ? UITableViewRowAnimationRight : UITableViewRowAnimationNone;
	[tableView beginUpdates];
	
	if ( [_stack count] > 1 )
	{
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[self _indexPathForNumberAtIndex:index]] withRowAnimation:animation];
	}
	else
	{
		[tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:animation];
	}
	
	[_stack removeObjectAtIndex:index];	//	update the stack
	
	[tableView endUpdates];
}

- (void)insertNumber:(SMNumber *)number intoStackAtIndex:(NSUInteger)index animated:(BOOL)animated
{
	DebugLog(@"StackViewController was told to insertNumber: %@ intoStackAtIndex: %u", number, index);
	
	UITableView *tableView = self.tableView;
	[_stack insertObject:number atIndex:index];	//	update the model
	
	/*	update the view		*/
	UITableViewRowAnimation animation = (animated) ? UITableViewRowAnimationLeft : UITableViewRowAnimationNone;
	[tableView beginUpdates];
	NSIndexPath *indexPath = [self _indexPathForNumberAtIndex:index];
	
	if ( [_stack count] == 1 )
		[tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:animation];
	else
		[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:animation];
	
	[tableView endUpdates];
	
	[self performSelector:@selector(_scrollToLastNumber) withObject:nil afterDelay:.1];
}

- (void)clearNumbersAnimated:(BOOL)animated
{
	UITableView *tableView = self.tableView;
	UITableViewRowAnimation animation = (animated) ? UITableViewRowAnimationRight : UITableViewRowAnimationNone;
	[tableView beginUpdates];
	
	
	DebugLog(@"before clearing, the stack in the vc = %@", self.stack);
	
	if ( [_stack count] )
	{
		[tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:animation];
	}
	[_stack removeAllObjects];	//	delete everything in the stack
	
	DebugLog(@"after clearing, the stack in the vc = %@", self.stack);
	
	[tableView endUpdates];
}

- (void)_scrollToLastNumber
{
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_stack count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

@end

