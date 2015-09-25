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
    self.firebaseRef = [[Firebase alloc] initWithUrl: FIREBASE_URL];
}

- (void)setupView {
    self.invisibleDigits.delegate = self;
    self.enterName.delegate = self;
    self.displayJoinGameDigits.alpha = 0;
    
    UIView *viewToHandleDismissalOfKeyboardOnTap = [[UIView alloc] initWithFrame:self.view.frame];
    viewToHandleDismissalOfKeyboardOnTap.backgroundColor = [UIColor redColor];
    [self.view insertSubview:viewToHandleDismissalOfKeyboardOnTap
                belowSubview:self.displayJoinGameDigits];

    [viewToHandleDismissalOfKeyboardOnTap addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)]];
    
    [self.enterName setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    
    [SBUILabelHelper setupBorderOfLabelsWithArrayOfLabels:self.joinGameNumbers];
    self.isInJoinScreenMode = NO;
}

//- (void)setupClearButtonForTapToDismiss {
//    UIButton *transparencyButton = [[UIButton alloc] initWithFrame:self.view.bounds];
//
//    transparencyButton.backgroundColor = [UIColor clearColor];
//
//    [self.view insertSubview:transparencyButton
//                belowSubview:self.displayJoinGameDigits];
//
//    [transparencyButton addTarget:self
//                           action:@selector(dismissKeyboard:)
//                 forControlEvents:UIControlEventTouchUpInside];
//}
//
-(void)dismissKeyboard:(id)sender {
    NSLog(@"DismissKeyBoard: is being called.");
    if ([self.enterName isFirstResponder]) {
        [self.enterName resignFirstResponder];
    } else {
        [self.invisibleDigits resignFirstResponder];
    }
    
    if (self.isInJoinScreenMode) {
        [self bringButtonsBackAfterCancelTapped];
        self.isInJoinScreenMode = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.enterName]) {
        if (self.isInJoinScreenMode) {
            self.isInJoinScreenMode = NO;
            [self bringButtonsBackAfterCancelTapped];
            [self.enterName becomeFirstResponder];
        }
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.keyboardType == UIKeyboardTypeNumberPad) {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound) {
            NSLog(@"Only numbers can be entered.");
            return NO;
        }
    }
    
    NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    if (lowercaseCharRange.location != NSNotFound) {
        textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString:[string uppercaseString]];
        return NO;
    }
    
    if ([textField isEqual:self.invisibleDigits]) {
        if ([string isEqualToString:@""]) {
            if ([self.holdingTheDigits count] >= 1) {
                UILabel *currentLabel = self.joinGameNumbers[[self.holdingTheDigits count] - 1];
                currentLabel.text = @"-";
                [self.holdingTheDigits removeLastObject];
                self.connectProp.enabled = NO;
            }
            
        } else if ([self.holdingTheDigits count] < 6) {
            [self.holdingTheDigits addObject:string];
            UILabel *currentLabel = self.joinGameNumbers[[self.holdingTheDigits count] - 1];
            currentLabel.text = string;
            
            if ([self.holdingTheDigits count] == 6) {
                self.connectProp.enabled = YES;
            }
        }
        
        return (textField.text.length >= 6 && range.length == 0) ? NO : YES;
        
    } else {
        NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (updatedText.length > 10) {
            return NO;
        }
        
        return YES;
    }
}

#pragma mark - Action Methods

- (IBAction)connect:(id)sender {
    __weak typeof(self) tmpself = self;
    self.connectProp.enabled = NO;
    
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
                        [tmpself bringButtonsBackAfterCancelTapped];
                        [tmpself performSegueWithIdentifier:@"GameScreenSegue" sender:sender];
                    }
                }];
            }
        } else {
            [tmpself displayGameDoesntExistAlert];
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"We have an error in the connect method: %@", error.description);
    }];
}

- (IBAction)createGame:(id)sender {
    __weak typeof(self) tmpself = self;
    
    SBUser *currentUser = [[SBUser alloc] initWithName:self.enterName.text monsterName:[SBConstants randomMonsterName] hp:@10 vp:@0];
    
    [FirebaseAPIclient createGameOnFirebaseWithRef:tmpself.firebaseRef
                                              user:currentUser
                               withCompletionBlock:^(BOOL success, NSString *digits) {
                                   
                                   if (success) {
                                       tmpself.digitsToPassForward = digits;
                                       tmpself.IDOfCurrentUser = @"0";
                                       tmpself.randomMonsterName = currentUser.monster;
                                       tmpself.currentPlayerName = self.enterName.text;
                                       [tmpself performSegueWithIdentifier:@"CreateGameSegue" sender:sender];
                                   }
                                   
                               } withFailureBlock:^(NSError *error) {
                                   NSLog(@"Error: %@", error.localizedDescription);
                               }];
}

