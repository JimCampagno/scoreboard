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
    
    return [self initWithName:@"" monsterName:@"" hp:@0 vp:@0];
}

- (instancetype)initWithName:(NSString *)name
                 monsterName:(NSString *)monsterName
                          hp:(NSNumber *)hp
                          vp:(NSNumber *)vp {
    self = [super init];
    
    if (self) {
        
        _name = name;
        _monster = monsterName;
        _hp = hp;
        _vp = vp;
    }
    
    return self;
}

@end
