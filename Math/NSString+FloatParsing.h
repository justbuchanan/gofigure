//
//  NSString+FloatParsing.h
//  Precision RPN
//
//  Created by Justin Buchanan on 8/28/09.
//  Copyright 2009 JustBuchanan Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Decimal.h"

/*	The parser ignores any non-number characters except decimal
 *	points, minus signs, and the letter E for scientific notation.
 */
@interface NSString (FloatParsing)

- (Decimal)parseDecimalInRange:(NSRange)range;

@end



/*	Note: superscripts aren't valid
*/
BOOL CharacterIsNumber(unichar character);

unichar CharacterFromNumber(short number);
unichar SuperscriptCharacterFromNumber(short number);

#define CHARACTER_NOT_VALID_NUMBER -1
short NumberFromCharacter(unichar character);