- (IBAction)joinGame:(id)sender {
    NSString *currentEnteredName = self.enterName.text;
    if (currentEnteredName.length < 1) {
        [self.enterName resignFirstResponder];
        [self.invisibleDigits resignFirstResponder];
        
        [self displayAlertForNameNotEntered];
    } else {
        self.isInJoinScreenMode = YES;
        
        [UIView animateWithDuration:0.3
                         animations:^{
                         }
                         completion:^ (BOOL finished) {
                             [self animateCreateButtonDown];
                             [self animateJoinButtonDown];
                         }];
    }
    
}

- (void)displayAlertForNameNotEntered {
    NSString *errorTitle = @"Name has not been entered.";
    NSString *errorMessage = @"Please enter your name.";
    
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:errorTitle
                                                                        message:errorMessage
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *errorAlertAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 
                                                             }];
    
    [errorAlert addAction:errorAlertAction];
    
    [self presentViewController:errorAlert
                       animated:YES
                     completion:nil];
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
    __weak typeof(self) tmpself = self;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         tmpself.createGameProp.alpha = 0.0;
                     }
                     completion:nil];
}

- (void)animateJoinButtonDown {
    __weak typeof(self) tmpself = self;
    
    [UIView animateWithDuration:0.3
                          delay:0.15
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         tmpself.joinGameProp.alpha = 0.0;
                     }
                     completion:^ (BOOL finished) {
                         [tmpself.invisibleDigits becomeFirstResponder];
                         
                         [UIView animateWithDuration:0.2 animations:^{
                             tmpself.displayJoinGameDigits.alpha = 1;
                             
                         }];
                     }];
}

- (void)bringButtonsBackAfterCancelTapped {
    __weak typeof(self) tmpself = self;
    
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         tmpself.displayJoinGameDigits.alpha = 0;
                     } completion:^(BOOL finished) {
                         tmpself.connectProp.enabled = NO;
                         [tmpself.holdingTheDigits removeAllObjects];
                         tmpself.invisibleDigits.text = @"";
                         
                         for (UILabel *label in tmpself.joinGameNumbers) {
                             label.text = @"-";
                         }
                         
                         [UIView animateWithDuration:0.5
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              tmpself.createGameProp.alpha = 1;
                                              tmpself.joinGameProp.alpha = 1;
                                          }
                                          completion:nil];
                     }];
}

- (IBAction)cancel:(id)sender {
    NSLog(@"Cancel has been tapped.");
    [self bringButtonsBackAfterCancelTapped];
}

- (void)displayGameDoesntExistAlert {
    __weak typeof(self) tmpself = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game doesn't exist"
                                                                   message:@"Please confirm that you're entering in the correct number."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              tmpself.connectProp.enabled = NO;
                                                              tmpself.invisibleDigits.text = @"";
                                                              [tmpself.holdingTheDigits removeAllObjects];
                                                              [tmpself.invisibleDigits becomeFirstResponder];
                                                              
                                                              for (UILabel *label in tmpself.joinGameNumbers) {
                                                                  label.text = @"-";
                                                              }
                                                          }];
    
    [alert addAction:defaultAction];
    
    [self presentViewController:alert
                       animated:YES
                     completion:^{
                         //ToDo: Doing nothing here right now, do we need this completion block to do anything?
                     }];
}

- (void)displayGameIsFullAlert {
    __weak typeof(self) tmpself = self;
    
    NSString *errorMSG = [NSString stringWithFormat:@"The game # %@ is full, it contains six players.", tmpself.invisibleDigits.text];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game is full"
                                                                   message:errorMSG
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              
                                                              
                                                          }];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert
                       animated:YES
                     completion:^{
                         //ToDo: Doing nothing here right now, do we need this completion block to do anything?
                     }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SBGameScreenViewController *destVC = (SBGameScreenViewController *)segue.destinationViewController;
    
    //ToDo: Is referencing self.firebaseRef & self.currentUser here a retain cycle?
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
