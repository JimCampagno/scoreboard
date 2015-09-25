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
#import "SBGameScreenViewController.h"

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

@property (strong, nonatomic) NSString *digitsToPassForward;
@property (strong, nonatomic) NSString *IDOfCurrentUser;
@property (strong, nonatomic) NSString *randomMonsterName;
@property (strong, nonatomic) NSString *currentPlayerName;
@property (strong, nonatomic) SBUser *currentUser;

@property (nonatomic) BOOL isInJoinScreenMode;
@property (nonatomic) CGRect frameOfOriginalJoinButton;
@property (nonatomic) CGRect frameOfOriginalCreateButton;


- (IBAction)cancel:(id)sender;
@end

static const NSInteger kMaxNumberOfPlayers = 6;


@implementation SBSetupViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupView];
    _firebaseRef = [[Firebase alloc] initWithUrl: FIREBASE_URL];
}

- (void)setupView {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.invisibleDigits.delegate = self;
    self.displayJoinGameDigits.alpha = 0;
    
    [SBUILabelHelper setupBorderOfLabelsWithArrayOfLabels:self.joinGameNumbers];
    _isInJoinScreenMode = NO;
}

-(void)dismissKeyboard {
    [self.enterName resignFirstResponder];
    [self.invisibleDigits resignFirstResponder];
    
    if (self.isInJoinScreenMode) {
        [self bringButtonsBackAfterCancelTapped];
        self.isInJoinScreenMode = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
//    if (textField.text.length == 6) {
//        return NO;
//    }
    
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"\n\nLength:%ld", textField.text.length);
    
//    if (textField.text.length == 6) {
//        NSLog(@"\n\n ABOUT TO RETURN NO!\n\n");
//        return NO;
//    }
    return YES;
}



- (IBAction)connect:(id)sender {
    __weak typeof(self) tmpself = self;
    [[self.firebaseRef childByAppendingPath:self.invisibleDigits.text] observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        if ([snapshot exists]) {
            
            if (snapshot.childrenCount == kMaxNumberOfPlayers) {
                
                [tmpself displayGameIsFullAlert];
            } else {
                [[tmpself.firebaseRef childByAppendingPath:self.invisibleDigits.text] runTransactionBlock:^FTransactionResult *(FMutableData *currentData) {
                    
                    if ([currentData hasChildren]) {
                        tmpself.currentUser = [[SBUser alloc] initWithName:tmpself.enterName.text
                                                            monsterName:[SBConstants randomMonsterName]
                                                                     hp:@10
                                                                     vp:@0];
                    
                        tmpself.IDOfCurrentUser = [tmpself createIDOfCurrentUserWithCurrentData:currentData];
                        
                        NSDictionary *newUser = @{ @"name": tmpself.currentUser.name,
                                                   @"monster": tmpself.currentUser.monster,
                                                   @"hp": @10,
                                                   @"vp": @0 };
                        
                        [[currentData childDataByAppendingPath:tmpself.IDOfCurrentUser] setValue:newUser];
                    }
                    
                    return [FTransactionResult successWithValue:currentData];
                    
                } andCompletionBlock:^(NSError *error, BOOL committed, FDataSnapshot *snapshot) {
                    
                    if (committed) {
                        
                        tmpself.digitsToPassForward = tmpself.invisibleDigits.text;
                        
                        [tmpself performSegueWithIdentifier:@"GameScreenSegue" sender:sender];
                    }
                }];
            }
        } else {
            
            [tmpself displayGameDoesntExistAlert];
        }
    } withCancelBlock:^(NSError *error) {
        //this doesn't appear to work when I'm in the subway with no internet connection.
        //Put up alert box stating what the error is or that there was a problem connecting to the Network.
        NSLog(@"We have an error in the connect method: %@", error.description);
    }];
}

- (IBAction)createGame:(id)sender {
    SBUser *currentUser = [[SBUser alloc] initWithName:self.enterName.text monsterName:[SBConstants randomMonsterName] hp:@10 vp:@0];
    
    [FirebaseAPIclient createGameOnFirebaseWithRef:self.firebaseRef
                                              user:currentUser
                               withCompletionBlock:^(BOOL success, NSString *digits) {
                                   
                                   if (success) {
                                       self.digitsToPassForward = digits;
                                       self.IDOfCurrentUser = @"0";
                                       self.randomMonsterName = currentUser.monster;
                                       self.currentPlayerName = self.enterName.text;
                                       [self performSegueWithIdentifier:@"CreateGameSegue" sender:sender];
                                   }
                                   
                               } withFailureBlock:^(NSError *error) {
                                   NSLog(@"Error: %@", error.localizedDescription);
                               }];
}

