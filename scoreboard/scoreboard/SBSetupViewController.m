//
//  SBSetupViewController.m
//  scoreboard
//
//  Created by Jim Campagno on 5/24/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "SBSetupViewController.h"
#import "SBUILabelHelper.h"

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

@end

@implementation SBSetupViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.invisibleDigits.delegate = self;
    
    self.displayJoinGameDigits.alpha = 0;
    
    [SBUILabelHelper setupBorderOfLabelsWithArrayOfLabels:self.joinGameNumbers];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    NSLog(@"The connect button was pressed!");
}

- (IBAction)createGame:(id)sender {
    
    NSLog(@"The createGame button was pressed.");
    
    [self animateCreateButtonDown];
    [self animateJoinButtonDown];
}

- (IBAction)joinGame:(id)sender {
    
    
    [self animateCreateButtonDown];

    [self animateJoinButtonOnTap];
    
    //    [self.invisibleDigits becomeFirstResponder];
    //    NSLog(@"The joinGame button was pressed.");
    
    //    [UIView animateWithDuration:2.0 animations:^{
    //        self.displayJoinGameDigits.alpha = 1;
    //
    //    }];
    
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)cancel:(id)sender {
    
    
    [self bringButtonsBackAfterCancelTapped];
}
@end
