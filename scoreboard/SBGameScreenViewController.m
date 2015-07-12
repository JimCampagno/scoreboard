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

//Main Player Card
@property (weak, nonatomic) IBOutlet UIView *mainMonsterView; // <-- being used?
@property (weak, nonatomic) IBOutlet UILabel *monsterName;
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UIImageView *monsterImage;
@property (weak, nonatomic) IBOutlet UIPickerView *victoryPoints;
@property (weak, nonatomic) IBOutlet UIPickerView *healthPoints;

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

- (IBAction)smallButton:(id)sender;

@end

@implementation SBGameScreenViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _room = [[SBRoom alloc] init];
    
    
    [self setupListenerToFirebase];
}

- (void)setupListenerToFirebase {
    
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

@end
