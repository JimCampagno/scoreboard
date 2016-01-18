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
#import "SBChangeMonsterViewController.h"

#import <SceneKit/SceneKit.h>
#import <Masonry.h>


@interface SBGameScreenViewController ()

//Main Player Card
@property (weak, nonatomic) IBOutlet UILabel *monsterName;
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UIButton *monsterImage;
@property (weak, nonatomic) IBOutlet UIPickerView *victoryPoints;
@property (weak, nonatomic) IBOutlet UIPickerView *healthPoints;
@property (strong, nonatomic) NSMutableArray *vpPointsOnPicker;
@property (strong, nonatomic) NSMutableArray *hpPointsOnPicker;

//All other player cards (including main)
@property (weak, nonatomic) IBOutlet Scorecard *player1;
@property (weak, nonatomic) IBOutlet Scorecard *player2;
@property (weak, nonatomic) IBOutlet Scorecard *player3;
@property (weak, nonatomic) IBOutlet Scorecard *player4;
@property (weak, nonatomic) IBOutlet Scorecard *player5;
@property (weak, nonatomic) IBOutlet Scorecard *player6;

//Other
@property (strong, nonatomic) NSArray *playerScorecards;
@property (strong, nonatomic) SBRoom *room;
@property (strong, nonatomic) Firebase *currentPlayerRef;
@property (strong, nonatomic) Firebase *connectedRef;
@property (nonatomic) BOOL didLoseConnectionToFireBase;
@property (strong, nonatomic) UIView *noConnectionView;
@property (strong, nonatomic) UIView *initialLoad;
@property (strong, nonatomic) UIVisualEffectView *blurView;
@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) UILabel *loadingGameLabel;

@property (nonatomic) NSInteger numberOfPlayers;
@property (strong, nonatomic) NSMutableArray *userKeys;
@property (nonatomic) BOOL comingBackFromDisconnect;

@property (nonatomic) BOOL viewResignedActive;

- (IBAction)monsterImageTapped:(id)sender;
- (void)aboutToLeaveTheScreen;


@end


@implementation SBGameScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.didLoseConnectionToFireBase = NO;
    self.room = [[SBRoom alloc] init];
    self.userKeys = [NSMutableArray new];
    self.comingBackFromDisconnect = NO;
    self.viewResignedActive = NO;
    
    [self setupPickerViewsDelegateAndDataSource];
    [self setupMainPlayerScorecard];
    [self doTheThing]; // fix this method name
    [self displayInitialLoad];
    [self setupNavigationBar];
    [self observeCertainNotifications];
}

- (void)observeCertainNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(aboutToLeaveTheScreen)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(aboutToEnterView)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)aboutToLeaveTheScreen {
    
    for (Scorecard *sc in self.playerScorecards) {
        sc.itGotDoneDisconnected = YES;
    }
    
}

- (void)setDisconnectPropertyForAllScorecardsToNo {
    
    
    //if some property is still set to NO as in this didn't get set to YES below - delay it some more?? animations don't appear to do the thing or maybe trying to animate it really fast is bad?? when coming back
    NSLog(@"============================================ SET DISCONNECT CALLED ===================================\n\n");
    
    for (Scorecard *sc in self.playerScorecards) {
        sc.itGotDoneDisconnected = NO;
        
        if (sc.firstTimeThrough) {
            
            sc.firstTimeThrough = NO;
        }
    }
    
}

- (void)aboutToEnterView {
    
    [self performSelector:@selector(setDisconnectPropertyForAllScorecardsToNo)
               withObject:nil
               afterDelay:2.0];
    
}


- (void)setupNavigationBar {
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *leaveGameBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<"
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = leaveGameBarButtonItem;
    
    NSUInteger size = 26;
    UIFont *font = [UIFont systemFontOfSize:size];
    NSDictionary *attributes = @{ NSFontAttributeName: font };
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.navigationItem.title = [NSString stringWithFormat:@"%@", _roomDigits];
    NSDictionary *attributesForTitleText = @{ NSForegroundColorAttributeName: [UIColor colorWithRed:0.98 green:0.8 blue:0 alpha:1] };
    self.navigationController.navigationBar.titleTextAttributes = attributesForTitleText;
}

