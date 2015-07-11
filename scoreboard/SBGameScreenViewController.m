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

@property (strong, nonatomic) SBRoom *room;

- (IBAction)smallButton:(id)sender;

@end

@implementation SBGameScreenViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _room = [[SBRoom alloc] init];
    
    self.player1.monsterName.text = @"Godzilla";
    self.player1.playerName.text = @"JIM";
    self.player1.monsterImage.image = [UIImage imageNamed:@"MANTIS_384"];
    
    [self.player1.topPicker selectRow:5 inComponent:0 animated:YES];
    [self.player1.bottomPicker selectRow:5 inComponent:0 animated:YES];
    
    
    [[self.ref childByAppendingPath:self.roomDigits]
     observeEventType:FEventTypeValue
     withBlock:^(FDataSnapshot *snapshot) {
         
         BOOL numberOfPlayersChanged = [self.room.users count] != snapshot.childrenCount ? YES : NO;
         
         if (numberOfPlayersChanged) {
             
             self.room = [SBRoom createRoomWithData:snapshot];
             [self setupScorecardWithUsersInfo];
             
         } else {
             
             SBRoom *changedRoom = [SBRoom createRoomWithData:snapshot];
             
             
             
             [self.room updateChangesMadeToPlayers];
             
             //create a method to see who and what changed, then update those people.
             
         }
         
     } withCancelBlock:^(NSError *error) {
         
         
     }];
    
}

- (void)testData {
    
    
    self.player1.monsterImage.image = [UIImage imageNamed:@"KONG_128"];
}

- (void)setupScorecardWithUsersInfo {
    
    for (NSInteger i = 0 ; i < [self.room.users count] ; i++) {
        
        SBUser *user = self.room.users[i];
        
        Scorecard *currentScorecard = self.playerScorecards[i];
        
        [currentScorecard setupScorecardWithMonsterName:user.monster
                                             playerName:user.name
                                           monsterImage:user.monsterImage];
        
        [currentScorecard.bottomPicker selectRow:[user.hp integerValue] inComponent:0 animated:YES];
        [currentScorecard.topPicker selectRow:[user.vp integerValue] inComponent:0 animated:YES];
        
        currentScorecard.hidden = NO;
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

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (SBRoom *)usersInTheRoom {
    
    if (!_usersInTheRoom) {
        
        _usersInTheRoom = [[SBRoom alloc] init];
    }
    return _usersInTheRoom;
}

- (IBAction)smallButton:(id)sender {
    
    //settings?
}

@end
