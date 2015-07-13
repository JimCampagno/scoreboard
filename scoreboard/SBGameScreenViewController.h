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

@interface SBGameScreenViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) Firebase *ref;
@property (strong, nonatomic) NSString *roomDigits;
@property (strong, nonatomic) SBUser *currentPlayer;

@end