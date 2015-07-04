//
//  SBConstants.h
//  scoreboard
//
//  Created by Jim Campagno on 5/25/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBConstants : NSObject

extern NSString *const FIREBASE_URL;
extern NSString *const FIREBASE_CHILD;
extern unsigned int const MIN_VALUE;
extern unsigned int const MAX_VALUE;

+ (NSString *)randomRoomNumber;
+ (NSString *)randomMonsterName;

@end