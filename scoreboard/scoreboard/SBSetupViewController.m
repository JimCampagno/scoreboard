//
//  SBSetupViewController.m
//  scoreboard
//
//  Created by Jim Campagno on 5/24/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "SBSetupViewController.h"
#import "SBUILabelHelper.h"
#import <Firebase/Firebase.h>
#import "SBConstants.h"
#import "FirebaseAPIclient.h"
#import "SBRoom.h"

@interface SBSetupViewController ()


@property (weak, nonatomic) IBOutlet UIView *displayJoinGameDigits;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *joinGameNumbers;
@property (weak, nonatomic) IBOutlet UITextField *enterName;
- (IBAction)connect:(id)sender;
- (IBAction)createGame:(id)sender;
- (IBAction)joinGame:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *invisibleDigits;
@property (strong, nonatomic) NSMutableArray *holdingTheDigits;
@property (weak, nonatomic) IBOutlet UIButton *connectProp;
@property (weak, nonatomic) IBOutlet UIButton *joinGameProp;
@property (weak, nonatomic) IBOutlet UIButton *createGameProp;
- (IBAction)cancel:(id)sender;

@property (strong, nonatomic) NSArray *roomOfPeopleToPassForward;

@end

@implementation SBSetupViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupView];
    _firebaseRef= [[Firebase alloc] initWithUrl: FIREBASE_URL];
}

- (void)setupView {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.invisibleDigits.delegate = self;
    self.displayJoinGameDigits.alpha = 0;
    
    [SBUILabelHelper setupBorderOfLabelsWithArrayOfLabels:self.joinGameNumbers];
}

-(void)dismissKeyboard {
    [self.enterName resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)roomOfPeopleToPassForward {
    
    if (!_roomOfPeopleToPassForward) {
        _roomOfPeopleToPassForward = [[NSArray alloc] init];
    }
    return _roomOfPeopleToPassForward;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        
        if ([self.holdingTheDigits count] >= 1) {
            UILabel *label = self.joinGameNumbers[[self.holdingTheDigits count] - 1];
            label.text = @"-";
            [self.holdingTheDigits removeLastObject];
            self.connectProp.enabled = NO;
        }
        
    } else if ([self.holdingTheDigits count] < 6){
        
        [self.holdingTheDigits addObject:string];
        UILabel *label = self.joinGameNumbers[[self.holdingTheDigits count] - 1];
        label.text = string;
        
        if ([self.holdingTheDigits count] == 6) {
            self.connectProp.enabled = YES;
        }
    }
    
    return YES;
}

- (IBAction)connect:(id)sender {
    
    //699737

    
    NSLog(@"The connect button was pressed!");
    
    
    [[self.firebaseRef childByAppendingPath:self.invisibleDigits.text] observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        if ([snapshot exists]) {
            
            NSLog(@"The room exists");
            
            self.roomOfPeopleToPassForward  = [SBRoom createRoomWithData:snapshot];
            
            for (SBUser *user in self.roomOfPeopleToPassForward) {
                
                NSLog(@"The name of the user is %@", user.name);
                NSLog(@"The name of the monster is %@", user.monster);
                NSLog(@"The health points is %@", user.hp);
                NSLog(@"The victory points is %@", user.vp);
            }
            
        } else {
            
            NSLog(@"We dead");
        }

    } withCancelBlock:^(NSError *error) {
        
        NSLog(@"We have an error in the connect method: %@", error.description);

    }];
    
//    [[self.firebaseRef childByAppendingPath:self.invisibleDigits.text] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *roomToJoin) {
//        
//        if ([roomToJoin exists]) {
//            
//            NSLog(@"The room exists");
//            
//            self.roomOfPeopleToPassForward  = [SBRoom createRoomWithData:roomToJoin];
//            
//            for (SBUser *user in self.roomOfPeopleToPassForward) {
//                
//                NSLog(@"The name of the user is %@", user.name);
//                NSLog(@"The name of the monster is %@", user.monster);
//                NSLog(@"The health points is %@", user.hp);
//                NSLog(@"The victory points is %@", user.vp);
//            }
//            
//        } else {
//            
//            NSLog(@"We dead");
//        }
//        
//    } withCancelBlock:^(NSError *error) {
//             NSLog(@"We have an error in the connect method: %@", error.description);
//         }];
    
    
    