- (IBAction)joinGame:(id)sender {
    _isInJoinScreenMode = YES;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         //                         [self dismissKeyboard];
                     }
                     completion:^ (BOOL finished) {
                         [self animateCreateButtonDown];
                         [self animateJoinButtonDown];
                     }];
}

- (NSMutableArray *)holdingTheDigits {
    if (!_holdingTheDigits) {
        _holdingTheDigits = [[NSMutableArray alloc] init];
    }
    return _holdingTheDigits;
}

- (NSString *)createIDOfCurrentUserWithCurrentData:(FMutableData *)currentData {
    NSDictionary *data = currentData.value;
    NSInteger largestID;
    
    if ([data respondsToSelector:@selector(allKeys)]) {
        NSArray *allKeysOfData = [data allKeys];
        NSString *firstItemInData = allKeysOfData[0];
        largestID = [firstItemInData integerValue];
        
        for (NSString *userID in allKeysOfData) {
            NSInteger numberToCompare = [userID integerValue];
            
            if (numberToCompare > largestID) {
                largestID = [userID integerValue];
            }
        }
        return [@(largestID + 1) stringValue];
        
    } else {
        NSArray *dataToUse = currentData.value;
        largestID = [dataToUse count];
        return [@(largestID) stringValue];
    }
}

- (void)animateCreateButtonDown {
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.createGameProp.alpha = 0.0;
                     }
                     completion:nil];
}

- (void)animateJoinButtonDown {
    [UIView animateWithDuration:0.3
                          delay:0.15
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.joinGameProp.alpha = 0.0;
                     }
                     completion:^ (BOOL finished) {
                         [self.invisibleDigits becomeFirstResponder];
                         
                         [UIView animateWithDuration:0.2 animations:^{
                             self.displayJoinGameDigits.alpha = 1;
                             
                         }];
                     }];
}

- (void)bringButtonsBackAfterCancelTapped {
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.displayJoinGameDigits.alpha = 0;
                     } completion:^(BOOL finished) {
                         self.connectProp.enabled = NO;
                         [self.holdingTheDigits removeAllObjects];
                         
                         for (UILabel *label in self.joinGameNumbers) {
                             label.text = @"-";
                         }
                         
                         [UIView animateWithDuration:0.5
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.createGameProp.alpha = 1;
                                              self.joinGameProp.alpha = 1;
                                          }
                                          completion:nil];
                     }];
}

- (IBAction)cancel:(id)sender {
    [self bringButtonsBackAfterCancelTapped];
}

- (void)displayGameDoesntExistAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game doesn't exist"
                                                                   message:@"Please confirm that you're entering in the correct number."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              
                                                              self.connectProp.enabled = NO;
                                                              self.invisibleDigits.text = @"";
                                                              
                                                              for (UILabel *label in self.joinGameNumbers) {
                                                                  label.text = @"-";
                                                              }
                                                              
                                                              [self.holdingTheDigits removeAllObjects];
                                                          }];
    
    [alert addAction:defaultAction];
    
    
    [self presentViewController:alert
                       animated:YES
                     completion:^{
                         
                         
                         NSLog(@"In completion block when game doesn't exist!");
                         
                     }];
    
}

- (void)displayGameIsFullAlert {
    
    NSString *errorMSG = [NSString stringWithFormat:@"The game # %@ is full, it contains six players.", self.invisibleDigits.text];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game is full"
                                                                   message:errorMSG
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              
                                                              
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:^{
        //do anything on completion? clear out what was originally entered?
    }];
    
}

-(IBAction)reset:(UIStoryboardSegue *)segue {
    NSLog(@"\n\n\n RESET WAS CALLED!!! \n\n\n");
    // delegate call to destroy game
    
    
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SBGameScreenViewController *destVC = (SBGameScreenViewController *)segue.destinationViewController;
    destVC.ref = self.firebaseRef;
    destVC.currentPlayer = self.currentUser;
    destVC.roomDigits = [self.digitsToPassForward copy];
    destVC.IDOfCurrentPlayer = [self.IDOfCurrentUser copy];
    destVC.randomMonsterName = [self.currentUser.monster copy];
    destVC.currentPlayerName = [self.currentUser.name copy];
}

- (void)turnFireBaseOnline {
    [Firebase goOnline];
}

@end
