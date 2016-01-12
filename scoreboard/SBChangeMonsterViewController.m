//
//  SBChangeMonsterViewController.m
//  scoreboard
//
//  Created by James Campagno on 8/18/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "SBChangeMonsterViewController.h"
#import "AppDelegate.h"
#import <Masonry.h>

@interface SBChangeMonsterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIView *changeMonsterView;
@property (strong, nonatomic) NSArray *monsterNames;
@property (strong, nonatomic) UIButton *monsterOne;
@property (strong, nonatomic) UIButton *monsterTwo;
@property (strong, nonatomic) UIButton *monsterThree;
@property (strong, nonatomic) UIButton *monsterFour;
@property (strong, nonatomic) UIButton *monsterFive;
@property (strong, nonatomic) UIButton *monsterSix;
@property (strong, nonatomic) UITableView *tableView;

- (void)setupBlurredViewToContainMonsters;
- (void)setupLabel;
@end


static NSString *const kCellIdentifier = @"MonsterCell";
static const CGFloat SBChangeMVCWidthMultiplier = 0.8;
static const CGFloat SBChangeMVCHeightMultiplier = 0.7;
//static const CGFloat HeightOfMonsterButtonDivisor = 3;
//static const CGFloat WidthOfMonsterButtonDivisor = 0.5;

@implementation SBChangeMonsterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBlurredViewToContainMonsters];
    [self setupLabel];
    
    [self setupMonsterChoosingTableView];
}



#pragma mark - Action methods

- (void)monsterTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *title = button.currentTitle;
    [self.delegate userHasChangedToMonsterWithName:title];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupMonsterChoosingTableView {
    CGRect changeMonsterViewFrame = _changeMonsterView.frame;
    
    self.tableView = [[UITableView alloc] initWithFrame:changeMonsterViewFrame
                                                  style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.42 green:0.45 blue:0.47 alpha:0.97];

    [_tableView registerClass:[UITableViewCell class]
       forCellReuseIdentifier:kCellIdentifier];
    
    [_changeMonsterView addSubview:_tableView];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.left.and.right.equalTo(_changeMonsterView);
    }];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell.detailTextLabel.text) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:kCellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:0.42 green:0.45 blue:0.47 alpha:0.97];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    cell.textLabel.text = @"Jim Campagno";
    cell.detailTextLabel.text = @"Flatiron School";
    cell.imageView.image = [UIImage imageNamed:@"DRAKONIS_384"];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"Human";
}


#pragma mark - Setting up views

- (void)setupBlurredViewToContainMonsters {
//    self.view.backgroundColor = [UIColor colorWithRed:0.26 green:0.43 blue:0.56 alpha:0.9];
    self.view.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8];
    self.changeMonsterView = [[UIView alloc] init];
    self.changeMonsterView.backgroundColor = [UIColor colorWithRed:0.42 green:0.45 blue:0.47 alpha:0.97];
    [self.view addSubview:self.changeMonsterView];
    
    self.changeMonsterView.layer.borderColor = [UIColor blackColor].CGColor;
    self.changeMonsterView.layer.borderWidth = 0.6f;
    self.changeMonsterView.layer.cornerRadius = 10.0f;
    self.changeMonsterView.clipsToBounds = YES;
    
    [self.changeMonsterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(SBChangeMVCWidthMultiplier);
        make.height.equalTo(self.view).multipliedBy(SBChangeMVCHeightMultiplier);
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).multipliedBy(1.05);
    }];
}

//- (void)setupMonsterButtons {
//    NSInteger numberOfAvailableMonsters = [self.monsterNames count];
//    for (NSInteger i = 0; i < numberOfAvailableMonsters; ++i) {
//        
//        switch (i) {
//            case 0:
//                self.monsterOne = [self createMonsterButtonWithMonsterName:self.monsterNames[i]];
//                [self.view addSubview:self.monsterOne];
//                break;
//            case 1:
//                self.monsterTwo = [self createMonsterButtonWithMonsterName:self.monsterNames[i]];
//                [self.view addSubview:self.self.monsterTwo];
//                break;
//            case 2:
//                self.monsterThree = [self createMonsterButtonWithMonsterName:self.monsterNames[i]];
//                [self.view addSubview:self.self.monsterThree];
//                break;
//            case 3:
//                self.monsterFour = [self createMonsterButtonWithMonsterName:self.monsterNames[i]];
//                [self.view addSubview:self.monsterFour];
//                break;
//            case 4:
//                self.monsterFive = [self createMonsterButtonWithMonsterName:self.monsterNames[i]];
//                [self.view addSubview:self.monsterFive];
//                break;
//            case 5:
//                self.monsterSix = [self createMonsterButtonWithMonsterName:self.monsterNames[i]];
//                [self.view addSubview:self.monsterSix];
//                break;
//            default:
//                [NSException raise:NSInvalidArgumentException format:@"Array contains more than 6 monsters, this isn't correct.  Make sure the monsterName array contains 6 monsters."];
//                break;
//        }
//    }
//    [self setupConstraintsForMonsterButtons];
//}

