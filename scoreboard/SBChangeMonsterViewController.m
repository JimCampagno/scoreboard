//
//  SBChangeMonsterViewController.m
//  scoreboard
//
//  Created by James Campagno on 8/18/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "SBChangeMonsterViewController.h"
#import <Masonry.h>

@interface SBChangeMonsterViewController ()
@property (strong, nonatomic) UIView *changeMonsterView;
@property (strong, nonatomic) NSArray *monsterNames;
@property (strong, nonatomic) NSArray *monsterButtons;

@property (strong, nonatomic) UIButton *monsterOne;
@property (strong, nonatomic) UIButton *monsterTwo;
@property (strong, nonatomic) UIButton *monsterThree;
@property (strong, nonatomic) UIButton *monsterFour;
@property (strong, nonatomic) UIButton *monsterFive;
@property (strong, nonatomic) UIButton *monsterSix;

- (void)setupBlurredViewToContainMonsters;
- (void)setupMonsterButtons;
- (UIButton *)createMonsterButtonWithMonsterName:(NSString *)monsterName;
- (void)setupConstraintsForMonsterButtons;

@end

static const CGFloat SBChangeMVCWidthMultiplier = 0.8;
static const CGFloat SBChangeMVCHeightMultiplier = 0.7;
static const CGFloat HeightOfMonsterButtonDivisor = 3;
static const CGFloat WidthOfMonsterButtonDivisor = 0.5;

@implementation SBChangeMonsterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBlurredViewToContainMonsters];
    [self setupMonsterButtons];
}

#pragma mark - Action methods

- (void)monsterTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *title = button.currentTitle;
    NSLog(@"%@ was tapped.", title);
}


#pragma mark - Setting up views

- (void)setupBlurredViewToContainMonsters {
    self.changeMonsterView = [[UIView alloc] init];
    self.changeMonsterView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6f];
    [self.view addSubview:self.changeMonsterView];
    
    [self.changeMonsterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(SBChangeMVCWidthMultiplier);
        make.height.equalTo(self.view).multipliedBy(SBChangeMVCHeightMultiplier);
        
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).multipliedBy(0.9);
    }];
}

- (void)setupMonsterButtons {
    NSInteger numberOfAvailableMonsters = [self.monsterNames count];
    for (NSInteger i = 0; i < numberOfAvailableMonsters; ++i) {
        
        switch (i) {
            case 0:
                self.monsterOne = [self createMonsterButtonWithMonsterName:self.monsterNames[i]];
                [self.view addSubview:self.monsterOne];
                break;
            case 1:
                self.monsterTwo = [self createMonsterButtonWithMonsterName:self.monsterNames[i]];
                [self.view addSubview:self.self.monsterTwo];
                break;
            case 2:
                self.monsterThree = [self createMonsterButtonWithMonsterName:self.monsterNames[i]];
                [self.view addSubview:self.self.monsterThree];
                break;
            case 3:
                self.monsterFour = [self createMonsterButtonWithMonsterName:self.monsterNames[i]];
                [self.view addSubview:self.monsterFour];
                break;
            case 4:
                self.monsterFive = [self createMonsterButtonWithMonsterName:self.monsterNames[i]];
                [self.view addSubview:self.monsterFive];
                break;
            case 5:
                self.monsterSix = [self createMonsterButtonWithMonsterName:self.monsterNames[i]];
                [self.view addSubview:self.monsterSix];
                break;
            default:
                [NSException raise:NSInvalidArgumentException format:@"Array contains more than 6 monsters, this isn't correct.  Make sure the monsterName array contains 6 monsters."];
                break;
        }
    }
    
    [self setupConstraintsForMonsterButtons];
}


#pragma mark - Helper Methods

- (UIButton *)createMonsterButtonWithMonsterName:(NSString *)monsterName {
    UIButton *monsterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [monsterButton addTarget:self
                      action:@selector(monsterTapped:)
            forControlEvents:UIControlEventTouchUpInside];
    
//    monsterButton.layer.borderColor = [[UIColor blueColor] colorWithAlphaComponent:0.1f].CGColor;
//    monsterButton.layer.borderWidth = 1.5f;
    
    [monsterButton setTitle:monsterName
                   forState:UIControlStateNormal];
    [monsterButton setTitleColor:[UIColor clearColor]
                        forState:UIControlStateNormal];
    
    UIImage *robMonster = [UIImage imageNamed:[NSString stringWithFormat:@"%@_384", monsterName]];
    
    [monsterButton setBackgroundImage:robMonster
                             forState:UIControlStateNormal];
    
    return monsterButton;
}

- (void)setupConstraintsForMonsterButtons {
    [self.monsterOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.changeMonsterView).multipliedBy(WidthOfMonsterButtonDivisor);
        make.height.equalTo(self.changeMonsterView).dividedBy(HeightOfMonsterButtonDivisor);
        make.top.and.left.equalTo(self.changeMonsterView);
    }];
    [self.monsterTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.changeMonsterView).multipliedBy(WidthOfMonsterButtonDivisor);
        make.height.equalTo(self.changeMonsterView).dividedBy(HeightOfMonsterButtonDivisor);
        make.top.and.right.equalTo(self.changeMonsterView);
    }];
    [self.monsterThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.changeMonsterView).multipliedBy(WidthOfMonsterButtonDivisor);
        make.height.equalTo(self.changeMonsterView).dividedBy(HeightOfMonsterButtonDivisor);
        make.top.equalTo(self.monsterOne.mas_bottom);
        make.left.equalTo(self.changeMonsterView);
    }];
    [self.monsterFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.changeMonsterView).multipliedBy(WidthOfMonsterButtonDivisor);
        make.height.equalTo(self.changeMonsterView).dividedBy(HeightOfMonsterButtonDivisor);
        make.top.equalTo(self.monsterTwo.mas_bottom);
        make.right.equalTo(self.changeMonsterView);
    }];
    [self.monsterFive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.changeMonsterView).multipliedBy(WidthOfMonsterButtonDivisor);
        make.height.equalTo(self.changeMonsterView).dividedBy(HeightOfMonsterButtonDivisor);
        make.bottom.and.left.equalTo(self.changeMonsterView);
    }];
    [self.monsterSix mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.changeMonsterView).multipliedBy(WidthOfMonsterButtonDivisor);
        make.height.equalTo(self.changeMonsterView).dividedBy(HeightOfMonsterButtonDivisor);
        make.bottom.and.right.equalTo(self.changeMonsterView);
    }];
}

#pragma mark - Lazy Insatiation

- (NSArray *)monsterNames {
    if (!_monsterNames) {
        _monsterNames = @[@"CAPTAIN FISH", @"DRAKONIS", @"KONG", @"MANTIS", @"ROB", @"SHERIFF"];
    }
    return _monsterNames;
}

- (NSArray *)monsterButtons {
    if (!_monsterButtons) {
        _monsterButtons = @[self.monsterOne, self.monsterTwo, self.monsterThree, self.monsterFour, self.monsterFive, self.monsterSix];
    }
    return _monsterButtons;
}

@end
