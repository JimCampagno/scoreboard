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
        NSString *nameOfImage = [NSString stringWithFormat:@"%@_384", monsterName];
        _monsterImage = [UIImage imageNamed:nameOfImage];
    }
    
    return self;
}

- (BOOL)didAttributesChangeWithUserOnServer:(SBUser *)user {
    BOOL nameIsEqual = [self.name isEqualToString:user.name];
    BOOL monsterNameIsEqual = [self.monster isEqualToString:user.monster];
    BOOL hpIsEqual = [self.hp integerValue] == [user.hp integerValue];
    BOOL vpIsEqual = [self.vp integerValue] == [user.vp integerValue];
    
    return !(nameIsEqual && monsterNameIsEqual && hpIsEqual && vpIsEqual);
}

- (void)updateAttributesToMatchUser:(SBUser *)user {
    self.name = user.name;
    self.monster = user.monster;
    self.hp = user.hp;
    self.vp = user.vp;
    
    NSString *nameOfImage = [NSString stringWithFormat:@"%@_384", self.monster];
    self.monsterImage = [UIImage imageNamed:nameOfImage];
}


@end
