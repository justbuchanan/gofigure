/*
 *  Debug.h
 *
 *  Created by Justin Buchanan on 4/27/09.
 *  Copyright 2009 JustBuchanan Software. All rights reserved.
 *
 */

//#define DEBUG		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef DEBUG
	#define DebugLog(...) NSLog(__VA_ARGS__)
#else
	#define DebugLog(...) //
#endif
