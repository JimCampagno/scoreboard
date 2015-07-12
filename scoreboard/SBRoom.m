//
//  SBRoom.m
//  scoreboard
//
//  Created by Jim Campagno on 5/25/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "SBRoom.h"
#import "SBConstants.h"

@implementation SBRoom


- (instancetype)initWithUser:(SBUser *)user {
    
    self = [super init];
    
    if (self) {
        
        [self.users addObject:user];
    }
    
    return self;
}

+ (SBRoom *)createRoomWithData:(FDataSnapshot *)data {
    
    SBRoom *newRoom = [[SBRoom alloc] init];
    
    for (FDataSnapshot* child in data.children) {
                
        NSDictionary *person = child.value;

        SBUser *currentPerson = [[SBUser alloc] initWithName:person[@"name"]
                                                 monsterName:person[@"monster"]
                                                          hp:person[@"hp"]
                                                          vp:person[@"vp"]];
        
        [newRoom.users addObject:currentPerson];
    }
    
    return newRoom;
}

- (NSMutableArray *)users {
    
    if (!_users) {
        _users = [[NSMutableArray alloc] init];
    }
    return _users;
}

@end
