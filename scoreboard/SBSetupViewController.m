//
//  SBSetupViewController.m
//  scoreboard
//
//  Created by Jim Campagno on 5/24/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "SBSetupViewController.h"
#import <Firebase/Firebase.h>
#import "SBConstants.h"
#import "FirebaseAPIclient.h"
#import "SBRoom.h"
#import "SBGameScreenViewController.h"
#import <Masonry.h>

@interface SBSetupViewController ()
@property (weak, nonatomic) IBOutlet UIView *displayJoinGameDigits;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *joinGameNumbers;
@property (weak, nonatomic) IBOutlet UITextField *enterName;
- (IBAction)createGame:(id)sender;
- (IBAction)joinGame:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *invisibleDigits;
@property (strong, nonatomic) NSMutableArray *holdingTheDigits;
@property (weak, nonatomic) IBOutlet UIButton *joinGameProp;
@property (weak, nonatomic) IBOutlet UIButton *createGameProp;
@property (weak, nonatomic) IBOutlet UIButton *cancelProp;

@property (strong, nonatomic) NSString *digitsToPassForward;
@property (strong, nonatomic) NSString *IDOfCurrentUser;
@property (strong, nonatomic) NSString *randomMonsterName;
@property (strong, nonatomic) NSString *currentPlayerName;
@property (strong, nonatomic) SBUser *currentUser;

@property (nonatomic) BOOL isInJoinScreenMode;
@property (nonatomic) CGRect frameOfOriginalJoinButton;
@property (nonatomic) CGRect frameOfOriginalCreateButton;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIActivityIndicatorView *createGameActivityView;

@property (nonatomic, strong) UIView *viewToHandleDismissalOfKeyboardOnTap;

@property (nonatomic, strong) UILabel *instructions;

@property (nonatomic, strong) UIButton *info;

@property (nonatomic) BOOL instructionOnScreen;

- (IBAction)cancel:(id)sender;
@end

static const NSInteger kMaxNumberOfPlayers = 6;


@implementation SBSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTheViewToHandleTheDismissingOfTheKeyboardOnTap];
    [self setupTheLabelDisplayingTheEnteredDigits];
    [self setupJoinGameButton];
    [self setupCreateGameButton];
    [self setupEnterNameLabel];
    [self setupTheDisplayJoinGameDigits];
    [self setupTheConnectAndCancelButtons];
    [self setUpActivityViews];
    [self setupInstructions];
    
    _instructionOnScreen = NO;
    
    
    self.navigationController.navigationBar.hidden = YES;
    //    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0.52 green:0.48 blue:0.67 alpha:1];
    
    //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.98 green:0.8 blue:0 alpha:1];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.35 green:0.38 blue:0.46 alpha:1];
    
    self.firebaseRef = [[Firebase alloc] initWithUrl: FIREBASE_URL];
    self.invisibleDigits.delegate = self;
    self.isInJoinScreenMode = NO;
    self.view.backgroundColor = [UIColor colorWithRed:0.8 green:0.82 blue:0.91 alpha:1];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [Firebase goOnline];
}

- (void)instructionTapped {
    
    self.info.userInteractionEnabled = NO;
    
    if (!self.instructionOnScreen) {
        
        [UIView animateWithDuration:0.7
                         animations:^{
                             
                             self.instructions.alpha = 1.0;
                             
                         } completion:^(BOOL finished) {
                             
                             self.info.userInteractionEnabled = YES;
                             self.instructionOnScreen = YES;
                             
                         }];
    } else {
        
        [UIView animateWithDuration:0.7
                         animations:^{
                             
                             self.instructions.alpha = 0.0;
                             
                         } completion:^(BOOL finished) {
                             
                             self.info.userInteractionEnabled = YES;
                             self.instructionOnScreen = NO;
                             
                         }];
    }
}