- (void)doTheThing {
    
    NSLog(@"BEGIN doTheThing");
    
    __weak typeof(self) tmpself = self;
    
    
    self.connectedRef = [[Firebase alloc] initWithUrl:@"https://boiling-heat-4798.firebaseio.com/.info/connected"];
    
    [self.connectedRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if([snapshot.value boolValue]) {
            
            NSString *boolThing = [snapshot.value boolValue] ? @"YES" : @"NO";
            NSLog(@"if statement - [snapshot.value boolValue] is %@", boolThing);
            
            
            if (tmpself.didLoseConnectionToFireBase) {
                
                
                NSString *boolThing = tmpself.didLoseConnectionToFireBase ? @"YES" : @"NO";
                NSLog(@"if statement - if self.didLoseConnectionToFireBase is %@", boolThing);
                
                
                for (Scorecard *sc in tmpself.playerScorecards) {
                    
                    sc.firstTimeThrough = YES;
                }
                
                NSLog(@"if statement - just looped through the scorecards and set their firstTimeThrough and itGotDoneDisconnected property to yes.");
                
                [tmpself performSelector:@selector(setDisconnectPropertyForAllScorecardsToNo) withObject:nil afterDelay:2.0];
                
                
                [tmpself doMagic];
                tmpself.view.userInteractionEnabled = YES;
            }
            
            
            
            [tmpself setupListenerToEntireRoomOnFirebase];
            [tmpself setupCurrentPlayerReferenceToFirebase];
            
        } else {
            
            NSString *boolThing = tmpself.didLoseConnectionToFireBase ? @"YES" : @"NO";
            NSLog(@"if statement - in the else when self.didLoseConectionToFireBase is %@", boolThing);
            
            
            self.comingBackFromDisconnect = YES;
            
            for (Scorecard *sc in tmpself.playerScorecards) {
                
                sc.wasDisconnected = YES;
                sc.firstTimeThrough = YES;
                
                sc.itGotDoneDisconnected = YES;
                
                
                
            }
            
            [tmpself displayNoConnectionView];
            tmpself.didLoseConnectionToFireBase = YES;
            
            
        }
    }];
    
    NSLog(@"END doTheThing\n\n");
    
}

- (void)displayInitialLoad {
    self.view.userInteractionEnabled = NO;
    
    self.initialLoad = [[UIView alloc] initWithFrame:self.view.frame];
    self.initialLoad.backgroundColor = [UIColor clearColor];
    self.initialLoad.userInteractionEnabled = NO;
    [self.view addSubview:self.initialLoad];
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurView.frame = self.view.bounds;
    
    [self.initialLoad addSubview:self.blurView];
    
    self.loadingGameLabel = [UILabel new];
    self.loadingGameLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingGameLabel.text = @"assembling monsters...";
    [self.loadingGameLabel setFont:[UIFont systemFontOfSize:25]];
    self.loadingGameLabel.clipsToBounds = YES;
    self.loadingGameLabel.textColor = [UIColor colorWithRed:0.98 green:0.8 blue:0 alpha:1] ;
    self.loadingGameLabel.numberOfLines = 1;
    self.loadingGameLabel.adjustsFontSizeToFitWidth = YES;
    self.loadingGameLabel.lineBreakMode = NSLineBreakByClipping;
    
    [self.initialLoad addSubview:self.loadingGameLabel];
    
    [self.loadingGameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.initialLoad);
        make.centerY.equalTo(self.initialLoad).multipliedBy(0.7);
    }];
    
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    [self.initialLoad addSubview:self.loadingIndicator];
    
    [self.loadingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loadingGameLabel.mas_bottom).with.offset(16);
        make.centerX.equalTo(self.view);
        
    }];
    
    [self.loadingIndicator startAnimating];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self isBeingPresented] || [self isMovingToParentViewController]) {
        
        [self performSelector:@selector(doMagic) withObject:self afterDelay:4.2];
        
        for (Scorecard *sc in self.playerScorecards) {
            [sc createHeartAndStarViews];
        }
        
        self.view.userInteractionEnabled = YES;
    }
    
    NSLog(@"++++++++++++ viewDidAppear: has been called");
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    NSLog(@"\n\n\nTHE VIEW WILL DISAPPEAR MY BRO!!!");
}

- (void)doMagic {
    
    NSLog(@"BEGIN doMagic called.");
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         self.initialLoad.alpha = 0.0;
                         
                     } completion:^(BOOL finished) {
                         
                         [self.loadingIndicator stopAnimating];
                         self.initialLoad.hidden = YES;
                     }];
    
    NSLog(@"END doMagic.\n\n");
}

- (void)displayNoConnectionView {
    self.loadingGameLabel.text = @"no internet connection 🚧";
    self.initialLoad.hidden = NO;
    self.view.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.7
                     animations:^{
                         
                         self.initialLoad.alpha = 1.0;
                     }];
    
}

