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
    
    return [self initWithName:@"" andMonsterName:@""];
}

- (instancetype)initWithName:(NSString *)name andMonsterName:(NSString *)monsterName {
    
    self = [super init];
    
    if (self) {
        
        self.name = name;
        self.monsterName = monsterName;
        self.hp = @10;
        self.vp = @0;
    }
    
    return self;
}

@end