//        [self performSegueWithIdentifier:@"GameScreenSegue" sender:self];
    
}

- (IBAction)createGame:(id)sender {
    
    NSLog(@"The createGame button was pressed.");
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self dismissKeyboard];
                     }
                     completion:^ (BOOL finished) {
                         [self animateCreateButtonDown];
                         [self animateJoinButtonDown];
                     }];
    
    SBUser *currentUser = [[SBUser alloc] initWithName:self.enterName.text monsterName:@"" hp:@10 vp:@0];
    SBRoom *newRoom = [[SBRoom alloc] initWithUser:currentUser];
    [FirebaseAPIclient createGameOnFirebaseWithRef:self.firebaseRef andRoom:newRoom];
}

- (IBAction)joinGame:(id)sender {
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self dismissKeyboard];
                     }
                     completion:^ (BOOL finished) {
                         [self animateCreateButtonDown];
                           [self animateJoinButtonOnTap];
                     }];
    
    
    
}

- (NSMutableArray *)holdingTheDigits {
    
    if (!_holdingTheDigits) {
        _holdingTheDigits = [[NSMutableArray alloc] init];
    }
    return _holdingTheDigits;
}


- (void)animateCreateButtonDown {
    
    [UIView animateWithDuration:0.8
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.createGameProp.frame = CGRectMake(self.createGameProp.frame.origin.x + 0, self.createGameProp.frame.origin.y + 200, self.createGameProp.frame.size.width, self.createGameProp.frame.size.height);
                         self.createGameProp.alpha = 0.0;
                         
                     }
                     completion:^ (BOOL finished) {
                         
                     }];
}

- (void)animateJoinButtonDown {
    
    [UIView animateWithDuration:0.8
                          delay:0.34
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.joinGameProp.frame = CGRectMake(self.joinGameProp.frame.origin.x + 0, self.joinGameProp.frame.origin.y + 200, self.joinGameProp.frame.size.width, self.joinGameProp.frame.size.height);
                         self.joinGameProp.alpha = 0.0;
                         
                     }
                     completion:^ (BOOL finished) {
                         
                     }];
}

- (void)animateJoinButtonOnTap {
    
    [UIView animateWithDuration:0.8
                          delay:0.34
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.joinGameProp.frame = CGRectMake(self.joinGameProp.frame.origin.x + 0, self.joinGameProp.frame.origin.y + 200, self.joinGameProp.frame.size.width, self.joinGameProp.frame.size.height);
                         self.joinGameProp.alpha = 0.0;
                         
                     }
                     completion:^ (BOOL finished) {
                         
                         [self.invisibleDigits becomeFirstResponder];
                         NSLog(@"The joinGame button was pressed.");
                         
                         [UIView animateWithDuration:0.2 animations:^{
                             self.displayJoinGameDigits.alpha = 1;
                             
                         }];
                         
                         
                     }];
}

- (void)bringButtonsBackAfterCancelTapped {
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.8
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.createGameProp.alpha = 1;
                         self.joinGameProp.alpha = 1;
                         
                         self.createGameProp.frame = CGRectMake(self.createGameProp.frame.origin.x + 0, self.createGameProp.frame.origin.y - 200, self.createGameProp.frame.size.width, self.createGameProp.frame.size.height);
                         
                         self.joinGameProp.frame = CGRectMake(self.joinGameProp.frame.origin.x + 0, self.joinGameProp.frame.origin.y - 200, self.joinGameProp.frame.size.width, self.joinGameProp.frame.size.height);
                         
                         self.displayJoinGameDigits.alpha = 0;
                         
                     }
                     completion:^ (BOOL finished) {
                     }];
    
}

- (IBAction)cancel:(id)sender {
    
    [self bringButtonsBackAfterCancelTapped];
    self.connectProp.enabled = NO;
    [self.holdingTheDigits removeAllObjects];
    
    for (UILabel *label in self.joinGameNumbers) {
        label.text = @"-";
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
@end
