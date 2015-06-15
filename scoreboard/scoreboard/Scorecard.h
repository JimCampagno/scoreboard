//
//  Scorecard.h
//  scoreboard
//
//  Created by Jim Campagno on 6/14/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Scorecard : UIView

@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UILabel *monsterName;
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UIImageView *monsterImage;
@property (weak, nonatomic) IBOutlet UIPickerView *topPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *bottomPicker;

@property (strong, nonatomic) NSMutableArray *customSBConstraints;
//@property (strong, nonatomic) UIView *containerView;


@end
