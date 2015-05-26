//
//  SBRoom.h
//  scoreboard
//
//  Created by Jim Campagno on 5/25/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBUser.h"

@interface SBRoom : NSObject

@property (strong, nonatomic) NSString *roomNumber;
@property (strong, nonatomic) NSMutableArray *users;

- (instancetype)init;
- (instancetype)initWithUser:(SBUser *)user;

- (void)addUser:(SBUser *)user;
- (void)addArrayOfUsers:(NSArray *)users;

+ (NSDictionary *)createRoomWithData:(SBRoom *)data;




// Room#, staging users, string of all the monsters.
// Room object, stagingUser is another object with a name & a monster name. an array of stagins uers, and an array of unused monsters - "monsters" of your array of monster.  "stagingUsers"

@end
