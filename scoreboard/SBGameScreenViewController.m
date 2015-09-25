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
#import "SBHeartScene.h"
#import "SBStarScene.h"
#import "SBSetupViewController.h"

#import <Masonry.h>


@interface SBGameScreenViewController ()

//Main Player Card
@property (weak, nonatomic) IBOutlet UIView *mainMonsterView; // <-- being used?
@property (weak, nonatomic) IBOutlet UILabel *monsterName;
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UIImageView *monsterImage;
@property (weak, nonatomic) IBOutlet UIPickerView *victoryPoints;
@property (weak, nonatomic) IBOutlet UIPickerView *healthPoints;
@property (strong, nonatomic) NSMutableArray *vpPointsOnPicker;
@property (strong, nonatomic) NSMutableArray *hpPointsOnPicker;
@property (weak, nonatomic) IBOutlet SKView *mainHeartParticleView;
@property (weak, nonatomic) IBOutlet SKView *mainStarParticleView;
@property (nonatomic, strong) SBHeartScene *mainHeartScene;
@property (nonatomic, strong) SBStarScene *mainStarScene;


//All other player cards (including main)
@property (weak, nonatomic) IBOutlet Scorecard *player1;
@property (weak, nonatomic) IBOutlet Scorecard *player2;
@property (weak, nonatomic) IBOutlet Scorecard *player3;
@property (weak, nonatomic) IBOutlet Scorecard *player4;
@property (weak, nonatomic) IBOutlet Scorecard *player5;
@property (weak, nonatomic) IBOutlet Scorecard *player6;

@property (strong, nonatomic) NSArray *playerScorecards;
@property (strong, nonatomic) NSArray *pickerData;
@property (strong, nonatomic) SBRoom *room;

@property (strong, nonatomic) Firebase *currentPlayerRef;


- (void)setupMainPlayerScorecard;
@end

static const NSTimeInterval kLengthOfMainHeartScene = 0.7;
static const NSTimeInterval kLengthOfMainStarScene = 0.7;

@implementation SBGameScreenViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.room = [[SBRoom alloc] init];
    [self setupPickerViewsDelegateAndDataSource];
    [self setupListenerToEntireRoomOnFirebase];
    [self setupCurrentPlayerReferenceToFirebase];
    [self setupMainPlayerScorecard];
    [self setupSettingsButton];
    //    [self generateTestData];
    
}

//- (void)generateTestData {
//    NSArray *monsterNames = @[@"CAPTAIN FISH", @"DRAKONIS", @"KONG", @"MANTIS", @"ROB", @"SHERIFF"];
//    for (NSInteger i = 0 ; i < 6 ; i++) {
//
//
//        SBUser *currentPerson = [[SBUser alloc] initWithName:@"CoolGuy"
//                                                 monsterName:monsterNames[i]
//                                                          hp:@8
//                                                          vp:@9];
//
//        [self.room.users addObject:currentPerson];
//
//    }
//
//    self.playerName.text = @"JIMBO";
//    [self setupScorecardWithUsersInfo];
//}

- (void)userHasChangedToMonsterWithName:(NSString *)name {
    NSDictionary *monsterNameChange = @{@"monster": name};
    self.monsterImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_384", name]];
    
    self.monsterName.text = name;
    
    [self.currentPlayerRef updateChildValues:monsterNameChange
                         withCompletionBlock:^(NSError *error, Firebase *ref) {
                             
                             if (error) {
                        
                             } else {
                                 
                             }
                         }];
}

- (void)setupCurrentPlayerReferenceToFirebase {
    self.currentPlayerRef = [[self.ref childByAppendingPath: self.roomDigits] childByAppendingPath:self.IDOfCurrentPlayer];
    [self.currentPlayerRef onDisconnectRemoveValue];
}

- (void)setupMainPlayerScorecard {
    self.monsterImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_384", self.currentPlayer.monster]];
    self.monsterName.text = self.currentPlayer.monster;
    self.playerName.text = self.currentPlayer.name;
    [self.healthPoints selectRow:[self.currentPlayer.hp integerValue] inComponent:0 animated:YES];
    [self.victoryPoints selectRow:[self.currentPlayer.vp integerValue] inComponent:0 animated:YES];
    
    [self setupMainHeartParticleView];
    [self setupMainStarParticleView];
}