- (void)setupInstructions {
    
    self.instructions = [UILabel new];
    self.instructions.textAlignment = NSTextAlignmentLeft;
    self.instructions.text = @"• one person creates a new game, then provides the game number\n• all others join that game\n• change monsters by tapping your monster image\n• you can't change your name in game\n• board game required";
//    [self.instructions setFont:[UIFont systemFontOfSize:18]];
    [self.instructions setFont:[UIFont fontWithName:@"Avenir Next" size:18]];
    //    monsterLabel.backgroundColor = [UIColor colorWithRed:0.42 green:0.45 blue:0.47 alpha:0.97];
    
    //    monsterLabel.layer.borderColor = [UIColor blackColor].CGColor;
    //    monsterLabel.layer.borderWidth = 0.6f;
    //    monsterLabel.layer.cornerRadius = 10.0f;
    self.instructions.clipsToBounds = YES;
    self.instructions.textColor = [UIColor blackColor] ;
    
    self.instructions.numberOfLines = 15;
    self.instructions.adjustsFontSizeToFitWidth = YES;
    self.instructions.lineBreakMode = NSLineBreakByClipping;
    
    [self.view addSubview:self.instructions];
    
    [self.instructions mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.joinGameProp);
        make.right.equalTo(self.joinGameProp);
        make.top.equalTo(self.joinGameProp.mas_bottom).with.offset(24);
        
    }];
    
    
    self.instructions.alpha = 0.0;
    
    self.info = [UIButton buttonWithType:UIButtonTypeSystem];
    
    
    [self.info addTarget:self
                  action:@selector(instructionTapped)
        forControlEvents:UIControlEventTouchUpInside];
    
    //    newButton.backgroundColor = [UIColor colorWithRed:0.42 green:0.45 blue:0.47 alpha:0.97];
    // newButton.layer.borderColor = [UIColor blackColor].CGColor;
    //  newButton.layer.borderWidth = 0.6f;
    // newButton.layer.cornerRadius = 10.0f;
    
    self.info.titleLabel.font = [UIFont systemFontOfSize:24.0];
    [self.info setTitleColor:[UIColor colorWithRed:0.30 green:0.10 blue:0.95 alpha:1] forState:UIControlStateNormal];
    
    [self.info setTitle:@"ⓘ"
               forState:UIControlStateNormal];
    
    self.info.titleLabel.numberOfLines = 1;
    self.info.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.info.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    [self.view addSubview:self.info];
    
    
    [self.info mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view).with.offset(-20);
        make.right.equalTo(self.view).with.offset(-20);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    
    
    
    
    //
    //
    //
    //
    //    UILabel *enterRoomDigitsLabel = [UILabel new];
    //    enterRoomDigitsLabel.text = @"tap your monster image to change ";
    //    enterRoomDigitsLabel.font = [UIFont systemFontOfSize:20];
    //    enterRoomDigitsLabel.adjustsFontSizeToFitWidth = YES;
    //    enterRoomDigitsLabel.textColor = [UIColor colorWithRed:0 green:0.2 blue:0.4 alpha:1];
    
}



- (void)setUpActivityViews {
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.activityView];
    
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        UILabel *labelToConstrainTo = self.joinGameNumbers[0];
        make.top.equalTo(labelToConstrainTo.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.displayJoinGameDigits);
    }];
    
    
    self.createGameActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.createGameActivityView];
    
    [self.createGameActivityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.createGameProp.mas_top).with.offset(-16);
        make.centerX.equalTo(self.view);
    }];
}

- (void)setupJoinGameButton {
    self.joinGameProp.backgroundColor = [UIColor colorWithRed:0.42 green:0.45 blue:0.47 alpha:0.97];
    self.joinGameProp.layer.borderColor = [UIColor blackColor].CGColor;
    self.joinGameProp.layer.borderWidth = 0.2f;
    self.joinGameProp.layer.cornerRadius = 10.0f;
    
    self.joinGameProp.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.joinGameProp setTitleColor:[UIColor colorWithRed:0.98 green:0.8 blue:0 alpha:1] forState:UIControlStateNormal];
    
    self.joinGameProp.titleLabel.numberOfLines = 1;
    self.joinGameProp.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.joinGameProp.titleLabel.lineBreakMode = NSLineBreakByClipping;
}

- (void)setupCreateGameButton {
    self.createGameProp.backgroundColor = [UIColor colorWithRed:0.42 green:0.45 blue:0.47 alpha:0.97];
    self.createGameProp.layer.borderColor = [UIColor blackColor].CGColor;
    self.createGameProp.layer.borderWidth = 0.2f;
    self.createGameProp.layer.cornerRadius = 10.0f;
    
    self.createGameProp.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.createGameProp setTitleColor:[UIColor colorWithRed:0.98 green:0.8 blue:0 alpha:1] forState:UIControlStateNormal];
    
    self.createGameProp.titleLabel.numberOfLines = 1;
    self.createGameProp.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.createGameProp.titleLabel.lineBreakMode = NSLineBreakByClipping;
}

- (void)setupTheLabelDisplayingTheEnteredDigits {
    for (UILabel *label in self.joinGameNumbers) {
        label.textColor = [UIColor colorWithRed:1 green:0.8 blue:0 alpha:1];
        label.text = @"-";
    }
}

