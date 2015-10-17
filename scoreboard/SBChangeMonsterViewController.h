//
//  SBChangeMonsterViewController.h
//  scoreboard
//
//  Created by James Campagno on 8/18/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBGameScreenViewController.h"

@interface SBChangeMonsterViewController : UIViewController

@property (nonatomic, strong) NSString *roomID;
@property (weak, nonatomic) id <MonsterChangeDelegate> delegate;

@end
