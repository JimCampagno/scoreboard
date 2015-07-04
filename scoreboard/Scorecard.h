//
//  Scorecard.h
//  scoreboard
//
//  Created by Jim Campagno on 6/14/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScorecardProtocol <NSObject>

- (void)didScoreVictoryPointsTotalling:(NSInteger)vp;
- (void)didTakeDamageTotalling:(NSInteger)hp;
- (void)damageHasReachedZero;
- (BOOL)allowChangingOfHealthAndVictoryPoints;

@end


@interface Scorecard : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *monsterName;
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UIImageView *monsterImage;

//topPicker is Victory Points
@property (weak, nonatomic) IBOutlet UIPickerView *topPicker;
//bottomPicker is Health Points
@property (weak, nonatomic) IBOutlet UIPickerView *bottomPicker;

@property (strong, nonatomic) NSArray *health;
@property (strong, nonatomic) NSArray *victoryPoints;

@property (strong, nonatomic) id <ScorecardProtocol> delegate;

@property (strong, nonatomic) NSMutableArray *customSBConstraints;


- (void)setupScorecardWithMonsterName:(NSString *)monsterName
                           playerName:(NSString *)playerName
                         monsterImage:(UIImage *)image;


@end
