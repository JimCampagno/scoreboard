//
//  SBGameScreenViewController.m
//  scoreboard
//
//  Created by James Campagno on 6/6/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "SBGameScreenViewController.h"
#import "Scorecard.h"
#import "SBUser.h"

@interface SBGameScreenViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainMonsterView;

@property (weak, nonatomic) IBOutlet Scorecard *player1;
@property (weak, nonatomic) IBOutlet Scorecard *player2;
@property (weak, nonatomic) IBOutlet Scorecard *player3;
@property (weak, nonatomic) IBOutlet Scorecard *player4;
@property (weak, nonatomic) IBOutlet Scorecard *player5;
@property (weak, nonatomic) IBOutlet Scorecard *player6;

@property (strong, nonatomic) NSArray *playerScorecards;
@property (strong, nonatomic) NSArray *pickerData;

@end

@implementation SBGameScreenViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupStartingHealthAndVictoryPoints];
    
    [self setupScorecardWithUsersInfo];
    
    
    
    
    
}

- (void)setupScorecardWithUsersInfo {
    
    
    for (NSInteger i = 0 ; i < [self.usersInTheRoom count] ; i++) {
        
        SBUser *user = self.usersInTheRoom[i];
        
        switch (i+1) {
            case 1:
                [self.player1 setupScorecardWithMonsterName:user.monster
                                                 playerName:user.name
                                               monsterImage:user.monsterImage];
                break;
                
            case 2:
                [self.player2 setupScorecardWithMonsterName:user.monster
                                                 playerName:user.name
                                               monsterImage:user.monsterImage];
                break;
                
            case 3:
                [self.player3 setupScorecardWithMonsterName:user.monster
                                                 playerName:user.name
                                               monsterImage:user.monsterImage];
                break;
                
            case 4:
                [self.player4 setupScorecardWithMonsterName:user.monster
                                                 playerName:user.name
                                               monsterImage:user.monsterImage];
                break;
                
            case 5:
                [self.player5 setupScorecardWithMonsterName:user.monster
                                                 playerName:user.name
                                               monsterImage:user.monsterImage];
                break;
                
            case 6:
                [self.player6 setupScorecardWithMonsterName:user.monster
                                                 playerName:user.name
                                               monsterImage:user.monsterImage];
                break;
                
            default:
                break;
        }
    }
    
    [self hideUnusedScorecards];
    
}

- (void)hideUnusedScorecards {
    
    if ([self.usersInTheRoom count] < 6) {
        
        for (NSInteger j = 6 ; j > [self.usersInTheRoom count] ; j--) {
            
            switch (j) {
                case 6:
                    self.player6.hidden = YES;
                    break;
                    
                case 5:
                    self.player5.hidden = YES;
                    break;
                    
                case 4:
                    self.player4.hidden = YES;
                    break;
                    
                case 3:
                    self.player3.hidden = YES;
                    break;
                    
                case 2:
                    self.player2.hidden = YES;
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (NSArray *)playerScorecards {
    
    if (!_playerScorecards) {
        _playerScorecards = @[self.player1, self.player2, self.player3, self.player4, self.player5, self.player6];
    }
    return _playerScorecards;
}


- (void)setupStartingHealthAndVictoryPoints {
    
    for (Scorecard *scorecard in self.playerScorecards) {
        
        [scorecard.bottomPicker selectRow:10 inComponent:0 animated:YES];
        [scorecard.topPicker selectRow:0 inComponent:0 animated:YES];
    }
}

//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//
//    return 1;
//}
//
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//
//
//    return [self.pickerData count];
//}


//- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//
//    [[pickerView.subviews objectAtIndex:1] setBackgroundColor:[UIColor blueColor]];
//    [[pickerView.subviews objectAtIndex:2] setBackgroundColor:[UIColor blueColor]];
//
//    return self.pickerData[row];
//}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    NSString *title = self.pickerData[row];
//    NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:title
//                                                                   attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
//
//    [[pickerView.subviews objectAtIndex:1] setBackgroundColor:[UIColor redColor]];
//    [[pickerView.subviews objectAtIndex:2] setBackgroundColor:[UIColor redColor]];
//
//    return attTitle;
//
//}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//
//    [[pickerView.subviews objectAtIndex:1] setBackgroundColor:[UIColor blueColor]];
//    [[pickerView.subviews objectAtIndex:2] setBackgroundColor:[UIColor blueColor]];
//
//
//}




//- (NSArray *)pickerData {
//
//    if (!_pickerData) {
//
//        _pickerData = [[NSArray alloc] init];
//
//        NSMutableArray *holdingData = [[NSMutableArray alloc] init];
//
//        for (NSInteger i = 0 ; i < 21 ; i++) {
//
//            [holdingData addObject:[NSString stringWithFormat:@"%ld", i]];
//        }
//
//        _pickerData = [holdingData copy];
//    }
//
//    return _pickerData;
//}

-(void)viewDidAppear:(BOOL)animated {
    
    
    //    CGFloat widthJ = CGRectGetWidth(self.player2.bounds);
    //    CGFloat heightJ = CGRectGetHeight(self.player2.bounds);
    //        NSLog(@"The width is : %f and the height is %f", widthJ, heightJ);
    //
    //
    //
    //
    //    //    NSLog(@"The width is : %f and the height is %f", width, height);
    //    Scorecard *playerTwoStuff =[[Scorecard alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    //    self.player2.translatesAutoresizingMaskIntoConstraints = NO;
    //
    //    [self.player2 addSubview:playerTwoStuff];
    //
    //    [self.player2 setNeedsUpdateConstraints];
    
    
    
    //
    //    CGFloat width = CGRectGetWidth(self.mainMonsterView.bounds);
    //    CGFloat height = CGRectGetHeight(self.mainMonsterView.bounds);
    //    //    NSLog(@"The width is : %f and the height is %f", width, height);
    //    UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(0,height/6,height/1.5,height/1.5)];
    //    dot.backgroundColor = [UIColor blackColor];
    //    [self.mainMonsterView addSubview:dot];
    //
    //
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, height/1.5, height/6)];
    //    label.backgroundColor = [UIColor blueColor];
    //    label.textAlignment = NSTextAlignmentCenter;
    //    label.textColor = [UIColor whiteColor];
    //    label.numberOfLines = 0;
    //    label.text = @"TOP";
    //    [self.mainMonsterView addSubview:label];
    //
    //
    //    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height-(height/6), height/1.5, height/6)];
    //    bottomLabel.backgroundColor = [UIColor greenColor];
    //    bottomLabel.textAlignment = NSTextAlignmentCenter;
    //    bottomLabel.textColor = [UIColor blackColor];
    //    bottomLabel.numberOfLines = 0;
    //    bottomLabel.text = @"BOTTOM";
    //    [self.mainMonsterView addSubview:bottomLabel];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)usersInTheRoom {
    
    if (!_usersInTheRoom) {
        
        _usersInTheRoom = [[NSArray alloc] init];
    }
    return _usersInTheRoom;
}




@end
