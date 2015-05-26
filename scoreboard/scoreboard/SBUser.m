//
//  SBStagingUser.m
//  scoreboard
//
//  Created by Jim Campagno on 5/25/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "SBUser.h"

@implementation SBUser

- (instancetype)init {
    
    return [self initWithName:@""];
}

- (instancetype)initWithName:(NSString *)name;
 {
    self = [super init];
    
    if (self) {
        
        self.name = name;
        self.monster = @"BIG BAD DAD!";
        self.hp = @10;
        self.vp = @0;
    }
    
    return self;
}

@end