- (void)setupLabel {
    UILabel *monsterLabel = [UILabel new];
    monsterLabel.textAlignment = NSTextAlignmentCenter;
    monsterLabel.text = @"CHOOSE YOUR MONSTER";
    [monsterLabel setFont:[UIFont systemFontOfSize:20]];
    monsterLabel.backgroundColor = [UIColor colorWithRed:0.42 green:0.45 blue:0.47 alpha:0.97];
    
    monsterLabel.layer.borderColor = [UIColor blackColor].CGColor;
    monsterLabel.layer.borderWidth = 0.6f;
    monsterLabel.layer.cornerRadius = 10.0f;
    monsterLabel.clipsToBounds = YES;
    monsterLabel.textColor = [UIColor colorWithRed:0.98 green:0.8 blue:0 alpha:1] ;
    
    monsterLabel.numberOfLines = 1;
    monsterLabel.adjustsFontSizeToFitWidth = YES;
    monsterLabel.lineBreakMode = NSLineBreakByClipping;
    
    [self.view addSubview:monsterLabel];
    
    [monsterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.changeMonsterView);
        make.bottom.equalTo(self.changeMonsterView.mas_top).with.offset(-2);
        make.centerX.equalTo(self.changeMonsterView);
        make.height.equalTo(@35);
    }];
    
    UIButton *goBackButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [goBackButton addTarget:self
                     action:@selector(goBackTapped:)
           forControlEvents:UIControlEventTouchUpInside];
    
    goBackButton.backgroundColor = [UIColor colorWithRed:0.42 green:0.45 blue:0.47 alpha:0.97];
    goBackButton.layer.borderColor = [UIColor blackColor].CGColor;
    goBackButton.layer.borderWidth = 0.6f;
    goBackButton.layer.cornerRadius = 10.0f;
    
    goBackButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [goBackButton setTitleColor:[UIColor colorWithRed:0.98 green:0.8 blue:0 alpha:1] forState:UIControlStateNormal];
    
    [goBackButton setTitle:@"GO BACK"
                  forState:UIControlStateNormal];
    
    goBackButton.titleLabel.numberOfLines = 1;
    goBackButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    goBackButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    [self.view addSubview:goBackButton];
    
    [goBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.changeMonsterView.mas_bottom).with.offset(2);
        make.right.equalTo(self.changeMonsterView);
        make.left.equalTo(self.changeMonsterView);
        make.height.equalTo(@35);
    }];
}


#pragma mark - Helper Methods

//- (UIButton *)createMonsterButtonWithMonsterName:(NSString *)monsterName {
//    UIButton *monsterButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    
//    [monsterButton addTarget:self
//                      action:@selector(monsterTapped:)
//            forControlEvents:UIControlEventTouchUpInside];
//
//    [monsterButton setTitle:monsterName
//                   forState:UIControlStateNormal];
//    [monsterButton setTitleColor:[UIColor clearColor]
//                        forState:UIControlStateNormal];
//    
//    UIImage *robMonster = [UIImage imageNamed:[NSString stringWithFormat:@"%@_384", monsterName]];
//    [monsterButton setBackgroundImage:robMonster
//                             forState:UIControlStateNormal];
//    return monsterButton;
//}

//- (void)setupConstraintsForMonsterButtons {
//    [self.monsterOne mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.changeMonsterView).multipliedBy(WidthOfMonsterButtonDivisor);
//        make.height.equalTo(self.changeMonsterView).dividedBy(HeightOfMonsterButtonDivisor);
//        make.top.and.left.equalTo(self.changeMonsterView);
//    }];
//    [self.monsterTwo mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.changeMonsterView).multipliedBy(WidthOfMonsterButtonDivisor);
//        make.height.equalTo(self.changeMonsterView).dividedBy(HeightOfMonsterButtonDivisor);
//        make.top.and.right.equalTo(self.changeMonsterView);
//    }];
//    [self.monsterThree mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.changeMonsterView).multipliedBy(WidthOfMonsterButtonDivisor);
//        make.height.equalTo(self.changeMonsterView).dividedBy(HeightOfMonsterButtonDivisor);
//        make.top.equalTo(self.monsterOne.mas_bottom);
//        make.left.equalTo(self.changeMonsterView);
//    }];
//    [self.monsterFour mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.changeMonsterView).multipliedBy(WidthOfMonsterButtonDivisor);
//        make.height.equalTo(self.changeMonsterView).dividedBy(HeightOfMonsterButtonDivisor);
//        make.top.equalTo(self.monsterTwo.mas_bottom);
//        make.right.equalTo(self.changeMonsterView);
//    }];
//    [self.monsterFive mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.changeMonsterView).multipliedBy(WidthOfMonsterButtonDivisor);
//        make.height.equalTo(self.changeMonsterView).dividedBy(HeightOfMonsterButtonDivisor);
//        make.bottom.and.left.equalTo(self.changeMonsterView);
//    }];
//    [self.monsterSix mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.changeMonsterView).multipliedBy(WidthOfMonsterButtonDivisor);
//        make.height.equalTo(self.changeMonsterView).dividedBy(HeightOfMonsterButtonDivisor);
//        make.bottom.and.right.equalTo(self.changeMonsterView);
//    }];
//}




#pragma mark - Action Methods

- (void)leaveGame {
    __block SBGameScreenViewController *presentingVC = (SBGameScreenViewController *)self.presentingViewController;
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 [presentingVC resetMethodHasBeenCalled];
                             }];
}

- (void)cancelTapped:(UIButton *)sender {
}

- (void)goBackTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Lazy Insatiation

- (NSArray *)monsterNames {
    if (!_monsterNames) {
        _monsterNames = @[@"CAPTAIN FISH", @"DRAKONIS", @"KONG", @"MANTIS", @"ROB", @"SHERIFF"];
    }
    return _monsterNames;
}



@end
