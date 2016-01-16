//
//  SBStagingUser.h
//  scoreboard
//
//  Created by Jim Campagno on 5/25/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SBUser : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *monster;
@property (strong, nonatomic) NSNumber *hp;
@property (strong, nonatomic) NSNumber *vp;
@property (strong, nonatomic) UIImage *monsterImage;
@property (strong, nonatomic) NSString *key;

- (instancetype)init;
- (instancetype)initWithName:(NSString *)name
                 monsterName:(NSString *)monsterName
                          hp:(NSNumber *)hp
                          vp:(NSNumber *)vp;

- (BOOL)didAttributesChangeWithUserOnServer:(SBUser *)user;
- (void)updateAttributesToMatchUser:(SBUser *)user;

@end