- (void)setupTheViewToHandleTheDismissingOfTheKeyboardOnTap {
    self.viewToHandleDismissalOfKeyboardOnTap = [[UIView alloc] initWithFrame:self.view.frame];
    self.viewToHandleDismissalOfKeyboardOnTap.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:self.viewToHandleDismissalOfKeyboardOnTap
                belowSubview:self.displayJoinGameDigits];
    
    [self.viewToHandleDismissalOfKeyboardOnTap addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)]];
}

- (void)setupEnterNameLabel {
    self.enterName.delegate = self;
    
    if ([self.enterName respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:0.35 green:0.38 blue:0.46 alpha:1];
        self.enterName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter name here"
                                                                               attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    [self.enterName setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
}

- (void)setupTheDisplayJoinGameDigits {
    self.displayJoinGameDigits.alpha = 0;
    self.displayJoinGameDigits.backgroundColor = [UIColor colorWithRed:0.42 green:0.45 blue:0.47 alpha:0.97];
    self.displayJoinGameDigits.layer.borderColor = [UIColor blackColor].CGColor;
    self.displayJoinGameDigits.layer.borderWidth = 0.2f;
    self.displayJoinGameDigits.layer.cornerRadius = 10.0f;
    
    //    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"Enter Room Digits"];
    //    [attributeString addAttribute:NSUnderlineStyleAttributeName
    //                            value:[NSNumber numberWithInt:1]
    //                            range:(NSRange){0,[attributeString length]}];
    
    //    [attributeString addAttribute:NSUnderlineColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attributeString.length)];//TextColor
    
    
    UILabel *enterRoomDigitsLabel = [UILabel new];
    enterRoomDigitsLabel.text = @"Enter game number:";
    enterRoomDigitsLabel.font = [UIFont systemFontOfSize:20];
    enterRoomDigitsLabel.adjustsFontSizeToFitWidth = YES;
    enterRoomDigitsLabel.textColor = [UIColor colorWithRed:0 green:0.2 blue:0.4 alpha:1];
    
    //    enterRoomDigitsLabel.attributedText = attributeString;
    
    [self.displayJoinGameDigits addSubview:enterRoomDigitsLabel];
    
    [enterRoomDigitsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.displayJoinGameDigits).with.offset(8);
        make.top.equalTo(self.displayJoinGameDigits).with.offset(8);
    }];
}

- (void)setupTheConnectAndCancelButtons {
    UIColor *colorToUseHere = [UIColor colorWithRed:0 green:0.2 blue:0.4 alpha:1];
    //    UIColor *colorToUseHere = [UIColor colorWithRed:0.42 green:0.45 blue:0.47 alpha:0.97];
    UIColor *backgroundColorsForBothButtons = [UIColor clearColor];
    
    UIColor *normalStateColor = [colorToUseHere copy];
    //    UIColor *disabledStateColor= [[colorToUseHere copy] colorWithAlphaComponent:0.4];
    
    
    [self.cancelProp setTitleColor:normalStateColor forState:UIControlStateNormal];
    [self.cancelProp.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.cancelProp.titleLabel.font = [UIFont systemFontOfSize:20];
    //    self.cancelProp.layer.borderWidth = 0.3;
    //    self.cancelProp.layer.borderColor = [UIColor blackColor].CGColor;
    //    self.cancelProp.layer.cornerRadius = 12.5;
    //    self.cancelProp.clipsToBounds = YES;
    [self.cancelProp setTitle:@"X" forState:UIControlStateNormal];
    self.cancelProp.backgroundColor = backgroundColorsForBothButtons;
    
    
}

-(void)dismissKeyboard:(id)sender {
    NSLog(@"DismissKeyBoard: is being called.");
    if ([self.enterName isFirstResponder]) {
        [self.enterName resignFirstResponder];
    }
    
    if ([self.invisibleDigits isFirstResponder]) {
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
            
            return NO;
        }
    }
    
    if ([textField isEqual:self.invisibleDigits]) {
        if ([string isEqualToString:@""]) {
            if ([self.holdingTheDigits count] >= 1) {
                UILabel *currentLabel = self.joinGameNumbers[[self.holdingTheDigits count] - 1];
                currentLabel.text = @"-";
                [self.holdingTheDigits removeLastObject];
            }
            
        } else if ([self.holdingTheDigits count] < 6) {
            [self.holdingTheDigits addObject:string];
            UILabel *currentLabel = self.joinGameNumbers[[self.holdingTheDigits count] - 1];
            currentLabel.text = string;
            
            if ([self.holdingTheDigits count] == 6) {
                [self.activityView startAnimating];
                self.viewToHandleDismissalOfKeyboardOnTap.userInteractionEnabled = NO;
                self.cancelProp.userInteractionEnabled = NO;
                self.enterName.userInteractionEnabled = NO;
                [self performSelector:@selector(connectToGameRoom)withObject:nil afterDelay:0.6];
            }
        }
        
        return (textField.text.length >= 6 && range.length == 0) ? NO : YES;
        
    } else {
        NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if (updatedText.length > 10) {
            return NO;
        }
        
        NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
        if (lowercaseCharRange.location != NSNotFound) {
            textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                     withString:[string uppercaseString]];
            return NO;
        }
        
        return YES;
    }
}

