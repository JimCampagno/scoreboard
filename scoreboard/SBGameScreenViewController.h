//
//  SBGameScreenViewController.h
//  scoreboard
//
//  Created by James Campagno on 6/6/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "SBRoom.h"


@protocol MonsterChangeDelegate <NSObject>
- (void)userHasChangedToMonsterWithName:(NSString *)name;
@end


@interface SBGameScreenViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate, MonsterChangeDelegate>

@property (strong, nonatomic) Firebase *ref;
@property (strong, nonatomic) NSString *roomDigits;
@property (strong, nonatomic) SBUser *currentPlayer;
@property (strong, nonatomic) NSString *IDOfCurrentPlayer;
@property (strong, nonatomic) NSString *randomMonsterName;
@property (strong, nonatomic) NSString *currentPlayerName;

- (void)resetGame;
@end