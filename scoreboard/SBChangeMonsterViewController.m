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
@property (strong, nonatomic) NSDictionary *allVersions;
@property (strong, nonatomic) NSSortDescriptor *sortDescriptor;
@property (strong, nonatomic) NSArray *sortedVersionNames;
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


@implementation SBChangeMonsterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sortedVersionNames = @[ @"King of Tokyo", @"King of New York", @"King of Tokyo: Halloween", @"King of Tokyo: Power Up!" ];
    
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
    
    NSString *nameOfSection = self.sortedVersionNames[section];
    NSArray *monstersInSection = self.allVersions[nameOfSection];
    return monstersInSection.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *versionName = self.sortedVersionNames[indexPath.section];
    NSArray *monstersInVersion = self.allVersions[versionName];
    NSString *monsterName = monstersInVersion[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell.detailTextLabel.text) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:kCellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:0.42 green:0.45 blue:0.47 alpha:0.97];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    cell.textLabel.text = monsterName;
    //    cell.detailTextLabel.text = versionName;
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    //    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_384", monsterName]];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.allVersions.allKeys.count;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *versionName = self.sortedVersionNames[section];
    return versionName;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *versionName = self.sortedVersionNames[indexPath.section];
    NSArray *monstersInVersion = self.allVersions[versionName];
    NSString *monsterName = monstersInVersion[indexPath.row];
    [self.delegate userHasChangedToMonsterWithName:[monsterName copy]];
    
    [self dismissViewControllerAnimated:YES completion:^{
       
    }];
    
    
    
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

- (NSDictionary *)allVersions {
    
    if (!_allVersions) {
        
        NSArray *kingOfNewYork = @[@"CAPTAIN FISH", @"DRAKONIS", @"KONG", @"MANTIS", @"ROB", @"SHERIFF"];
        NSArray *kingOfTokyo = @[@"ALIENOID", @"CYBER BUNNY", @"GIGAZAUR", @"KRAKEN", @"MEKA DRAGON", @"THE KING"];
        NSArray *kingOfTokyoHalloween = @[@"BOOGIE WOOGIE", @"PUMPKIN JACK"];
        NSArray *kingOfTokyoPowerUp = @[@"PANDAKAI"];
        
        _allVersions = @{ @"King of Tokyo": kingOfTokyo,
                          @"King of New York": kingOfNewYork,
                          @"King of Tokyo: Halloween": kingOfTokyoHalloween,
                          @"King of Tokyo: Power Up!": kingOfTokyoPowerUp };
        
    }
    
    return _allVersions;
}



@end