#pragma mark - Action Methods

- (void)connectToGameRoom {
    if (![FirebaseAPIclient isNetworkAvailable]) {
        self.viewToHandleDismissalOfKeyboardOnTap.userInteractionEnabled = YES;
        self.cancelProp.userInteractionEnabled = YES;
        self.enterName.userInteractionEnabled = YES;
        [self.activityView stopAnimating];
        [self displayNoNetworkAlert];
        
    } else {
        __weak typeof(self) tmpself = self;
        
        [[self.firebaseRef childByAppendingPath:self.invisibleDigits.text] observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            if ([snapshot exists]) {
                if (snapshot.childrenCount == kMaxNumberOfPlayers) {
                    [tmpself.activityView stopAnimating];
                    [tmpself displayGameIsFullAlert];
                    tmpself.viewToHandleDismissalOfKeyboardOnTap.userInteractionEnabled = YES;
                    tmpself.cancelProp.userInteractionEnabled = YES;
                    tmpself.enterName.userInteractionEnabled = YES;
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
                            [tmpself.activityView stopAnimating];
                            tmpself.viewToHandleDismissalOfKeyboardOnTap.userInteractionEnabled = YES;
                            tmpself.cancelProp.userInteractionEnabled = YES;
                            tmpself.enterName.userInteractionEnabled = YES;
                            [tmpself performSegueWithIdentifier:@"GameScreenSegue" sender:nil];
                        } else {
                        }
                    }];
                }
            } else {
                tmpself.viewToHandleDismissalOfKeyboardOnTap.userInteractionEnabled = YES;
                tmpself.cancelProp.userInteractionEnabled = YES;
                tmpself.enterName.userInteractionEnabled = YES;
                
                [tmpself.activityView stopAnimating];
                [tmpself displayGameDoesntExistAlert];
            }
        } withCancelBlock:^(NSError *error) {
            NSLog(@"We have an error in the connect method: %@", error.description);
        }];
        
    }
    
    
}



- (IBAction)createGame:(id)sender {
    if (![FirebaseAPIclient isNetworkAvailable]) {
        [self displayNoNetworkAlert];
    } else {
        
        if (self.instructionOnScreen) {
            
            [UIView animateWithDuration:0.2
                             animations:^{
                                 
                                 self.instructions.alpha = 0.0;
                                 
                             } completion:^(BOOL finished) {
                                 
                                 self.instructionOnScreen = NO;
                                 
                             }];
        }
        
        
        [self.createGameActivityView startAnimating];
        self.joinGameProp.userInteractionEnabled = NO;
        self.createGameProp.userInteractionEnabled = NO;
        self.enterName.userInteractionEnabled = NO;
        self.viewToHandleDismissalOfKeyboardOnTap.userInteractionEnabled = NO;
        
        NSString *currentEnteredName = self.enterName.text;
        if (currentEnteredName.length < 1) {
            [self.createGameActivityView stopAnimating];
            self.joinGameProp.userInteractionEnabled = YES;
            self.enterName.userInteractionEnabled = YES;
            self.createGameProp.userInteractionEnabled = YES;
            self.viewToHandleDismissalOfKeyboardOnTap.userInteractionEnabled = YES;
            [self.enterName resignFirstResponder];
            [self.invisibleDigits resignFirstResponder];
            [self displayAlertForNameNotEntered];
        } else {
            
            [self performSelector:@selector(createGameOnFirebase)withObject:nil afterDelay:0.6];
        }
    }
}

