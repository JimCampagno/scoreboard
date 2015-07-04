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

- (instancetype)init {
    
    return [self initWithUser:nil];
}

- (instancetype)initWithUser:(SBUser *)user {
    
    self = [super init];
    
    if (self) {
        
        [self.users addObject:user];
    }
    
    return self;
}

- (void)addUser:(SBUser *)user {
    
    [self.users addObject:user];
}

- (void)addArrayOfUsers:(NSArray *)stagingUsers {
    
    for (SBUser *user in stagingUsers) {
        
        [self.users addObject:user];
    }
}

+ (NSArray *)createRoomWithRoom:(SBRoom *)room {
    
    NSArray *result = [[NSArray alloc] init];
    
    SBUser *currentUser = [[SBUser alloc] init];
    currentUser = room.users[0];
    
    result = @[ @{ @"name": currentUser.name,
                   @"monster": currentUser.monster,
                   @"hp": currentUser.hp,
                   @"vp": currentUser.vp } ];
    
    return result;
    
}

+ (NSArray *)createRoomWithData:(FDataSnapshot *)data {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSDictionary *person in data.value) {
        
        SBUser *currentPerson = [[SBUser alloc] initWithName:person[@"name"]
                                                 monsterName:person[@"monster"]
                                                          hp:person[@"hp"]
                                                          vp:person[@"vp"]];
        
        [result addObject:currentPerson];
    }
    
    NSArray *completeRoom = [result copy];
    
    return completeRoom;
    
}

- (NSMutableArray *)users {
    
    if (!_users) {
        _users = [[NSMutableArray alloc] init];
    }
    return _users;
}


@end