- (void)setupMainHeartParticleView {
    self.mainHeartParticleView.allowsTransparency = YES;
    self.mainHeartParticleView.backgroundColor = [UIColor clearColor];
    self.mainHeartScene = [SBHeartScene sceneWithSize:self.mainHeartParticleView.bounds.size];
    self.mainHeartScene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self.mainHeartParticleView presentScene:self.mainHeartScene];
    [self.mainHeartScene runHearts];
    [self.mainHeartScene pauseHearts];
    [self.mainHeartScene.heart setParticleSize:CGSizeMake(300, 300)];
    [self.mainHeartScene.heart setParticlePositionRange:CGVectorMake(50, 50)];
}

- (void)setupMainStarParticleView {
    self.mainStarParticleView.allowsTransparency = YES;
    self.mainStarParticleView.backgroundColor = [UIColor clearColor];
    self.mainStarScene = [SBStarScene sceneWithSize:self.mainStarParticleView.bounds.size];
    self.mainStarScene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self.mainStarParticleView presentScene:self.mainStarScene];
    [self.mainStarScene runStars];
    [self.mainStarScene pauseStars];
    [self.mainStarScene.star setParticleSize:CGSizeMake(300, 300)];
    [self.mainStarScene.star setParticlePositionRange:CGVectorMake(50, 50)];
}


- (void)setupListenerToEntireRoomOnFirebase {
    __weak typeof(self) tmpself = self;
    [[self.ref childByAppendingPath:self.roomDigits]

     observeEventType:FEventTypeValue
     withBlock:^(FDataSnapshot *snapshot) {

         BOOL numberOfPlayersChanged = [tmpself.room.users count] != snapshot.childrenCount ? YES : NO;
         
         if (numberOfPlayersChanged) {
             tmpself.room = [SBRoom createRoomWithData:snapshot];
             [tmpself setupScorecardWithUsersInfo];
         } else {
             SBRoom *changedRoom = [SBRoom createRoomWithData:snapshot];
             [tmpself updateScoresWithRoom:changedRoom];
         }
     } withCancelBlock:^(NSError *error) {
         //Still should do something here.
         NSLog(@"ERROR: %@", error.description);
     }];
}


- (void)updateScoresWithRoom:(SBRoom *)room {
    for (NSInteger i = 0 ; i < [self.room.users count] ; i++) {
        SBUser *currentUser = self.room.users[i];
        SBUser *userOnServer = room.users[i];
        
        if ([currentUser didAttributesChangeWithUserOnServer:userOnServer]) {
            [currentUser updateAttributesToMatchUser:userOnServer];
            [self.playerScorecards[i] updateScorecardWithInfoFromUser:self.room.users[i]];
        }
    }
}

- (void)setupScorecardWithUsersInfo {
    for (NSInteger i = 0 ; i < [self.room.users count] ; i++) {
        SBUser *user = self.room.users[i];
        Scorecard *currentScorecard = self.playerScorecards[i];
        [currentScorecard updateScorecardWithInfoFromUser:user];
    }
    
    if ([self.room.users count] < 6) {
        [self hideUnusedScorecards];
    }
}

- (void)hideUnusedScorecards {
    for (NSUInteger i = [self.room.users count] ; i < 6 ; i++) {
        Scorecard *sc = self.playerScorecards[i];
        sc.hidden = YES;
    }
}

- (NSArray *)playerScorecards {
    if (!_playerScorecards) {
        _playerScorecards = @[self.player1, self.player2, self.player3, self.player4, self.player5, self.player6];
    }
    return _playerScorecards;
}



- (void)setupSettingsButton {
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"settings"]
                              forState:UIControlStateNormal];
    
    [settingsButton addTarget:self
                       action:@selector(settingsTapped:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.mainMonsterView addSubview:settingsButton];
    
    [settingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.mainMonsterView).with.offset(8);
        make.height.and.width.equalTo(@18);
    }];
}

- (void)settingsTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:@"changeMonster" sender:self];
}

#pragma mark - Main Scorecard Methods

