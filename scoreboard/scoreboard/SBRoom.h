//
//  SBRoom.h
//  scoreboard
//
//  Created by Jim Campagno on 5/25/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#import "SBUser.h"

@interface SBRoom : NSObject

@property (strong, nonatomic) NSMutableArray *users;

- (instancetype)init;
- (instancetype)initWithUser:(SBUser *)user;
- (void)addUser:(SBUser *)user;
- (void)addArrayOfUsers:(NSArray *)users;
+ (NSArray *)createRoomWithData:(FDataSnapshot *)data;

@end
