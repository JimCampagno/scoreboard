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

+ (NSArray *)createRoomWithData:(SBRoom *)data {
    
    NSArray *result = [[NSArray alloc] init];
    
    SBUser *currentUser = [[SBUser alloc] init];
    currentUser = data.users[0];
    
    result = @[ @{ @"name": currentUser.name,
                   @"monster": currentUser.monster,
                   @"hp": currentUser.hp,
                   @"vp": currentUser.vp } ];
    
    return result;
    
}

- (NSMutableArray *)users {
    
    if (!_users) {
        _users = [[NSMutableArray alloc] init];
    }
    return _users;
}


@end