- (void)handleBack:(id)sender {
    [self presentActionSheetForLeaveGame];
}

- (void)userHasChangedToMonsterWithName:(NSString *)name {
    NSDictionary *monsterNameChange = @{@"monster": name};
    UIImage *imageOfMonster = [UIImage imageNamed:[NSString stringWithFormat:@"%@_384", name]];
    [self.monsterImage setImage:imageOfMonster forState:UIControlStateNormal];
    
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
    
    // [self.currentPlayerRef onDisconnectRemoveValue];
}

- (IBAction)monsterImageTapped:(id)sender {
    
    [self performSegueWithIdentifier:@"changeMonster" sender:nil];
}

- (void)setupMainPlayerScorecard {
    UIImage *imageOfMonster = [UIImage imageNamed:[NSString stringWithFormat:@"%@_384", self.currentPlayer.monster]];
    [self.monsterImage setImage:imageOfMonster forState:UIControlStateNormal];
    [self.monsterImage.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.monsterName.text = self.currentPlayer.monster;
    self.playerName.text = self.currentPlayer.name;
    [self.healthPoints selectRow:[self.currentPlayer.hp integerValue] inComponent:0 animated:YES];
    [self.victoryPoints selectRow:[self.currentPlayer.vp integerValue] inComponent:0 animated:YES];
}

- (void)setupListenerToEntireRoomOnFirebase {
    __weak typeof(self) tmpself = self;
    
    NSLog(@"BEGIN setupListenerToEntireRoomOnFirebase");
    
    if (_didLoseConnectionToFireBase) {
        
        NSLog(@"if statement - self.didLoseConnectionToFireBase is %@", @(self.didLoseConnectionToFireBase));
        
        [[tmpself.ref childByAppendingPath:tmpself.roomDigits] runTransactionBlock:^FTransactionResult *(FMutableData *currentData) {
            if ([currentData hasChildren]) {
                
                NSDictionary *newUser = @{ @"name": tmpself.playerName.text,
                                           @"monster": tmpself.monsterName.text,
                                           @"hp": tmpself.currentPlayer.hp,
                                           @"vp": tmpself.currentPlayer.vp };
                
                [[currentData childDataByAppendingPath:tmpself.IDOfCurrentPlayer] setValue:newUser];
            }
            return [FTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError *error, BOOL committed, FDataSnapshot *snapshot) {
            
        }];
        
        
    } else {
        
        [[tmpself.ref childByAppendingPath:self.roomDigits]
         observeEventType:FEventTypeValue
         withBlock:^(FDataSnapshot *snapshot) {
             
             BOOL numberOfPlayersChanged = [tmpself.room.users count] != snapshot.childrenCount ? YES : NO;
             
             if (numberOfPlayersChanged) {
                 
                 NSLog(@"if statement - numberOfPlayers Changed");
                 NSLog(@"SETUP scorecardWithUsersInfo");
                 
                 tmpself.room = [SBRoom createRoomWithData:snapshot];
                 [tmpself setupScorecardWithUsersInfo];
                 
             } else {
                 NSLog(@"if statement - numberOfPlayers did not change");
                 NSLog(@"UPDATE scorecardWithUsersInfo");
                 
                 SBRoom *changedRoom = [SBRoom createRoomWithData:snapshot];
                 [tmpself updateScoresWithRoom:changedRoom];
             }
             
             
         } withCancelBlock:^(NSError *error) {
             //Still should do something here.
             NSLog(@"ERROR: %@", error.description);
         }];
        
        
        
        
        
    }
    
    
}


- (void)updateScoresWithRoom:(SBRoom *)room {
    
    for (SBUser *user in self.room.users) {
        
        NSUInteger indexOfUser = [self.room.users indexOfObject:user];
        SBUser *userOnServer = room.users[indexOfUser];
        
        if ([user didAttributesChangeWithUserOnServer:userOnServer]) {
            
            [user updateAttributesToMatchUser:userOnServer];
            
            NSArray *sortedKeys = [self.userKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            
            if ([sortedKeys isEqualToArray:self.userKeys]) {
                
                NSUInteger indexOfKey = [self.userKeys indexOfObject:user.key];
                
                [self.playerScorecards[indexOfKey] updateScorecardWithInfoFromUser:user];
                
            } else {
                
                NSUInteger indexOfKey = [sortedKeys indexOfObject:user.key];
                
                
                [self.playerScorecards[indexOfKey] updateScorecardWithNoAnimationFromUser:user];
                
            }
        }
    }
    
    [self.userKeys sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    
    
    
    
    
    
    for (Scorecard *card in self.playerScorecards) {
        
        if ([card.playerName.text.lowercaseString isEqualToString:@"player name"]) {
            
            continue;
        }
        
        NSLog(@"*****************************************************");
        
        NSLog(@"BEFORE CHANGE: %@ - firstTimeThrough: %@ - wasDisconnected: %@", card.playerName.text.capitalizedString, @(card.firstTimeThrough), @(card.wasDisconnected));
        
        
        if (!_viewResignedActive) {
            
            NSLog(@"%@ will set wasDisconnected to NO", card.playerName.text.uppercaseString);
            
            card.wasDisconnected = NO;
        }
        
        
        
        
        
        
        
        NSLog(@"AFTER CHANGE: %@ - firstTimeThrough: %@ - wasDisconnected: %@", card.playerName.text.capitalizedString, @(card.firstTimeThrough), @(card.wasDisconnected));
        
        NSLog(@"*****************************************************\n\n");
        
    }
    
    self.viewResignedActive = NO;
    
    
    
    
}

- (void)setupScorecardWithUsersInfo {
    
    NSString *unusedKey;
    
    if (_comingBackFromDisconnect) {
        
        NSMutableArray *unusedKeys = [self.userKeys mutableCopy];
        
        for (NSString *key in self.userKeys) {
            
            for (SBUser *user in self.room.users) {
                
                if ([key isEqualToString:user.key]) {
                    
                    [unusedKeys removeObject:key];
                    
                    
                }
            }
        }
        
        unusedKey = [unusedKeys firstObject];
        
        
        NSArray *sortedKeys = [self.userKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        if ([sortedKeys isEqualToArray:self.userKeys]) {
            
            NSUInteger indexOfKey = [self.userKeys indexOfObject:unusedKey];
            // Scorecard *scorecard = self.playerScorecards[indexOfKey];
            
          //fsdf  NSLog(@"%@ is about to set the wasDisconnected to NO in the if sortedKeysEqualArray", scorecard.playerName.text.capitalizedString);
            
            // scorecard.wasDisconnected = NO;
            
            for (NSString *key in self.userKeys) {
                
                NSUInteger index = [self.userKeys indexOfObject:key];
                Scorecard *sc = self.playerScorecards[index];
                
                NSLog(@"if statement about to happen with wasDisconnected/firsTThrimgGhrough");
                
                if (sc.wasDisconnected && !sc.firstTimeThrough) {
                    
                    NSLog(@"%@ is about to set the wasDisconnected Property in this weird if statement.", sc.playerName.text.capitalizedString);
                    sc.wasDisconnected = NO;
                };
            }
            
            
            
        } else {
            
            NSUInteger indexOfKey = [sortedKeys indexOfObject:unusedKey];
            Scorecard *scorecard = self.playerScorecards[indexOfKey];
            
            NSLog(@"%@ is about to set the wasDisconnected to NO in the ELSE of the if sortedkeysequalarray", scorecard.playerName.text.capitalizedString);
            
            scorecard.wasDisconnected = NO;
            
            
            for (NSString *key in self.userKeys) {
                
                NSUInteger index = [sortedKeys indexOfObject:key];
                Scorecard *sc = self.playerScorecards[index];
                
                NSLog(@"if statement about to happen with wasDisconnected and firstTimeThrough");
                
                if (sc.wasDisconnected && !sc.firstTimeThrough) {
                    
                    NSLog(@"%@ is about to set the wasDisconnected Property in this weird if statement.", sc.playerName.text.capitalizedString);
                    
                    sc.wasDisconnected = NO;
                };
            }
            
            
            
            
        }
        
        
        self.comingBackFromDisconnect = NO;
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    for (SBUser *user in self.room.users) {
        
        
        if (![self.userKeys containsObject:user.key]) {
            
            [self removeUnusedKey];
            [self.userKeys addObject:[user.key copy]];
        }
        
        NSArray *sortedKeys = [self.userKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        if ([sortedKeys isEqualToArray:self.userKeys]) {
            
            
            
            NSUInteger indexOfKey = [self.userKeys indexOfObject:user.key];
            Scorecard *scorecard = self.playerScorecards[indexOfKey];
            scorecard.unHidden = YES;
            [scorecard updateScorecardWithInfoFromUser:user];
            
        } else {
            
            NSUInteger indexOfKey = [sortedKeys indexOfObject:user.key];
            Scorecard *scorecard = self.playerScorecards[indexOfKey];
            scorecard.unHidden = YES;
            [scorecard updateScorecardWithNoAnimationFromUser:user];
            
        }
        
    }
    
    
    
    
    
    
    [self.userKeys sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    
    
    //TODO: Should I remove this?  I feel like I don't need it.
    if (self.numberOfPlayers == self.room.users.count) {
        
        Scorecard *sc = self.playerScorecards[self.room.users.count - 1];
        sc.hidden = YES;
    }
    
    
    self.numberOfPlayers = self.room.users.count;
    
    if ([self.room.users count] < 6) {
        [self hideUnusedScorecards];
    }
}

- (void)removeUnusedKey {
    
    //TODO: This is ugly, clean this up.  THIS IS ONLY removing key if count were to exceed 6 (maybe change this to somehow KNOWING when a user actually exits the game by tapping the back button to exit the game by selecting YES or by closing the app with a swipe (where the view would die).  If this is the case then this is when you would remove the key.  How though would firebase be able to distinguish between the two.  If on disconnect through a certain method (possible?) store some value (bool/string) on firebase letting firebase know that HEY this user is just disconnected but this view is still alive (maybe they are idle for too long or lost internet connection) which would keep the key in this array.
    
    if (self.userKeys.count + 1 == 7) {
        
        for (NSString *key in self.userKeys) {
            
            BOOL foundMatch = NO;
            
            for (SBUser *userAgain in self.room.users) {
                
                if ([key isEqualToString:userAgain.key]) {
                    
                    foundMatch = YES;
                    break;
                }
            }
            
            if (!foundMatch) {
                
                [self.userKeys removeObject:key];
            }
        }
    }
}

- (void)hideUnusedScorecards {
    for (NSUInteger i = [self.room.users count] ; i < 6 ; i++) {
        Scorecard *sc = self.playerScorecards[i];
        
        if (!sc.unHidden) {
            sc.hidden = YES;
        }
        
    }
    
}

- (NSArray *)playerScorecards {
    if (!_playerScorecards) {
        _playerScorecards = @[self.player1, self.player2, self.player3, self.player4, self.player5, self.player6];
    }
    return _playerScorecards;
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
    return 49;
}


- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    
    if ([pickerView isEqual:_victoryPoints]) {
        if ([self.currentPlayer.vp integerValue] != row) {
            //            [self runTheStarParticles];
            [self updateTheVPOfTheCurrentUserOnFirebaseWithSelectedRow:row];
            self.currentPlayer.vp = @(row);
        }
    } else {
        if ([self.currentPlayer.hp integerValue] != row) {
            //            [self runTheHeartParticles];
            [self updateTheHPOfTheCurrentUserOnFirebaseWithSelectedRow:row];
            self.currentPlayer.hp = @(row);
        }
    }
    
}

- (void)updateTheVPOfTheCurrentUserOnFirebaseWithSelectedRow:(NSInteger)row {
    
    NSDictionary *victoryPointChange = @{ @"vp": @(row)};
    
    [self.currentPlayerRef updateChildValues:victoryPointChange
                         withCompletionBlock:^(NSError *error, Firebase *ref) {
                             if (error) {
                                 
                             }
                         }];
}

- (void)updateTheHPOfTheCurrentUserOnFirebaseWithSelectedRow:(NSInteger)row {
    NSDictionary *healthPointChange = @{ @"hp": @(row)};
    
    [self.currentPlayerRef updateChildValues:healthPointChange
                         withCompletionBlock:^(NSError *error, Firebase *ref) {
                             if (error) {
                                 
                             }
                         }];
}



- (void)resetMethodHasBeenCalled {
    [self.currentPlayerRef removeValue];
    [self.currentPlayerRef removeAllObservers];
    [self.ref removeAllObservers];
    [self.connectedRef removeAllObservers];
    
    [Firebase goOffline];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Prepare For Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SBChangeMonsterViewController *destVC = segue.destinationViewController;
    
    destVC.delegate = self;
    destVC.roomID = [self.roomDigits copy];
}

- (void)presentActionSheetForLeaveGame {
    
    __weak typeof(self) tmpself = self;
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Are you sure you want to leave this game?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [tmpself resetMethodHasBeenCalled];
    }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [actionSheet dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [actionSheet addAction: yesAction];
    [actionSheet addAction: noAction];
    
    [tmpself presentViewController:actionSheet animated:YES completion:nil];
}

@end