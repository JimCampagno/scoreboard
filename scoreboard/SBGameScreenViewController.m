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

- (IBAction)smallButton:(id)sender;

- (void)setupMainPlayerScorecard;

@end

@implementation SBGameScreenViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _room = [[SBRoom alloc] init];
    [self setupPickerViewsDelegateAndDataSource];
    [self setupListenerToEntireRoomOnFirebase];
    [self setupCurrentPlayerReferenceToFirebase];
    [self setupMainPlayerScorecard];
    [self setupGesture];
    [self generateTestData];
}

- (void)generateTestData {
    NSArray *monsterNames = @[@"CAPTAIN FISH", @"DRAKONIS", @"KONG", @"MANTIS", @"ROB", @"SHERIFF"];
    for (NSInteger i = 0 ; i < 6 ; i++) {
        
        
        SBUser *currentPerson = [[SBUser alloc] initWithName:@"CoolGuy"
                                                 monsterName:monsterNames[i]
                                                          hp:@8
                                                          vp:@9];
        
        [self.room.users addObject:currentPerson];
        
    }
    
    [self setupScorecardWithUsersInfo];
}

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
    NSLog(@"WE ARE BACK IN THE OTHER VIEW CONTROLLER, THE NAME IS %@", name);
}

- (void)setupGesture {
    
    self.monsterImage.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *lpHandler = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleHoldGesture:)];
    lpHandler.minimumPressDuration = 1; //seconds
    lpHandler.delegate = self;
    [self.monsterImage addGestureRecognizer:lpHandler];
}

- (void)handleHoldGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        //        self.mainMonsterView.hidden = YES;
        [self performSegueWithIdentifier:@"changeMonster" sender:self];
        
        
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        
        
        
        
    }
    
    
    
}




- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
    
}

- (void)setupCurrentPlayerReferenceToFirebase {
    
    self.currentPlayerRef = [[self.ref childByAppendingPath: self.roomDigits] childByAppendingPath:self.IDOfCurrentPlayer];
    
}

- (void)setupMainPlayerScorecard {
    self.monsterImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_384", self.randomMonsterName]];
    self.monsterName.text = self.randomMonsterName;
    self.playerName.text = self.currentPlayerName;
    [self.healthPoints selectRow:10 inComponent:0 animated:YES];
}


- (void)setupListenerToEntireRoomOnFirebase {
    [[self.ref childByAppendingPath:self.roomDigits]
     observeEventType:FEventTypeValue
     withBlock:^(FDataSnapshot *snapshot) {
         
         BOOL numberOfPlayersChanged = [self.room.users count] != snapshot.childrenCount ? YES : NO;
         
         if (numberOfPlayersChanged) {
             self.room = [SBRoom createRoomWithData:snapshot];
             [self setupScorecardWithUsersInfo];
         } else {
             SBRoom *changedRoom = [SBRoom createRoomWithData:snapshot];
             [self updateScoresWithRoom:changedRoom];
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

- (IBAction)smallButton:(id)sender {
    
    //settings?
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

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    
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
    
    _vpPointsOnPicker = [[NSMutableArray alloc] initWithArray:[vp copy]];
    _hpPointsOnPicker = [[NSMutableArray alloc] initWithArray:[hp copy]];
    
    
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
        
        NSDictionary *victoryPointChange = @{ @"vp": [@(row) stringValue]};
        
        [self.currentPlayerRef updateChildValues:victoryPointChange
                             withCompletionBlock:^(NSError *error, Firebase *ref) {
                                 
                                 if (error) {
                                     
                                     
                                 } else {
                                     
                                 }
                             }];
        
    } else {
        
        NSDictionary *healthPointChange = @{ @"hp": [@(row) stringValue]};
        
        [self.currentPlayerRef updateChildValues:healthPointChange
                             withCompletionBlock:^(NSError *error, Firebase *ref) {
                                 
                                 if (error) {
                                     
                                     
                                 } else {
                                     
                                 }
                             }];
        
    }
}

@end
