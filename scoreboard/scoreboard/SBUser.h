//
//  SBStagingUser.h
//  scoreboard
//
//  Created by Jim Campagno on 5/25/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBUser : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *monsterName;
@property (strong, nonatomic) NSNumber *hp;
@property (strong, nonatomic) NSNumber *vp;

- (instancetype)init;
- (instancetype)initWithName:(NSString *)name andMonsterName:(NSString *)monsterName;

@end