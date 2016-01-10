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

@property (strong, nonatomic) SCNView *player1SCNView;
@property (strong, nonatomic) SCNView *player2SCNView;
@property (strong, nonatomic) SCNView *player3SCNView;
@property (strong, nonatomic) SCNView *player4SCNView;
@property (strong, nonatomic) SCNView *player5SCNView;
@property (strong, nonatomic) SCNView *player6SCNView;

@property (strong, nonatomic) NSArray *scnviews;
@property (strong, nonatomic) NSArray *playerScorecards;
@property (strong, nonatomic) NSArray *pickerData;
@property (strong, nonatomic) SBRoom *room;

@property (strong, nonatomic) Firebase *currentPlayerRef;
@property (strong, nonatomic) Firebase *connectedRef;

@property (nonatomic) BOOL isExitingView;

@property (nonatomic) BOOL didLoseConnectionToFireBase;



- (IBAction)monsterImageTapped:(id)sender;

- (void)setupMainPlayerScorecard;
@end

//static const NSTimeInterval kLengthOfMainHeartScene = 0.7;
//static const NSTimeInterval kLengthOfMainStarScene = 0.7;

@implementation SBGameScreenViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.didLoseConnectionToFireBase = NO;
    
    NSLog(@"VIEW DID LOAD!!!");
    
    self.room = [[SBRoom alloc] init];
    [self setupPickerViewsDelegateAndDataSource];
    [self setupMainPlayerScorecard];
    
    CGRect frame = CGRectMake(0.0, 0.0, 90.0, 90.0);
    
    self.player1SKView = [[SKView alloc] initWithFrame:frame];
    self.player2SKView = [[SKView alloc] initWithFrame:frame];
    self.player3SKView = [[SKView alloc] initWithFrame:frame];
    self.player4SKView = [[SKView alloc] initWithFrame:frame];
    self.player5SKView = [[SKView alloc] initWithFrame:frame];
    self.player6SKView = [[SKView alloc] initWithFrame:frame];
    
    self.skviews = @[ self.player1SKView, self.player2SKView, self.player3SKView, self.player4SKView, self.player5SKView, self.player6SKView];
    
  
    
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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __weak typeof(self) tmpself = self;
    
    
    self.connectedRef = [[Firebase alloc] initWithUrl:@"https://boiling-heat-4798.firebaseio.com/.info/connected"];
    [self.connectedRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if([snapshot.value boolValue]) {
            
            NSLog(@"connected----------------\n");
            
            [tmpself setupListenerToEntireRoomOnFirebase];
            [tmpself setupCurrentPlayerReferenceToFirebase];
            
        } else {
            
            NSLog(@"not connected--------------\n");
            
            tmpself.didLoseConnectionToFireBase = YES;
            
        }
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
}






- (void)setupListenerToEntireRoomOnFirebase {
    __weak typeof(self) tmpself = self;
    
    if (self.didLoseConnectionToFireBase) {
        
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
        
        
    }
    
    [[tmpself.ref childByAppendingPath:self.roomDigits]
     
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
