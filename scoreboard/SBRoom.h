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

@property (strong, nonatomic) NSMutableArray *users; //of SBUsers

- (instancetype)initWithUser:(SBUser *)user;
+ (SBRoom *)createRoomWithData:(FDataSnapshot *)data;


@end
