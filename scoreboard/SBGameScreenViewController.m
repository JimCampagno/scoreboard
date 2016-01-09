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

#import <Masonry.h>


@interface SBGameScreenViewController ()

//Main Player Card
@property (weak, nonatomic) IBOutlet UIView *mainMonsterView; // <-- being used?
@property (weak, nonatomic) IBOutlet UILabel *monsterName;
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UIButton *monsterImage;
@property (weak, nonatomic) IBOutlet UIPickerView *victoryPoints;
@property (weak, nonatomic) IBOutlet UIPickerView *healthPoints;
@property (strong, nonatomic) NSMutableArray *vpPointsOnPicker;
@property (strong, nonatomic) NSMutableArray *hpPointsOnPicker;

//@property (weak, nonatomic) IBOutlet SKView *mainHeartParticleView;
//@property (weak, nonatomic) IBOutlet SKView *mainStarParticleView;
//@property (nonatomic, strong) SBHeartScene *mainHeartScene;
//@property (nonatomic, strong) SBStarScene *mainStarScene;


//All other player cards (including main)
@property (weak, nonatomic) IBOutlet Scorecard *player1;
@property (weak, nonatomic) IBOutlet Scorecard *player2;
@property (weak, nonatomic) IBOutlet Scorecard *player3;
@property (weak, nonatomic) IBOutlet Scorecard *player4;
@property (weak, nonatomic) IBOutlet Scorecard *player5;
@property (weak, nonatomic) IBOutlet Scorecard *player6;

@property (strong, nonatomic) SKView *player1SKView;
@property (strong, nonatomic) SKView *player2SKView;
@property (strong, nonatomic) SKView *player3SKView;
@property (strong, nonatomic) SKView *player4SKView;
@property (strong, nonatomic) SKView *player5SKView;
@property (strong, nonatomic) SKView *player6SKView;

@property (strong, nonatomic) NSArray *skviews;







@property (strong, nonatomic) NSArray *playerScorecards;
@property (strong, nonatomic) NSArray *pickerData;
@property (strong, nonatomic) SBRoom *room;

@property (strong, nonatomic) Firebase *currentPlayerRef;

- (IBAction)monsterImageTapped:(id)sender;

- (void)setupMainPlayerScorecard;
@end

//static const NSTimeInterval kLengthOfMainHeartScene = 0.7;
//static const NSTimeInterval kLengthOfMainStarScene = 0.7;

@implementation SBGameScreenViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.room = [[SBRoom alloc] init];
    [self setupPickerViewsDelegateAndDataSource];
    [self setupListenerToEntireRoomOnFirebase];
    [self setupCurrentPlayerReferenceToFirebase];
    [self setupMainPlayerScorecard];
    
    CGRect frame = CGRectMake(0.0, 0.0, 90.0, 90.0);
    
    
    self.player1SKView = [[SKView alloc] initWithFrame:frame];
    self.player2SKView = [[SKView alloc] initWithFrame:frame];
    self.player3SKView = [[SKView alloc] initWithFrame:frame];
    self.player4SKView = [[SKView alloc] initWithFrame:frame];
    self.player5SKView = [[SKView alloc] initWithFrame:frame];
    self.player6SKView = [[SKView alloc] initWithFrame:frame];
    
    self.skviews = @[ self.player1SKView, self.player2SKView, self.player3SKView, self.player4SKView, self.player5SKView, self.player6SKView];
    
    for (SKView *sk in self.skviews) {
        
        [self.view addSubview:sk];
    }


    
    
    
    for (Scorecard *sc in self.playerScorecards) {
        
        NSLog(@"\n\n %@ \n\n", CGRectCreateDictionaryRepresentation(sc.heartContainerView.frame));

    }
     
