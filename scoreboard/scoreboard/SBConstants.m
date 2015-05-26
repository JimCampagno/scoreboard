//
//  SBConstants.m
//  scoreboard
//
//  Created by Jim Campagno on 5/25/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "SBConstants.h"

@implementation SBConstants

NSString *const FIREBASE_URL = @"https://boiling-heat-4798.firebaseio.com";
NSString *const FIREBASE_CHILD = @"rooms";
unsigned int const MIN_VALUE = 100000;
unsigned int const MAX_VALUE = 999999;

+ (NSString *)randomRoomNumber {
    NSString *random = [@(arc4random_uniform((MAX_VALUE - MIN_VALUE)) + MIN_VALUE) stringValue];
    return random;
}


@end