- (void)createGameOnFirebase {
    self.currentUser = [[SBUser alloc] initWithName:self.enterName.text monsterName:[SBConstants randomMonsterName] hp:@10 vp:@0];
    
    __weak typeof(self) tmpself = self;
    
    [FirebaseAPIclient createGameOnFirebaseWithRef:tmpself.firebaseRef
                                              user:self.currentUser
                               withCompletionBlock:^(BOOL success, NSString *digits) {
                                   [tmpself.createGameActivityView stopAnimating];
                                   
                                   
                                   tmpself.joinGameProp.userInteractionEnabled = YES;
                                   tmpself.enterName.userInteractionEnabled = YES;
                                   tmpself.viewToHandleDismissalOfKeyboardOnTap.userInteractionEnabled = YES;
                                   tmpself.createGameProp.userInteractionEnabled = YES;
                                   
                                   [self animateJoinAndCreateGameButtonsOnCreateGameTap];
                                   
                                   
                                   if (success) {
                                       tmpself.digitsToPassForward = digits;
                                       tmpself.IDOfCurrentUser = @"0";
                                       [tmpself performSegueWithIdentifier:@"CreateGameSegue" sender:nil];
                                   }
                                   
                               } withFailureBlock:^(NSError *error) {
                                   NSLog(@"Error: %@", error.localizedDescription);
                               }];
}

- (void)animateJoinAndCreateGameButtonsOnCreateGameTap {
    __weak typeof(self) tmpself = self;
    
    [UIView animateWithDuration:0.6
                     animations:^{
                         tmpself.createGameProp.alpha = 0.0;
                         tmpself.joinGameProp.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:1.0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              tmpself.createGameProp.alpha = 1.0;
                                              tmpself.joinGameProp.alpha = 1.0;
                                          } completion:nil];
                     }];
}

- (void)turnVariousViewsInteractionsOn {
    self.viewToHandleDismissalOfKeyboardOnTap.userInteractionEnabled = YES;
    self.enterName.userInteractionEnabled = YES;
}

- (IBAction)joinGame:(id)sender {
    if ([self.enterName isFirstResponder]) {
        [self.enterName resignFirstResponder];
    }
    
    if (self.instructionOnScreen) {
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             
                             self.instructions.alpha = 0.0;
                             
                         } completion:^(BOOL finished) {
                             
                             self.instructionOnScreen = NO;
                             
                         }];
    }

    
    self.viewToHandleDismissalOfKeyboardOnTap.userInteractionEnabled = NO;
    self.enterName.userInteractionEnabled = NO;
    
    NSString *currentEnteredName = self.enterName.text;
    if (currentEnteredName.length < 1) {
        [self.enterName resignFirstResponder];
        [self.invisibleDigits resignFirstResponder];
        self.viewToHandleDismissalOfKeyboardOnTap.userInteractionEnabled = YES;
        self.enterName.userInteractionEnabled = YES;
        [self displayAlertForNameNotEntered];
    } else {
        self.isInJoinScreenMode = YES;
        [self animateCreateButtonDown];
        [self animateJoinButtonDown];
        [self performSelector:@selector(turnVariousViewsInteractionsOn)withObject:nil afterDelay:1.0];
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
                         
                         
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              tmpself.displayJoinGameDigits.alpha = 1;
                                              
                                          } completion:^(BOOL finished) {
                                              
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
    [self bringButtonsBackAfterCancelTapped];
}

- (void)displayGameDoesntExistAlert {
    __weak typeof(self) tmpself = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game not found"
                                                                   message:@"Entered game # doesn't exist"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
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

- (void)displayNoNetworkAlert {
    __weak typeof(self) tmpself = self;
    
    NSString *errorMSG = @"Please check your internet connection or try again later.";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Internet Connection"
                                                                   message:errorMSG
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              tmpself.invisibleDigits.text = @"";
                                                              [tmpself.holdingTheDigits removeAllObjects];
                                                              
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SBGameScreenViewController *destVC = (SBGameScreenViewController *)segue.destinationViewController;
    
    //ToDo: Is referencing self.firebaseRef & self.currentUser here a retain cycle?
    destVC.ref = self.firebaseRef;
    destVC.currentPlayer = self.currentUser;
    destVC.roomDigits = [self.digitsToPassForward copy];
    destVC.IDOfCurrentPlayer = [self.IDOfCurrentUser copy];
    destVC.randomMonsterName = [self.currentUser.monster copy];
    destVC.currentPlayerName = [self.currentUser.name copy];
    
    
    
    
    
    [self.firebaseRef removeAllObservers];
    
}




@end