//    for (NSInteger i = 0; i < [self.playerScorecards count]; i++) {
//        
//        NSLog(@"Entering for loop to setup the scorecard!");
//        
//        Scorecard *sc = self.playerScorecards[i];
//        SKView *skview = skviews[i];
//        
//        [sc.heartContainerView addSubview:skview];
////        [skview mas_makeConstraints:^(MASConstraintMaker *make) {
////            
////            make.top.and.bottom.and.right.and.left.equalTo(sc.heartContainerView);
////            
////        }];
//    }
    
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
    
    
    //    for (Scorecard *sc in self.playerScorecards) {
    //
    //
    //        NSLog(@"installTheHeartScene has been called!");
    //
    //        SKView *heartParticleView = [[SKView alloc] init];
    //
    //
    //        [sc.heartContainerView addSubview:heartParticleView];
    //
    //        [heartParticleView mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //            make.top.and.bottom.and.right.and.left.equalTo(sc.heartContainerView);
    //
    //        }];
    //
    //
    //
    //        heartParticleView.allowsTransparency = YES;
    //        heartParticleView.ignoresSiblingOrder = NO;
    //        heartParticleView.backgroundColor = [UIColor clearColor];
    //        sc.heartScene = [SBHeartScene sceneWithSize:sc.heartContainerView.bounds.size];
    //        sc.heartScene.scaleMode = SKSceneScaleModeAspectFill;
    //        [heartParticleView presentScene:sc.heartScene];
    //
    //        [sc.heartScene runHearts];
    //        [sc.heartScene pauseHearts];
    //
    //    }
    
    
    //                 [self.player1 installTheHeartScene];
    //                 [self.player2 installTheHeartScene];
    //                 [self.player3 installTheHeartScene];
    //                 [self.player4 installTheHeartScene];
    //                 [self.player5 installTheHeartScene];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    for (NSInteger i = 6; i < [self.playerScorecards count]; i++) {
        
        NSLog(@"Entering for loop to setup the scorecard!");
        
        Scorecard *sc = self.playerScorecards[i];
        SKView *skview = self.skviews[i];
        
        
//        NSLog(@"\n\n %@ \n\n", CGRectCreateDictionaryRepresentation(sc.heartContainerView.frame));
        
        
        [sc.heartContainerView addSubview:skview];
//                [skview mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//                    make.top.and.bottom.and.right.and.left.equalTo(sc.heartContainerView);
//        
//                }];
    }

    
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
    [self.currentPlayerRef onDisconnectRemoveValue];
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
    
    //    [self setupMainHeartParticleView];
    //    [self setupMainStarParticleView];
}



//- (void)setupMainHeartParticleView {
//    self.mainHeartParticleView.allowsTransparency = YES;
//    self.mainHeartParticleView.backgroundColor = [UIColor clearColor];
//    self.mainHeartScene = [SBHeartScene sceneWithSize:self.mainHeartParticleView.bounds.size];
//    self.mainHeartScene.scaleMode = SKSceneScaleModeAspectFill;
//
//    [self.mainHeartParticleView presentScene:self.mainHeartScene];
//    [self.mainHeartScene runHearts];
//    [self.mainHeartScene pauseHearts];
//    [self.mainHeartScene.heart setParticleSize:CGSizeMake(300, 300)];
//    [self.mainHeartScene.heart setParticlePositionRange:CGVectorMake(50, 50)];
//}
//
//- (void)setupMainStarParticleView {
//    self.mainStarParticleView.allowsTransparency = YES;
//    self.mainStarParticleView.backgroundColor = [UIColor clearColor];
//    self.mainStarScene = [SBStarScene sceneWithSize:self.mainStarParticleView.bounds.size];
//    self.mainStarScene.scaleMode = SKSceneScaleModeAspectFill;
//
//    [self.mainStarParticleView presentScene:self.mainStarScene];
//    [self.mainStarScene runStars];
//    [self.mainStarScene pauseStars];
//    [self.mainStarScene.star setParticleSize:CGSizeMake(300, 300)];
//    [self.mainStarScene.star setParticlePositionRange:CGVectorMake(50, 50)];
//}


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
        sc.hidden = NO;
    }
    
    //    for (Scorecard *card in self.playerScorecards) {
    //
    //        if (card.isHidden) {
    //
    //
    //        } else {
    //
    //            NSLog(@"Not hidden");
    //
    //            [card installTheHeartScene];
    //        }
    //    }
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

//- (void)runTheStarParticles {
//    [self.mainStarScene runStars];
//
//    [NSTimer scheduledTimerWithTimeInterval:kLengthOfMainStarScene
//                                     target:self
//                                   selector:@selector(pauseStarTimer)
//                                   userInfo:nil
//                                    repeats:NO];
//}
//
//- (void)runTheHeartParticles {
//    [self.mainHeartScene runHearts];
//
//    [NSTimer scheduledTimerWithTimeInterval:kLengthOfMainHeartScene
//                                     target:self
//                                   selector:@selector(pauseHeartTimer)
//                                   userInfo:nil
//                                    repeats:NO];
//}
//
//- (void)pauseHeartTimer {
//    [self.mainHeartScene pauseHearts];
//}
//
//- (void)pauseStarTimer {
//    [self.mainStarScene pauseStars];
//}

- (void)resetMethodHasBeenCalled {
    //    SBSetupViewController *presentingVC = (SBSetupViewController *)self.presentingViewController;
    
    [self.currentPlayerRef removeValue];
    [Firebase goOffline];
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //    [self.navigationController dismissViewControllerAnimated:YES
    //                                                  completion:^{
    //
    //                                                      [presentingVC turnFireBaseOnline];
    //                                                  }];
    
    
    
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
