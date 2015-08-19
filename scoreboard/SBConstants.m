//
//  SBConstants.m
//  scoreboard
//
//  Created by Jim Campagno on 5/25/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "SBConstants.h"

@implementation SBConstants

NSString *const FIREBASE_URL = @"https://boiling-heat-4798.firebaseio.com/rooms";
NSString *const FIREBASE_CHILD = @"rooms";
unsigned int const MIN_VALUE = 100000;
unsigned int const MAX_VALUE = 999999;

+ (NSString *)randomRoomNumber {
    NSString *random = [@(arc4random_uniform((MAX_VALUE - MIN_VALUE)) + MIN_VALUE) stringValue];
    return random;
}

+ (NSString *)randomMonsterName {
    NSArray *monsterNames = @[@"CAPTAIN FISH", @"DRAKONIS", @"KONG", @"MANTIS", @"ROB", @"SHERIFF"];
    NSString *monster = monsterNames[arc4random_uniform((uint32_t)[monsterNames count])];
    return monster;
}

@end