- (void)setupPickerViewsDelegateAndDataSource {
    self.victoryPoints.delegate = self;
    self.healthPoints.delegate = self;
    self.victoryPoints.dataSource = self;
    self.healthPoints.dataSource = self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSMutableArray *hp = [[NSMutableArray alloc] init];
    NSMutableArray *vp = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0 ; i < 21 ; i++) {
        if (i > 12) {
            [vp addObject:@(i)];
        } else {
            [vp addObject:@(i)];
            [hp addObject:@(i)];
        }
    }
    
    _vpPointsOnPicker = [vp mutableCopy];
    _hpPointsOnPicker = [hp mutableCopy];
    
    if ([pickerView isEqual:_victoryPoints]) {
        return [vp count];
    } else {
        return [hp count];
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
             attributedTitleForRow:(NSInteger)row
                      forComponent:(NSInteger)component {
    
    if ([pickerView isEqual:_victoryPoints]) {
        NSString *vpString = [NSString stringWithFormat:@"%@", [self.vpPointsOnPicker[row] stringValue]];
        NSAttributedString *attVPString = [[NSAttributedString alloc] initWithString:vpString
                                                                          attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attVPString;
        
    } else {
        NSString *hpString = [NSString stringWithFormat:@"%@", [self.hpPointsOnPicker[row] stringValue]];
        NSAttributedString *attHPString = [[NSAttributedString alloc] initWithString:hpString
                                                                          attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attHPString;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45;
}


- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    
    if ([pickerView isEqual:_victoryPoints]) {
        if ([self.currentPlayer.vp integerValue] != row) {
            [self runTheStarParticles];
            [self updateTheVPOfTheCurrentUserOnFirebaseWithSelectedRow:row];
            self.currentPlayer.vp = @(row);
        }
    } else {
        if ([self.currentPlayer.hp integerValue] != row) {
            [self runTheHeartParticles];
            [self updateTheHPOfTheCurrentUserOnFirebaseWithSelectedRow:row];
            self.currentPlayer.hp = @(row);
        }
    }
}

- (void)updateTheVPOfTheCurrentUserOnFirebaseWithSelectedRow:(NSInteger)row {
    NSDictionary *victoryPointChange = @{ @"vp": [@(row) stringValue]};
    
    [self.currentPlayerRef updateChildValues:victoryPointChange
                         withCompletionBlock:^(NSError *error, Firebase *ref) {
                             if (error) {
                                 
                             }
                         }];
}

- (void)updateTheHPOfTheCurrentUserOnFirebaseWithSelectedRow:(NSInteger)row {
    NSDictionary *healthPointChange = @{ @"hp": [@(row) stringValue]};
    
    [self.currentPlayerRef updateChildValues:healthPointChange
                         withCompletionBlock:^(NSError *error, Firebase *ref) {
                             if (error) {
                                 
                             }
                         }];
}

- (void)runTheStarParticles {
    [self.mainStarScene runStars];
    
    [NSTimer scheduledTimerWithTimeInterval:kLengthOfMainStarScene
                                     target:self
                                   selector:@selector(pauseStarTimer)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)runTheHeartParticles {
    [self.mainHeartScene runHearts];
    
    [NSTimer scheduledTimerWithTimeInterval:kLengthOfMainHeartScene
                                     target:self
                                   selector:@selector(pauseHeartTimer)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)pauseHeartTimer {
    [self.mainHeartScene pauseHearts];
}

- (void)pauseStarTimer {
    [self.mainStarScene pauseStars];
}

- (void)resetMethodHasBeenCalled {
    SBSetupViewController *presentingVC = (SBSetupViewController *)self.presentingViewController;
    
//    @property (strong, nonatomic) Firebase *ref;
//    @property (strong, nonatomic) NSString *roomDigits;
//    @property (strong, nonatomic) SBUser *currentPlayer;
//    @property (strong, nonatomic) NSString *IDOfCurrentPlayer;
//    @property (strong, nonatomic) NSString *randomMonsterName;
//    @property (strong, nonatomic) NSString *currentPlayerName;
    
    
    
    
    NSLog(@"Reset Method has been called has been called!!");
    [self.currentPlayerRef removeValue];
    [Firebase goOffline];
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 [presentingVC turnFireBaseOnline];
                                 NSLog(@"In completion block of the last completion of view dismissing itself!");
                             }];
}




#pragma mark - Commented Out Methods
//- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
//    return NO;
//}


@end
